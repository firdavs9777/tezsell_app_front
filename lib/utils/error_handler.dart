import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'app_logger.dart';

/// Centralized error handling utility.
/// 
/// Provides consistent error message formatting and display
/// across the entire application.
class AppErrorHandler {
  /// Get a user-friendly error message from various error types
  static String getErrorMessage(dynamic error) {
    // If it's already a String, return it directly
    if (error is String) {
      return error;
    }
    
    if (error is SocketException) {
      return 'No internet connection. Please check your network and try again.';
    } else if (error is TimeoutException) {
      return 'Request timed out. Please try again.';
    } else if (error is HttpException) {
      return 'Server error occurred. Please try again later.';
    } else if (error is FormatException) {
      return 'Invalid data format. Please try again.';
    } else if (error is Exception) {
      return error.toString().replaceFirst('Exception: ', '');
    }
    return 'An unexpected error occurred. Please try again.';
  }

  /// Show error message as a SnackBar
  /// 
  /// [error] can be a String message or an error object
  static void showError(BuildContext context, dynamic error) {
    if (!context.mounted) return;
    
    final message = getErrorMessage(error);
    // Only log as error if it's not already a user-friendly string
    if (error is String) {
      AppLogger.warning('Error message shown to user: $message');
    } else {
      AppLogger.error('Error shown to user: $message', error);
    }
    
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {
            // Check if context is still mounted before hiding
            if (context.mounted) {
              scaffoldMessenger.hideCurrentSnackBar();
            }
          },
        ),
      ),
    );
  }

  /// Show success message as a SnackBar
  static void showSuccess(BuildContext context, String message) {
    if (!context.mounted) return;
    
    AppLogger.info('Success message: $message');
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Show warning message as a SnackBar
  static void showWarning(BuildContext context, String message) {
    if (!context.mounted) return;
    
    AppLogger.warning('Warning message: $message');
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Log error with full details (for debugging)
  static void logError(
    String context,
    dynamic error, [
    StackTrace? stackTrace,
  ]) {
    AppLogger.error('Error in $context', error, stackTrace);
  }
}

