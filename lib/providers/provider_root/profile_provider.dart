import 'dart:convert';
import 'package:app/constants/constants.dart';
import 'package:app/providers/provider_models/favorite_items.dart';

import 'package:app/providers/provider_models/product_model.dart';
import 'package:app/providers/provider_models/service_model.dart';
import 'package:app/providers/provider_models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shared_preferences/shared_preferences.dart';

class ProfileService {
  Future<UserInfo> getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    print(token);

    final response = await http.get(Uri.parse('$baseUrl$USER_INFO'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Token $token',
    });
    print(response.body);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      return UserInfo.fromJson(data['data']);
    } else {
      throw Exception('Failed to load posts');
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
    print(response.body);
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
      // Check if the response body contains the success message "done"
      return Products.fromJson(data['liked_product']);
    } else {
      throw Exception('Failed to load service');
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
      // Check if the response body contains the success message "done"
      return Products.fromJson(data['disliked_product']);
    } else {
      throw Exception('Failed to load service');
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
