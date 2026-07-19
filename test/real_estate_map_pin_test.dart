import 'package:flutter_test/flutter_test.dart';
import 'package:app/providers/provider_models/real_estate.dart';

/// Plan B Task 4: parsing for the lightweight map-browse pin, mirroring the
/// backend's `PropertyMapSerializer` payload from
/// `GET /real_estate/api/map/bounds/`.
void main() {
  group('RealEstateMapPin.fromJson', () {
    test('parses numeric latitude/longitude and an integer id', () {
      final pin = RealEstateMapPin.fromJson({
        'id': 42,
        'title': 'Cozy apartment',
        'latitude': 41.311,
        'longitude': 69.279,
        'price': '420.00',
        'price_per_sqm': '10.5',
        'currency': 'USD',
        'property_type': 'apartment',
        'listing_type': 'rent',
        'bedrooms': 2,
        'square_meters': 60,
        'district': 'Yunusabad',
        'city': 'Tashkent',
        'is_featured': false,
        'main_image': 'https://example.com/img.jpg',
      });

      expect(pin.id, '42');
      expect(pin.latitude, 41.311);
      expect(pin.longitude, 69.279);
      expect(pin.title, 'Cozy apartment');
      expect(pin.bedrooms, 2);
      expect(pin.squareMeters, 60);
      expect(pin.isFeatured, false);
      expect(pin.mainImage, 'https://example.com/img.jpg');
    });

    test('parses a UUID string id and string-encoded coordinates', () {
      final pin = RealEstateMapPin.fromJson({
        'id': 'c9b1e2f0-1234-4abc-8def-0123456789ab',
        'title': 'Modern house',
        'latitude': '41.3',
        'longitude': '69.24',
        'price': '150000',
        'price_per_sqm': '2500',
        'currency': 'UZS',
        'property_type': 'house',
        'listing_type': 'sale',
        'bedrooms': '4',
        'square_meters': '120',
        'district': 'Chilanzar',
        'city': 'Tashkent',
        'is_featured': true,
      });

      expect(pin.id, 'c9b1e2f0-1234-4abc-8def-0123456789ab');
      expect(pin.latitude, 41.3);
      expect(pin.longitude, 69.24);
      expect(pin.bedrooms, 4);
      expect(pin.squareMeters, 120);
      expect(pin.isFeatured, true);
      expect(pin.mainImage, isNull);
    });

    test('defaults latitude/longitude to 0.0 when missing', () {
      final pin = RealEstateMapPin.fromJson({
        'id': 1,
        'title': 'No coords',
      });
      expect(pin.latitude, 0.0);
      expect(pin.longitude, 0.0);
    });

    test('priceLabel formats a compact USD price with a dollar sign', () {
      final pin = RealEstateMapPin.fromJson({
        'id': 1,
        'title': 'Studio',
        'price': '420',
        'currency': 'USD',
      });
      expect(pin.priceLabel, '\$420');
    });

    test('priceLabel formats a large UZS price in millions', () {
      final pin = RealEstateMapPin.fromJson({
        'id': 1,
        'title': 'Villa',
        'price': '2400000',
        'currency': 'UZS',
      });
      expect(pin.priceLabel, '2.4M UZS');
    });

    test('priceDisplay concatenates raw price and currency', () {
      final pin = RealEstateMapPin.fromJson({
        'id': 1,
        'title': 'Villa',
        'price': '150000',
        'currency': 'UZS',
      });
      expect(pin.priceDisplay, '150000 UZS');
    });
  });
}
