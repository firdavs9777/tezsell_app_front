import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/constants/constants.dart';
import 'package:app/providers/provider_models/trust_score_model.dart';
import 'package:app/providers/provider_models/transaction_model.dart';
import 'package:app/providers/provider_models/review_model.dart';

/// Reviews & Trust Score API Service
class ReviewsService {
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

  // ==================== Trust Score ====================

  /// Get user's trust score (manner temperature)
  Future<TrustScore> getTrustScore(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/reviews/trust-score/$userId/'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          return TrustScore.fromJson(data['data']);
        }
      }

      // Return default score if not found
      return TrustScore.defaultScore(userId, '');
    } catch (e) {
      print('Error getting trust score: $e');
      return TrustScore.defaultScore(userId, '');
    }
  }

  /// Get available badges
  Future<List<UserBadge>> getAvailableBadges() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/reviews/badges/'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          return (data['data'] as List)
              .map((b) => UserBadge.fromJson(b))
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('Error getting badges: $e');
      return [];
    }
  }

  // ==================== Transactions ====================

  /// Create a new transaction (start a deal)
  Future<Transaction?> createTransaction({
    required int sellerId,
    required String itemType,
    required int itemId,
    int? chatRoomId,
  }) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/api/reviews/transactions/'),
        headers: headers,
        body: jsonEncode({
          'seller_id': sellerId,
          'item_type': itemType,
          'item_id': itemId,
          if (chatRoomId != null) 'chat_room_id': chatRoomId,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          return Transaction.fromJson(data['data']);
        }
      }
      return null;
    } catch (e) {
      print('Error creating transaction: $e');
      return null;
    }
  }

  /// Get user's transactions
  Future<List<Transaction>> getMyTransactions({
    String? role, // 'buyer' or 'seller'
    String? status,
  }) async {
    try {
      final headers = await _getAuthHeaders();

      var url = '$baseUrl/api/reviews/transactions/';
      final queryParams = <String, String>{};
      if (role != null) queryParams['role'] = role;
      if (status != null) queryParams['status'] = status;

      if (queryParams.isNotEmpty) {
        url += '?${Uri(queryParameters: queryParams).query}';
      }

      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          return (data['data'] as List)
              .map((t) => Transaction.fromJson(t))
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('Error getting transactions: $e');
      return [];
    }
  }

  /// Update transaction status
  Future<Transaction?> updateTransaction({
    required int transactionId,
    required String status,
    String? agreedPrice,
  }) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.patch(
        Uri.parse('$baseUrl/api/reviews/transactions/$transactionId/'),
        headers: headers,
        body: jsonEncode({
          'status': status,
          if (agreedPrice != null) 'agreed_price': agreedPrice,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          return Transaction.fromJson(data['data']);
        }
      }
      return null;
    } catch (e) {
      print('Error updating transaction: $e');
      return null;
    }
  }

  // ==================== Reviews ====================

  /// Submit a review for a transaction
  Future<Review?> submitReview({
    required int transactionId,
    required int rating,
    String? reviewText,
    List<String> tags = const [],
  }) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/api/reviews/transactions/$transactionId/review/'),
        headers: headers,
        body: jsonEncode({
          'rating': rating,
          if (reviewText != null) 'review_text': reviewText,
          'tags': tags,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          return Review.fromJson(data['data']);
        }
      }
      return null;
    } catch (e) {
      print('Error submitting review: $e');
      return null;
    }
  }

  /// Get user's reviews
  Future<Map<String, dynamic>> getUserReviews(
    int userId, {
    String type = 'received', // 'received' or 'given'
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/reviews/users/$userId/reviews/?type=$type'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          final reviewsData = data['data'];
          return {
            'summary': reviewsData['summary'] != null
                ? ReviewSummary.fromJson(reviewsData['summary'])
                : null,
            'reviews': (reviewsData['reviews'] as List?)
                    ?.map((r) => Review.fromJson(r))
                    .toList() ??
                [],
          };
        }
      }
      return {'summary': null, 'reviews': []};
    } catch (e) {
      print('Error getting user reviews: $e');
      return {'summary': null, 'reviews': []};
    }
  }

  /// Get review tags
  Future<List<ReviewTag>> getReviewTags({
    bool? forBuyer,
    bool? forSeller,
  }) async {
    try {
      var url = '$baseUrl/api/reviews/tags/';
      final queryParams = <String, String>{};
      if (forBuyer != null) queryParams['for_buyer'] = forBuyer.toString();
      if (forSeller != null) queryParams['for_seller'] = forSeller.toString();

      if (queryParams.isNotEmpty) {
        url += '?${Uri(queryParameters: queryParams).query}';
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          return (data['data'] as List)
              .map((t) => ReviewTag.fromJson(t))
              .toList();
        }
      }

      // Return predefined tags as fallback
      return ReviewTags.all;
    } catch (e) {
      print('Error getting review tags: $e');
      return ReviewTags.all;
    }
  }
}
