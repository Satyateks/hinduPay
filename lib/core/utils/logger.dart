import 'dart:developer' as developer;

class AppLogger {
  AppLogger._();

  static void info(String message) {
    developer.log(message, name: 'INFO');
  }

  static void error(String message, {Object? error, StackTrace? stackTrace}) {
    developer.log(message, name: 'ERROR', error: error, stackTrace: stackTrace);
  }

  static void warning(String message) {
    developer.log(message, name: 'WARNING');
  }

  static void debug(String message) {
    developer.log(message, name: 'DEBUG');
  }
}
