import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/config/app_config.dart';
import 'package:app/utils/app_logger.dart';

/// Result of a report submission
class ReportResult {
  final bool success;
  final String? errorMessage;
  final String? errorCode; // 'already_reported', 'invalid', etc.

  ReportResult({
    required this.success,
    this.errorMessage,
    this.errorCode,
  });
}

/// Service for reporting objectionable content.
/// 
/// Handles reporting of products, services, messages, and users.
class ContentReportService {
  static const String _reportEndpoint = '/api/reports/';

  /// Get authentication headers
  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    
    final headers = {
      'Content-Type': 'application/json',
    };
    
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Token $token';
    }
    
    return headers;
  }

  /// Parse error response and return error details
  ReportResult _parseErrorResponse(int statusCode, String responseBody) {
    try {
      final errorData = json.decode(responseBody) as Map<String, dynamic>;
      final errorMessage = errorData['error'] as String?;
      
      if (errorMessage != null) {
        if (errorMessage.toLowerCase().contains('already reported')) {
          return ReportResult(
            success: false,
            errorMessage: errorMessage,
            errorCode: 'already_reported',
          );
        }
      }
      
      return ReportResult(
        success: false,
        errorMessage: errorMessage ?? 'Failed to submit report',
        errorCode: 'unknown',
      );
    } catch (e) {
      return ReportResult(
        success: false,
        errorMessage: 'Failed to submit report',
        errorCode: 'parse_error',
      );
    }
  }

  /// Report a product
  /// 
  /// [productId] - ID of the product to report
  /// [reason] - Reason for reporting (e.g., 'spam', 'inappropriate', 'fraud', 'other')
  /// [description] - Optional additional details
  Future<ReportResult> reportProduct({
    required int productId,
    required String reason,
    String? description,
  }) async {
    try {
      final headers = await _getHeaders();
      
      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}$_reportEndpoint'),
        headers: headers,
        body: json.encode({
          'content_type': 'product',
          'content_id': productId,
          'reason': reason,
          'description': description ?? '',
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        AppLogger.info('Product reported successfully: $productId');
        return ReportResult(success: true);
      } else {
        final responseBody = utf8.decode(response.bodyBytes);
        AppLogger.error('Failed to report product: ${response.statusCode}');
        AppLogger.error('Response: $responseBody');
        return _parseErrorResponse(response.statusCode, responseBody);
      }
    } catch (e) {
      AppLogger.error('Error reporting product: $e');
      return ReportResult(
        success: false,
        errorMessage: 'Network error occurred',
        errorCode: 'network_error',
      );
    }
  }

  /// Report a service
  /// 
  /// [serviceId] - ID of the service to report
  /// [reason] - Reason for reporting
  /// [description] - Optional additional details
  Future<ReportResult> reportService({
    required int serviceId,
    required String reason,
    String? description,
  }) async {
    try {
      final headers = await _getHeaders();
      
      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}$_reportEndpoint'),
        headers: headers,
        body: json.encode({
          'content_type': 'service',
          'content_id': serviceId,
          'reason': reason,
          'description': description ?? '',
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        AppLogger.info('Service reported successfully: $serviceId');
        return ReportResult(success: true);
      } else {
        final responseBody = utf8.decode(response.bodyBytes);
        AppLogger.error('Failed to report service: ${response.statusCode}');
        AppLogger.error('Response: $responseBody');
        
        // Log more details for debugging
        if (response.statusCode == 403) {
          AppLogger.error('403 Forbidden - Endpoint may not exist or user lacks permission');
        }
        return _parseErrorResponse(response.statusCode, responseBody);
      }
    } catch (e) {
      AppLogger.error('Error reporting service: $e');
      return ReportResult(
        success: false,
        errorMessage: 'Network error occurred',
        errorCode: 'network_error',
      );
    }
  }

  /// Report a message
  /// 
  /// [messageId] - ID of the message to report
  /// [reason] - Reason for reporting
  /// [description] - Optional additional details
  Future<ReportResult> reportMessage({
    required int messageId,
    required String reason,
    String? description,
  }) async {
    try {
      final headers = await _getHeaders();
      
      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}$_reportEndpoint'),
        headers: headers,
        body: json.encode({
          'content_type': 'message',
          'content_id': messageId,
          'reason': reason,
          'description': description ?? '',
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        AppLogger.info('Message reported successfully: $messageId');
        return ReportResult(success: true);
      } else {
        final responseBody = utf8.decode(response.bodyBytes);
        AppLogger.error('Failed to report message: ${response.statusCode}');
        AppLogger.error('Response: $responseBody');
        return _parseErrorResponse(response.statusCode, responseBody);
      }
    } catch (e) {
      AppLogger.error('Error reporting message: $e');
      return ReportResult(
        success: false,
        errorMessage: 'Network error occurred',
        errorCode: 'network_error',
      );
    }
  }

  /// Report a user
  /// 
  /// [userId] - ID of the user to report
  /// [reason] - Reason for reporting
  /// [description] - Optional additional details
  Future<ReportResult> reportUser({
    required int userId,
    required String reason,
    String? description,
  }) async {
    try {
      final headers = await _getHeaders();
      
      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}$_reportEndpoint'),
        headers: headers,
        body: json.encode({
          'content_type': 'user',
          'content_id': userId,
          'reason': reason,
          'description': description ?? '',
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        AppLogger.info('User reported successfully: $userId');
        return ReportResult(success: true);
      } else {
        final responseBody = utf8.decode(response.bodyBytes);
        AppLogger.error('Failed to report user: ${response.statusCode}');
        AppLogger.error('Response: $responseBody');
        return _parseErrorResponse(response.statusCode, responseBody);
      }
    } catch (e) {
      AppLogger.error('Error reporting user: $e');
      return ReportResult(
        success: false,
        errorMessage: 'Network error occurred',
        errorCode: 'network_error',
      );
    }
  }

  /// Report a property
  /// 
  /// [propertyId] - ID of the property to report (UUID string)
  /// [reason] - Reason for reporting
  /// [description] - Optional additional details
  Future<ReportResult> reportProperty({
    required String propertyId,
    required String reason,
    String? description,
  }) async {
    try {
      final headers = await _getHeaders();
      
      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}$_reportEndpoint'),
        headers: headers,
        body: json.encode({
          'content_type': 'property',
          'content_id': propertyId,
          'reason': reason,
          'description': description ?? '',
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        AppLogger.info('Property reported successfully: $propertyId');
        return ReportResult(success: true);
      } else {
        final responseBody = utf8.decode(response.bodyBytes);
        AppLogger.error('Failed to report property: ${response.statusCode}');
        AppLogger.error('Response: $responseBody');
        return _parseErrorResponse(response.statusCode, responseBody);
      }
    } catch (e) {
      AppLogger.error('Error reporting property: $e');
      return ReportResult(
        success: false,
        errorMessage: 'Network error occurred',
        errorCode: 'network_error',
      );
    }
  }
}

