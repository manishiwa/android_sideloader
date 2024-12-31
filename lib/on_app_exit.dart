import 'dart:io';
import 'package:window_manager/window_manager.dart';
import 'logs/log.dart';

class OnAppExit {
  static var _exitHooksInitialized = false;

  static void listen(Function onAppExit) {
    Log.d("Adding onAppExit listener");
    windowManager.addListener(_OnAppExitListener._internal(onAppExit));
    if (!_exitHooksInitialized) {
      _setupExitHooks();
    }
  }

  static void _setupExitHooks() {
    Log.d("Setting up exit hooks");
    final signals = [
      // Shutdowns
      ProcessSignal.sigint,
      if (!Platform.isWindows) ProcessSignal.sigterm,
      ProcessSignal.sighup,
      ProcessSignal.sigquit,
      ProcessSignal.sigkill,
      // Crashes
      ProcessSignal.sigabrt,
      ProcessSignal.sigsegv,
      ProcessSignal.sigill,
      ProcessSignal.sigbus,
    ];
    for (var signal in signals) {
      try {
        signal.watch().listen((_) async {
          Log.f('Received termination signal ($signal). Stop tracking...');
          for (final listener in windowManager.listeners) {
            listener.onWindowClose();
          }
        });
      } catch (ignored) {}
    }
    _exitHooksInitialized = true;
  }
}

class _OnAppExitListener extends WindowListener {
  final Function _onAppExit;

  _OnAppExitListener._internal(this._onAppExit);

  @override
  void onWindowClose() {
    Log.d("Calling onWindowClose");
    _onAppExit();
    super.onWindowClose();
  }
}
