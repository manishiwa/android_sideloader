import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:android_sideloader/file_path.dart';
import '../log.dart';
import '../on_app_exit.dart';
import 'adb_path.dart';

class AdbDeviceTracker {
  AdbDeviceTracker._internal() {
    OnAppExit.listen(() => stopTracking());
  }
  static final AdbDeviceTracker instance = AdbDeviceTracker._internal();
  factory AdbDeviceTracker() => instance;

  Process? _process;
  List<String>? _connectedDevices;

  /// Starts the adb `track-devices` process and pushes updates to the provided
  /// callback function.
  Future<void> startTracking({
    required Function(List<String> devices) onDeviceChange,
  }) async {
    if (_process != null) {
      throw Exception(
          "You must call `stopTracking` before calling `startTracking` again!"
      );
    }
    try {
      await _deleteLockerInfo();
      _process = await Process.start(
          (await AdbPath.adbFile).path,
          ['track-devices'],
          workingDirectory: (await AdbPath.adbFile).parent.path
      );
      await _persistLockerInfo(_process!.pid);
      Log.i('Started tracking devices using adb track-devices.');

      _process!.stdout
          .transform(utf8.decoder)
          .listen((lines) {
            Log.d("Raw `track-devices` string: '''$lines'''");
            final connectedDevices = _parseConnectedDevicesFromOutput(lines);
            Log.d("Detected connected devices: $connectedDevices");

            if (!_equalLists(connectedDevices, _connectedDevices)) {
              _connectedDevices = connectedDevices;
              onDeviceChange(connectedDevices);
            }
          });

      _process!.stderr
          .transform(utf8.decoder)
          .listen((error) {
            Log.e("ADB Error", error: error);
          });

      _process!.exitCode.then((code) {
        Log.e('ADB track-devices process exited with code $code.');
        stopTracking();
      });
    } catch (e) {
      Log.e('Error starting adb track-devices', error: e);
      stopTracking();
    }
  }

  /// Stops the process and cleans up resources
  void stopTracking() {
    _process?.kill();
    _process = null;
    Log.i('Stopped tracking devices.');
  }

  /// Helper to compare two device lists
  bool _equalLists(List<String>? a, List<String>? b) {
    if (a == null && b == null) {
      return true;
    }
    if (a == null || b == null) {
      return false;
    }
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  /// Output is in the format:
  /// ```
  ///   XXXXDEVICEID  INFO
  /// ```
  /// Where the first 4 characters are the size of the following payload.
  /// Device IDs cannot start with a number. There is a `\t` between the
  /// device ID and the info.
  ///
  /// There can be multiple devices per payload. Example:
  ///
  /// ```
  /// 0026SN078C10027323	device
  ///
  /// fcd41e7b	device
  /// ```
  List<String> _parseConnectedDevicesFromOutput(String lines) {
    return lines
        // Multiple outputs are occasionally sent at once. We can detect the
        // start of an output by its having 4 hexadecimal characters at the
        // beginning of a line. This is the payload size indicator for that
        // output. We only care about the most recent output.
        .split(RegExp(r"\n(?=[0-9a-fA-F]{4})")).last
        // Remove the output payload size characters
        .substring(4)
        // Remove empty lines
        .trim()
        // Each device has its own line, so we split by newline.
        .split("\n")
        .map((line) => line.trim())
        // Connected devices have `device` as the info
        .where((line) => line.isNotEmpty && line.contains('\tdevice'))
        // The device name and info are separated by `\t`
        .map((line) => line.split('\t').first)
        .toList();
  }

  Future<void> _persistLockerInfo(int pid) async {
    final file = await _getLockerFile();
    await file.writeAsString("$pid");
    Log.d("Persisted ADB lock information");
  }

  Future<void> _deleteLockerInfo() async {
    final file = await _getLockerFile();
    final fileContents = await file.readAsString();
    final pid = int.tryParse(fileContents);
    if (pid != null) {
      final didKill = Process.killPid(pid);
      Log.d("Killed old ADB process ($pid): $didKill");
    }
    await file.delete();
    Log.d("Deleted ADB lock information");
  }

  Future<File> _getLockerFile() async => await FilePath.getFile('locker');
}
