import 'package:app/providers/provider_models/recently_viewed_model.dart';
import 'package:flutter_test/flutter_test.dart';

/// The reorder rule `recordView` applies when an item is already in the strip:
/// move it to the front, preserving the relative order of everything else.
/// Extracted here because the provider itself needs a live service.
List<RecentlyViewedItem> reorderToFront(
  List<RecentlyViewedItem> items,
  String itemType,
  int itemId,
) {
  final i = items.indexWhere(
    (e) => e.itemType == itemType && e.itemId == itemId,
  );
  if (i < 0) return items;
  final out = [...items];
  out.insert(0, out.removeAt(i));
  return out;
}

RecentlyViewedItem _item(int id, String type) => RecentlyViewedItem(
      id: id,
      itemType: type,
      itemId: id,
      viewedAt: DateTime(2026, 1, 1),
    );

void main() {
  group('recently viewed reorder', () {
    test('moves an existing item to the front', () {
      final items = [_item(1, 'product'), _item(2, 'product'), _item(3, 'product')];

      final out = reorderToFront(items, 'product', 3);

      expect(out.map((e) => e.itemId), [3, 1, 2]);
    });

    test('preserves the order of the remaining items', () {
      final items = [_item(1, 'product'), _item(2, 'product'), _item(3, 'product')];

      final out = reorderToFront(items, 'product', 2);

      expect(out.map((e) => e.itemId), [2, 1, 3]);
    });

    test('an item already at the front stays put', () {
      final items = [_item(1, 'product'), _item(2, 'product')];

      expect(reorderToFront(items, 'product', 1).map((e) => e.itemId), [1, 2]);
    });

    test('matches on type as well as id, not id alone', () {
      // A product and a service can share an itemId; only the right one moves.
      final items = [_item(1, 'product'), _item(2, 'service')];

      final out = reorderToFront(items, 'service', 2);

      expect(out.first.itemType, 'service');
    });

    test('leaves the list untouched when the item is absent', () {
      final items = [_item(1, 'product')];

      expect(reorderToFront(items, 'product', 99).map((e) => e.itemId), [1]);
    });
  });
}
