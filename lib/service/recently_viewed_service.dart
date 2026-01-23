import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/constants/constants.dart';
import 'package:app/providers/provider_models/recently_viewed_model.dart';

/// Recently Viewed API Service
class RecentlyViewedService {
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

  /// Get recently viewed items
  Future<List<RecentlyViewedItem>> getRecentlyViewed({
    int? limit,
    String? itemType,
  }) async {
    try {
      final headers = await _getAuthHeaders();

      var url = '$baseUrl/api/favorites/recently-viewed/';
      final queryParams = <String, String>{};
      if (limit != null) queryParams['limit'] = limit.toString();
      if (itemType != null) queryParams['type'] = itemType;

      if (queryParams.isNotEmpty) {
        url += '?${Uri(queryParameters: queryParams).query}';
      }

      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          return (data['data'] as List)
              .map((item) => RecentlyViewedItem.fromJson(item))
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('Error getting recently viewed: $e');
      return [];
    }
  }

  /// Record a view
  Future<bool> recordView({
    required String itemType,
    required int itemId,
  }) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/api/favorites/recently-viewed/record/'),
        headers: headers,
        body: jsonEncode({
          'item_type': itemType,
          'item_id': itemId,
        }),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Error recording view: $e');
      return false;
    }
  }

  /// Clear viewing history
  Future<bool> clearHistory() async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.delete(
        Uri.parse('$baseUrl/api/favorites/recently-viewed/'),
        headers: headers,
      );

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print('Error clearing history: $e');
      return false;
    }
  }
}
