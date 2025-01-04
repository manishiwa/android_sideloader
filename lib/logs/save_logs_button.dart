import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'log.dart';

class SaveLogButton extends StatelessWidget {
  const SaveLogButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: "Save logs",
      child: IconButton(
          onPressed: () {
            _showSaveAsDialog(
              onLogsSaved: (String logFilePath) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Log file saved successfully at "$logFilePath"'
                    )
                  ),
                );
              },
              onLogsFailedToSave: (Object error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Log file failed to save! "$error"')),
                );
              },
            );
          },
          icon: const Icon(Icons.bug_report_rounded)
      ),
    );
  }

  Future<void> _showSaveAsDialog({
    required Function(String logFilePath) onLogsSaved,
    required Function(Object error) onLogsFailedToSave,
  }) async {
    final String? selectedPath = await FilePicker.platform.saveFile(
      type: FileType.custom,
      dialogTitle: "Save logs",
      fileName: "android_sideloader_logs.txt",
      lockParentWindow: true,
      allowedExtensions: ["txt"],
    );

    if (selectedPath == null) {
      return;
    }

    final File selectedFile = File(selectedPath);

    try {
      await Log.logFile.copy(selectedFile.path);
      onLogsSaved(selectedFile.path);
    } catch (e) {
      Log.e("Failed to save logs!", error: e);
      onLogsFailedToSave(e);
    }
  }
}
