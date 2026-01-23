import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/config/app_config.dart';
import 'package:app/providers/provider_models/offer_model.dart';

/// Service for handling offer/negotiation operations
class OffersService {
  final String baseUrl = AppConfig.baseUrl;

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Map<String, String> _getHeaders(String? token) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Token $token',
    };
  }

  /// Create a new offer
  Future<Offer> createOffer(CreateOfferRequest request) async {
    final token = await _getToken();
    if (token == null) throw Exception('Not authenticated');

    final response = await http.post(
      Uri.parse('$baseUrl/api/reviews/offers/create/'),
      headers: _getHeaders(token),
      body: jsonEncode(request.toJson()),
    );

    if (kDebugMode) {
      print('Create Offer Response: ${response.statusCode}');
    }

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      if (data['success'] == true && data['data'] != null) {
        return Offer.fromJson(data['data']);
      }
      throw Exception(data['message'] ?? 'Failed to create offer');
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? error['error'] ?? 'Failed to create offer');
    }
  }

  /// Get list of offers
  /// [role] - 'buyer' or 'seller' to filter by role
  /// [status] - Filter by offer status
  Future<List<Offer>> getOffers({String? role, String? status}) async {
    final token = await _getToken();
    if (token == null) throw Exception('Not authenticated');

    final queryParams = <String, String>{};
    if (role != null) queryParams['role'] = role;
    if (status != null) queryParams['status'] = status;

    final uri = Uri.parse('$baseUrl/api/reviews/offers/').replace(
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );

    final response = await http.get(uri, headers: _getHeaders(token));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true && data['data'] != null) {
        return (data['data'] as List)
            .map((json) => Offer.fromJson(json))
            .toList();
      }
      return [];
    } else {
      throw Exception('Failed to load offers');
    }
  }

  /// Get offer details
  Future<Offer> getOfferDetails(int offerId) async {
    final token = await _getToken();
    if (token == null) throw Exception('Not authenticated');

    final response = await http.get(
      Uri.parse('$baseUrl/api/reviews/offers/$offerId/'),
      headers: _getHeaders(token),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true && data['data'] != null) {
        return Offer.fromJson(data['data']);
      }
      throw Exception('Offer not found');
    } else {
      throw Exception('Failed to load offer details');
    }
  }

  /// Respond to an offer (seller only)
  /// [action] - 'accept', 'decline', or 'counter'
  Future<Offer> respondToOffer(int offerId, OfferResponseRequest request) async {
    final token = await _getToken();
    if (token == null) throw Exception('Not authenticated');

    final response = await http.put(
      Uri.parse('$baseUrl/api/reviews/offers/$offerId/'),
      headers: _getHeaders(token),
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true && data['data'] != null) {
        return Offer.fromJson(data['data']);
      }
      throw Exception(data['message'] ?? 'Failed to respond to offer');
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? error['error'] ?? 'Failed to respond to offer');
    }
  }

  /// Accept a counter offer (buyer only)
  Future<Offer> acceptCounterOffer(int offerId) async {
    final token = await _getToken();
    if (token == null) throw Exception('Not authenticated');

    final response = await http.post(
      Uri.parse('$baseUrl/api/reviews/offers/$offerId/accept-counter/'),
      headers: _getHeaders(token),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true && data['data'] != null) {
        return Offer.fromJson(data['data']);
      }
      throw Exception(data['message'] ?? 'Failed to accept counter offer');
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? error['error'] ?? 'Failed to accept counter offer');
    }
  }

  /// Cancel an offer (buyer only)
  Future<void> cancelOffer(int offerId) async {
    final token = await _getToken();
    if (token == null) throw Exception('Not authenticated');

    final response = await http.delete(
      Uri.parse('$baseUrl/api/reviews/offers/$offerId/'),
      headers: _getHeaders(token),
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Failed to cancel offer');
    }
  }

  /// Get pending offers count
  Future<int> getPendingOffersCount() async {
    try {
      final offers = await getOffers(role: 'seller', status: 'pending');
      return offers.length;
    } catch (e) {
      return 0;
    }
  }
}
