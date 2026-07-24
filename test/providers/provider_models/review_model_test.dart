import 'package:app/providers/provider_models/review_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
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

  group('SubmitReviewRequest.toJson', () {
    test('serializes rating, review text and tags', () {
      final request = SubmitReviewRequest(
        rating: 5,
        reviewText: 'Great deal!',
        tags: const ['Fast Response', 'Fair Price'],
      );

      final json = request.toJson();

      expect(json['rating'], 5);
      expect(json['review_text'], 'Great deal!');
      expect(json['tags'], ['Fast Response', 'Fair Price']);
    });
  });
}
