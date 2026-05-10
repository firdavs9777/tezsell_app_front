import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:app/config/app_config.dart';
import 'package:app/providers/provider_models/neighborhood.dart';
import 'package:app/services/maps/maps_exceptions.dart';

/// Calls the deployed Carrot-style verification endpoints.
/// Server validates GPS accuracy, reverse-geocodes via Nominatim, and persists
/// the user's verified neighborhood list (capped at 2 by backend).
class VerifyNeighborhoodService {
  static const _verifyPath = '/locations/users/me/verify_neighborhood';
  static const _deletePath = '/locations/users/me/verified_neighborhoods/';

  Future<Map<String, String>> _authHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Token $token',
    };
  }

  /// POST verification. Returns the parsed Neighborhood on success.
  /// Throws [MapsException] for transport / server errors with usable messages.
  Future<Neighborhood> verify({
    required double lat,
    required double lng,
    required double gpsAccuracyM,
    bool lowConfidence = false,
  }) async {
    final headers = await _authHeaders();
    final body = jsonEncode({
      'lat': lat,
      'lng': lng,
      'gps_accuracy_m': gpsAccuracyM,
      'low_confidence': lowConfidence,
    });

    http.Response resp;
    try {
      resp = await http
          .post(
            Uri.parse('${AppConfig.baseUrl}$_verifyPath'),
            headers: headers,
            body: body,
          )
          .timeout(const Duration(seconds: 12));
    } catch (e) {
      throw MapsException('verify_neighborhood transport: $e');
    }

    if (resp.statusCode == 429) {
      throw MapsRateLimitException();
    }
    if (resp.statusCode >= 400) {
      String body;
      try {
        body = (jsonDecode(resp.body)['error'] ?? resp.body).toString();
      } catch (_) {
        body = resp.body;
      }
      throw MapsServerException(resp.statusCode, body);
    }

    Map<String, dynamic> data;
    try {
      data = jsonDecode(resp.body) as Map<String, dynamic>;
    } catch (e) {
      throw MapsParseException(resp.body, 'verify_neighborhood JSON: $e');
    }

    final list = (data['verified_neighborhoods'] as List?) ?? const [];
    if (list.isEmpty) {
      throw MapsParseException(
          resp.body, 'verify_neighborhood returned empty list');
    }
    final newest = Map<String, dynamic>.from(list.last);
    final nbhd = newest['neighborhood'] as Map<String, dynamic>?;
    if (nbhd == null) {
      throw MapsParseException(
          resp.body, 'verify_neighborhood: missing neighborhood in response');
    }
    return Neighborhood.fromJson(nbhd);
  }

  /// DELETE one verified neighborhood by its id.
  Future<void> remove(String neighborhoodId) async {
    final headers = await _authHeaders();
    final encoded = Uri.encodeComponent(neighborhoodId);
    http.Response resp;
    try {
      resp = await http
          .delete(
            Uri.parse('${AppConfig.baseUrl}$_deletePath$encoded'),
            headers: headers,
          )
          .timeout(const Duration(seconds: 8));
    } catch (e) {
      throw MapsException('delete_neighborhood transport: $e');
    }
    if (resp.statusCode >= 400) {
      throw MapsServerException(resp.statusCode, resp.body);
    }
  }
}
