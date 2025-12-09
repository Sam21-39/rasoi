import 'package:flutter/foundation.dart';

/// Log levels
enum LogLevel { debug, info, warning, error }

/// Centralized logging service
class LoggerService {
  static final LoggerService _instance = LoggerService._internal();
  factory LoggerService() => _instance;
  LoggerService._internal();

  /// Log a debug message
  void debug(String message, [String? tag]) {
    _log(LogLevel.debug, message, tag);
  }

  /// Log an info message
  void info(String message, [String? tag]) {
    _log(LogLevel.info, message, tag);
  }

  /// Log a warning message
  void warning(String message, [String? tag]) {
    _log(LogLevel.warning, message, tag);
  }

  /// Log an error message
  void error(String message, [dynamic error, StackTrace? stackTrace, String? tag]) {
    _log(LogLevel.error, message, tag, error: error, stackTrace: stackTrace);
  }

  /// Internal log method
  void _log(LogLevel level, String message, String? tag, {dynamic error, StackTrace? stackTrace}) {
    // Only log in debug mode
    if (!kDebugMode && level != LogLevel.error) {
      return;
    }

    final timestamp = DateTime.now().toIso8601String();
    final levelStr = level.name.toUpperCase().padRight(7);
    final tagStr = tag != null ? '[$tag]' : '';

    final logMessage = '$timestamp $levelStr $tagStr $message';

    // Print to console
    switch (level) {
      case LogLevel.debug:
        debugPrint('🔍 $logMessage');
        break;
      case LogLevel.info:
        debugPrint('ℹ️  $logMessage');
        break;
      case LogLevel.warning:
        debugPrint('⚠️  $logMessage');
        break;
      case LogLevel.error:
        debugPrint('❌ $logMessage');
        if (error != null) {
          debugPrint('   Error: $error');
        }
        if (stackTrace != null) {
          debugPrint('   StackTrace: $stackTrace');
        }
        break;
    }

    // In production, you could send errors to a crash reporting service
    // if (level == LogLevel.error && !kDebugMode) {
    //   // Send to Firebase Crashlytics, Sentry, etc.
    // }
  }
}
