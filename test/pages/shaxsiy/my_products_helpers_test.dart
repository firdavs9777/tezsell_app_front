import 'package:flutter_test/flutter_test.dart';

import 'package:app/pages/shaxsiy/my-products/my_products_helpers.dart';
import 'package:app/providers/provider_models/product_model.dart';

/// Plan E Task 5 — regression guard for the my-listings Active/Sold tab
/// split. Active must include not-yet-sold items regardless of
/// is_active (hidden items stay in Active with their own indicator);
/// Sold must include every is_sold item regardless of is_active.
void main() {
  Products buildProduct({
    required int id,
    required bool isSold,
    bool isActive = true,
  }) {
    return Products.fromJson({
      'id': id,
      'title': 'Product $id',
      'description': '',
      'price': '1000',
      'condition': 'new',
      'category': <String, dynamic>{},
      'location': <String, dynamic>{},
      'currency': 'UZS',
      'in_stock': true,
      'is_active': isActive,
      'is_sold': isSold,
      'is_reserved': false,
      'images': <dynamic>[],
      'rating': 0.0,
      'likeCount': 0,
      'commentCount': 0,
      'userName': <String, dynamic>{},
      'userAddress': <String, dynamic>{},
      'created_at': '2026-01-01T00:00:00Z',
      'updated_at': '2026-01-01T00:00:00Z',
    });
  }

  group('activeListings / soldListings', () {
    test('active tab includes visible and hidden not-yet-sold items', () {
      final visible = buildProduct(id: 1, isSold: false, isActive: true);
      final hidden = buildProduct(id: 2, isSold: false, isActive: false);
      final sold = buildProduct(id: 3, isSold: true, isActive: true);

      final active = activeListings([visible, hidden, sold]);

      expect(active.map((p) => p.id), containsAll([1, 2]));
      expect(active.map((p) => p.id), isNot(contains(3)));
    });

    test('sold tab includes sold items regardless of is_active', () {
      final soldVisible = buildProduct(id: 1, isSold: true, isActive: true);
      final soldHidden = buildProduct(id: 2, isSold: true, isActive: false);
      final active = buildProduct(id: 3, isSold: false, isActive: true);

      final sold = soldListings([soldVisible, soldHidden, active]);

      expect(sold.map((p) => p.id), containsAll([1, 2]));
      expect(sold.map((p) => p.id), isNot(contains(3)));
    });

    test('every listing lands in exactly one of the two tabs', () {
      final products = [
        buildProduct(id: 1, isSold: false, isActive: true),
        buildProduct(id: 2, isSold: false, isActive: false),
        buildProduct(id: 3, isSold: true, isActive: true),
        buildProduct(id: 4, isSold: true, isActive: false),
      ];

      final active = activeListings(products);
      final sold = soldListings(products);

      expect(active.length + sold.length, products.length);
      expect(
        active
            .map((p) => p.id)
            .toSet()
            .intersection(sold.map((p) => p.id).toSet()),
        isEmpty,
      );
    });

    test('empty input yields empty tabs', () {
      expect(activeListings(const []), isEmpty);
      expect(soldListings(const []), isEmpty);
    });
  });
}
