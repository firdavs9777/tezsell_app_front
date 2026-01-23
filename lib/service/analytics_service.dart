import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/config/app_config.dart';
import 'package:app/providers/provider_models/analytics_model.dart';

/// Service for handling seller analytics operations
class AnalyticsService {
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

  /// Get overall seller analytics
  Future<SellerAnalytics> getOverallAnalytics() async {
    final token = await _getToken();
    if (token == null) throw Exception('Not authenticated');

    final response = await http.get(
      Uri.parse('$baseUrl/api/reviews/analytics/'),
      headers: _getHeaders(token),
    );

    if (kDebugMode) {
      print('Analytics Response: ${response.statusCode}');
    }

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true && data['data'] != null) {
        return SellerAnalytics.fromJson(data['data']);
      }
      throw Exception('Failed to parse analytics data');
    } else {
      throw Exception('Failed to load analytics');
    }
  }

  /// Get analytics for a specific listing
  /// [itemType] - 'product' or 'service'
  /// [itemId] - The ID of the listing
  Future<ListingAnalytics> getListingAnalytics(String itemType, int itemId) async {
    final token = await _getToken();
    if (token == null) throw Exception('Not authenticated');

    final response = await http.get(
      Uri.parse('$baseUrl/api/reviews/analytics/$itemType/$itemId/'),
      headers: _getHeaders(token),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true && data['data'] != null) {
        return ListingAnalytics.fromJson(data['data']);
      }
      throw Exception('Failed to parse listing analytics');
    } else {
      throw Exception('Failed to load listing analytics');
    }
  }

  /// Record a view on a listing (call when user opens detail page)
  Future<void> recordView(String itemType, int itemId) async {
    final token = await _getToken();
    // Views can be recorded without authentication for public listings

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/favorites/recently-viewed/record/'),
        headers: _getHeaders(token),
        body: jsonEncode({
          'item_type': itemType,
          'item_id': itemId,
        }),
      );

      if (kDebugMode) {
        print('Record View Response: ${response.statusCode}');
      }
    } catch (e) {
      // Silently fail - view tracking shouldn't break the app
      if (kDebugMode) {
        print('Failed to record view: $e');
      }
    }
  }
}
