import 'package:flutter/widgets.dart';
import 'package:process_run/process_run.dart';
import 'adb_path.dart';

class Adb {
  Adb._internal();
  static final Adb instance = Adb._internal();
  factory Adb() => instance;

  final _shell = Shell();
  final _adbPath = AdbPath();

  Future<void> installAPK({
    required String filePath,
    String? device,
    required void Function(String outText) onSuccess,
    required void Function(String errorMessage) onFailure,
  }) async {
    try {
      final result = await _shell.run(
          '${await _adbPath.adbPath} '
          '${device != null ? "-s $device " : ""}'
          'install $filePath'
      );
      debugPrint(result.outText);
      onSuccess(result.outText);
    } catch (e) {
      debugPrint("Error: $e");
      onFailure("Error: $e");
    }
  }
}
