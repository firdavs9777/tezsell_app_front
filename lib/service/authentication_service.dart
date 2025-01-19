import 'dart:convert';

import 'package:app/store/providers/authentication_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod/riverpod.dart';
import 'package:app/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Token {
  final String token;

  Token({required this.token});
}

final authenticationServiceProvider =
    Provider((ref) => AuthenticationService(authStatesProvider));

class AuthenticationService {
  AuthenticationService(
      StateNotifierProvider<authStateProvider, List<dynamic>>
          authStatesProvider);

  Future<Token?> login(
      BuildContext context, String phoneNumber, String password) async {
    final url = Uri.parse('$baseUrl$LOGIN_URL');
    final body =
        jsonEncode({'phone_number': phoneNumber, 'password': password});

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      print(response.statusCode);
      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);
        final token = userData['token'] as String;
        final userId = userData['user_info']['id'].toString();
        final userLocation = userData['user_info']['location']['id'].toString();
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('token', token);
        prefs.setString('userId', userId);
        prefs.setString('userLocation', userLocation);

        return Token(token: token);
      }
    } catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString())));
      return null;
    }
  }

  Future<Token?> register(
    String phoneNumber,
    String password,
    String userName,
    String regionName,
    String districtName,
  ) async {
    final url = Uri.parse('$baseUrl$REGISTER_URL');
    final body = jsonEncode({
      'phone_number': phoneNumber,
      'password': password,
      'user_type': 'regular',
      'location': {
        'country': 'Uzbekistan',
        'region': regionName,
        'district': districtName
      },
      'username': userName
    });

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final userData = jsonDecode(response.body);
        final token = userData['token'] as String;
        final userId = userData['user_info']['id'].toString();
        final userLocation = userData['user_info']['location']['id'].toString();
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('token', token);
        prefs.setString('userId', userId);
        prefs.setString('userLocation', userLocation);
        return Token(token: token);
      } else {
        // Handle non-200 status code
        print('Registration failed with status code: ${response.statusCode}');
        return null;
      }
    } catch (error) {
      if (error is http.ClientException) {
        print('Network error occurred: $error');
      } else {
        print('Unknown error occurred: $error');
      }
      return null;
    }
  }
}
