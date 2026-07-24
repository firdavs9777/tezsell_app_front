import 'package:flutter_test/flutter_test.dart';
import 'package:app/pages/products/widgets/product_filter_sheet.dart';

/// Plan D Task 4 — verifies `ProductFilter.toQueryParams()` matches the
/// backend's product-list filter contract (`price_min`/`price_max` as
/// decimal strings, `condition` passed through as-is), and that
/// `copyWith`'s clear flags behave as an explicit "unset", not just "leave
/// unspecified" (a common off-by-one bug: `copyWith(clearPriceMin: true)`
/// must not be overridable by a stale `priceMin` positional default).
void main() {
  group('ProductFilter', () {
    test('empty filter serializes to no params', () {
      expect(ProductFilter.empty.toQueryParams(), isEmpty);
      expect(ProductFilter.empty.isActive, isFalse);
      expect(ProductFilter.empty.activeCount, 0);
    });

    test('serializes price range as fixed-2dp decimal strings', () {
      const filter = ProductFilter(priceMin: 10, priceMax: 250.5);
      expect(filter.toQueryParams(), {
        'price_min': '10.00',
        'price_max': '250.50',
      });
      expect(filter.isActive, isTrue);
      expect(filter.activeCount, 2);
    });

    test('serializes condition as-is', () {
      const filter = ProductFilter(condition: 'like_new');
      expect(filter.toQueryParams(), {'condition': 'like_new'});
      expect(filter.activeCount, 1);
    });

    test('serializes all three filters together', () {
      const filter =
          ProductFilter(priceMin: 5, priceMax: 100, condition: 'used');
      expect(filter.toQueryParams(), {
        'price_min': '5.00',
        'price_max': '100.00',
        'condition': 'used',
      });
      expect(filter.activeCount, 3);
    });

    test('empty-string condition is treated as unset', () {
      const filter = ProductFilter(condition: '');
      expect(filter.toQueryParams(), isEmpty);
      expect(filter.isActive, isFalse);
    });

    test('copyWith clear flags unset fields regardless of other args', () {
      const filter =
          ProductFilter(priceMin: 5, priceMax: 100, condition: 'used');

      final clearedMin = filter.copyWith(clearPriceMin: true);
      expect(clearedMin.priceMin, isNull);
      expect(clearedMin.priceMax, 100);
      expect(clearedMin.condition, 'used');

      final clearedAll = filter.copyWith(
        clearPriceMin: true,
        clearPriceMax: true,
        clearCondition: true,
      );
      expect(clearedAll, ProductFilter.empty);
    });

    test('copyWith replaces a field without touching the others', () {
      const filter = ProductFilter(priceMin: 5);
      final updated = filter.copyWith(condition: 'new');
      expect(updated.priceMin, 5);
      expect(updated.condition, 'new');
    });

    test('equality is value-based', () {
      const a = ProductFilter(priceMin: 5, condition: 'new');
      const b = ProductFilter(priceMin: 5, condition: 'new');
      expect(a, b);
      expect(a.hashCode, b.hashCode);
    });
  });
}
