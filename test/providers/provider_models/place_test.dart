import 'package:app/providers/provider_models/place.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Place.fromNominatim', () {
    test('parses a typical Tashkent reverse-geocode response', () {
      final json = {
        'place_id': 12345,
        'lat': '41.299496',
        'lon': '69.240073',
        'display_name': 'Yunusabad, Tashkent, Uzbekistan',
        'address': {
          'suburb': 'Yunusabad',
          'city': 'Tashkent',
          'state': 'Tashkent Region',
          'country': 'Uzbekistan',
          'country_code': 'uz',
        }
      };
      final p = Place.fromNominatim(json);
      expect(p.placeId, '12345');
      expect(p.lat, closeTo(41.299496, 1e-6));
      expect(p.lng, closeTo(69.240073, 1e-6));
      expect(p.formattedAddress, 'Yunusabad, Tashkent, Uzbekistan');
      expect(p.countryCode, 'UZ');
      expect(p.region, 'Tashkent Region');
      expect(p.city, 'Tashkent');
      expect(p.neighborhood, 'Yunusabad');
    });

    test('falls through admin levels when suburb is missing', () {
      final json = {
        'place_id': 67890,
        'lat': '40.0',
        'lon': '70.0',
        'display_name': 'Some village, Andijon, Uzbekistan',
        'address': {
          'village': 'Olmazor',
          'state': 'Andijon Region',
          'country_code': 'uz',
        }
      };
      final p = Place.fromNominatim(json);
      expect(p.neighborhood, 'Olmazor');
      expect(p.city, 'Olmazor');
    });

    test('handles missing address block', () {
      final json = {
        'place_id': 1,
        'lat': '0',
        'lon': '0',
        'display_name': 'Null Island',
      };
      final p = Place.fromNominatim(json);
      expect(p.placeId, '1');
      expect(p.formattedAddress, 'Null Island');
      expect(p.countryCode, isNull);
      expect(p.neighborhood, isNull);
    });
  });

  group('Place backend JSON round-trip', () {
    test('serializes only non-null fields', () {
      final p = Place(
        placeId: 'p1',
        formattedAddress: '123 Main St',
        lat: 1.0,
        lng: 2.0,
        countryCode: 'US',
      );
      final j = p.toJson();
      expect(j['place_id'], 'p1');
      expect(j['lat'], 1.0);
      expect(j.containsKey('region'), false);
      expect(j.containsKey('city'), false);
    });

    test('round-trips through fromJson', () {
      final p = Place(
        placeId: 'p1',
        formattedAddress: 'addr',
        lat: 1.5,
        lng: 2.5,
        countryCode: 'UZ',
        region: 'Tashkent',
        city: 'Tashkent',
        neighborhood: 'Yunusabad',
      );
      final p2 = Place.fromJson(p.toJson());
      expect(p2.placeId, p.placeId);
      expect(p2.lat, p.lat);
      expect(p2.lng, p.lng);
      expect(p2.countryCode, p.countryCode);
      expect(p2.neighborhood, p.neighborhood);
    });

    test('tolerates missing optional fields from backend (migration period)', () {
      final j = {'lat': 1.0, 'lng': 2.0};
      final p = Place.fromJson(j);
      expect(p.lat, 1.0);
      expect(p.lng, 2.0);
      expect(p.placeId, isNull);
      expect(p.formattedAddress, isNull);
      expect(p.neighborhood, isNull);
    });
  });
}
