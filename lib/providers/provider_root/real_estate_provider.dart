import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:app/constants/constants.dart';
import 'package:app/providers/provider_models/real_estate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

// ============= SAVED PROPERTY MODELS =============

class SavedProperty {
  final int id;
  final RealEstate property;
  final DateTime savedAt;

  const SavedProperty({
    required this.id,
    required this.property,
    required this.savedAt,
  });

  factory SavedProperty.fromJson(Map<String, dynamic> json) {
    return SavedProperty(
      id: json['id'] ?? 0,
      property: RealEstate.fromJson(json['property'] ?? {}),
      savedAt: json['saved_at'] != null
          ? DateTime.parse(json['saved_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'property': property.toJson(),
      'saved_at': savedAt.toIso8601String(),
    };
  }
}

class SavedPropertiesResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<SavedProperty> results;

  const SavedPropertiesResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory SavedPropertiesResponse.fromJson(Map<String, dynamic> json) {

    final resultsData = json['results'] as List? ?? [];

    final results = resultsData.map((item) {
      try {
        if (item['property'] != null) {
          return SavedProperty.fromJson(item);
        } else {
          return SavedProperty(
            id: DateTime.now().millisecondsSinceEpoch,
            property: RealEstate.fromJson(item),
            savedAt: DateTime.now(),
          );
        }
      } catch (e) {
        rethrow;
      }
    }).toList();

    return SavedPropertiesResponse(
      count: json['count'] ?? 0,
      next: json['next'],
      previous: json['previous'],
      results: results,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'next': next,
      'previous': previous,
      'results': results.map((e) => e.toJson()).toList(),
    };
  }
}

// ============= SERVICE CLASS =============

class RealEstateService {
  final Dio dio = Dio(BaseOptions(baseUrl: baseUrl));
  final Map<String, Future> _pendingRequests = {};

  void _logPerformance(String operation, int milliseconds) {
    if (kDebugMode) {
    }
  }

  // ============= EXISTING METHODS =============

  Future<List<RealEstate>> getAllProperties() async {
    final response = await http.get(
      Uri.parse('$baseUrl$REAL_ESTATE_PROPERTIES'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['results'] as List)
          .map((propertyJson) => RealEstate.fromJson(propertyJson))
          .toList();
    } else {
      throw Exception('Failed to load properties');
    }
  }

  Future<List<RealEstate>> _fetchFilteredProperties({
    required int currentPage,
    required int pageSize,
    required String propertyType,
    required String listingType,
    required String regionName,
    required String districtName,
    required String minPrice,
    required String maxPrice,
  }) async {
    try {
      final queryParams = <String, String>{
        'page': currentPage.toString(),
        'page_size': pageSize.toString(),
      };

      if (propertyType.isNotEmpty) queryParams['property_type'] = propertyType;
      if (listingType.isNotEmpty) queryParams['listing_type'] = listingType;
      if (regionName.isNotEmpty) queryParams['city'] = regionName;
      if (districtName.isNotEmpty) queryParams['district'] = districtName;
      if (minPrice.isNotEmpty) queryParams['min_price'] = minPrice;
      if (maxPrice.isNotEmpty) queryParams['max_price'] = maxPrice;

      final response = await dio.get(
        '$REAL_ESTATE_PROPERTIES',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final data = response.data;

        if (kDebugMode) {
        }

        return (data['results'] as List)
            .map((propertyJson) => RealEstate.fromJson(propertyJson))
            .toList();
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to load filtered properties: ${response.statusCode}',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<RealEstate> fetchSingleFilteredProperty({
    required String propertyId,
  }) async {
    try {
      final response = await dio.get('$REAL_ESTATE_PROPERTIES$propertyId/');

      if (response.statusCode == 200) {
        final data = response.data;

        if (kDebugMode) {
        }

        if (data['success'] == true && data['property'] != null) {
          return RealEstate.fromJson(data['property']);
        } else {
          throw DioException(
            requestOptions: response.requestOptions,
            response: response,
            message: 'Invalid response structure: missing property data',
          );
        }
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to load property: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (kDebugMode) {
      }
      rethrow;
    }
  }

  Future<List<RealEstate>> getFilteredProperties({
    int currentPage = 1,
    int pageSize = 12,
    String propertyType = "",
    String listingType = "",
    String regionName = "",
    String districtName = "",
    String minPrice = "",
    String maxPrice = "",
  }) async {
    final cacheKey =
        'filtered_properties_${currentPage}_${pageSize}_${propertyType}_${listingType}_${regionName}_${districtName}_${minPrice}_$maxPrice';

    if (_pendingRequests.containsKey(cacheKey)) {
      if (kDebugMode) {
      }
      return await _pendingRequests[cacheKey] as List<RealEstate>;
    }

    final timer = Stopwatch()..start();

    final future = _fetchFilteredProperties(
      currentPage: currentPage,
      pageSize: pageSize,
      propertyType: propertyType,
      listingType: listingType,
      regionName: regionName,
      districtName: districtName,
      minPrice: minPrice,
      maxPrice: maxPrice,
    );

    _pendingRequests[cacheKey] = future;

    try {
      final properties = await future;

      timer.stop();
      _logPerformance('Get Filtered Properties', timer.elapsed.inMilliseconds);

      return properties;
    } finally {
      _pendingRequests.remove(cacheKey);
    }
  }

  Future<RealEstate> getSingleProperty({required String propertyId}) async {
    final response = await http.get(
      Uri.parse('$baseUrl$REAL_ESTATE_PROPERTIES/$propertyId/'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return RealEstate.fromJson(data);
    } else {
      throw Exception('Failed to load property details');
    }
  }

  Future<RealEstate> createProperty({
    required String title,
    required String propertyType,
    required String listingType,
    required String price,
    required int squareMeters,
    required int bedrooms,
    required int bathrooms,
    required String address,
    required String latitude,
    required String longitude,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? userLocation = prefs.getString('userLocation');

    final response = await http.post(
      Uri.parse('$baseUrl$REAL_ESTATE_PROPERTIES'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Token $token',
      },
      body: json.encode({
        'title': title,
        'property_type': propertyType,
        'listing_type': listingType,
        'price': price,
        'square_meters': squareMeters,
        'bedrooms': bedrooms,
        'bathrooms': bathrooms,
        'address': address,
        'latitude': latitude,
        'longitude': longitude,
        'location_id': int.tryParse(userLocation ?? '0'),
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body);
      return RealEstate.fromJson(data);
    } else {
      throw Exception('Failed to create property');
    }
  }

  // ============= SAVED PROPERTIES METHODS =============
  Future<SavedPropertiesResponse> getSavedProperties({
    required String token,
    int page = 1,
    int pageSize = 12,
  }) async {
    final timer = Stopwatch()..start();

    try {

      final response = await dio.get(
        REAL_ESTATE_SAVED_PROPERTIES,
        queryParameters: {
          'page': page.toString(),
          'page_size': pageSize.toString(),
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Token $token',
          },
        ),
      );

      timer.stop();
      _logPerformance('Get Saved Properties', timer.elapsed.inMilliseconds);

      if (response.statusCode == 200) {
        final parsedResponse = SavedPropertiesResponse.fromJson(response.data);
        return parsedResponse;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to load saved properties: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is DioException) {
      }
      rethrow;
    }
  }

  Future<Map<String, dynamic>> toggleSaveProperty({
    required String propertyId,
    required String token,
  }) async {
    final timer = Stopwatch()..start();

    try {
      final response = await dio.post(
        '${REAL_ESTATE_PROPERTIES}${propertyId}/save/',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Token $token',
          },
        ),
      );

      timer.stop();
      _logPerformance('Toggle Save Property', timer.elapsed.inMilliseconds);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (kDebugMode) {
        }
        return response.data;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to toggle save property: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (kDebugMode) {
      }
      rethrow;
    }
  }

  Future<void> unsaveProperty({
    required String propertyId,
    required String token,
  }) async {
    final timer = Stopwatch()..start();

    try {
      final response = await dio.delete(
        '${REAL_ESTATE_PROPERTIES}${propertyId}/save/',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Token $token',
          },
        ),
      );

      timer.stop();
      _logPerformance('Unsave Property', timer.elapsed.inMilliseconds);

      if (response.statusCode == 200 || response.statusCode == 204) {
        if (kDebugMode) {
        }
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to unsave property: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (kDebugMode) {
      }
      rethrow;
    }
  }

  Future<bool> isPropertySaved({
    required String propertyId,
    required String token,
  }) async {
    try {
      final response = await dio.get(
        '${REAL_ESTATE_PROPERTIES}${propertyId}/save/',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Token $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data['is_saved'] ?? false;
      } else {
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
      }
      return false;
    }
  }
}

// ============= STATE NOTIFIER FOR SAVED PROPERTIES =============

class SavedPropertiesNotifier
    extends StateNotifier<AsyncValue<SavedPropertiesResponse>> {
  final RealEstateService _service;
  final String _token;
  int _currentPage = 1;
  final int _pageSize = 12;

  SavedPropertiesNotifier(this._service, this._token)
      : super(const AsyncValue.loading()) {
    loadSavedProperties();
  }

  Future<void> loadSavedProperties() async {
    state = const AsyncValue.loading();
    try {
      final response = await _service.getSavedProperties(
        token: _token,
        page: _currentPage,
        pageSize: _pageSize,
      );
      state = AsyncValue.data(response);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> refreshSavedProperties() async {
    _currentPage = 1;
    await loadSavedProperties();
  }

  Future<void> loadNextPage() async {
    final currentState = state.value;
    if (currentState != null && currentState.next != null) {
      _currentPage++;
      await loadSavedProperties();
    }
  }

  Future<void> unsaveProperty(String propertyId) async {
    try {
      await _service.unsaveProperty(propertyId: propertyId, token: _token);
      await refreshSavedProperties();
    } catch (error) {
      if (kDebugMode) {
      }
      rethrow;
    }
  }
}

// ============= PROVIDERS =============

// Existing providers
final realEstateProvider = FutureProvider<List<RealEstate>>((ref) async {
  final realEstateService = RealEstateService();
  return realEstateService.getAllProperties();
});

final realEstateServiceProvider = Provider((ref) => RealEstateService());

// Token provider
final tokenProvider = FutureProvider<String?>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('token');
});

// Saved properties provider (simple)
final savedPropertiesProvider =
    FutureProvider.family<SavedPropertiesResponse, String>(
  (ref, token) async {
    final realEstateService = ref.read(realEstateServiceProvider);
    return realEstateService.getSavedProperties(token: token);
  },
);

// Saved properties notifier provider (with state management)
final savedPropertiesNotifierProvider = StateNotifierProvider.family<
    SavedPropertiesNotifier, AsyncValue<SavedPropertiesResponse>, String>(
  (ref, token) {
    final service = ref.read(realEstateServiceProvider);
    return SavedPropertiesNotifier(service, token);
  },
);
