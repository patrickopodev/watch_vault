import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

class ErrorHandler {
  static void handleError(
    BuildContext context,
    dynamic error,
    StackTrace? stackTrace,
  ) {
    final message = _userFriendlyMessage(error);
    _logError(error, stackTrace, message);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  static String _userFriendlyMessage(dynamic error) {
    if (error is SocketException) return 'No internet connection.';
    if (error is TimeoutException) return 'Request timed out.';
    if (error is HttpException) return 'Server error. Please try again.';
    return 'Something went wrong.';
  }

  static void _logError(dynamic error, StackTrace? stack, String message) {
    debugPrint('ERROR: $message');
    debugPrint('  Error: $error');
    if (stack != null) debugPrint('  Stack: $stack');
  }
}
