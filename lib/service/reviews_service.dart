import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app/constants/constants.dart';
import 'package:app/providers/provider_models/trust_score_model.dart';
import 'package:app/providers/provider_models/transaction_model.dart';
import 'package:app/providers/provider_models/review_model.dart';
import 'package:app/service/token_store.dart';

/// Reviews & Trust Score API Service
class ReviewsService {
  /// HTTP client seam so the service can be unit tested with a mocked client.
  final http.Client _client;

  ReviewsService({http.Client? client}) : _client = client ?? http.Client();

  Future<Map<String, String>> _getAuthHeaders() async {
    final token = await TokenStore.instance.getAccessToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Token $token',
    };
  }

  // ==================== Trust Score ====================

  /// Get user's trust score (manner temperature)
  Future<TrustScore> getTrustScore(int userId) async {
    try {
      final response = await _client.get(
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
      final response = await _client.get(
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
      final response = await _client.post(
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

      final response = await _client.get(
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
      final response = await _client.patch(
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

  /// Submit a review for a transaction.
  ///
  /// Matches the backend `CreateReviewView` (empty-path route under the
  /// `/api/reviews/` prefix): the transaction id travels in the body and the
  /// backend derives the reviewer's buyer/seller role from `request.user`.
  /// `tags` are ReviewTag PK integers.
  Future<Review?> submitReview({
    required int transactionId,
    required int rating,
    String? reviewText,
    List<int> tags = const [],
  }) async {
    try {
      final headers = await _getAuthHeaders();
      final trimmedText = reviewText?.trim();
      final response = await _client.post(
        Uri.parse('$baseUrl/api/reviews/'),
        headers: headers,
        body: jsonEncode({
          'transaction_id': transactionId,
          'rating': rating,
          if (trimmedText != null && trimmedText.isNotEmpty)
            'review_text': trimmedText,
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
      final response = await _client.get(
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

  /// Get one page of a user's reviews from the public, paginated
  /// `UserReviewsView` endpoint (`{success, data: {trust_score, reviews,
  /// pagination}}}`). Unlike [getUserReviews], this does NOT expect a
  /// `summary` key -- that key is never present in this endpoint's response.
  Future<PaginatedReviews> getUserReviewsPage(
    int userId, {
    int page = 1,
    int pageSize = 10,
    String type = 'received',
  }) async {
    try {
      final response = await _client.get(
        Uri.parse(
          '$baseUrl/api/reviews/users/$userId/reviews/'
          '?type=$type&page=$page&page_size=$pageSize',
        ),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          return PaginatedReviews.fromJson(data['data']);
        }
      }
      return PaginatedReviews.empty();
    } catch (e) {
      return PaginatedReviews.empty();
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

      final response = await _client.get(
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

  /// Get transactions awaiting a review from the current user.
  /// Returns a map with `transactions` (List<Transaction>) and `count` (int),
  /// matching the `{success, data: {transactions, count}}` envelope.
  Future<Map<String, dynamic>> getPendingReviews() async {
    try {
      final headers = await _getAuthHeaders();
      final response = await _client.get(
        Uri.parse('$baseUrl/api/reviews/pending/'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          final pendingData = data['data'];
          return {
            'transactions': (pendingData['transactions'] as List?)
                    ?.map((t) => Transaction.fromJson(t))
                    .toList() ??
                <Transaction>[],
            'count': pendingData['count'] ?? 0,
          };
        }
      }
      return {'transactions': <Transaction>[], 'count': 0};
    } catch (e) {
      print('Error getting pending reviews: $e');
      return {'transactions': <Transaction>[], 'count': 0};
    }
  }
}
