import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class AdbPath {
  AdbPath._internal();
  static final AdbPath instance = AdbPath._internal();
  factory AdbPath() => instance;

  Future<String>? _adbPath;

  Future<String> get adbPath async {
    return _adbPath ??= _initializeAdbPath();
  }

  Future<String> _initializeAdbPath() async {
    final adbAssetPath = "assets/adb/${
        Platform.isWindows ? "adb.exe" :
        Platform.isLinux ? "adb-linux" :
        Platform.isMacOS ? "adb-mac-intel" :
        throw UnsupportedError(
            'Unsupported platform: ${Platform.operatingSystem}'
        )
    }";

    final adbFile = await _unpackageAsset(adbAssetPath);

    if (Platform.isWindows) {
      // Windows needs some extra files
      await _unpackageAsset("assets/adb/AdbWinApi.dll");
      await _unpackageAsset("assets/adb/AdbWinUsbApi.dll");
      await _unpackageAsset("assets/adb/libusb-1.0.dll");
    } else {
      // Mac and Linux need to make adb executable
      await Process.run('chmod', ['+x', adbFile.path]);
    }

    return adbFile.path;
  }

  Future<File> _unpackageAsset(String assetPath) async {
    final Directory tempDir = await getTemporaryDirectory();
    final path = p.normalize('${tempDir.path}/android_sideloader/$assetPath');
    final file = await File(path).create(recursive: true);
    final asset = await rootBundle.load(assetPath);
    return file.writeAsBytes(asset.buffer.asUint8List());
  }
}
