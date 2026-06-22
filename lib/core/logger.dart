import 'package:flutter/foundation.dart';

enum LogLevel { debug, info, warning, error }

class Logger {
  static void log(LogLevel level, String message, {dynamic error, StackTrace? stack}) {
    final prefix = switch (level) {
      LogLevel.debug => '[DEBUG]',
      LogLevel.info => '[INFO]',
      LogLevel.warning => '[WARN]',
      LogLevel.error => '[ERROR]',
    };
    debugPrint('$prefix $message');
    if (error != null) debugPrint('  Error: $error');
    if (stack != null) debugPrint('  Stack: $stack');
  }
}
