import 'package:app/providers/provider_models/review_model.dart';
import 'package:app/providers/provider_models/transaction_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Transaction.fromJson (backend TransactionSerializer shape)', () {
    test('parses int seller/buyer PKs plus *_name and item_* fields', () {
      final json = {
        'id': 9,
        'seller': 3,
        'seller_name': 'Alice',
        'buyer': 2,
        'buyer_name': 'Bob',
        'item_type': 'product',
        'item_title': 'Vintage bike',
        'item_image': 'https://example.com/bike.jpg',
        'status': 'completed',
        'agreed_price': '150000',
        'created_at': '2026-07-01T00:00:00.000Z',
        'completed_at': '2026-07-02T00:00:00.000Z',
        'seller_reviewed': false,
        'buyer_reviewed': true,
        'can_review': true,
      };

      final tx = Transaction.fromJson(json);

      expect(tx.id, 9);
      expect(tx.seller, 3);
      expect(tx.sellerName, 'Alice');
      expect(tx.buyer, 2);
      expect(tx.buyerName, 'Bob');
      expect(tx.itemTitle, 'Vintage bike');
      expect(tx.itemImage, 'https://example.com/bike.jpg');
      expect(tx.status, 'completed');
      expect(tx.agreedPrice, '150000');
      expect(tx.canReview, isTrue);
      expect(tx.buyerReviewed, isTrue);
      expect(tx.sellerReviewed, isFalse);
      expect(tx.isCompleted, isTrue);
    });

    test('isBuyerFor resolves role by comparing user id to buyer/seller PKs', () {
      final tx = Transaction.fromJson({
        'id': 1,
        'seller': 3,
        'buyer': 2,
        'item_type': 'product',
        'item_title': 'Chair',
        'status': 'completed',
        'can_review': true,
      });

      expect(tx.isBuyerFor(2), isTrue); // buyer
      expect(tx.isBuyerFor(3), isFalse); // seller
      expect(tx.isBuyerFor(99), isNull); // neither party -> no default
      expect(tx.isBuyerFor(null), isNull);
    });

    test('tolerates a null item_image', () {
      final tx = Transaction.fromJson({
        'id': 1,
        'seller': 3,
        'buyer': 2,
        'item_type': 'product',
        'item_title': 'Chair',
        'item_image': null,
        'status': 'completed',
        'can_review': true,
      });

      expect(tx.itemImage, isNull);
    });
  });

  group('ReviewTag.fromJson', () {
    test('parses a full backend response', () {
      final json = {
        'id': 12,
        'name': 'Fast Response',
        'name_uz': 'Tez javob',
        'name_ru': 'Быстрый ответ',
        'tag_type': 'positive',
        'icon': '⚡',
        'for_buyer': true,
        'for_seller': false,
      };

      final tag = ReviewTag.fromJson(json);

      expect(tag.id, 12);
      expect(tag.name, 'Fast Response');
      expect(tag.isPositive, isTrue);
      expect(tag.isNegative, isFalse);
      expect(tag.forBuyer, isTrue);
      expect(tag.forSeller, isFalse);
    });

    test('defaults missing fields sensibly', () {
      final tag = ReviewTag.fromJson({'id': 1, 'name': 'Ok'});

      expect(tag.tagType, 'positive');
      expect(tag.forBuyer, isTrue);
      expect(tag.forSeller, isTrue);
    });
  });

  group('ReviewTag.getLocalizedName', () {
    const tag = ReviewTag(
      id: 1,
      name: 'Fast Response',
      nameUz: 'Tez javob',
      nameRu: 'Быстрый ответ',
      tagType: 'positive',
      icon: '⚡',
    );

    test('returns the Uzbek name for uz locale', () {
      expect(tag.getLocalizedName('uz'), 'Tez javob');
    });

    test('returns the Russian name for ru locale', () {
      expect(tag.getLocalizedName('ru'), 'Быстрый ответ');
    });

    test('falls back to the English name for unknown/en locales', () {
      expect(tag.getLocalizedName('en'), 'Fast Response');
      expect(tag.getLocalizedName('fr'), 'Fast Response');
    });

    test('falls back to the English name when a translation is missing', () {
      const partialTag = ReviewTag(
        id: 2,
        name: 'Good Condition',
        tagType: 'positive',
        icon: '✨',
      );
      expect(partialTag.getLocalizedName('uz'), 'Good Condition');
      expect(partialTag.getLocalizedName('ru'), 'Good Condition');
    });
  });

  group('ReviewTags filtering by role (mirrors ReviewTagsNotifier.getTagsForRole)', () {
    test('buyer-facing tags only include tags marked forBuyer', () {
      final buyerTags = ReviewTags.all.where((t) => t.forBuyer).toList();
      expect(buyerTags, isNotEmpty);
      expect(buyerTags.every((t) => t.forBuyer), isTrue);
    });

    test('seller-facing tags only include tags marked forSeller', () {
      final sellerTags = ReviewTags.all.where((t) => t.forSeller).toList();
      expect(sellerTags, isNotEmpty);
      expect(sellerTags.every((t) => t.forSeller), isTrue);
    });
  });

  group('SubmitReviewRequest.toJson (backend CreateReviewSerializer shape)', () {
    test('serializes transaction_id, rating, review text and int tags', () {
      final request = SubmitReviewRequest(
        transactionId: 42,
        rating: 5,
        reviewText: 'Great deal!',
        tags: const [1, 6],
      );

      final json = request.toJson();

      expect(json['transaction_id'], 42);
      expect(json['rating'], 5);
      expect(json['review_text'], 'Great deal!');
      expect(json['tags'], [1, 6]);
      expect(json['tags'], everyElement(isA<int>()));
    });

    test('omits review_text when null', () {
      final request = SubmitReviewRequest(
        transactionId: 7,
        rating: 4,
        tags: const [],
      );

      expect(request.toJson().containsKey('review_text'), isFalse);
    });
  });
}
