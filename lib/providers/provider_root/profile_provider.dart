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
import 'package:app/service/token_store.dart';
import 'package:app/service/auth_interceptor.dart';

class ProfileService {
  Future<UserInfo> getUserInfo() async {
    final String? token = await TokenStore.instance.getAccessToken();

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
    int? locationId,
    File? profileImage,
    String? countryCode,
  }) async {
    print('[ProfileService] updateUserInfo called with district_id: $locationId, country_code: $countryCode');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = await TokenStore.instance.getAccessToken();
    print('[ProfileService] Token: ${token != null ? "present" : "missing"}');

    final Map<String, dynamic> formDataMap = {};

    if (locationId != null) {
      formDataMap['district_id'] = locationId;
    }

    // Add country_code if provided - helps backend disambiguate districts with same IDs across countries
    if (countryCode != null && countryCode.isNotEmpty) {
      formDataMap['country_code'] = countryCode;
    }

    print('[ProfileService] Form data: $formDataMap');

    // Only add username if it's provided and not empty
    if (username != null && username.isNotEmpty) {
      formDataMap['username'] = username;
    }

    final formData = FormData.fromMap(formDataMap);

    // Add single profile image if provided
    if (profileImage != null) {
      final String extension = profileImage.path.split('.').last.toLowerCase();
      formData.files.add(MapEntry(
        'profile_image',
        await MultipartFile.fromFile(
          profileImage.path,
          filename:
              'profile_${DateTime.now().millisecondsSinceEpoch}.$extension',
        ),
      ));
    }

    // 401 refresh-retry-or-logout via AuthInterceptor (Plan F Task 5).
    final dio = buildAuthedDio(baseUrl);

    print('[ProfileService] Sending PUT to: $baseUrl$USER_INFO');
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

    print('[ProfileService] Response status: ${response.statusCode}');
    print('[ProfileService] Response data: ${response.data}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Update the userLocation in SharedPreferences for future use
      if (locationId != null) {
        await prefs.setString('userLocation', locationId.toString());
        print('[ProfileService] Updated userLocation in SharedPreferences: $locationId');
      }

      // Handle different response structures
      try {
        if (response.data != null) {
          // Check if response.data has 'user_info' key (new format)
          if (response.data is Map && response.data['user_info'] != null) {
            return UserInfo.fromJson(response.data['user_info']);
          }
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
      print('[ProfileService] ERROR: Status ${response.statusCode}, Data: ${response.data}');
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

  /// Fetches the CURRENT user's own products via the owner-aware
  /// `GET /accounts/profile/:userId/products/` endpoint (Plan E Task 5) --
  /// unlike the legacy `/products/api/user/products/` endpoint this
  /// previously called, this one's `ProductSerializer` actually returns
  /// `is_sold`/`is_active`/`is_reserved`, which the my-listings screen
  /// needs to split into Active/Sold tabs and show a Hidden indicator.
  ///
  /// [includeInactive] adds `?include_inactive=true`, which the backend
  /// only honors for the authenticated owner viewing their own profile --
  /// it drops the default active-only filter so hidden/sold listings show
  /// up too. Requests `page_size=50` (the endpoint's max) since this
  /// screen has no "load more" and a seller's full listing set should fit
  /// in one page for the common case.
  Future<List<Products>> getUserProducts({bool includeInactive = false}) async {
    final String? token = await TokenStore.instance.getAccessToken();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userIdStr = prefs.getString('userId');
    final int? userId = userIdStr != null ? int.tryParse(userIdStr) : null;

    if (userId == null) {
      throw Exception('User not authenticated');
    }

    final uri = Uri.parse(AppConfig.getUserProductsUrl(userId)).replace(
      queryParameters: {
        'page_size': '50',
        if (includeInactive) 'include_inactive': 'true',
      },
    );

    final response = await http.get(uri, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Token $token',
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

  /// Fetches the CURRENT user's own services via the owner-aware
  /// `GET /accounts/profile/:userId/services/` endpoint (Plan E Task 5) --
  /// mirrors [getUserProducts]: the legacy `/services/api/user/services/`
  /// endpoint this previously called never exposed `is_active` at all, so
  /// the my-services screen's Hide/Unhide couldn't reflect real state.
  ///
  /// [includeInactive] adds `?include_inactive=true`, honored by the
  /// backend only for the authenticated owner viewing their own profile.
  Future<List<Services>> getUserServices({bool includeInactive = false}) async {
    final String? token = await TokenStore.instance.getAccessToken();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userIdStr = prefs.getString('userId');
    final int? userId = userIdStr != null ? int.tryParse(userIdStr) : null;

    if (userId == null) {
      throw Exception('User not authenticated');
    }

    final uri = Uri.parse(AppConfig.getUserServicesUrl(userId)).replace(
      queryParameters: {
        'page_size': '50',
        if (includeInactive) 'include_inactive': 'true',
      },
    );

    final response = await http.get(uri, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Token $token',
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
    final String? token = await TokenStore.instance.getAccessToken();
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
    final String? token = await TokenStore.instance.getAccessToken();

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
    final String? token = await TokenStore.instance.getAccessToken();

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

    final String? token = await TokenStore.instance.getAccessToken();

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
    final String? token = await TokenStore.instance.getAccessToken();

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
    final String? token = await TokenStore.instance.getAccessToken();

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
    final String? token = await TokenStore.instance.getAccessToken();

    if (token == null) {
      throw ApiException(statusCode: 401, message: 'Avtorizatsiya talab qilinadi');
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
        throw ApiException(statusCode: 404, message: 'Obuna funksiyasi hozircha mavjud emas');
      } else {
        throw ApiException.fromResponse(response.statusCode, json.decode(response.body));
      }
    } on FormatException {
      throw ApiException(statusCode: 500, message: "Server javobini o'qib bo'lmadi");
    }
  }

  /// Unfollow a user (uses DELETE on the same follow endpoint)
  Future<bool> unfollowUser({required int userId}) async {
    final String? token = await TokenStore.instance.getAccessToken();

    if (token == null) {
      throw ApiException(statusCode: 401, message: 'Avtorizatsiya talab qilinadi');
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
        throw ApiException(statusCode: 404, message: 'Obuna funksiyasi hozircha mavjud emas');
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
    final String? token = await TokenStore.instance.getAccessToken();

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
    final String? token = await TokenStore.instance.getAccessToken();

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
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = await TokenStore.instance.getAccessToken();
    final String? userIdStr = prefs.getString('userId');

    if (token == null) {
      throw ApiException(statusCode: 401, message: 'Avtorizatsiya talab qilinadi');
    }

    final userId = userIdStr != null ? int.tryParse(userIdStr) : null;
    if (userId == null) {
      throw ApiException(statusCode: 400, message: 'Foydalanuvchi ID topilmadi');
    }

    // Use the regular profile endpoint with current user's ID
    return getUserProfile(userId: userId);
  }

  /// Get my followers
  Future<FollowListResponse> getMyFollowers({int page = 1}) async {
    final String? token = await TokenStore.instance.getAccessToken();

    if (token == null) {
      throw ApiException(statusCode: 401, message: 'Avtorizatsiya talab qilinadi');
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
    final String? token = await TokenStore.instance.getAccessToken();

    if (token == null) {
      throw ApiException(statusCode: 401, message: 'Avtorizatsiya talab qilinadi');
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
    final String? token = await TokenStore.instance.getAccessToken();

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
    final String? token = await TokenStore.instance.getAccessToken();

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
