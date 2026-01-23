import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/constants/constants.dart';
import 'package:app/providers/provider_models/enhanced_favorite_model.dart';

/// Enhanced Favorites API Service with collections and price tracking
class FavoritesService {
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

  // ==================== Favorites ====================

  /// Toggle favorite (add/remove)
  Future<Map<String, dynamic>> toggleFavorite({
    required String itemType,
    required int itemId,
    String? note,
    bool notifyPriceDrop = false,
  }) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/api/favorites/toggle/'),
        headers: headers,
        body: jsonEncode({
          'item_type': itemType,
          'item_id': itemId,
          if (note != null) 'note': note,
          'notify_price_drop': notifyPriceDrop,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return {
          'success': data['success'] ?? true,
          'action': data['action'], // 'added' or 'removed'
          'message': data['message'],
          'data': data['data'] != null
              ? FavoriteItem.fromJson(data['data'])
              : null,
        };
      }

      return {
        'success': false,
        'message': 'Failed to toggle favorite',
      };
    } catch (e) {
      print('Error toggling favorite: $e');
      return {
        'success': false,
        'message': 'Network error: $e',
      };
    }
  }

  /// Get user's favorites
  Future<List<FavoriteItem>> getFavorites({
    String? itemType,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final headers = await _getAuthHeaders();

      var url = '$baseUrl/api/favorites/';
      final queryParams = <String, String>{
        'page': page.toString(),
        'page_size': pageSize.toString(),
      };
      if (itemType != null) queryParams['item_type'] = itemType;

      url += '?${Uri(queryParameters: queryParams).query}';

      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final results = data['results'] as List? ?? [];
        return results.map((f) => FavoriteItem.fromJson(f)).toList();
      }
      return [];
    } catch (e) {
      print('Error getting favorites: $e');
      return [];
    }
  }

  /// Check if item is favorited
  Future<FavoriteCheckResult> checkFavorite({
    required String itemType,
    required int itemId,
  }) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.get(
        Uri.parse(
            '$baseUrl/api/favorites/check/?item_type=$itemType&item_id=$itemId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return FavoriteCheckResult.fromJson(data);
      }

      return FavoriteCheckResult(isFavorited: false);
    } catch (e) {
      print('Error checking favorite: $e');
      return FavoriteCheckResult(isFavorited: false);
    }
  }

  /// Get favorites count
  Future<FavoritesCount> getFavoritesCount({String? itemType}) async {
    try {
      final headers = await _getAuthHeaders();
      var url = '$baseUrl/api/favorites/count/';
      if (itemType != null) url += '?item_type=$itemType';

      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return FavoritesCount.fromJson(data);
      }

      return FavoritesCount(
        totalCount: 0,
        productCount: 0,
        serviceCount: 0,
        propertyCount: 0,
      );
    } catch (e) {
      print('Error getting favorites count: $e');
      return FavoritesCount(
        totalCount: 0,
        productCount: 0,
        serviceCount: 0,
        propertyCount: 0,
      );
    }
  }

  /// Update favorite (note/settings)
  Future<FavoriteItem?> updateFavorite({
    required int favoriteId,
    String? note,
    bool? notifyPriceDrop,
  }) async {
    try {
      final headers = await _getAuthHeaders();
      final body = <String, dynamic>{};
      if (note != null) body['note'] = note;
      if (notifyPriceDrop != null) body['notify_price_drop'] = notifyPriceDrop;

      final response = await http.patch(
        Uri.parse('$baseUrl/api/favorites/$favoriteId/'),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['data'] != null) {
          return FavoriteItem.fromJson(data['data']);
        }
      }
      return null;
    } catch (e) {
      print('Error updating favorite: $e');
      return null;
    }
  }

  /// Delete favorite
  Future<bool> deleteFavorite(int favoriteId) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.delete(
        Uri.parse('$baseUrl/api/favorites/$favoriteId/'),
        headers: headers,
      );

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print('Error deleting favorite: $e');
      return false;
    }
  }

  // ==================== Collections ====================

  /// Get user's collections
  Future<List<FavoriteCollection>> getCollections() async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/api/favorites/collections/'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          return (data['data'] as List)
              .map((c) => FavoriteCollection.fromJson(c))
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('Error getting collections: $e');
      return [];
    }
  }

  /// Create a collection
  Future<FavoriteCollection?> createCollection({
    required String name,
    String? description,
    bool isPublic = false,
  }) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/api/favorites/collections/'),
        headers: headers,
        body: jsonEncode({
          'name': name,
          if (description != null) 'description': description,
          'is_public': isPublic,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data['data'] != null) {
          return FavoriteCollection.fromJson(data['data']);
        }
      }
      return null;
    } catch (e) {
      print('Error creating collection: $e');
      return null;
    }
  }

  /// Update collection
  Future<FavoriteCollection?> updateCollection({
    required int collectionId,
    String? name,
    String? description,
    bool? isPublic,
  }) async {
    try {
      final headers = await _getAuthHeaders();
      final body = <String, dynamic>{};
      if (name != null) body['name'] = name;
      if (description != null) body['description'] = description;
      if (isPublic != null) body['is_public'] = isPublic;

      final response = await http.patch(
        Uri.parse('$baseUrl/api/favorites/collections/$collectionId/'),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['data'] != null) {
          return FavoriteCollection.fromJson(data['data']);
        }
      }
      return null;
    } catch (e) {
      print('Error updating collection: $e');
      return null;
    }
  }

  /// Delete collection
  Future<bool> deleteCollection(int collectionId) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.delete(
        Uri.parse('$baseUrl/api/favorites/collections/$collectionId/'),
        headers: headers,
      );

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print('Error deleting collection: $e');
      return false;
    }
  }

  /// Add favorite to collection
  Future<bool> addToCollection({
    required int collectionId,
    required int favoriteId,
  }) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/api/favorites/collections/$collectionId/items/'),
        headers: headers,
        body: jsonEncode({'favorite_id': favoriteId}),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Error adding to collection: $e');
      return false;
    }
  }

  /// Remove favorite from collection
  Future<bool> removeFromCollection({
    required int collectionId,
    required int favoriteId,
  }) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.delete(
        Uri.parse(
            '$baseUrl/api/favorites/collections/$collectionId/items/$favoriteId/'),
        headers: headers,
      );

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print('Error removing from collection: $e');
      return false;
    }
  }

  /// Get collection items
  Future<List<FavoriteItem>> getCollectionItems(int collectionId) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/api/favorites/collections/$collectionId/items/'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['data'] != null) {
          return (data['data'] as List)
              .map((f) => FavoriteItem.fromJson(f))
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('Error getting collection items: $e');
      return [];
    }
  }
}
