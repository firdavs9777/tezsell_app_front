import 'package:app/services/maps/maps_exceptions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Maps exceptions', () {
    test('MapsServerException carries status code and is a MapsException', () {
      final e = MapsServerException(503, 'Service Unavailable');
      expect(e, isA<MapsException>());
      expect(e.statusCode, 503);
      expect(e.toString(), contains('503'));
    });

    test('MapsRateLimitException is a distinct subtype', () {
      final e = MapsRateLimitException();
      expect(e, isA<MapsException>());
      expect(e, isA<MapsRateLimitException>());
    });

    test('MapsTimeoutException is a distinct subtype', () {
      final e = MapsTimeoutException();
      expect(e, isA<MapsException>());
    });

    test('MapsParseException carries the raw body', () {
      final e = MapsParseException('garbage', 'expected JSON object');
      expect(e.toString(), contains('garbage'));
      expect(e.toString(), contains('expected JSON object'));
    });
  });
}
