import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';

class DragAndDropApk extends StatefulWidget {
  final Widget child;
  final Function(String) onApkDropped;

  const DragAndDropApk({
    super.key, required this.child, required this.onApkDropped,
  });

  @override
  State<DragAndDropApk> createState() => _DragAndDropApkState();
}

class _DragAndDropApkState extends State<DragAndDropApk> {
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    return DropTarget(
      onDragEntered: (details) {
        setState(() {
          _isDragging = true;
        });
      },
      onDragExited: (details) {
        setState(() {
          _isDragging = false;
        });
      },
      onDragDone: (details) async {
        if (details.files.isNotEmpty) {
          final file = details.files.first;
          if (file.name.toLowerCase().endsWith('.apk')) {
            _handleApkDropped(file.path);
          } else {
            _handleInvalidFileDropped();
          }
        }
      },
      child: Stack(
        children: [
          widget.child,
          if (_isDragging)
            Positioned.fill(
              child: Stack(
                children: [
                  Container(
                    color: Colors.black.withAlpha(128),
                  ),
                  AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    content: Padding(
                      padding: const EdgeInsets.all(64.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                              Icons.file_download,
                              size: 50,
                              color: Colors.blue
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Drag and drop your APK file here',
                            style: Theme.of(context).textTheme.bodyLarge,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _handleApkDropped(String filePath) {
    widget.onApkDropped(filePath);
    setState(() {
      _isDragging = false;
    });
  }

  void _handleInvalidFileDropped() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        icon: const Icon(Icons.warning_rounded, color: Colors.orange, size: 48),
        title: const Text('Invalid File'),
        content: const Text('You can only drag and drop APK files here',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
