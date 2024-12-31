import 'dart:io';
import 'package:android_sideloader/log.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:logger/logger.dart';
import 'package:window_manager/window_manager.dart';

import 'adb/adb.dart';
import 'apk_drop.dart';
import 'device_list_widget.dart';

void main() async => await Log.init(level: Level.all, () async {
  Log.i("Logging initialized. Starting app...");
  await windowManager.ensureInitialized();

  windowManager.waitUntilReadyToShow(
    const WindowOptions(
      title: "App Sideloader",
      size: Size(800, 600),
      maximumSize: Size(1200, 900),
      minimumSize: Size(800, 600),
    ),
    () async {
      await windowManager.show();
      await windowManager.focus();
    },
  );

  runApp(const SideloaderApp());
});

class SideloaderApp extends StatelessWidget {
  const SideloaderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Sideloader',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.light
        ),
        useMaterial3: true,
        brightness: Brightness.light
      ),
      darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue,
              brightness: Brightness.dark
          ),
          useMaterial3: true,
          brightness: Brightness.dark
      ),
      themeMode: ThemeMode.dark,
      home: const HomeScreen(title: 'App Sideloader'),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _selectedDevice;
  String? _selectedFile;
  bool get _isButtonEnabled => _selectedDevice != null && _selectedFile != null;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['apk'], // Restrict to APK files only
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedFile = result.files.single.path!;
        Log.i("Selected APK file $_selectedFile");
      });
    } else {
      Log.w("Did not pick good file: $result");
    }
  }

  Future<void> _installAPK() async {
    final selectedFile = _selectedFile;
    if (selectedFile == null || _selectedDevice == null) return;
    Adb.installAPK(
      device: _selectedDevice,
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

  @override
  Widget build(BuildContext context) {
    return DragAndDropApk(
      onApkDropped: (String s) {
        setState(() => _selectedFile = s );
      },
      child: Scaffold(
        floatingActionButton: IconButton(
            onPressed: () {

            },
            icon: const Icon(Icons.help)
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
                      _selectedFile != null
                          ? 'Selected File: ${
                            _selectedFile!.split(Platform.pathSeparator).last
                          }' : 'No file selected',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _selectedFile != null ?
                          Colors.green : Colors.red,
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