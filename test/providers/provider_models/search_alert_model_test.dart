import 'package:app/providers/provider_models/search_alert_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SearchAlert.fromJson', () {
    test('parses a full backend response', () {
      final json = {
        'id': 5,
        'keyword': 'macbook',
        'item_type': 'product',
        'region': 'Tashkent',
        'district': 'Chilanzar',
        'is_active': true,
        'notify_push': true,
        'notify_email': false,
        'matches_found': 3,
        'last_checked': '2026-07-20T10:00:00.000Z',
        'last_notified': '2026-07-22T10:00:00.000Z',
        'created_at': '2026-06-01T00:00:00.000Z',
      };

      final alert = SearchAlert.fromJson(json);

      expect(alert.id, 5);
      expect(alert.keyword, 'macbook');
      expect(alert.isActive, isTrue);
      expect(alert.notifyPush, isTrue);
      expect(alert.notifyEmail, isFalse);
      expect(alert.matchesFound, 3);
      expect(alert.hasLocationFilter, isTrue);
      expect(alert.hasPriceFilter, isFalse);
    });

    test('defaults missing booleans/ids sensibly', () {
      final json = {
        'keyword': 'chair',
        'created_at': '2026-01-01T00:00:00.000Z',
      };

      final alert = SearchAlert.fromJson(json);

      expect(alert.id, 0);
      expect(alert.itemType, 'all');
      expect(alert.isActive, isTrue);
      expect(alert.notifyPush, isTrue);
      expect(alert.notifyEmail, isFalse);
      expect(alert.matchesFound, 0);
      expect(alert.hasLocationFilter, isFalse);
    });
  });

  group('SearchAlert.copyWith', () {
    test('toggling isActive leaves other fields untouched', () {
      final alert = SearchAlert(
        id: 1,
        keyword: 'desk',
        itemType: 'product',
        isActive: true,
        notifyPush: true,
        notifyEmail: false,
        matchesFound: 0,
        createdAt: DateTime.parse('2026-01-01T00:00:00.000Z'),
      );

      final toggled = alert.copyWith(isActive: false);

      expect(toggled.isActive, isFalse);
      expect(toggled.keyword, alert.keyword);
      expect(toggled.notifyPush, alert.notifyPush);
    });
  });
}
