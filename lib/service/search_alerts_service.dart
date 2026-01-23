import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/constants/constants.dart';
import 'package:app/providers/provider_models/search_alert_model.dart';

/// Search Alerts API Service
class SearchAlertsService {
  SharedPreferences? _prefs;

  Future<SharedPreferences> _getPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  Future<Map<String, String>> _getAuthHeaders() async {
    final prefs = await _getPrefs();
    final token = prefs.getString('token');
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Token $token',
    };
  }

  /// Create a search alert
  Future<SearchAlert?> createAlert({
    required String keyword,
    String itemType = 'all',
    int? categoryId,
    String? region,
    String? district,
    String? minPrice,
    String? maxPrice,
    bool notifyPush = true,
    bool notifyEmail = false,
  }) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/api/notifications/alerts/'),
        headers: headers,
        body: jsonEncode({
          'keyword': keyword,
          'item_type': itemType,
          if (categoryId != null) 'category_id': categoryId,
          if (region != null) 'region': region,
          if (district != null) 'district': district,
          if (minPrice != null) 'min_price': minPrice,
          if (maxPrice != null) 'max_price': maxPrice,
          'notify_push': notifyPush,
          'notify_email': notifyEmail,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          return SearchAlert.fromJson(data['data']);
        }
      }

      // Check for max alerts error
      if (response.statusCode == 400) {
        final data = jsonDecode(response.body);
        throw Exception(data['error'] ?? 'Failed to create alert');
      }

      return null;
    } catch (e) {
      print('Error creating search alert: $e');
      rethrow;
    }
  }

  /// Get user's search alerts
  Future<List<SearchAlert>> getAlerts() async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/api/notifications/alerts/'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          return (data['data'] as List)
              .map((a) => SearchAlert.fromJson(a))
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('Error getting search alerts: $e');
      return [];
    }
  }

  /// Get single alert
  Future<SearchAlert?> getAlert(int alertId) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/api/notifications/alerts/$alertId/'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          return SearchAlert.fromJson(data['data']);
        }
      }
      return null;
    } catch (e) {
      print('Error getting search alert: $e');
      return null;
    }
  }

  /// Update search alert
  Future<SearchAlert?> updateAlert({
    required int alertId,
    String? keyword,
    String? itemType,
    int? categoryId,
    String? region,
    String? district,
    String? minPrice,
    String? maxPrice,
    bool? notifyPush,
    bool? notifyEmail,
  }) async {
    try {
      final headers = await _getAuthHeaders();
      final body = <String, dynamic>{};

      if (keyword != null) body['keyword'] = keyword;
      if (itemType != null) body['item_type'] = itemType;
      if (categoryId != null) body['category_id'] = categoryId;
      if (region != null) body['region'] = region;
      if (district != null) body['district'] = district;
      if (minPrice != null) body['min_price'] = minPrice;
      if (maxPrice != null) body['max_price'] = maxPrice;
      if (notifyPush != null) body['notify_push'] = notifyPush;
      if (notifyEmail != null) body['notify_email'] = notifyEmail;

      final response = await http.put(
        Uri.parse('$baseUrl/api/notifications/alerts/$alertId/'),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          return SearchAlert.fromJson(data['data']);
        }
      }
      return null;
    } catch (e) {
      print('Error updating search alert: $e');
      return null;
    }
  }

  /// Toggle alert on/off
  Future<Map<String, dynamic>> toggleAlert(int alertId) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/api/notifications/alerts/$alertId/toggle/'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': data['success'] ?? true,
          'message': data['message'],
          'isActive': data['is_active'],
        };
      }

      return {
        'success': false,
        'message': 'Failed to toggle alert',
      };
    } catch (e) {
      print('Error toggling search alert: $e');
      return {
        'success': false,
        'message': 'Network error: $e',
      };
    }
  }

  /// Delete search alert
  Future<bool> deleteAlert(int alertId) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.delete(
        Uri.parse('$baseUrl/api/notifications/alerts/$alertId/'),
        headers: headers,
      );

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print('Error deleting search alert: $e');
      return false;
    }
  }

  /// Get alerts count
  Future<int> getAlertsCount() async {
    try {
      final alerts = await getAlerts();
      return alerts.length;
    } catch (e) {
      return 0;
    }
  }

  /// Get active alerts count
  Future<int> getActiveAlertsCount() async {
    try {
      final alerts = await getAlerts();
      return alerts.where((a) => a.isActive).length;
    } catch (e) {
      return 0;
    }
  }
}
