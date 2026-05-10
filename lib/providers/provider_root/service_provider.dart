import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart'; // Added missing import
import 'package:app/constants/constants.dart';
import 'package:app/providers/provider_models/category_model.dart';
import 'package:app/providers/provider_models/service_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServiceProvider {
  // Initialize Dio instance with base URL
  final Dio dio = Dio(BaseOptions(baseUrl: baseUrl));

  // Properties for caching and performance tracking
  final Map<String, Future> _pendingRequests = {};

  void _logPerformance(String operation, int milliseconds) {
    if (kDebugMode) {
    }
  }

  Future<List<Services>> getServices({
    String? neighborhoodId,
    double? radiusKm,
  }) async {
    final qp = <String, String>{};
    if (neighborhoodId != null) qp['neighborhood_id'] = neighborhoodId;
    if (radiusKm != null && radiusKm.isFinite) {
      qp['radius_km'] = radiusKm.toStringAsFixed(0);
    }
    final uri = Uri.parse('$baseUrl$SERVICES_URL/').replace(
      queryParameters: qp.isEmpty ? null : qp,
    );
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['results'] as List)
          .map((postJson) => Services.fromJson(postJson))
          .toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Future<Services> getSingleService({required String serviceId}) async {
    final response =
        await http.get(Uri.parse('$baseUrl$SERVICES_URL/$serviceId/'));
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);

      if (kDebugMode) {
        print('🔍 Service Detail API Response keys: ${responseData.keys}');
      }

      // Handle different API response formats
      Map<String, dynamic> serviceData;

      // Handle {success: true, data: {service: {...}}} format
      if (responseData['success'] == true && responseData['data'] != null) {
        final data = responseData['data'];
        if (kDebugMode) {
          print('🔍 Using success/data wrapper, data keys: ${data.keys}');
        }

        if (data['service'] != null) {
          serviceData = data['service'] as Map<String, dynamic>;
        } else if (data['id'] != null) {
          // Service data is directly in data
          serviceData = data as Map<String, dynamic>;
        } else {
          throw Exception('Invalid service data format in data wrapper');
        }
      } else if (responseData['service'] != null) {
        serviceData = responseData['service'] as Map<String, dynamic>;
      } else if (responseData['id'] != null) {
        // API returns service data directly without 'service' wrapper
        serviceData = responseData as Map<String, dynamic>;
      } else {
        throw Exception('Invalid service response format: ${responseData.keys}');
      }

      if (kDebugMode) {
        print('🔍 Service data images: ${serviceData['images']}');
      }

      return Services.fromJson(serviceData);
    } else {
      throw Exception('Failed to load service: ${response.statusCode}');
    }
  }

  Future<List<Services>> getRecommendedServices(
      {required String serviceId}) async {
    final response =
        await http.get(Uri.parse('$baseUrl$SERVICES_URL/$serviceId/'));
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);

      // Handle {success: true, data: {...}} format
      dynamic data = responseData;
      if (responseData['success'] == true && responseData['data'] != null) {
        data = responseData['data'];
      }

      final recommendedList = data['recommended_services'] as List? ?? [];
      return recommendedList
          .map((serviceJson) => Services.fromJson(serviceJson))
          .toList();
    } else {
      throw Exception('Failed to load recommended services');
    }
  }

  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl$SERVICE_CATEGORY/'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (kDebugMode) {
          print('📦 Service Categories API response type: ${data.runtimeType}');
        }

        // Handle both List and Map responses
        List<dynamic> categoriesList;
        if (data is List) {
          categoriesList = data;
        } else if (data is Map && data.containsKey('results')) {
          categoriesList = data['results'] as List;
        } else if (data is Map && data.containsKey('data')) {
          categoriesList = data['data'] as List;
        } else {
          throw Exception('Unexpected service categories response format: ${data.runtimeType}');
        }

        return categoriesList
            .map((categoryJson) => CategoryModel.fromJson(categoryJson as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load service categories: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error fetching service categories: $e');
      }
      rethrow;
    }
  }

  Future<Services> createService({
    required String name,
    required String description,
    required int categoryId,
    required List<File> imageFiles,
    // Phase-1 OSM/Carrot place fields (optional during transition).
    double? latitude,
    double? longitude,
    String? placeId,
    String? formattedAddress,
    String? countryCode,
    String? regionName,
    String? cityName,
  }) async {
    const url = '$baseUrl$SERVICES_URL/';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? userLocation = prefs.getString('userLocation');
    String? userId = prefs.getString('userId');
    Dio dio = Dio();

    // Always fetch fresh location from backend to ensure we have the latest
    int? locationId;
    final userIdInt = userId != null ? int.tryParse(userId) : null;

    if (kDebugMode) {
      print('[ServiceProvider] Fetching fresh user location from backend...');
    }
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/accounts/user/info/'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Token $token',
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final userInfo = data['user_info'] ?? data['data'] ?? data;
        final location = userInfo['location'];
        if (location != null && location['id'] != null) {
          locationId = location['id'] is int ? location['id'] : int.tryParse(location['id'].toString());
          // Update SharedPreferences with latest value
          if (locationId != null) {
            await prefs.setString('userLocation', locationId.toString());
            if (kDebugMode) {
              print('[ServiceProvider] Using location_id: $locationId (from backend)');
            }
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('[ServiceProvider] Error fetching user location: $e, falling back to cached');
      }
      // Fallback to cached value if backend fails
      locationId = userLocation != null ? int.tryParse(userLocation) : null;
    }

    if (locationId == null) {
      throw DioException(
        requestOptions: RequestOptions(path: url),
        message: 'User location not set. Please update your location in settings.',
      );
    }

    if (kDebugMode) {
      print('[ServiceProvider] Creating service with location_id: $locationId');
    }

    FormData formData = FormData.fromMap({
      'name': name,
      'description': description,
      'category_id': categoryId,
      'location_id': locationId,
      'userAddress_id': locationId,
      'userName_id': userIdInt,
      'images': imageFiles
          .map((file) => MultipartFile.fromFileSync(file.path))
          .toList(),
      // Backend DecimalField caps at 6 decimal places — round before send.
      if (latitude != null) 'latitude': latitude.toStringAsFixed(6),
      if (longitude != null) 'longitude': longitude.toStringAsFixed(6),
      if (placeId != null) 'place_id': placeId,
      if (formattedAddress != null) 'formatted_address': formattedAddress,
      if (countryCode != null) 'country_code': countryCode,
      if (regionName != null) 'region_name': regionName,
      if (cityName != null) 'city_name': cityName,
    });
    final response = await dio.post(url,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Token $token',
            'Content-Type': 'application/json'
          },
          validateStatus: (status) => status! < 500,
        ));
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Services.fromJson(response.data);
    } else {
      String errorMessage = 'Failed to create service';
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
  }

  Future<Services> updateService({
    required int serviceId,
    required String name,
    required String description,
    required int categoryId,
    required int locationId,
    List<File>? newImageFiles,
    List<int>? existingImageIds, // Changed from URLs to IDs
  }) async {
    final url = '$baseUrl$SERVICES_URL/$serviceId/';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? userId = prefs.getString('userId');
    Dio dio = Dio();

    // Create FormData for the update
    Map<String, dynamic> formDataMap = {
      'name': name,
      'description': description,
      'category_id': categoryId,
      'location_id': locationId,
      'userName_id': int.tryParse(userId.toString()),
    };

    // Add existing images (IDs of images to keep)
    if (existingImageIds != null) {
      formDataMap['existing_images'] = existingImageIds;
    }

    // Add new images if provided
    if (newImageFiles != null && newImageFiles.isNotEmpty) {
      formDataMap['new_images'] = newImageFiles
          .map((file) => MultipartFile.fromFileSync(file.path))
          .toList();
    }

    FormData formData = FormData.fromMap(formDataMap);

    try {
      final response = await dio.put(
        // Use PUT for full update
        url,
        data: formData,
        options: Options(headers: {
          'Authorization': 'Token $token',
          'Content-Type': 'multipart/form-data',
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Services.fromJson(response.data);
      } else {
        throw Exception('Failed to update service: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to update service: $e');
    }
  }

// Delete service method
  Future<bool> deleteService(int serviceId) async {
    final url = '$baseUrl$SERVICES_URL/$serviceId/';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Token $token',
        },
      );

      if (response.statusCode == 204 || response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to delete service: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to delete service: $e');
    }
  }

// Private method to fetch services
  Future<List<Services>> _fetchFilteredServices({
    required int currentPage,
    required int pageSize,
    required String categoryName,
    required String regionName,
    required String districtName,
    required String serviceName,
    int? districtId,
    String? neighborhoodId,
    double? radiusKm,
    double? centerLat,
    double? centerLng,
  }) async {
    try {
      final queryParams = <String, String>{
        'page': currentPage.toString(),
        'page_size': pageSize.toString(),
      };

      // Geo-radius takes precedence over neighborhood_id (Karrot pattern).
      if (centerLat != null && centerLng != null && radiusKm != null && radiusKm.isFinite) {
        queryParams['center_lat'] = centerLat.toStringAsFixed(6);
        queryParams['center_lng'] = centerLng.toStringAsFixed(6);
        queryParams['radius_km'] = radiusKm.toStringAsFixed(0);
      } else {
        if (neighborhoodId != null) {
          queryParams['neighborhood_id'] = neighborhoodId;
        }
        if (radiusKm != null && radiusKm.isFinite) {
          queryParams['radius_km'] = radiusKm.toStringAsFixed(0);
        }
      }

      // Prefer district_id over name strings (avoids locale mismatch issues)
      if (districtId != null && districtId > 0) {
        queryParams['district_id'] = districtId.toString();
        if (kDebugMode) {
          print('🔧 [ServicesAPI] Filtering by district_id: $districtId');
        }
      } else if (regionName.isNotEmpty || districtName.isNotEmpty) {
        // Fallback to name-based filtering
        if (regionName.isNotEmpty) queryParams['region_name'] = regionName;
        if (districtName.isNotEmpty) queryParams['district_name'] = districtName;
        if (kDebugMode) {
          print('🔧 [ServicesAPI] Filtering by names: region=$regionName, district=$districtName');
        }
      }

      // Only add non-empty parameters to reduce URL size
      if (categoryName.isNotEmpty) queryParams['category_name'] = categoryName;
      if (serviceName.isNotEmpty) queryParams['service_name'] = serviceName;

      final response = await dio.get(
        '$SERVICES_URL/', // Fixed: removed leading slash to work with baseUrl
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final data = response.data;

        if (kDebugMode) {
        }

        return (data['results'] as List)
            .map((serviceJson) => Services.fromJson(serviceJson))
            .toList();
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to load filtered services: ${response.statusCode}',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

// Public method with caching and performance logging
  Future<List<Services>> getFilteredServices({
    int currentPage = 1,
    int pageSize = 12,
    String categoryName = "",
    String regionName = "",
    String districtName = "",
    String serviceName = "",
    int? districtId,
    String? neighborhoodId,
    double? radiusKm,
    double? centerLat,
    double? centerLng,
  }) async {
    final cacheKey =
        'filtered_services_${currentPage}_${pageSize}_${categoryName}_${regionName}_${districtName}_${districtId}_${neighborhoodId ?? ""}_${radiusKm ?? ""}_${centerLat ?? ""}_${centerLng ?? ""}_$serviceName';

    // Check for pending request
    if (_pendingRequests.containsKey(cacheKey)) {
      if (kDebugMode) {
      }
      return await _pendingRequests[cacheKey] as List<Services>;
    }

    final timer = Stopwatch()..start();

    final future = _fetchFilteredServices(
      currentPage: currentPage,
      pageSize: pageSize,
      categoryName: categoryName,
      regionName: regionName,
      districtName: districtName,
      serviceName: serviceName,
      districtId: districtId,
      neighborhoodId: neighborhoodId,
      radiusKm: radiusKm,
      centerLat: centerLat,
      centerLng: centerLng,
    );

    _pendingRequests[cacheKey] = future;

    try {
      final services = await future;

      timer.stop();
      _logPerformance('Get Filtered Services', timer.elapsed.inMilliseconds);

      return services;
    } finally {
      _pendingRequests.remove(cacheKey);
    }
  }
}

final servicesProvider = FutureProvider<List<Services>>((ref) async {
  final service = ServiceProvider();
  return service.getServices();
});

final serviceMainProvider = Provider((ref) => ServiceProvider());

// Service categories provider
final serviceCategoriesProvider = FutureProvider<List<CategoryModel>>((ref) async {
  final service = ref.watch(serviceMainProvider);
  return service.getCategories();
});

// Refresh trigger provider - increment to trigger reload in ServiceList
final servicesRefreshProvider = StateProvider<int>((ref) => 0);
