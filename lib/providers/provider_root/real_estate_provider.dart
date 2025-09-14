import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:app/constants/constants.dart';
import 'package:app/providers/provider_models/real_estate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class RealEstateService {
  // Initialize Dio instance with base URL
  final Dio dio = Dio(BaseOptions(baseUrl: baseUrl));

  // Properties for caching and performance tracking
  final Map<String, Future> _pendingRequests = {};

  void _logPerformance(String operation, int milliseconds) {
    if (kDebugMode) {
      print('⏱️ $operation took ${milliseconds}ms');
    }
  }

  // Get all properties (basic method)
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

  // Private method to fetch filtered properties
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

      // Only add non-empty parameters to reduce URL size
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
        print(data);

        if (kDebugMode) {
          print(
              '📊 Filtered properties count: ${(data['results'] as List).length}');
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
          print('📊 Single property fetched successfully');
          print('Property data: $data');
        }

        // Check if the response has the expected structure
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
        print('❌ Error fetching single property: $e');
      }
      rethrow;
    }
  }

  // Public method with caching and performance logging
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

    // Check for pending request
    if (_pendingRequests.containsKey(cacheKey)) {
      if (kDebugMode) {
        print('🔄 Filtered properties request already in progress');
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

  // Get single property details
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

  // Create new property listing
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
}

// Providers
final realEstateProvider = FutureProvider<List<RealEstate>>((ref) async {
  final realEstateService = RealEstateService();
  return realEstateService.getAllProperties();
});

final realEstateServiceProvider = Provider((ref) => RealEstateService());
