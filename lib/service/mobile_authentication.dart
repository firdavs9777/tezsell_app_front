import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app/config/app_config.dart';

// Phone verification functions (kept for backward compatibility)
Future<bool> sendVerificationCode(String phoneNumber) async {
  final url = Uri.parse('${AppConfig.baseUrl}/accounts/send-sms/');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'phone_number': phoneNumber}),
  );

  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

Future<bool> sendVerificationCodeEskiz(String phoneNumber) async {
  final url = Uri.parse('${AppConfig.baseUrl}/accounts/send-sms-eskiz/');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'phone_number': phoneNumber}),
  );

  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

Future<bool> verifyVerificationCode(String phoneNumber, String otp) async {
  final url = Uri.parse('${AppConfig.baseUrl}/accounts/verify-code/');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'phone_number': phoneNumber, 'otp': otp}),
  );

  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

// Email verification functions for registration
Future<Map<String, dynamic>> sendEmailVerificationCode(String email) async {
  try {
    final url = Uri.parse('${AppConfig.baseUrl}/accounts/send-verification-code/');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return {
        'success': true,
        'message': data['message'] ?? 'Verification code sent to your email',
        'email': data['email'] ?? email,
      };
    } else {
      return {
        'success': false,
        'error': data['error'] ?? data['message'] ?? 'Failed to send verification code'
      };
    }
  } catch (e) {
    return {
      'success': false,
      'error': 'Network error: ${e.toString()}'
    };
  }
}

Future<Map<String, dynamic>> verifyEmailCode(String email, String code) async {
  try {
    final url = Uri.parse('${AppConfig.baseUrl}/accounts/verify-email-code/');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'code': code}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return {
        'success': true,
        'message': data['message'] ?? 'Email verified successfully',
        'verified': data['verified'] ?? true,
        'email': data['email'] ?? email,
      };
    } else {
      return {
        'success': false,
        'error': data['error'] ?? data['message'] ?? 'Invalid or expired verification code'
      };
    }
  } catch (e) {
    return {
      'success': false,
      'error': 'Network error: ${e.toString()}'
    };
  }
}
