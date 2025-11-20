import 'dart:convert';
import 'package:http/http.dart' as http;

Future<bool> sendVerificationCode(String phoneNumber) async {
  final url = Uri.parse('https://api.webtezsell.com/accounts/send-sms/');
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
  final url = Uri.parse('https://api.webtezsell.com/accounts/send-sms-eskiz/');
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
  final url = Uri.parse('https://api.webtezsell.com/accounts/verify-code/');
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
