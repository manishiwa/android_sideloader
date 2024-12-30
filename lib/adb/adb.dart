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
          '${await AdbPath.adbPath} '
          '${device != null ? "-s $device " : ""}'
          'install $filePath'
      );
      Log.i(result.outText);
      onSuccess(result.outText);
    } catch (e) {
      Log.e("Error installing APK", error: e);
      onFailure("Error: $e");
    }
  }
}
