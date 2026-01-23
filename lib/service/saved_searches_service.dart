import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/constants/constants.dart';
import 'package:app/providers/provider_models/saved_search_model.dart';

/// Saved Searches API Service
class SavedSearchesService {
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

  /// Get saved searches
  Future<List<SavedSearch>> getSavedSearches() async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/api/favorites/saved-searches/'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          return (data['data'] as List)
              .map((item) => SavedSearch.fromJson(item))
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('Error getting saved searches: $e');
      return [];
    }
  }

  /// Create a saved search
  Future<SavedSearch?> createSavedSearch({
    required String query,
    String? name,
    String? itemType,
    int? categoryId,
    String? region,
    String? district,
    String? minPrice,
    String? maxPrice,
  }) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/api/favorites/saved-searches/'),
        headers: headers,
        body: jsonEncode({
          'query': query,
          if (name != null) 'name': name,
          if (itemType != null) 'item_type': itemType,
          if (categoryId != null) 'category_id': categoryId,
          if (region != null) 'region': region,
          if (district != null) 'district': district,
          if (minPrice != null) 'min_price': minPrice,
          if (maxPrice != null) 'max_price': maxPrice,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          return SavedSearch.fromJson(data['data']);
        }
      }

      // Check for max searches error
      if (response.statusCode == 400) {
        final data = jsonDecode(response.body);
        throw Exception(data['error'] ?? 'Failed to save search');
      }

      return null;
    } catch (e) {
      print('Error creating saved search: $e');
      rethrow;
    }
  }

  /// Get and use a saved search (increments use count)
  Future<SavedSearch?> useSavedSearch(int searchId) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/api/favorites/saved-searches/$searchId/'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          return SavedSearch.fromJson(data['data']);
        }
      }
      return null;
    } catch (e) {
      print('Error using saved search: $e');
      return null;
    }
  }

  /// Update a saved search
  Future<SavedSearch?> updateSavedSearch({
    required int searchId,
    String? name,
    String? query,
    String? itemType,
    int? categoryId,
    String? region,
    String? district,
    String? minPrice,
    String? maxPrice,
  }) async {
    try {
      final headers = await _getAuthHeaders();
      final body = <String, dynamic>{};

      if (name != null) body['name'] = name;
      if (query != null) body['query'] = query;
      if (itemType != null) body['item_type'] = itemType;
      if (categoryId != null) body['category_id'] = categoryId;
      if (region != null) body['region'] = region;
      if (district != null) body['district'] = district;
      if (minPrice != null) body['min_price'] = minPrice;
      if (maxPrice != null) body['max_price'] = maxPrice;

      final response = await http.put(
        Uri.parse('$baseUrl/api/favorites/saved-searches/$searchId/'),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          return SavedSearch.fromJson(data['data']);
        }
      }
      return null;
    } catch (e) {
      print('Error updating saved search: $e');
      return null;
    }
  }

  /// Delete a saved search
  Future<bool> deleteSavedSearch(int searchId) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.delete(
        Uri.parse('$baseUrl/api/favorites/saved-searches/$searchId/'),
        headers: headers,
      );

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print('Error deleting saved search: $e');
      return false;
    }
  }

  /// Get saved searches count
  Future<int> getSavedSearchesCount() async {
    try {
      final searches = await getSavedSearches();
      return searches.length;
    } catch (e) {
      return 0;
    }
  }
}
