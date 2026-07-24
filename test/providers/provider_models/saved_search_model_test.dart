import 'package:app/providers/provider_models/saved_search_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SavedSearch.fromJson', () {
    test('parses a full backend response', () {
      final json = {
        'id': 7,
        'query': 'iphone',
        'name': 'iPhones near me',
        'display_name': 'iPhones near me',
        'item_type': 'product',
        'category_id': 3,
        'region': 'Tashkent',
        'district': 'Yunusabad',
        'min_price': '100',
        'max_price': '500',
        'use_count': 4,
        'last_used': '2026-07-01T12:00:00.000Z',
        'created_at': '2026-06-01T09:00:00.000Z',
      };

      final search = SavedSearch.fromJson(json);

      expect(search.id, 7);
      expect(search.query, 'iphone');
      expect(search.displayName, 'iPhones near me');
      expect(search.region, 'Tashkent');
      expect(search.district, 'Yunusabad');
      expect(search.useCount, 4);
      expect(search.lastUsed, DateTime.parse('2026-07-01T12:00:00.000Z'));
      expect(search.hasFilters, isTrue);
    });

    test('falls back to query when name/display_name are absent', () {
      final json = {
        'id': 1,
        'query': 'bicycle',
        'created_at': '2026-01-01T00:00:00.000Z',
      };

      final search = SavedSearch.fromJson(json);

      expect(search.displayName, 'bicycle');
      expect(search.name, isNull);
      expect(search.useCount, 0);
      expect(search.lastUsed, isNull);
      expect(search.hasFilters, isFalse);
    });
  });

  group('SavedSearch.toJson round-trip', () {
    test('re-parses to an equivalent object', () {
      final original = SavedSearch(
        id: 42,
        query: 'sofa',
        name: 'Sofas',
        displayName: 'Sofas',
        itemType: 'product',
        region: 'Samarkand',
        district: null,
        useCount: 2,
        lastUsed: DateTime.parse('2026-05-05T00:00:00.000Z'),
        createdAt: DateTime.parse('2026-01-01T00:00:00.000Z'),
      );

      final roundTripped = SavedSearch.fromJson(original.toJson());

      expect(roundTripped.id, original.id);
      expect(roundTripped.query, original.query);
      expect(roundTripped.region, original.region);
      expect(roundTripped.useCount, original.useCount);
      expect(roundTripped.lastUsed, original.lastUsed);
    });
  });
}
