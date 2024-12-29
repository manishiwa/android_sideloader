import 'package:android_sideloader/adb/adb_device_tracker.dart';
import 'package:window_manager/window_manager.dart';

class AdbProcessKiller extends WindowListener {
  final AdbDeviceTracker adbDeviceTracker = AdbDeviceTracker.instance;

  @override
  void onWindowClose() {
    adbDeviceTracker.stopTracking();
    super.onWindowClose();
  }
}
