import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/constants/constants.dart';
import 'package:app/providers/provider_models/vacation_mode_model.dart';

/// Vacation Mode API Service
class VacationModeService {
  SharedPreferences? _prefs;

  Future<SharedPreferences> _getPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  Future<Map<String, String>> _getAuthHeaders() async {
    final prefs = await _getPrefs();
    final token = prefs.getString('token');
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Token $token',
    };
  }

  /// Get vacation mode status
  Future<VacationStatus> getVacationStatus() async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/api/accounts/vacation-mode/'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          return VacationStatus.fromJson(data['data']);
        }
      }

      return VacationStatus();
    } catch (e) {
      print('Error getting vacation status: $e');
      return VacationStatus();
    }
  }

  /// Toggle vacation mode on/off
  Future<VacationToggleResponse> toggleVacationMode({String? message}) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/api/accounts/vacation-mode/'),
        headers: headers,
        body: jsonEncode({
          if (message != null) 'message': message,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return VacationToggleResponse.fromJson(data);
      }

      return VacationToggleResponse(
        success: false,
        message: 'Failed to toggle vacation mode',
        isOnVacation: false,
      );
    } catch (e) {
      print('Error toggling vacation mode: $e');
      return VacationToggleResponse(
        success: false,
        message: 'Network error: $e',
        isOnVacation: false,
      );
    }
  }

  /// Enable vacation mode
  Future<VacationToggleResponse> enableVacationMode({String? message}) async {
    return toggleVacationMode(message: message);
  }

  /// Disable vacation mode
  Future<VacationToggleResponse> disableVacationMode() async {
    return toggleVacationMode();
  }
}
