import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:app/constants/constants.dart';
import 'package:app/config/app_config.dart';
import 'package:app/providers/provider_models/real_estate.dart';
import 'package:app/utils/app_logger.dart';
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
    if (kDebugMode) {}
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
      print(response.body);
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
      print(response.data);
      print(queryParams);

      if (response.statusCode == 200) {
        final data = response.data;

        if (kDebugMode) {}

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

        if (kDebugMode) {}

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
      if (kDebugMode) {}
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
      if (kDebugMode) {}
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

  /// Create property with full support for all fields and images
  Future<Map<String, dynamic>> createProperty({
    required String title,
    required String description,
    required String propertyType,
    required String listingType,
    required String address,
    required int squareMeters,
    required String price,
    required String currency,
    List<File>? images,
    String? latitude,
    String? longitude,
    int? userLocation,
    int? bedrooms,
    int? bathrooms,
    int? floor,
    int? totalFloors,
    int? yearBuilt,
    int? parkingSpaces,
    bool hasBalcony = false,
    bool hasGarage = false,
    bool hasGarden = false,
    bool hasPool = false,
    bool hasElevator = false,
    bool isFurnished = false,
    int? metroDistance,
    int? schoolDistance,
    int? hospitalDistance,
    int? shoppingDistance,
    int? agent,
    required String token,
  }) async {
    try {
      final formData = FormData.fromMap({
        'title': title,
        'description': description,
        'property_type': propertyType,
        'listing_type': listingType,
        'address': address,
        'square_meters': squareMeters,
        'price': price,
        'currency': currency,
        if (latitude != null && latitude.isNotEmpty) 'latitude': latitude,
        if (longitude != null && longitude.isNotEmpty) 'longitude': longitude,
        if (userLocation != null) 'user_location': userLocation,
        if (bedrooms != null) 'bedrooms': bedrooms,
        if (bathrooms != null) 'bathrooms': bathrooms,
        if (floor != null) 'floor': floor,
        if (totalFloors != null) 'total_floors': totalFloors,
        if (yearBuilt != null) 'year_built': yearBuilt,
        if (parkingSpaces != null) 'parking_spaces': parkingSpaces,
        'has_balcony': hasBalcony,
        'has_garage': hasGarage,
        'has_garden': hasGarden,
        'has_pool': hasPool,
        'has_elevator': hasElevator,
        'is_furnished': isFurnished,
        if (metroDistance != null) 'metro_distance': metroDistance,
        if (schoolDistance != null) 'school_distance': schoolDistance,
        if (hospitalDistance != null) 'hospital_distance': hospitalDistance,
        if (shoppingDistance != null) 'shopping_distance': shoppingDistance,
        if (agent != null) 'agent': agent,
      });

      // Add images if provided
      if (images != null && images.isNotEmpty) {
        for (int i = 0; i < images.length; i++) {
          formData.files.add(MapEntry(
            'images',
            await MultipartFile.fromFile(
              images[i].path,
              filename: 'image_$i.jpg',
            ),
          ));
        }
      }

      final response = await dio.post(
        AppConfig.realEstatePropertiesPath,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Token $token',
            'Content-Type': 'multipart/form-data',
          },
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;
        // Handle both response formats
        if (responseData['success'] == true && responseData['data'] != null) {
          return responseData['data'];
        }
        return responseData;
      } else {
        String errorMessage = 'Failed to create property';
        if (response.data is Map) {
          final data = response.data as Map;
          // Extract validation errors if present
          if (data['errors'] is Map) {
            final errors = data['errors'] as Map;
            final errorMessages = <String>[];
            errors.forEach((field, messages) {
              if (messages is List && messages.isNotEmpty) {
                errorMessages.add(messages.first.toString());
              }
            });
            if (errorMessages.isNotEmpty) {
              errorMessage = errorMessages.join('. ');
            }
          } else if (data['error'] != null) {
            errorMessage = data['error'].toString();
          } else if (data['message'] != null) {
            errorMessage = data['message'].toString();
          }
        }
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: errorMessage,
        );
      }
    } catch (e) {
      if (e is DioException) {
        rethrow;
      }
      throw Exception('Failed to create property: $e');
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
      if (e is DioException) {}
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
        if (kDebugMode) {}
        return response.data;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to toggle save property: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (kDebugMode) {}
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
        if (kDebugMode) {}
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to unsave property: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (kDebugMode) {}
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
      if (kDebugMode) {}
      return false;
    }
  }

  // ============= PROPERTY INQUIRIES METHODS =============
  Future<Map<String, dynamic>> createInquiry({
    required String propertyId,
    required String inquiryType,
    String? message,
    String? preferredContactTime,
    String? offeredPrice,
    required String token,
  }) async {
    try {
      final response = await dio.post(
        '${AppConfig.realEstateInquiriesPath}',
        data: {
          'property': propertyId,
          'inquiry_type': inquiryType,
          if (message != null && message.isNotEmpty) 'message': message,
          if (preferredContactTime != null && preferredContactTime.isNotEmpty)
            'preferred_contact_time': preferredContactTime,
          if (offeredPrice != null && offeredPrice.isNotEmpty)
            'offered_price': offeredPrice,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Token $token',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to create inquiry: ${response.statusCode}',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  // ============= MAP METHODS =============
  Future<Map<String, dynamic>> getMapProperties({
    required double north,
    required double south,
    required double east,
    required double west,
    int limit = 500,
    Map<String, dynamic>? filters,
    String? token,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'north': north.toString(),
        'south': south.toString(),
        'east': east.toString(),
        'west': west.toString(),
        'limit': limit.toString(),
      };

      if (filters != null) {
        queryParams.addAll(filters);
      }

      final headers = <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      if (token != null) {
        headers['Authorization'] = 'Token $token';
      }

      final response = await dio.get(
        AppConfig.realEstateMapBoundsPath,
        queryParameters: queryParams,
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to load map properties: ${response.statusCode}',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getMapStats({
    required double north,
    required double south,
    required double east,
    required double west,
    Map<String, dynamic>? filters,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'north': north.toString(),
        'south': south.toString(),
        'east': east.toString(),
        'west': west.toString(),
      };

      if (filters != null) {
        queryParams.addAll(filters);
      }

      final response = await dio.get(
        AppConfig.realEstateMapStatsPath,
        queryParameters: queryParams,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to load map stats: ${response.statusCode}',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  // ============= LOCATION METHODS =============
  Future<Map<String, dynamic>> getLocationChoices() async {
    try {
      final response = await dio.get(
        AppConfig.realEstateLocationsChoicesPath,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          return {
            'countries': List<Map<String, dynamic>>.from(data['countries'] ?? []),
            'regions': List<Map<String, dynamic>>.from(data['regions'] ?? []),
            'districts': List<Map<String, dynamic>>.from(data['districts'] ?? []),
          };
        }
        return {'countries': [], 'regions': [], 'districts': []};
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to load location choices: ${response.statusCode}',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Get all UserLocation objects for selection
  /// Returns empty list if endpoint requires auth or fails
  Future<List<Map<String, dynamic>>> getUserLocations() async {
    try {
      // Get authentication token
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConfig.tokenKey);
      
      final headers = <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      
      // Add authorization header if token is available
      if (token != null) {
        headers['Authorization'] = 'Token $token';
      }
      
      final response = await dio.get(
        AppConfig.realEstateLocationsUserLocationsPath,
        options: Options(
          headers: headers,
          validateStatus: (status) => status! < 500, // Don't throw on 401/403
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true && data['locations'] != null) {
          return List<Map<String, dynamic>>.from(data['locations']);
        }
        return [];
      } else {
        // If auth required or other error, return empty list (not critical)
        // Only log in debug mode to avoid noise
        if (kDebugMode) {
          AppLogger.error('UserLocations endpoint returned ${response.statusCode}, using district IDs from profile provider');
        }
        return [];
      }
    } catch (e) {
      // Return empty list on error - we'll use district IDs from profile provider
      // Only log in debug mode to avoid noise
      if (kDebugMode) {
        AppLogger.error('Error fetching user locations: $e');
      }
      return [];
    }
  }

  // ============= STATISTICS METHODS =============
  Future<Map<String, dynamic>> getStatistics() async {
    try {
      final response = await dio.get(
        AppConfig.realEstateStatsPath,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to load statistics: ${response.statusCode}',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  // ============= AGENT METHODS =============
  Future<Map<String, dynamic>> becomeAgent({
    required String agencyName,
    required String licenceNumber,
    required int yearsExperience,
    required String specialization,
    required String token,
  }) async {
    try {
      final response = await dio.post(
        AppConfig.realEstateAgentBecomePath,
        data: {
          'agency_name': agencyName,
          'licence_number': licenceNumber,
          'years_experience': yearsExperience,
          'specialization': specialization,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Token $token',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to submit agent application: ${response.statusCode}',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getAgentStatus({
    required String token,
  }) async {
    try {
      final response = await dio.get(
        AppConfig.realEstateAgentStatusPath,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Token $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to get agent status: ${response.statusCode}',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getAgentApplicationStatus({
    required String token,
  }) async {
    try {
      final response = await dio.get(
        AppConfig.realEstateAgentApplicationStatusPath,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Token $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to get application status: ${response.statusCode}',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Get agent dashboard data
  Future<Map<String, dynamic>> getAgentDashboard({
    required String token,
  }) async {
    try {
      final response = await dio.get(
        AppConfig.realEstateAgentDashboardPath,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Token $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else if (response.statusCode == 403) {
        throw Exception('You are not registered as an agent.');
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to get agent dashboard: ${response.statusCode}',
        );
      }
    } catch (e) {
      rethrow;
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
      if (kDebugMode) {}
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

// Refresh trigger provider - increment to trigger reload in RealEstateMain
final realEstateRefreshProvider = StateProvider<int>((ref) => 0);
