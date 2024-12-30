import 'package:flutter/material.dart';

import 'adb/adb_device_tracker.dart';
import 'log.dart';

class DeviceListWidget extends StatefulWidget {
  final void Function(String? selectedDevice) onDeviceSelected;

  const DeviceListWidget({super.key, required this.onDeviceSelected});

  @override
  State<DeviceListWidget> createState() => _DeviceListWidgetState();
}

class _DeviceListWidgetState extends State<DeviceListWidget> {
  final AdbDeviceTracker _tracker = AdbDeviceTracker();
  String? _selectedDevice;
  List<String> _devices = [];

  @override
  void initState() {
    super.initState();
    _tracker.startTracking((devices) {
      setState(() {
        _devices = devices;
      });
    });
  }

  @override
  void dispose() {
    _tracker.stopTracking();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: SizedBox(
        width: 250,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Connected Devices',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            Expanded(
              child: Builder(
                builder: (context) {
                  if (_devices.isEmpty) {
                    if (_selectedDevice != null) {
                      _selectedDevice = null;
                      Log.d('Devices empty on build. Set selected null.');
                      widget.onDeviceSelected.call(null);
                    }
                    return const Center(
                        child: Text(
                          'No devices connected\n\nPlease connect your device',
                          textAlign: TextAlign.center,
                        )
                    );
                  } else {
                    if (_selectedDevice == null) {
                      _selectedDevice = _devices.first;
                      Log.d('First device connected. Setting selected.');
                      widget.onDeviceSelected.call(_selectedDevice);
                    }
                    if (!_devices.contains(_selectedDevice)) {
                      Log.d('Selected device removed. Setting to first device');
                      _selectedDevice = _devices.first;
                      widget.onDeviceSelected.call(_selectedDevice);
                    }
                  }

                  return ListView.builder(
                    itemCount: _devices.length,
                    itemBuilder: (context, index) {
                      final device = _devices[index];
                      final isSelected = device == _selectedDevice;
                      return GestureDetector(
                        onTap: () {
                          widget.onDeviceSelected.call(device);
                          setState(() {
                            Log.d('User selected device: $device');
                            _selectedDevice = device;
                          });
                        },
                        child: Container(
                          color: isSelected ?
                            theme.colorScheme.primary.withAlpha(32) :
                              Colors.transparent,
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 16.0
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.devices,
                                color: theme.colorScheme.onSurface
                              ),
                              const SizedBox(width: 10),
                              Flexible(
                                child: Text(
                                  device,
                                  style: TextStyle(
                                    color: theme.colorScheme.onSurface
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}