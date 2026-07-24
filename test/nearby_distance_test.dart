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

  group('Products.fromJson seller (Plan D Task 6)', () {
    test('parses a full seller block', () {
      final product = Products.fromJson({
        'id': 1,
        'title': 'Sofa',
        'price': '100000',
        'seller': {
          'id': 7,
          'username': 'alice',
          'avatar': 'https://cdn.example.com/avatar.jpg',
          'trust_temperature': 42.3,
          'rating_avg': 4.6,
          'review_count': 12,
          'response_label': 'Responds quickly',
        },
      });
      final seller = product.seller;
      expect(seller, isNotNull);
      expect(seller!.id, 7);
      expect(seller.username, 'alice');
      expect(seller.avatarUrl, 'https://cdn.example.com/avatar.jpg');
      expect(seller.trustTemperature, 42.3);
      expect(seller.ratingAvg, 4.6);
      expect(seller.reviewCount, 12);
      expect(seller.responseLabel, 'Responds quickly');
    });

    test('is null when the seller block is absent (list payload)', () {
      final product = Products.fromJson({
        'id': 1,
        'title': 'Sofa',
        'price': '100000',
      });
      expect(product.seller, isNull);
    });

    test(
        'applies null-safe defaults (36.5 temp, null rating, 0 count, null label)',
        () {
      final product = Products.fromJson({
        'id': 1,
        'title': 'Sofa',
        'price': '100000',
        'seller': {
          'id': 7,
          'username': 'brandnew',
        },
      });
      final seller = product.seller;
      expect(seller, isNotNull);
      expect(seller!.trustTemperature, 36.5);
      expect(seller.ratingAvg, isNull);
      expect(seller.reviewCount, 0);
      expect(seller.responseLabel, isNull);
    });

    test('parses a string trust_temperature/review_count (defensive)', () {
      final product = Products.fromJson({
        'id': 1,
        'title': 'Sofa',
        'price': '100000',
        'seller': {
          'id': 7,
          'username': 'brandnew',
          'trust_temperature': '38.1',
          'review_count': '5',
        },
      });
      final seller = product.seller;
      expect(seller!.trustTemperature, 38.1);
      expect(seller.reviewCount, 5);
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

  group('Services.fromJson ratingAvg/ratingCount (Plan B Task 7)', () {
    test('parses rating_avg/rating_count when present', () {
      final service = Services.fromJson({
        'id': 1,
        'name': 'Plumbing',
        'rating_avg': 4.8,
        'rating_count': 12,
      });
      expect(service.ratingAvg, 4.8);
      expect(service.ratingCount, 12);
    });

    test('ratingAvg is null and ratingCount is 0 when absent (no reviews)', () {
      final service = Services.fromJson({
        'id': 1,
        'name': 'Plumbing',
      });
      expect(service.ratingAvg, isNull);
      expect(service.ratingCount, 0);
    });

    test('ratingAvg is null when rating_avg is explicitly null', () {
      final service = Services.fromJson({
        'id': 1,
        'name': 'Plumbing',
        'rating_avg': null,
        'rating_count': 0,
      });
      expect(service.ratingAvg, isNull);
      expect(service.ratingCount, 0);
    });

    test('parses a string rating_count (defensive backend contract)', () {
      final service = Services.fromJson({
        'id': 1,
        'name': 'Plumbing',
        'rating_avg': '4.5',
        'rating_count': '3',
      });
      expect(service.ratingAvg, 4.5);
      expect(service.ratingCount, 3);
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
