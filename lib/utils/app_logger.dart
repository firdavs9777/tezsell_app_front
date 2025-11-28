import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Centralized logging utility for the application.
/// 
/// Replaces all `print()` statements with proper structured logging.
/// Logs are only shown in debug mode to avoid performance issues in production.
class AppLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 80,
      colors: true,
      printEmojis: true,
      printTime: true,
    ),
    level: kDebugMode ? Level.debug : Level.nothing,
  );

  /// Log debug messages (only in debug mode)
  static void debug(String message) {
    if (kDebugMode) {
      _logger.d(message);
    }
  }

  /// Log info messages
  static void info(String message) {
    if (kDebugMode) {
      _logger.i(message);
    }
  }

  /// Log warning messages
  static void warning(String message, [Object? error]) {
    if (kDebugMode) {
      _logger.w(message, error: error);
    }
  }

  /// Log error messages with optional error and stack trace
  static void error(
    String message, [
    Object? error,
    StackTrace? stackTrace,
  ]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  /// Log verbose messages (for detailed debugging)
  static void verbose(String message) {
    if (kDebugMode) {
      _logger.t(message);
    }
  }
}

