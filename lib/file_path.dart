import 'dart:io';
import 'package:android_sideloader/extensions.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'logs/log.dart';

class FilePath {
  static Future<String> get path async {
    return (await directory).path;
  }

  static Future<Directory>? _directory;
  static Future<Directory> get directory async {
    return _directory ??= _initializeDir();
  }

  static Future<Directory> _initializeDir() async {
    final Directory tempDir = await getTemporaryDirectory();
    final path = p.normalize('${tempDir.path}/android_sideloader');
    final ret = await Directory(path).create(recursive: true);
    Log.d("Initialized data directory: ${ret.path}");
    return ret;
  }

  static Future<File> getFile(String newPath) async {
    final file = File(p.normalize('${await path}/$newPath'));
    if (!await file.exists()) {
      await file.create(recursive: true);
    }
    Log.d("Getting / creating file: ${file.path}");
    return file;
  }

  static Future<File> extractAsset(String assetPath) async {
    final file = await getFile(assetPath);
    final asset = await rootBundle.load(assetPath);
    if (await file.isEqualToByteData(asset)) {
      Log.i("Asset already exists: $assetPath");
      return file;
    }
    final ret = await file.writeAsBytes(asset.buffer.asUint8List());
    Log.d("Extracted asset: ${ret.path}");
    return ret;
  }
}
