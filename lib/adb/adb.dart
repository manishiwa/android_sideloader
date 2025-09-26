import 'package:android_sideloader/adb/adb_device.dart';
import 'package:android_sideloader/logs/log.dart';
import 'package:process_run/process_run.dart';
import 'adb_path.dart';

class Adb {
  static final _shell = (() async => Shell(
    workingDirectory: await AdbPath.adbWorkingDirectoryPath,
  ))();

  static Future<void> installAPK({
    required String filePath,
    String? device,
    required void Function(String outText) onSuccess,
    required void Function(String errorMessage) onFailure,
  }) async {
    try {
      final result = await (await _shell).run(
        '"${await AdbPath.adbPath}" '
        '${device != null ? "-s $device " : ""}'
        'install -r "$filePath"'
      );
      Log.i("Successfully installed APK:\n${result.outText}");
      onSuccess(result.outText);
    } on ShellException catch (shellException, stackTrace) {
      Log.e(
        "Error installing APK.\n"
          "* stdout:\n${shellException.result?.outText}\n" 
          "* stderr:\n${shellException.result?.errText}", 
        error: shellException, 
        stackTrace: stackTrace
      );
      onFailure("Error: $shellException");
    }
  }

  static Future<AdbDevice?> getAdbDevice(String deviceId) async {
    final manufacturer = await getDeviceManufacturer(deviceId);
    final model = await getDeviceModel(deviceId);
    if (manufacturer == null || model == null) {
      return null;
    }
    return AdbDevice(id: deviceId, manufacturer: manufacturer, model: model);
  }

  static Future<String?> getDeviceModel(String deviceId) async {
    return await getProp(deviceId, "ro.product.model");
  }

  static Future<String?> getDeviceManufacturer(String deviceId) async {
    return await getProp(deviceId, "ro.product.manufacturer");
  }

  static Future<String?> getProp(String deviceId, String propId) async {
    try {
      final result = await (await _shell).run(
        '"${await AdbPath.adbPath}" '
        '-s $deviceId '
        'shell getprop $propId'
      );
      Log.d("Successfully got $propId: ${result.outText}");
      return result.outText;
    } on ShellException catch (shellException, stackTrace) {
      Log.e(
        "Error getting $propId.\n"
          "* stdout:\n${shellException.result?.outText}\n"
          "* stderr:\n${shellException.result?.errText}",
        error: shellException,
        stackTrace: stackTrace
      );
      return null;
    }
  }

  static Future<bool> killServer() async {
    try {
      final result = await (await _shell).run(
        '"${await AdbPath.adbPath}" '
        'kill-server'
      );
      Log.i("Successfully killed ADB server:\n${result.outText}");
      return true;
    } on ShellException catch (shellException, stackTrace) {
      Log.e(
          "Error starting ADB server.\n"
            "* stdout:\n${shellException.result?.outText}\n"
            "* stderr:\n${shellException.result?.errText}",
          error: shellException,
          stackTrace: stackTrace
      );
      return false;
    }
  }

  static Future<bool> startServer() async {
    try {
      final result = await (await _shell).run(
        '"${await AdbPath.adbPath}" '
        'start-server'
      );
      Log.i("Successfully started ADB server:\n${result.outText}");
      return true;
    } on ShellException catch (shellException, stackTrace) {
      Log.e(
        "Error starting ADB server.\n"
          "* stdout:\n${shellException.result?.outText}\n" 
          "* stderr:\n${shellException.result?.errText}", 
        error: shellException, 
        stackTrace: stackTrace
      );
      return false;
    }
  }
}
