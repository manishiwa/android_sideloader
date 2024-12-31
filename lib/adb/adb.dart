import 'package:android_sideloader/log.dart';
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
        'install "$filePath"'
      );
      Log.i("Successfully installed APK:\n${result.outText}");
      onSuccess(result.outText);
    } catch (e) {
      Log.e("Error installing APK", error: e);
      onFailure("Error: $e");
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
    } catch (e) {
      Log.e("Error killing ADB server", error: e);
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
    } catch (e) {
      Log.e("Error starting ADB server", error: e);
      return false;
    }
  }
}
