import 'dart:io';
import 'package:android_sideloader/util/file_path.dart';
import '../logs/log.dart';

class AdbPath {
  static Future<String> get adbPath async => (await adbFile).path;

  static Future<Directory> get adbWorkingDirectory async =>
    (await adbFile).parent;

  static Future<String> get adbWorkingDirectoryPath async =>
    (await adbWorkingDirectory).path;

  static Future<File>? _adbFile;
  static Future<File> get adbFile async {
    return _adbFile ??= _initializeAdbFile();
  }

  static Future<File> _initializeAdbFile() async {
    final adbAssetPath = "assets/adb/${
        Platform.isWindows ? "adb.exe" :
        Platform.isLinux ? "adb-linux" :
        Platform.isMacOS ? "adb-mac" :
        throw UnsupportedError(
            'Unsupported platform: ${Platform.operatingSystem}'
        )
    }";

    final adbFile = await FilePath.extractAsset(adbAssetPath);

    if (Platform.isWindows) {
      // Windows needs some extra files
      Log.d("Extracting additional Windows files");
      await FilePath.extractAsset("assets/adb/AdbWinApi.dll");
      await FilePath.extractAsset("assets/adb/AdbWinUsbApi.dll");
      await FilePath.extractAsset("assets/adb/libusb-1.0.dll");
    } else {
      // Mac and Linux need to make adb executable
      Log.d("Giving executable access to ADB");
      await Process.run('chmod', ['+x', adbFile.path]);
    }

    Log.d("Initialized ADB file: ${adbFile.path}");
    return adbFile;
  }
}
