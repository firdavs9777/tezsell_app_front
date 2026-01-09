import 'dart:convert';
import 'package:app/constants/constants.dart';
import 'package:app/providers/provider_models/favorite_items.dart';
import 'package:app/providers/provider_models/location_model.dart';

import 'package:app/providers/provider_models/product_model.dart';
import 'package:app/providers/provider_models/service_model.dart';
import 'package:app/providers/provider_models/user_model.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileService {
  Future<UserInfo> getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.get(Uri.parse('$baseUrl$USER_INFO'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Token $token',
    });
    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      return UserInfo.fromJson(data['data']);
    } else {
      String errorMessage = 'Failed to load user info';
      try {
        final errorData = json.decode(response.body);
        if (errorData is Map && errorData.containsKey('error')) {
          errorMessage = errorData['error'].toString();
        } else if (errorData is Map && errorData.containsKey('message')) {
          errorMessage = errorData['message'].toString();
        } else if (errorData is Map && errorData.containsKey('detail')) {
          errorMessage = errorData['detail'].toString();
        } else {
          errorMessage = 'Failed to load user info (Status: ${response.statusCode})';
        }
      } catch (e) {
        errorMessage = 'Failed to load user info (Status: ${response.statusCode})';
      }
      throw Exception(errorMessage);
    }
  }

  Future<UserInfo> updateUserInfo({
    String? username,
    required int locationId,
    File? profileImage,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    // Build form data conditionally
    final Map<String, dynamic> formDataMap = {
      'location_id': locationId,
    };

    // Only add username if it's provided and not empty
    if (username != null && username.isNotEmpty) {
      formDataMap['username'] = username;
    }

    final formData = FormData.fromMap(formDataMap);

    // Add single profile image if provided
    if (profileImage != null) {
      String extension = profileImage.path.split('.').last.toLowerCase();
      formData.files.add(MapEntry(
        'profile_image',
        await MultipartFile.fromFile(
          profileImage.path,
          filename:
              'profile_${DateTime.now().millisecondsSinceEpoch}.$extension',
        ),
      ));
    }

    final dio = Dio();

    final response = await dio.put(
      '$baseUrl$USER_INFO',
      data: formData,
      options: Options(
        headers: {
          'Authorization': 'Token $token',
          'Content-Type': 'multipart/form-data',
          'Accept': 'application/json',
        },
        validateStatus: (status) => status! < 500,
      ),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Handle different response structures
      try {
        if (response.data != null) {
          // Check if response.data has 'data' key
          if (response.data is Map && response.data['data'] != null) {
            return UserInfo.fromJson(response.data['data']);
          }
          // If response.data itself is the user data
          else if (response.data is Map) {
            return UserInfo.fromJson(response.data);
          }
        }
        return await getUserInfo(); // Call your existing getUserInfo method
      } catch (e) {
        // Fallback: fetch fresh user info since update was successful
        return await getUserInfo();
      }
    } else {
      final errorMessage = response.data is Map
          ? response.data.toString()
          : 'Failed to update user info';
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: errorMessage,
      );
    }
  }

  Future<List<Regions>> getRegionsList() async {
    final response =
        await http.get(Uri.parse('$baseUrl$REGIONS_URL'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      return (data['regions'] as List)
          .map((postJson) => Regions.fromJson(postJson))
          .toList();
    } else {
      throw Exception('Failed to load regions');
    }
  }

  Future<List<Districts>> getDistrictsList({
    required String regionName,
  }) async {
    final response = await http
        .get(Uri.parse('$baseUrl$DISTRICTS_URL$regionName/'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      return (data['districts'] as List)
          .map((postJson) => Districts.fromJson(postJson))
          .toList();
    } else {
      throw Exception('Failed to load regions');
    }
  }

  Future<List<Products>> getUserProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final response =
        await http.get(Uri.parse('$baseUrl$USER_PRODUCT'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Token $token',
    });
    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      return (data['results'] as List)
          .map((postJson) => Products.fromJson(postJson))
          .toList();
    } else {
      throw Exception('Failed to load post product');
    }
  }

  Future<List<Services>> getUserServices() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final response =
        await http.get(Uri.parse('$baseUrl$USER_SERVICE'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Token $token',
    });
    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      return (data['results'] as List)
          .map((postJson) => Services.fromJson(postJson))
          .toList();
    } else {
      throw Exception('Failed to load postssss');
    }
  }

  Future<FavoriteItems> getUserFavoriteItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final response =
        await http.get(Uri.parse('$baseUrl$FAVORITE_ITEMS'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Token $token',
    });
    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      return FavoriteItems.fromJson(data);
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Future<Products> getSingleUserProduct({required String productId}) async {
    final response =
        await http.get(Uri.parse('$baseUrl$USER_PRODUCT/$productId/'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Products.fromJson(data);
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Future<Services> getSingleUserService({required String serviceId}) async {
    final response =
        await http.get(Uri.parse('$baseUrl$SERVICES_URL/$serviceId/'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Services.fromJson(data);
    } else {
      throw Exception('Failed to load service');
    }
  }

  Future<Products> likeSingleProduct({required String productId}) async {
    final url = Uri.parse('$baseUrl$PRODUCT_LIKE$productId/');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      
      // Check if response contains error (already liked)
      if (data.containsKey('error')) {
        throw Exception(data['error']);
      }
      
      // Check if response contains success and liked_product
      if (data.containsKey('liked_product')) {
        return Products.fromJson(data['liked_product']);
      }
      
      // Fallback: try to parse as product directly
      return Products.fromJson(data);
    } else {
      throw Exception('Failed to like product: ${response.statusCode}');
    }
  }

  Future<Services> likeSingleService({required String serviceId}) async {
    final url = Uri.parse('$baseUrl$SERVICE_LIKE$serviceId/');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Check if the response body contains the success message "done"
      return Services.fromJson(data['liked_service']);
    } else {
      throw Exception('Failed to load service');
    }
  }

  Future<Products> dislikeProductItem({required String productId}) async {
    final url = Uri.parse('$baseUrl$PRODUCT_DISLIKE$productId/');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      
      // Check if response contains error (already disliked)
      if (data.containsKey('error')) {
        throw Exception(data['error']);
      }
      
      // Check if response contains disliked_product
      if (data.containsKey('disliked_product')) {
        return Products.fromJson(data['disliked_product']);
      }
      
      // Fallback: try to parse as product directly
      return Products.fromJson(data);
    } else {
      throw Exception('Failed to unlike product: ${response.statusCode}');
    }
  }

  Future<Services> dislikeSingleService({required String serviceId}) async {
    final url = Uri.parse('$baseUrl$SERVICE_DISLIKE$serviceId/');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Check if the response body contains the success message "done"
      return Services.fromJson(data['disliked_service']);
    } else {
      throw Exception('Failed to load service');
    }
  }
}

final profileProvider = FutureProvider<List<Products>>((ref) async {
  final profile = ProfileService();
  return profile.getUserProducts();
});

final profileServiceProvider = Provider((ref) => ProfileService());
