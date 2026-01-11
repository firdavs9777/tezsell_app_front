import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'app_logger.dart';

/// Custom API exception for handling HTTP errors with status codes
class ApiException implements Exception {
  final int statusCode;
  final String message;
  final Map<String, dynamic>? errors;

  ApiException({
    required this.statusCode,
    required this.message,
    this.errors,
  });

  /// Create from HTTP response
  factory ApiException.fromResponse(int statusCode, dynamic body) {
    String message;
    Map<String, dynamic>? errors;

    if (body is Map<String, dynamic>) {
      message = body['error'] ?? body['message'] ?? _getDefaultMessage(statusCode);
      errors = body['errors'] as Map<String, dynamic>?;
    } else if (body is String) {
      message = body;
    } else {
      message = _getDefaultMessage(statusCode);
    }

    return ApiException(
      statusCode: statusCode,
      message: message,
      errors: errors,
    );
  }

  static String _getDefaultMessage(int statusCode) {
    switch (statusCode) {
      case 400:
        return "Noto'g'ri so'rov. Ma'lumotlarni tekshiring.";
      case 401:
        return "Avtorizatsiya talab qilinadi. Iltimos, qaytadan kiring.";
      case 403:
        return "Ruxsat yo'q. Siz faqat o'z e'lonlaringizni tahrirlashingiz mumkin.";
      case 404:
        return "Topilmadi. So'ralgan ma'lumot mavjud emas.";
      case 422:
        return "Ma'lumotlar noto'g'ri. Iltimos, tekshiring.";
      case 429:
        return "Juda ko'p so'rov. Biroz kutib turing.";
      case 500:
        return "Server xatosi. Keyinroq urinib ko'ring.";
      case 502:
        return "Server vaqtincha ishlamayapti.";
      case 503:
        return "Xizmat vaqtincha mavjud emas.";
      default:
        return "Kutilmagan xatolik yuz berdi.";
    }
  }

  @override
  String toString() => message;

  /// Check if error is due to authorization (ownership) issue
  bool get isForbidden => statusCode == 403;

  /// Check if error is due to not being logged in
  bool get isUnauthorized => statusCode == 401;

  /// Check if error is validation error
  bool get isValidationError => statusCode == 400 || statusCode == 422;

  /// Check if error is server error
  bool get isServerError => statusCode >= 500;
}

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

    // Handle our custom API exception
    if (error is ApiException) {
      return error.message;
    }

    if (error is SocketException) {
      return "Internet aloqasi yo'q. Tarmoqni tekshiring.";
    } else if (error is TimeoutException) {
      return "So'rov vaqti tugadi. Qayta urinib ko'ring.";
    } else if (error is HttpException) {
      return "Server xatosi. Keyinroq urinib ko'ring.";
    } else if (error is FormatException) {
      return "Ma'lumot formati noto'g'ri.";
    } else if (error is Exception) {
      return error.toString().replaceFirst('Exception: ', '');
    }
    return "Kutilmagan xatolik yuz berdi.";
  }

  /// Get error message for specific HTTP status code
  static String getHttpErrorMessage(int statusCode, {String? serverMessage}) {
    if (serverMessage != null && serverMessage.isNotEmpty) {
      return serverMessage;
    }
    return ApiException._getDefaultMessage(statusCode);
  }

  /// Check if status code indicates forbidden (ownership) error
  static bool isForbiddenError(int statusCode) => statusCode == 403;

  /// Check if status code indicates unauthorized (login required) error
  static bool isUnauthorizedError(int statusCode) => statusCode == 401;

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

