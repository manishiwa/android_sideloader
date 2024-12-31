
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';

extension FileExtensions on File {
  Future<String> computeFileHash() async {
    return sha256.convert(await readAsBytes()).toString();
  }

  Future<bool> isEqualTo(File other) async {
    if (!await exists() || !await other.exists()) {
      return false;
    }
    return await computeFileHash() == await other.computeFileHash();
  }

  Future<bool> isEqualToByteData(ByteData byteData) async {
    if (!await exists()) {
      return false;
    }
    final dataHash = sha256.convert(byteData.buffer.asUint8List()).toString();
    return await computeFileHash() == dataHash;
  }
}

extension ColorExtensions on Color {
  Color? lerp(Color other, double t) => Color.lerp(this, other, t);
}
