import 'dart:convert';
import 'package:app/constants/constants.dart';

import 'package:app/providers/provider_models/product_model.dart';
import 'package:app/providers/provider_models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      throw Exception('Failed to load posts');
    }
  }

  Future<Products> getSingleUserProduct({required String productId}) async {
    final response =
        await http.get(Uri.parse('$baseUrl$USER_PRODUCT/$productId'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Products.fromJson(data);
    } else {
      throw Exception('Failed to load posts');
    }
  }
}

final profileProvider = FutureProvider<List<Products>>((ref) async {
  final profile = ProfileService();
  return profile.getUserProducts();
});

final profileServiceProvider = Provider((ref) => ProfileService());
