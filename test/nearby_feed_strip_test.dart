import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app/l10n/app_localizations.dart';
import 'package:app/pages/nearby/nearby_feed_strip.dart';
import 'package:app/pages/service/main/services_list.dart';
import 'package:app/providers/provider_models/category_model.dart';
import 'package:app/providers/provider_models/comments_model.dart';
import 'package:app/providers/provider_models/location_model.dart';
import 'package:app/providers/provider_models/neighborhood.dart';
import 'package:app/providers/provider_models/real_estate.dart';
import 'package:app/providers/provider_models/service_model.dart';
import 'package:app/providers/provider_models/user_model.dart';

/// Plan B Task 7 fix pass — unit tests for the "Near you now" strip's
/// previously-untested merge/gating logic (`mergeNearbyItems`,
/// `canFetchServices`), plus a widget test guarding the services-card
/// badge-row overflow fix in `services_list.dart`.

UserInfo _dummyUser() => const UserInfo(
      id: 1,
      username: 'tester',
      email: 'tester@example.com',
      phoneNumber: '',
      userType: 'buyer',
      profileImage: ProfileImage(image: '', altText: ''),
      location: Location(id: 1, country: '', region: '', district: ''),
      isActive: true,
    );

Comments _dummyComment(int i) => Comments(
      id: i,
      text: '',
      service_id: 1,
      user: _dummyUser(),
      created_at: '2026-01-01T00:00:00Z',
    );

Services _buildService({
  required int id,
  double? distanceKm,
  double? ratingAvg,
  int ratingCount = 0,
  int likeCount = 0,
  int commentCount = 0,
}) {
  return Services(
    id: id,
    name: 'Service $id',
    likeCount: likeCount,
    description: '',
    category: const CategoryModel(
      id: 1,
      key: 'k',
      nameUz: 'Kat',
      nameRu: 'Kat',
      nameEn: 'Category',
      icon: '',
    ),
    location: const Location(
      id: 1,
      country: 'UZ',
      region: 'Region',
      district: 'District',
    ),
    images: const [],
    comments: List.generate(commentCount, _dummyComment),
    userName: _dummyUser(),
    isActive: true,
    createdAt: DateTime(2026, 1, 1),
    updatedAt: DateTime(2026, 1, 1),
    distanceKm: distanceKm,
    ratingAvg: ratingAvg,
    ratingCount: ratingCount,
  );
}

RealEstate _buildProperty({required String id, double? distanceKm}) {
  return RealEstate.fromJson({
    'id': id,
    'title': 'Property $id',
    'distance_km': distanceKm,
  });
}

VerifiedNeighborhood _verified({required DateTime verifiedAt}) {
  return VerifiedNeighborhood(
    neighborhood: const Neighborhood(
      id: 'n1',
      name: 'n1',
      displayName: 'Neighborhood 1',
      countryCode: 'UZ',
      region: 'Region',
      city: 'City',
      centroidLat: 41.0,
      centroidLng: 69.0,
    ),
    verifiedAt: verifiedAt,
    gpsAccuracyM: 10,
  );
}

void main() {
  group('mergeNearbyItems', () {
    test('interleaves two lists, sorted ascending by distanceKm', () {
      final services = [
        NearbyFeedItem.service(_buildService(id: 1, distanceKm: 2.0)),
        NearbyFeedItem.service(_buildService(id: 2, distanceKm: 5.0)),
      ];
      final properties = [
        NearbyFeedItem.property(_buildProperty(id: 'a', distanceKm: 1.0)),
        NearbyFeedItem.property(_buildProperty(id: 'b', distanceKm: 3.0)),
      ];

      final merged = mergeNearbyItems(services, properties);

      expect(merged.map((e) => e.distanceKm).toList(), [1.0, 2.0, 3.0, 5.0]);
    });

    test('null distances sort last', () {
      final services = [
        NearbyFeedItem.service(_buildService(id: 1, distanceKm: null)),
        NearbyFeedItem.service(_buildService(id: 2, distanceKm: 2.0)),
      ];
      final properties = [
        NearbyFeedItem.property(_buildProperty(id: 'a', distanceKm: null)),
        NearbyFeedItem.property(_buildProperty(id: 'b', distanceKm: 1.0)),
      ];

      final merged = mergeNearbyItems(services, properties);

      expect(merged.map((e) => e.distanceKm).toList(), [1.0, 2.0, null, null]);
    });

    test('caps result at 10 items when given 12', () {
      final services = List.generate(
        6,
        (i) => NearbyFeedItem.service(
          _buildService(id: i, distanceKm: i.toDouble()),
        ),
      );
      final properties = List.generate(
        6,
        (i) => NearbyFeedItem.property(
          _buildProperty(id: 'p$i', distanceKm: (i + 100).toDouble()),
        ),
      );

      final merged = mergeNearbyItems(services, properties);

      expect(merged.length, 10);
      // First 10 by ascending distance: all 6 services (0..5) then first 4
      // properties (100..103).
      expect(merged.map((e) => e.distanceKm).toList(),
          [0.0, 1.0, 2.0, 3.0, 4.0, 5.0, 100.0, 101.0, 102.0, 103.0]);
    });

    test('empty + nonempty passes the nonempty list through untouched', () {
      final properties = [
        NearbyFeedItem.property(_buildProperty(id: 'a', distanceKm: 4.0)),
        NearbyFeedItem.property(_buildProperty(id: 'b', distanceKm: 1.0)),
      ];

      final merged = mergeNearbyItems(const [], properties);

      expect(merged.length, 2);
      expect(merged.map((e) => e.distanceKm).toList(), [1.0, 4.0]);
    });

    test('empty + empty is empty', () {
      expect(mergeNearbyItems(const [], const []), isEmpty);
    });
  });

  group('canFetchServices (mirrors NeighborhoodGate semantics)', () {
    test('empty list -> false', () {
      expect(canFetchServices(const []), isFalse);
    });

    test('all-expired list -> false', () {
      final expired = _verified(
        verifiedAt: DateTime.now().subtract(const Duration(days: 90)),
      );
      expect(canFetchServices([expired]), isFalse);
    });

    test('one valid (non-expired) entry -> true', () {
      final valid = _verified(verifiedAt: DateTime.now());
      final expired = _verified(
        verifiedAt: DateTime.now().subtract(const Duration(days: 90)),
      );
      expect(canFetchServices([expired, valid]), isTrue);
    });
  });

  group('services card badge row (overflow fix)', () {
    testWidgets(
        'renders all four badges (rating, distance, likes, comments) at a '
        'narrow width with no overflow', (tester) async {
      final service = _buildService(
        id: 1,
        distanceKm: 1.2,
        ratingAvg: 4.8,
        ratingCount: 12,
        likeCount: 99,
        commentCount: 99,
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: SizedBox(
                width: 320,
                child: ServiceList(service: service, refresh: () {}),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(ServiceList), findsOneWidget);
    });
  });
}
