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

  Future<List<Services>> getServices() async {
    final response = await http.get(Uri.parse('$baseUrl$SERVICES_URL/'));
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
      final data = json.decode(response.body);
      return Services.fromJson(data['service']);
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Future<List<Services>> getRecommendedServices(
      {required String serviceId}) async {
    final response =
        await http.get(Uri.parse('$baseUrl$SERVICES_URL/$serviceId/'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['recommended_services'] as List)
          .map((postJson) => Services.fromJson(postJson))
          .toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Future<List<CategoryModel>> getCategories() async {
    final response = await http.get(Uri.parse('$baseUrl$SERVICE_CATEGORY/'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      return (data as List)
          .map((postJson) => CategoryModel.fromJson(postJson))
          .toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Future<Services> createService({
    required String name,
    required String description,
    required int categoryId,
    required List<File> imageFiles,
  }) async {
    const url = '$baseUrl$SERVICES_URL/';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? userLocation = prefs.getString('userLocation');
    String? userId = prefs.getString('userId');
    Dio dio = Dio();

    FormData formData = FormData.fromMap({
      'name': name,
      'description': description,
      'category_id': categoryId,
      'location_id':
          int.tryParse(userLocation.toString()), // Ensure it's an integer
      'userAddress_id':
          int.tryParse(userLocation.toString()), // Ensure it's an integer
      'userName_id': int.tryParse(userId.toString()),
      'images': imageFiles
          .map((file) => MultipartFile.fromFileSync(file.path))
          .toList(),
    });
    final response = await dio.post(url,
        data: formData,
        options: Options(headers: {
          'Authorization': 'Token $token',
          'Content-Type': 'application/json'
        }));
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Services.fromJson(response.data);
// Assuming 'data' is a map representing the new moment
    } else {
      throw Exception('Failed to create moment');
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
  }) async {
    try {
      final queryParams = <String, String>{
        'page': currentPage.toString(),
        'page_size': pageSize.toString(),
      };

      // Only add non-empty parameters to reduce URL size
      if (categoryName.isNotEmpty) queryParams['category_name'] = categoryName;
      if (regionName.isNotEmpty) queryParams['region_name'] = regionName;
      if (districtName.isNotEmpty) queryParams['district_name'] = districtName;
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
  }) async {
    final cacheKey =
        'filtered_services_${currentPage}_${pageSize}_${categoryName}_${regionName}_${districtName}_$serviceName';

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
