import 'package:flutter_test/flutter_test.dart';
import 'package:app/providers/provider_models/product_model.dart';
import 'package:app/providers/provider_models/service_model.dart';
import 'package:app/providers/provider_models/real_estate.dart';

/// Plan B Task 3: distance_km parsing on the list-item models used by the
/// products/services/real-estate browse cards.
void main() {
  group('Products.fromJson distanceKm', () {
    test('parses a numeric distance_km into a double', () {
      final product = Products.fromJson({
        'id': 1,
        'title': 'Sofa',
        'price': '100000',
        'distance_km': 1.2,
      });
      expect(product.distanceKm, 1.2);
    });

    test('parses a string distance_km (defensive backend contract)', () {
      final product = Products.fromJson({
        'id': 1,
        'title': 'Sofa',
        'price': '100000',
        'distance_km': '3.5',
      });
      expect(product.distanceKm, 3.5);
    });

    test('is null when distance_km is absent (no geo center in request)', () {
      final product = Products.fromJson({
        'id': 1,
        'title': 'Sofa',
        'price': '100000',
      });
      expect(product.distanceKm, isNull);
    });

    test('is null when distance_km is explicitly null', () {
      final product = Products.fromJson({
        'id': 1,
        'title': 'Sofa',
        'price': '100000',
        'distance_km': null,
      });
      expect(product.distanceKm, isNull);
    });
  });

  group('Services.fromJson distanceKm', () {
    test('parses a numeric distance_km into a double', () {
      final service = Services.fromJson({
        'id': 1,
        'name': 'Plumbing',
        'distance_km': 0.8,
      });
      expect(service.distanceKm, 0.8);
    });

    test('is null when distance_km is absent', () {
      final service = Services.fromJson({
        'id': 1,
        'name': 'Plumbing',
      });
      expect(service.distanceKm, isNull);
    });
  });

  group('RealEstate.fromJson distanceKm', () {
    test('parses a numeric distance_km into a double', () {
      final property = RealEstate.fromJson({
        'id': 1,
        'title': 'Cozy apartment',
        'distance_km': 4.7,
      });
      expect(property.distanceKm, 4.7);
    });

    test('is null when distance_km is absent', () {
      final property = RealEstate.fromJson({
        'id': 1,
        'title': 'Cozy apartment',
      });
      expect(property.distanceKm, isNull);
    });

    test('round-trips through toJson when present', () {
      final property = RealEstate.fromJson({
        'id': 1,
        'title': 'Cozy apartment',
        'distance_km': 2.3,
      });
      final json = property.toJson();
      expect(json['distance_km'], 2.3);
    });

    test('omits distance_km from toJson when absent', () {
      final property = RealEstate.fromJson({
        'id': 1,
        'title': 'Cozy apartment',
      });
      final json = property.toJson();
      expect(json.containsKey('distance_km'), isFalse);
    });
  });
}
