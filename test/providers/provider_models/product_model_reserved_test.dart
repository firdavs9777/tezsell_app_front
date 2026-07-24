import 'package:flutter_test/flutter_test.dart';

import 'package:app/providers/provider_models/product_model.dart';

/// D8 — regression guard for `Products.isReserved` JSON parsing. The
/// backend's Plan A already returns `is_reserved`; this locks in that the
/// Flutter model actually reads it (and defaults sanely when absent).
void main() {
  Map<String, dynamic> buildBaseJson({dynamic isReserved}) => {
        'id': 1,
        'title': 'Test product',
        'description': '',
        'price': '1000',
        'condition': 'new',
        'category': <String, dynamic>{},
        'location': <String, dynamic>{},
        'currency': 'UZS',
        'in_stock': true,
        'is_active': true,
        'is_sold': false,
        if (isReserved != null) 'is_reserved': isReserved,
        'images': <dynamic>[],
        'rating': 0.0,
        'likeCount': 0,
        'commentCount': 0,
        'userName': <String, dynamic>{},
        'userAddress': <String, dynamic>{},
        'created_at': '2026-01-01T00:00:00Z',
        'updated_at': '2026-01-01T00:00:00Z',
      };

  group('Products.fromJson is_reserved', () {
    test('parses is_reserved: true', () {
      final product = Products.fromJson(buildBaseJson(isReserved: true));
      expect(product.isReserved, isTrue);
    });

    test('parses is_reserved: false', () {
      final product = Products.fromJson(buildBaseJson(isReserved: false));
      expect(product.isReserved, isFalse);
    });

    test('defaults to false when the field is absent', () {
      final product = Products.fromJson(buildBaseJson());
      expect(product.isReserved, isFalse);
    });
  });
}
