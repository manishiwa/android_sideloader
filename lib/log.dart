import 'dart:async';
import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';

import 'file_path.dart';

class Log {
  static late Logger _log;

  static t(dynamic message, {Object? error, StackTrace? stackTrace}) =>
    _log.t(message, error: error, stackTrace: stackTrace);

  static d(dynamic message, {Object? error, StackTrace? stackTrace}) =>
    _log.d(message, error: error, stackTrace: stackTrace);

  static i(dynamic message, {Object? error, StackTrace? stackTrace}) =>
    _log.i(message, error: error, stackTrace: stackTrace);

  static w(dynamic message, {Object? error, StackTrace? stackTrace}) =>
    _log.w(message, error: error, stackTrace: stackTrace);

  static e(dynamic message, {Object? error, StackTrace? stackTrace}) =>
    _log.e(message, error: error, stackTrace: stackTrace);

  static f(dynamic message, {Object? error, StackTrace? stackTrace}) =>
    _log.f(message, error: error, stackTrace: stackTrace);

  static Future<void> init(
    Function entrypoint, {Level level = Level.all}
  ) async => await _setupUncaughtExceptionLogging(() async {
    final pretty = PrettyPrinter(
      stackTraceBeginIndex: 1,
      errorMethodCount: 16,
      methodCount: 4,
      dateTimeFormat: DateTimeFormat.dateAndTime,
    );
    final simple = SimplePrinter(printTime: true);
    final hybrid = HybridPrinter(pretty, trace: simple, debug: simple);

    // Temporary in-memory logger until the log file is created
    final memoryLogOutput = _MemoryLogOutput();
    _log = Logger(
      filter: ProductionFilter(),
      printer: hybrid,
      output: memoryLogOutput,
      level: level,
    );
    await _log.init;

    final fullOutput = MultiOutput([
      ConsoleOutput(),
      FileOutput(file: await FilePath.getFile("log.txt")),
    ]);
    _log = Logger(
        filter: ProductionFilter(),
        printer: hybrid,
        output: fullOutput,
        level: level
    );
    await _log.init;
    memoryLogOutput.flushTo(fullOutput);

    // Run app entrypoint code
    entrypoint();
  });

  static _setupUncaughtExceptionLogging(Function entrypoint) {
    runZonedGuarded(
      () async {
        WidgetsFlutterBinding.ensureInitialized();
        FlutterError.onError = (FlutterErrorDetails details) {
          _log.e(
              "Uncaught Flutter framework exception",
              error: details.exception,
              stackTrace: details.stack
          );
        };
        PlatformDispatcher.instance.onError = (error, stack) {
          _log.e("Uncaught async exception", error: error, stackTrace: stack);
          return false;
        };
        await entrypoint();
      },
      (error, stack) {
        _log.e("Uncaught Zoned exception", error: error, stackTrace: stack);
      }
    );
  }
}

class _MemoryLogOutput extends LogOutput {
  final List<OutputEvent> _logs = [];

  @override
  void output(OutputEvent event) => _logs.add(event);

  void clearLogs() => _logs.clear();

  void flushTo(LogOutput output) {
    for (final line in _logs) {
      output.output(line);
    }
    clearLogs();
  }
}
