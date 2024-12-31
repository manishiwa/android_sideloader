import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../adb/adb.dart';
import '../adb/adb_device.dart';
import '../logs/log.dart';
import '../logs/save_logs_button.dart';
import 'device_list_widget.dart';
import 'drag_and_drop_apk.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AdbDevice? _selectedDevice;
  String? _selectedFile;
  String? get _selectedFileName =>
      _selectedFile!.split(Platform.pathSeparator).last;
  bool get _isButtonEnabled => _selectedDevice != null && _selectedFile != null;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['apk'],
    );

    final path = result?.files.single.path;
    if (path != null) {
      setState(() {
        _selectedFile = path;
        Log.i("Selected APK file $_selectedFile");
      });
    } else {
      Log.w("Did not pick good file: $result");
    }
  }

  Future<void> _installAPK() async {
    final selectedFile = _selectedFile;
    final deviceId = _selectedDevice?.id;
    if (selectedFile == null || deviceId == null) {
      return;
    }
    Adb.installAPK(
      device: deviceId,
      filePath: selectedFile,
      onSuccess: (outText) {
        Log.i("Successfully installed APK file $_selectedFile:\n$outText");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('App successfully installed!'),
            ),
          );
        }
      },
      onFailure: (errorMessage) {
        Log.w("Failed to install APK file $_selectedFile:\n$errorMessage");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to install app: $errorMessage'),
            ),
          );
        }
      },
    );
  }

  void _launchHelpURL() async {
    final Uri url = Uri.parse(
      'https://github.com/ryan-andrew/android_sideloader?tab=readme-ov-file#android-sideloader'
    );
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return DragAndDropApk(
      onApkDropped: (String s) {
        setState(() => _selectedFile = s );
      },
      child: Scaffold(
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SaveLogButton(),
            const SizedBox(width: 8),
            Tooltip(
              message: "More Information",
              child: IconButton(
                onPressed: () => _launchHelpURL(),
                icon: const Icon(Icons.help),
              ),
            ),
          ],
        ),
        body: Row(
          children: [
            DeviceListWidget(
              onDeviceSelected: (device) {
                Log.i("Selected device $device");
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() => _selectedDevice = device);
                });
              },
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _selectedFile == null
                        ? 'No file selected'
                        : 'Selected File: $_selectedFileName',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _selectedFile == null
                          ? Colors.red
                          : Colors.green,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: _pickFile,
                          child: const Text('Choose APK File'),
                        ),
                        const SizedBox(width: 40),
                        ElevatedButton(
                          onPressed: _isButtonEnabled ? _installAPK : null,
                          child: const Text('Install APK'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
