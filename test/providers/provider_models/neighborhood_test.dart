import 'package:app/providers/provider_models/neighborhood.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Neighborhood JSON', () {
    test('round-trips', () {
      final n = Neighborhood(
        id: 'UZ:12345',
        name: 'Yunusabad',
        displayName: 'Yunusabad, Tashkent, Uzbekistan',
        countryCode: 'UZ',
        region: 'Tashkent',
        city: 'Tashkent',
        centroidLat: 41.3,
        centroidLng: 69.24,
      );
      final n2 = Neighborhood.fromJson(n.toJson());
      expect(n2.id, n.id);
      expect(n2.name, n.name);
      expect(n2.centroidLat, closeTo(n.centroidLat, 1e-9));
    });
  });

  group('VerifiedNeighborhood', () {
    final nbhd = Neighborhood(
      id: 'UZ:1',
      name: 'X',
      displayName: 'X',
      countryCode: 'UZ',
      region: 'r',
      city: 'c',
      centroidLat: 0,
      centroidLng: 0,
    );

    test('isExpired returns false within 60 days', () {
      final v = VerifiedNeighborhood(
        neighborhood: nbhd,
        verifiedAt: DateTime.now().subtract(const Duration(days: 30)),
        gpsAccuracyM: 50,
      );
      expect(v.isExpired, false);
      expect(v.expiresAt.isAfter(DateTime.now()), true);
    });

    test('isExpired returns true past 60 days', () {
      final v = VerifiedNeighborhood(
        neighborhood: nbhd,
        verifiedAt: DateTime.now().subtract(const Duration(days: 61)),
        gpsAccuracyM: 50,
      );
      expect(v.isExpired, true);
    });

    test('lowConfidence defaults to false', () {
      final v = VerifiedNeighborhood(
        neighborhood: nbhd,
        verifiedAt: DateTime.now(),
        gpsAccuracyM: 50,
      );
      expect(v.lowConfidence, false);
    });

    test('JSON round-trip preserves lowConfidence and verifiedAt', () {
      final t = DateTime.utc(2026, 1, 1, 12);
      final v = VerifiedNeighborhood(
        neighborhood: nbhd,
        verifiedAt: t,
        gpsAccuracyM: 75,
        lowConfidence: true,
      );
      final v2 = VerifiedNeighborhood.fromJson(v.toJson());
      expect(v2.verifiedAt, t);
      expect(v2.lowConfidence, true);
      expect(v2.gpsAccuracyM, 75);
    });
  });
}
