import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/config/app_config.dart';
import 'package:app/providers/provider_models/country_model.dart';
import 'package:app/providers/provider_models/location_model.dart';
import 'package:app/service/token_store.dart';

/// Service for fetching country and region data
class CountryService {
  SharedPreferences? _prefs;

  Future<SharedPreferences> _getPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  Future<Map<String, String>> _getHeaders() async {
    final token = await TokenStore.instance.getAccessToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Token $token',
    };
  }

  /// Get list of supported countries
  /// Falls back to static list if API fails
  Future<List<CountryModel>> getCountries() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}${AppConfig.countriesPath}'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List results = data['results'] ?? data;
        return results.map((json) => CountryModel.fromJson(json)).toList();
      }
    } catch (e) {
      // Fall back to static list
    }
    return CountryModel.supportedCountries;
  }

  /// Get regions for a country
  Future<List<Regions>> getRegions(String countryCode) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}${AppConfig.regionsPath}?country=$countryCode'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List results = data['results'] ?? data;
        return results.map((json) => Regions.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  /// Get districts for a region
  Future<List<Districts>> getDistricts(int regionId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}${AppConfig.districtsPath}$regionId/'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List results = data['results'] ?? data;
        return results.map((json) => Districts.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  /// Save selected country code
  Future<void> saveSelectedCountry(String countryCode) async {
    final prefs = await _getPrefs();
    await prefs.setString('selected_country', countryCode);
  }

  /// Get saved country code
  Future<String?> getSavedCountryCode() async {
    final prefs = await _getPrefs();
    return prefs.getString('selected_country');
  }

  /// Check if user has selected a country
  Future<bool> hasSelectedCountry() async {
    final prefs = await _getPrefs();
    return prefs.containsKey('selected_country');
  }
}
