import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'adb_path.dart';

class AdbDeviceTracker {
  AdbDeviceTracker._internal();
  static final AdbDeviceTracker instance = AdbDeviceTracker._internal();
  factory AdbDeviceTracker() => instance;

  final _adbPath = AdbPath();

  final StreamController<List<String>> _deviceStreamController =
      StreamController<List<String>>();

  Process? _process;
  List<String> _connectedDevices = [];

  /// Starts the adb `track-devices` process and pushes updates to the provided
  /// callback function.
  Future<void> startTracking(
      Function(List<String> devices) onDeviceChange
  ) async {
    try {
      _process = await Process.start(await _adbPath.adbPath, ['track-devices']);
      debugPrint('Started tracking devices using adb track-devices.');

      _process!.stdout
          .transform(utf8.decoder)
          .listen((lines) {
            final connectedDevices = _parseConnectedDevicesFromOutput(lines);

            if (!_equalLists(connectedDevices, _connectedDevices)) {
              _connectedDevices = connectedDevices;
              onDeviceChange(_connectedDevices);
              _deviceStreamController.add(_connectedDevices);
            }
          });

      _process!.stderr
          .transform(utf8.decoder)
          .listen((error) {
            debugPrint("ADB Error: $error");
          });

      _process!.exitCode.then((code) {
        debugPrint('ADB track-devices process exited with code $code.');
        stopTracking();
      });
    } catch (e) {
      debugPrint('Error starting adb track-devices: $e');
      await stopTracking();
    }
  }

  /// Stops the process and cleans up resources
  Future<void> stopTracking() async {
    _process?.kill();
    _process = null;
    await _deviceStreamController.close();
    debugPrint('Stopped tracking devices.');
  }

  /// Returns a broadcast Stream to allow UI subscription for device updates
  Stream<List<String>> get deviceStream => _deviceStreamController.stream;

  /// Helper to compare two device lists
  bool _equalLists(List<String> a, List<String> b) {
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
        .split(r"\n[0-9a-fA-F]{4}").last
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
}
