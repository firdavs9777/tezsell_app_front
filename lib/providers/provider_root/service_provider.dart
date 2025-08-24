import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:app/constants/constants.dart';
import 'package:app/providers/provider_models/category_model.dart';
import 'package:app/providers/provider_models/service_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServiceProvider {
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

  Future<List<Services>> getFilteredServices({
    int currentPage = 1,
    int pageSize = 12,
    String categoryName = "",
    String regionName = "",
    String districtName = "",
    String serviceName = "",
  }) async {
    final response = await http.get(
      Uri.parse('$baseUrl$SERVICES_URL').replace(
        queryParameters: {
          'page': currentPage.toString(),
          'page_size': pageSize.toString(),
          'category_name': categoryName,
          'region_name': regionName,
          'district_name': districtName,
          'service_name': serviceName,
        },
      ),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['results'] as List)
          .map((postJson) => Services.fromJson(postJson))
          .toList();
    } else {
      throw Exception('Failed to load filtered services');
    }
  }
}

final servicesProvider = FutureProvider<List<Services>>((ref) async {
  final service = ServiceProvider();
  return service.getServices();
});

final serviceMainProvider = Provider((ref) => ServiceProvider());
