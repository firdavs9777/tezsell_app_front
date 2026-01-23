import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/config/app_config.dart';
import 'package:app/providers/provider_models/report_model.dart';

/// Service for handling content reporting operations
class ReportService {
  final String baseUrl = AppConfig.baseUrl;

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Map<String, String> _getHeaders(String? token) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Token $token',
    };
  }

  /// Submit a report
  Future<Report> submitReport(SubmitReportRequest request) async {
    final token = await _getToken();
    if (token == null) throw Exception('Not authenticated');

    final response = await http.post(
      Uri.parse('$baseUrl/api/moderation/reports/'),
      headers: _getHeaders(token),
      body: jsonEncode(request.toJson()),
    );

    if (kDebugMode) {
      print('Submit Report Response: ${response.statusCode}');
    }

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      if (data['success'] == true && data['data'] != null) {
        return Report.fromJson(data['data']);
      }
      throw Exception(data['message'] ?? 'Failed to submit report');
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? error['error'] ?? 'Failed to submit report');
    }
  }

  /// Get report status
  Future<Report> getReportStatus(int reportId) async {
    final token = await _getToken();
    if (token == null) throw Exception('Not authenticated');

    final response = await http.get(
      Uri.parse('$baseUrl/api/moderation/reports/$reportId/'),
      headers: _getHeaders(token),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true && data['data'] != null) {
        return Report.fromJson(data['data']);
      }
      throw Exception('Report not found');
    } else {
      throw Exception('Failed to load report status');
    }
  }

  /// Get list of user's submitted reports
  Future<List<Report>> getMyReports() async {
    final token = await _getToken();
    if (token == null) throw Exception('Not authenticated');

    final response = await http.get(
      Uri.parse('$baseUrl/api/moderation/reports/'),
      headers: _getHeaders(token),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true && data['data'] != null) {
        return (data['data'] as List)
            .map((json) => Report.fromJson(json))
            .toList();
      }
      return [];
    } else {
      throw Exception('Failed to load reports');
    }
  }
}
