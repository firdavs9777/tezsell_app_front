import 'dart:convert';

import 'package:app/providers/provider_models/transaction_model.dart';
import 'package:app/service/reviews_service.dart';
import 'package:app/service/token_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

/// In-memory [SecureTokenStorage] so the service's auth-header lookup resolves
/// without touching platform channels.
class _FakeTokenStorage implements SecureTokenStorage {
  final Map<String, String> _store;
  _FakeTokenStorage(this._store);

  @override
  Future<String?> read(String key) async => _store[key];
  @override
  Future<void> write(String key, String value) async => _store[key] = value;
  @override
  Future<void> delete(String key) async => _store.remove(key);
}

void main() {
  setUp(() {
    // Seed a token so _getAuthHeaders() resolves in tests.
    TokenStore.setInstanceForTesting(
      TokenStore.forTesting(
        _FakeTokenStorage({'secure_access_token': 'test-token'}),
      ),
    );
  });

  group('ReviewsService.submitReview', () {
    test('POSTs to /api/reviews/ with transaction_id, rating and int tags', () async {
      late http.Request captured;
      final client = MockClient((req) async {
        captured = req;
        return http.Response(
          jsonEncode({
            'success': true,
            'data': {
              'id': 1,
              'reviewer': {'id': 2, 'username': 'buyer'},
              'reviewed_user': {'id': 3, 'username': 'seller'},
              'transaction_id': 42,
              'rating': 5,
              'tags': [],
              'is_buyer_review': true,
              'created_at': '2026-07-24T00:00:00.000Z',
            },
          }),
          201,
        );
      });

      final service = ReviewsService(client: client);
      final review = await service.submitReview(
        transactionId: 42,
        rating: 5,
        reviewText: 'Nice',
        tags: const [1, 6],
      );

      // URL: the empty-path CreateReviewView route, NOT /transactions/:id/review/.
      expect(captured.method, 'POST');
      expect(captured.url.path, '/api/reviews/');

      final body = jsonDecode(captured.body) as Map<String, dynamic>;
      expect(body['transaction_id'], 42);
      expect(body['rating'], 5);
      expect(body['review_text'], 'Nice');
      expect(body['tags'], [1, 6]);
      expect(body['tags'], everyElement(isA<int>()));
      // The backend derives role itself — is_buyer_review must NOT be sent.
      expect(body.containsKey('is_buyer_review'), isFalse);

      expect(review, isNotNull);
      expect(review!.rating, 5);
    });

    test('omits review_text when blank/whitespace', () async {
      late http.Request captured;
      final client = MockClient((req) async {
        captured = req;
        return http.Response(jsonEncode({'success': false}), 400);
      });

      final service = ReviewsService(client: client);
      await service.submitReview(transactionId: 1, rating: 4, reviewText: '   ');

      final body = jsonDecode(captured.body) as Map<String, dynamic>;
      expect(body.containsKey('review_text'), isFalse);
    });
  });

  group('ReviewsService.getUserReviewsPage', () {
    test('requests the given page/page_size and parses the pagination envelope',
        () async {
      late Uri requestedUri;
      final client = MockClient((req) async {
        requestedUri = req.url;
        return http.Response(
          jsonEncode({
            'success': true,
            'data': {
              'trust_score': {'user_id': 5, 'temperature': '40.0'},
              'reviews': [
                {
                  'id': 1,
                  'reviewer': 8,
                  'reviewer_name': 'Carol',
                  'reviewed_user': 5,
                  'rating': 5,
                  'review_text': 'Awesome!',
                  'tags': [],
                  'created_at': '2026-07-01T00:00:00.000Z',
                },
              ],
              'pagination': {
                'page': 2,
                'page_size': 10,
                'total': 15,
                'total_pages': 2,
              },
            },
          }),
          200,
        );
      });

      final service = ReviewsService(client: client);
      final result =
          await service.getUserReviewsPage(5, page: 2, pageSize: 10);

      expect(requestedUri.path, '/api/reviews/users/5/reviews/');
      expect(requestedUri.queryParameters['page'], '2');
      expect(requestedUri.queryParameters['page_size'], '10');

      expect(result.reviews, hasLength(1));
      expect(result.reviews.first.reviewer.username, 'Carol');
      expect(result.page, 2);
      expect(result.total, 15);
      expect(result.totalPages, 2);
      expect(result.hasMore, isFalse); // page == total_pages
    });

    test('returns an empty page on a non-2xx response instead of throwing',
        () async {
      final client = MockClient((req) async => http.Response('', 404));
      final service = ReviewsService(client: client);

      final result = await service.getUserReviewsPage(999);

      expect(result.reviews, isEmpty);
      expect(result.hasMore, isFalse);
    });

    // MyReviewsScreen's "Given" tab (E4) relies on this query param to fetch
    // reviews the user has written rather than received.
    test('requests type=given for the "Given" tab', () async {
      late Uri requestedUri;
      final client = MockClient((req) async {
        requestedUri = req.url;
        return http.Response(
          jsonEncode({
            'success': true,
            'data': {
              'reviews': [],
              'pagination': {
                'page': 1,
                'page_size': 10,
                'total': 0,
                'total_pages': 1,
              },
            },
          }),
          200,
        );
      });

      final service = ReviewsService(client: client);
      await service.getUserReviewsPage(5, type: 'given');

      expect(requestedUri.queryParameters['type'], 'given');
    });
  });

  group('ReviewsService.getPendingReviews', () {
    test('parses the {success, data:{transactions, count}} envelope', () async {
      final client = MockClient((req) async {
        expect(req.url.path, '/api/reviews/pending/');
        return http.Response(
          jsonEncode({
            'success': true,
            'data': {
              'transactions': [
                {
                  'id': 9,
                  'seller': 3,
                  'seller_name': 'Alice',
                  'buyer': 2,
                  'buyer_name': 'Bob',
                  'item_type': 'product',
                  'item_title': 'Bike',
                  'item_image': null,
                  'status': 'completed',
                  'can_review': true,
                },
              ],
              'count': 1,
            },
          }),
          200,
        );
      });

      final service = ReviewsService(client: client);
      final result = await service.getPendingReviews();

      expect(result['count'], 1);
      final txns = result['transactions'] as List<Transaction>;
      expect(txns, hasLength(1));
      expect(txns.first.id, 9);
      expect(txns.first.sellerName, 'Alice');
    });
  });
}
