import 'dart:convert';
import 'package:app/constants/constants.dart';
import 'package:app/config/app_config.dart';
import 'package:app/providers/provider_models/favorite_items.dart';
import 'package:app/providers/provider_models/location_model.dart';

import 'package:app/providers/provider_models/product_model.dart';
import 'package:app/providers/provider_models/service_model.dart';
import 'package:app/providers/provider_models/user_model.dart';
import 'package:app/providers/provider_models/user_profile_model.dart';
import 'package:app/utils/error_handler.dart';
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

  // ============== PUBLIC PROFILE METHODS ==============

  /// Get public profile of another user
  Future<UserProfile> getUserProfile({required int userId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final url = AppConfig.getUserProfileUrl(userId);
    print('🔍 Fetching profile from: $url');

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          if (token != null) 'Authorization': 'Token $token',
        },
      );

      print('📡 Profile response status: ${response.statusCode}');
      print('📦 Profile response body: ${response.body.substring(0, response.body.length.clamp(0, 500))}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Handle wrapped response: {"data": {"profile": {...}}}
        if (data['data'] != null && data['data']['profile'] != null) {
          print('✅ Parsing from data.profile');
          return UserProfile.fromJson(data['data']['profile']);
        }
        // Handle: {"data": {...}}
        if (data['data'] != null) {
          print('✅ Parsing from data');
          return UserProfile.fromJson(data['data']);
        }
        // Handle: {"profile": {...}}
        if (data['profile'] != null) {
          print('✅ Parsing from profile');
          return UserProfile.fromJson(data['profile']);
        }
        print('✅ Parsing from root');
        return UserProfile.fromJson(data);
      } else {
        print('❌ Profile fetch failed: ${response.statusCode}');
        throw ApiException.fromResponse(response.statusCode, json.decode(response.body));
      }
    } catch (e) {
      print('❌ Profile fetch error: $e');
      rethrow;
    }
  }

  /// Follow a user
  Future<bool> followUser({required int userId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw ApiException(statusCode: 401, message: "Avtorizatsiya talab qilinadi");
    }

    try {
      final response = await http.post(
        Uri.parse(AppConfig.getFollowUserUrl(userId)),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Token $token',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else if (response.statusCode == 400) {
        // Already following - still considered success
        final data = json.decode(response.body);
        if (data['error']?.toString().contains('already following') ?? false) {
          return true;
        }
        throw ApiException.fromResponse(response.statusCode, data);
      } else if (response.statusCode == 404) {
        // Follow endpoint not implemented yet
        throw ApiException(statusCode: 404, message: "Obuna funksiyasi hozircha mavjud emas");
      } else {
        throw ApiException.fromResponse(response.statusCode, json.decode(response.body));
      }
    } on FormatException {
      throw ApiException(statusCode: 500, message: "Server javobini o'qib bo'lmadi");
    }
  }

  /// Unfollow a user (uses DELETE on the same follow endpoint)
  Future<bool> unfollowUser({required int userId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw ApiException(statusCode: 401, message: "Avtorizatsiya talab qilinadi");
    }

    try {
      final response = await http.delete(
        Uri.parse(AppConfig.getFollowUserUrl(userId)), // Same endpoint as follow, but DELETE method
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Token $token',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else if (response.statusCode == 400) {
        // Not following - still considered success for unfollow
        final data = json.decode(response.body);
        if (data['error']?.toString().contains('not following') ?? false) {
          return true;
        }
        throw ApiException.fromResponse(response.statusCode, data);
      } else if (response.statusCode == 404) {
        // Unfollow endpoint not implemented yet
        throw ApiException(statusCode: 404, message: "Obuna funksiyasi hozircha mavjud emas");
      } else {
        throw ApiException.fromResponse(response.statusCode, json.decode(response.body));
      }
    } on FormatException {
      throw ApiException(statusCode: 500, message: "Server javobini o'qib bo'lmadi");
    }
  }

  /// Get followers of a user
  Future<FollowListResponse> getFollowers({
    required int userId,
    int page = 1,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    try {
      final response = await http.get(
        Uri.parse('${AppConfig.getFollowersUrl(userId)}?page=$page'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          if (token != null) 'Authorization': 'Token $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return FollowListResponse.fromJson(data);
      } else if (response.statusCode == 404) {
        // No followers endpoint or user not found - return empty list
        return const FollowListResponse(count: 0, results: []);
      } else {
        throw ApiException.fromResponse(response.statusCode, json.decode(response.body));
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      // Return empty list on parse errors
      return const FollowListResponse(count: 0, results: []);
    }
  }

  /// Get users that a user is following
  Future<FollowListResponse> getFollowing({
    required int userId,
    int page = 1,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    try {
      final response = await http.get(
        Uri.parse('${AppConfig.getFollowingUrl(userId)}?page=$page'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          if (token != null) 'Authorization': 'Token $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return FollowListResponse.fromJson(data);
      } else if (response.statusCode == 404) {
        // No following endpoint or user not found - return empty list
        return const FollowListResponse(count: 0, results: []);
      } else {
        throw ApiException.fromResponse(response.statusCode, json.decode(response.body));
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      // Return empty list on parse errors
      return const FollowListResponse(count: 0, results: []);
    }
  }

  /// Get current user's own profile (fetches using current user's ID)
  Future<UserProfile> getMyProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? userIdStr = prefs.getString('userId');

    if (token == null) {
      throw ApiException(statusCode: 401, message: "Avtorizatsiya talab qilinadi");
    }

    final userId = userIdStr != null ? int.tryParse(userIdStr) : null;
    if (userId == null) {
      throw ApiException(statusCode: 400, message: "Foydalanuvchi ID topilmadi");
    }

    // Use the regular profile endpoint with current user's ID
    return getUserProfile(userId: userId);
  }

  /// Get my followers
  Future<FollowListResponse> getMyFollowers({int page = 1}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw ApiException(statusCode: 401, message: "Avtorizatsiya talab qilinadi");
    }

    try {
      final response = await http.get(
        Uri.parse('${AppConfig.getMyFollowersUrl()}?page=$page'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Token $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return FollowListResponse.fromJson(data);
      } else if (response.statusCode == 404) {
        return const FollowListResponse(count: 0, results: []);
      } else {
        throw ApiException.fromResponse(response.statusCode, json.decode(response.body));
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      return const FollowListResponse(count: 0, results: []);
    }
  }

  /// Get users I'm following
  Future<FollowListResponse> getMyFollowing({int page = 1}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw ApiException(statusCode: 401, message: "Avtorizatsiya talab qilinadi");
    }

    try {
      final response = await http.get(
        Uri.parse('${AppConfig.getMyFollowingUrl()}?page=$page'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Token $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return FollowListResponse.fromJson(data);
      } else if (response.statusCode == 404) {
        return const FollowListResponse(count: 0, results: []);
      } else {
        throw ApiException.fromResponse(response.statusCode, json.decode(response.body));
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      return const FollowListResponse(count: 0, results: []);
    }
  }

  /// Get products of a specific user
  Future<List<Products>> getUserProductsById({required int userId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    try {
      final url = AppConfig.getUserProductsUrl(userId);
      print('🔍 Fetching user products from: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          if (token != null) 'Authorization': 'Token $token',
        },
      );

      print('📡 User products response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Handle different response formats
        List<dynamic> productsList;
        if (data is List) {
          productsList = data;
        } else if (data['results'] != null) {
          productsList = data['results'];
        } else if (data['products'] != null) {
          productsList = data['products'];
        } else if (data['data'] != null) {
          if (data['data'] is List) {
            productsList = data['data'];
          } else if (data['data']['results'] != null) {
            productsList = data['data']['results'];
          } else {
            productsList = [];
          }
        } else {
          productsList = [];
        }

        return productsList.map((p) => Products.fromJson(p)).toList();
      } else if (response.statusCode == 404) {
        return [];
      } else {
        print('❌ User products fetch failed: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('❌ User products fetch error: $e');
      return [];
    }
  }

  /// Get services of a specific user
  Future<List<Services>> getUserServicesById({required int userId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    try {
      final url = AppConfig.getUserServicesUrl(userId);
      print('🔍 Fetching user services from: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          if (token != null) 'Authorization': 'Token $token',
        },
      );

      print('📡 User services response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Handle different response formats
        List<dynamic> servicesList;
        if (data is List) {
          servicesList = data;
        } else if (data['results'] != null) {
          servicesList = data['results'];
        } else if (data['services'] != null) {
          servicesList = data['services'];
        } else if (data['data'] != null) {
          if (data['data'] is List) {
            servicesList = data['data'];
          } else if (data['data']['results'] != null) {
            servicesList = data['data']['results'];
          } else {
            servicesList = [];
          }
        } else {
          servicesList = [];
        }

        return servicesList.map((s) => Services.fromJson(s)).toList();
      } else if (response.statusCode == 404) {
        return [];
      } else {
        print('❌ User services fetch failed: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('❌ User services fetch error: $e');
      return [];
    }
  }
}

final profileProvider = FutureProvider<List<Products>>((ref) async {
  final profile = ProfileService();
  return profile.getUserProducts();
});

final profileServiceProvider = Provider((ref) => ProfileService());

/// Provider to fetch a user's public profile
final userProfileProvider = FutureProvider.family<UserProfile, int>((ref, userId) async {
  final profileService = ref.read(profileServiceProvider);
  return profileService.getUserProfile(userId: userId);
});

/// Provider to fetch current user's profile with follow stats
final myProfileProvider = FutureProvider<UserProfile>((ref) async {
  final profileService = ref.read(profileServiceProvider);
  return profileService.getMyProfile();
});

/// Provider to fetch followers of a user
final userFollowersProvider = FutureProvider.family<FollowListResponse, int>((ref, userId) async {
  final profileService = ref.read(profileServiceProvider);
  return profileService.getFollowers(userId: userId);
});

/// Provider to fetch users that a user is following
final userFollowingProvider = FutureProvider.family<FollowListResponse, int>((ref, userId) async {
  final profileService = ref.read(profileServiceProvider);
  return profileService.getFollowing(userId: userId);
});

/// Provider to fetch current user's followers
final myFollowersProvider = FutureProvider<FollowListResponse>((ref) async {
  final profileService = ref.read(profileServiceProvider);
  return profileService.getMyFollowers();
});

/// Provider to fetch users the current user is following
final myFollowingProvider = FutureProvider<FollowListResponse>((ref) async {
  final profileService = ref.read(profileServiceProvider);
  return profileService.getMyFollowing();
});

/// Provider to fetch products of a specific user
final userProductsProvider = FutureProvider.family<List<Products>, int>((ref, userId) async {
  final profileService = ref.read(profileServiceProvider);
  return profileService.getUserProductsById(userId: userId);
});

/// Provider to fetch services of a specific user
final userServicesProvider = FutureProvider.family<List<Services>, int>((ref, userId) async {
  final profileService = ref.read(profileServiceProvider);
  return profileService.getUserServicesById(userId: userId);
});
