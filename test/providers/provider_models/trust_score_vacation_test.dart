import 'package:app/providers/provider_models/trust_score_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TrustScore public vacation fields', () {
    test('parses is_on_vacation and vacation_message from the payload', () {
      final score = TrustScore.fromJson({
        'temperature': '42.0',
        'is_on_vacation': true,
        'vacation_message': 'Back next week',
      });

      expect(score.isOnVacation, isTrue);
      expect(score.vacationMessage, 'Back next week');
    });

    test('defaults to not-on-vacation when the server omits the fields', () {
      // Older backends (and the defaultScore fallback path) send neither key;
      // the profile badge must stay hidden rather than throw.
      final score = TrustScore.fromJson({'temperature': '36.5'});

      expect(score.isOnVacation, isFalse);
      expect(score.vacationMessage, '');
    });

    test('defaultScore is never on vacation', () {
      expect(TrustScore.defaultScore(1, 'someone').isOnVacation, isFalse);
    });
  });
}
