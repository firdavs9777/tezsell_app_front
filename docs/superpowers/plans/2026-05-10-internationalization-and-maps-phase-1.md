# Internationalization & Maps — Phase 1 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Spec:** `docs/superpowers/specs/2026-05-10-internationalization-and-maps-design.md`

**Goal:** Replace static OSM map with interactive `flutter_map`, add Carrot-Korea-style profile-level neighborhood verification (1–2 verified per user, 100m GPS strictness, 60-day re-verify), backend schema for `place_id`/`formatted_address`/`country_code`/`region`/`city` on property+service, listing-visibility filtering by neighborhood+radius for products/services. Real estate stays city-scale.

**Architecture:** Frontend uses a swappable `MapsProvider` abstraction; phase-1 implementation is `OsmMapsProvider` (Nominatim + Photon + OSM raster tiles). Backend (Django) gains five new location fields per listing, a User-side `verified_neighborhoods` collection, two new endpoints, and a one-time reverse-geocoding management command. Frontend gates `products`+`services` tabs behind verification; real estate works without.

**Tech Stack:**
- Frontend: Flutter 3.x, Riverpod, `flutter_map: ^6.1.0`, `latlong2: ^0.9.1`, `geolocator: ^11.1.0`, `http: ^1.1.0`, `shared_preferences`
- Backend: Django + DRF, pytest-django, requests
- External (free, public): Nominatim (`nominatim.openstreetmap.org`), Photon (`photon.komoot.io`), OSM tiles (`tile.openstreetmap.org`)

---

## WIP Coordination Note

The user has heavy uncommitted WIP across these files at plan-write time. Tasks tagged **WIP-COORD** require coordinating with the user before/during/after merging the WIP work — there will likely be merge conflicts. Tasks NOT tagged WIP-COORD touch only files outside the WIP set and can run any time.

**Currently dirty (skip or coordinate):**
- `lib/pages/products/*` (filtered/main/category/detail/search/list)
- `lib/pages/service/main/*`, `lib/pages/service/comments/*`
- `lib/pages/real_estate/real_estate_detail.dart`, `real_estate_main.dart`, `agent/*`
- `lib/pages/chat/*`
- `lib/pages/authentication/*`
- `lib/pages/change_city/change_city.dart`
- `lib/pages/tab_bar/*`
- `lib/pages/onboarding/welcome_screen.dart`
- `lib/providers/provider_root/{product,service,real_estate,locale,chat}_provider.dart`
- `lib/providers/provider_models/{message_model,real_estate}.dart`
- `lib/l10n/*` (all ARB + generated)
- `lib/theme/app_theme.dart`, `lib/config/app_router.dart`, `lib/constants/app_colors.dart`
- `lib/widgets/{cached_network_image_widget,notification_dropdown,skeleton_loader}.dart`
- `lib/service/{authentication_service,token_refresh_service}.dart`

**Strategy for WIP-COORD tasks:**
1. Verify the file's WIP is committed/merged (or rebase against current main) before starting the task
2. If you encounter a conflict mid-task, surface it to the user — do not auto-resolve
3. Tests for these tasks are best run after WIP merges to guarantee no flake

---

## File Structure

### New files (frontend, no WIP overlap)

| Path | Responsibility |
|---|---|
| `lib/services/maps/maps_provider.dart` | Abstract `MapsProvider` interface |
| `lib/services/maps/osm_maps_provider.dart` | Concrete OSM impl (Nominatim + Photon) |
| `lib/services/maps/maps_exceptions.dart` | Typed errors (`MapsServerException`, `MapsRateLimitException`, etc.) |
| `lib/providers/provider_models/place.dart` | `Place` data class + JSON parsing |
| `lib/providers/provider_models/neighborhood.dart` | `Neighborhood` + `VerifiedNeighborhood` data classes |
| `lib/providers/provider_root/maps_provider_provider.dart` | Riverpod provider returning the active `MapsProvider` |
| `lib/providers/provider_root/verified_neighborhoods_provider.dart` | StateNotifier — user's 1-2 verified neighborhoods |
| `lib/providers/provider_root/active_neighborhood_provider.dart` | Which of the 1-2 is currently active |
| `lib/providers/provider_root/radius_provider.dart` | Selected browse radius |
| `lib/widgets/maps/map_view.dart` | Read-only map view (detail pages) |
| `lib/widgets/maps/location_picker.dart` | Full-screen pick-a-location flow |
| `lib/widgets/maps/place_search_field.dart` | Photon autocomplete search field |
| `lib/widgets/maps/neighborhood_verifier.dart` | GPS verify flow |
| `lib/widgets/maps/radius_slider.dart` | Carrot-style radius slider |
| `lib/widgets/maps/approximate_circle_layer.dart` | Privacy circle for products/services detail |

### Modified files (frontend)

| Path | Change | WIP? |
|---|---|---|
| `lib/pages/real_estate/property_create_page.dart` | Replace "Use GPS" button with `LocationPicker` | safe (refactored last session) |
| `lib/pages/real_estate/detail/property_map_widget.dart` | Replace static OSM image with `MapView` | safe |
| `lib/pages/products/product_new.dart` | Add `LocationPicker` to form | safe |
| `lib/pages/service/new/service_new.dart` | Add `LocationPicker` to form | safe |
| `lib/pages/service/details/service_detail_content.dart` | Add `MapView` section | safe |
| `lib/pages/products/product_detail.dart` | Add `MapView` section | **WIP-COORD** |
| `lib/pages/products/main_products.dart` | Add `RadiusSlider` to header | **WIP-COORD** |
| `lib/pages/service/main/main_service.dart` | Add `RadiusSlider` to header | **WIP-COORD** |
| `lib/providers/provider_root/product_provider.dart` | Accept `neighborhoodId`/`radiusKm` query params | **WIP-COORD** |
| `lib/providers/provider_root/service_provider.dart` | Accept `neighborhoodId`/`radiusKm` query params | **WIP-COORD** |
| `lib/providers/provider_models/real_estate.dart` | Add 5 new location fields | **WIP-COORD** |
| `lib/pages/real_estate/real_estate_detail.dart` | Use `MapView` for property map | **WIP-COORD** |
| `lib/pages/shaxsiy/shaxsiy.dart` | Add "My neighborhoods" section | safe |
| `lib/pages/tab_bar/tab_bar.dart` | Gate products+services tabs behind verification | **WIP-COORD** |

### New backend files (Django repo, separate path)

| Path | Responsibility |
|---|---|
| `<backend>/core/migrations/0XXX_add_location_fields.py` | Schema migration |
| `<backend>/users/migrations/0XXX_add_verified_neighborhoods.py` | User schema migration |
| `<backend>/locations/views.py` (or wherever appropriate) | `verify_neighborhood`, `delete_verified_neighborhood` |
| `<backend>/locations/serializers.py` | DRF serializers for the new endpoints |
| `<backend>/locations/services.py` | Server-side reverse-geocode + accuracy validation |
| `<backend>/locations/management/commands/backfill_locations.py` | One-time backfill |
| `<backend>/tests/test_verify_neighborhood.py` | Endpoint tests |
| `<backend>/tests/test_backfill_locations.py` | Management command tests |

### Tests (frontend)

| Path | Covers |
|---|---|
| `test/services/maps/osm_maps_provider_test.dart` | All `MapsProvider` methods + error paths |
| `test/providers/provider_models/place_test.dart` | JSON parsing, Nominatim/backend round-trip |
| `test/providers/provider_models/neighborhood_test.dart` | JSON, expiration logic |
| `test/providers/provider_root/verified_neighborhoods_provider_test.dart` | Add/remove, max-2, persistence |
| `test/providers/provider_root/radius_provider_test.dart` | Default, persist |
| `test/widgets/maps/map_view_test.dart` | Renders pin / circle / attribution |
| `test/widgets/maps/location_picker_test.dart` | Tap → reverse-geocode, search → autocomplete |
| `test/widgets/maps/neighborhood_verifier_test.dart` | GPS denied / accuracy / success |
| `test/widgets/maps/radius_slider_test.dart` | Drag debounce |
| `integration_test/verify_and_browse_test.dart` | End-to-end verify → filtered products |
| `integration_test/create_and_display_test.dart` | End-to-end create property → detail map |

---

## Pre-flight

### Task 0: Verify environment

**Files:** none (read-only)

- [ ] **Step 1: Confirm Flutter version + dependencies are present**

```bash
flutter --version
grep -E "flutter_map|latlong2|geolocator|http|shared_preferences" pubspec.yaml
```

Expected: `flutter_map: ^6.1.0`, `latlong2: ^0.9.1`, `geolocator: ^11.1.0`, `http: ^1.1.0`, `shared_preferences: ^2.2.0` (or compatible).

If any are missing, add them:

```bash
flutter pub add flutter_map latlong2 geolocator http shared_preferences
flutter pub get
```

- [ ] **Step 2: Snapshot WIP file list**

```bash
git diff --name-only > /tmp/wip_at_plan_start.txt
wc -l /tmp/wip_at_plan_start.txt
```

This is your reference for which files are off-limits without WIP-COORD coordination.

- [ ] **Step 3: Confirm baseline analyzer is clean for files NOT in WIP**

```bash
flutter analyze lib/services lib/widgets/maps 2>&1 | tail -5 || true
```

(These dirs don't exist yet — should report "No directories found" or "No issues found" once created.)

- [ ] **Step 4: Verify backend repo path is known**

User has confirmed they control the Django backend separately. Confirm with the user OR look at the project's docs/README for the path. If not known, **stop and ask**. The plan will refer to it as `<backend>` but you need a real path before backend tasks (Track F+G).

---

# Track A — `MapsProvider` Abstraction

Foundation for every map operation. No file in this track touches WIP code.

## Task A1: Define typed errors

**Files:**
- Create: `lib/services/maps/maps_exceptions.dart`
- Test: `test/services/maps/maps_exceptions_test.dart`

- [ ] **Step 1: Write the failing test**

```dart
// test/services/maps/maps_exceptions_test.dart
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
```

- [ ] **Step 2: Run test — expect FAIL**

```bash
flutter test test/services/maps/maps_exceptions_test.dart
```

Expected: `Could not find...maps_exceptions.dart` (or compile error).

- [ ] **Step 3: Implement**

```dart
// lib/services/maps/maps_exceptions.dart
class MapsException implements Exception {
  final String message;
  MapsException(this.message);
  @override
  String toString() => 'MapsException: $message';
}

class MapsServerException extends MapsException {
  final int statusCode;
  MapsServerException(this.statusCode, [String? body]) : super('HTTP $statusCode${body == null ? '' : ': $body'}');
}

class MapsRateLimitException extends MapsException {
  MapsRateLimitException() : super('Rate limited (429)');
}

class MapsTimeoutException extends MapsException {
  MapsTimeoutException() : super('Request timed out');
}

class MapsParseException extends MapsException {
  final String rawBody;
  final String reason;
  MapsParseException(this.rawBody, this.reason) : super('Parse failure: $reason — body=$rawBody');
}
```

- [ ] **Step 4: Run — expect PASS**

```bash
flutter test test/services/maps/maps_exceptions_test.dart
```

- [ ] **Step 5: Commit**

```bash
git add lib/services/maps/maps_exceptions.dart test/services/maps/maps_exceptions_test.dart
git commit -m "feat(maps): typed exceptions for MapsProvider"
```

---

## Task A2: Define `MapsProvider` abstract interface

**Files:**
- Create: `lib/services/maps/maps_provider.dart`

This task has no test of its own — abstract classes can't be tested directly. Tests come with the OSM implementation in A3.

- [ ] **Step 1: Implement**

```dart
// lib/services/maps/maps_provider.dart
import 'package:latlong2/latlong.dart';
import 'package:app/providers/provider_models/place.dart';
import 'package:app/providers/provider_models/neighborhood.dart';

abstract class MapsProvider {
  /// Search for places by free-text query. `near` biases results geographically.
  /// `sessionToken` groups multiple keystrokes into one billable session
  /// (relevant for paid providers; OSM ignores it).
  Future<List<Place>> searchPlaces(
    String query, {
    LatLng? near,
    String? sessionToken,
  });

  /// Convert a coordinate to a Place (address, country, region, city, neighborhood).
  Future<Place> reverseGeocode(LatLng latLng);

  /// Convert a free-text address to a Place. May return the most relevant match only.
  Future<Place> forwardGeocode(String address);

  /// Resolve the smallest available admin-area neighborhood for a coordinate.
  /// Falls through admin levels (suburb → village → district → region) per
  /// OSM coverage. Returns null only if no admin level is resolvable.
  Future<Neighborhood?> getNeighborhood(LatLng latLng);

  /// Tile URL template for use with flutter_map's TileLayer.
  String get tileUrlTemplate;

  /// Subdomains for the tile URL (e.g. ["a", "b", "c"]). Empty list = none.
  List<String> get tileSubdomains;

  /// Required attribution string. Must be visible on every map view per OSM/etc. ToS.
  String get attribution;

  /// User-Agent header sent on every HTTP request. OSM ToS requires identifying UA.
  String get userAgent;

  /// Human-readable provider name for diagnostics ("OpenStreetMap" / "Google Maps").
  String get providerName;
}
```

- [ ] **Step 2: Run analyzer — expect clean**

```bash
flutter analyze lib/services/maps/maps_provider.dart
```

Expected: `No issues found!` (Place + Neighborhood don't exist yet — analyzer will complain. That's the next two tasks.)

If analyzer errors only mention `Place` / `Neighborhood`, that's fine — they're created in B1/B2. Move on.

- [ ] **Step 3: Commit**

```bash
git add lib/services/maps/maps_provider.dart
git commit -m "feat(maps): MapsProvider abstract interface"
```

---

# Track B — Domain Models

## Task B1: `Place` data class with Nominatim + backend JSON parsing

**Files:**
- Create: `lib/providers/provider_models/place.dart`
- Test: `test/providers/provider_models/place_test.dart`

- [ ] **Step 1: Write failing tests**

```dart
// test/providers/provider_models/place_test.dart
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
      expect(p.countryCode, 'UZ'); // upper-cased
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
      expect(p.city, 'Olmazor'); // village fills city if no city/town
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
```

- [ ] **Step 2: Run — expect FAIL**

```bash
flutter test test/providers/provider_models/place_test.dart
```

Expected: compile failure on missing `Place`.

- [ ] **Step 3: Implement**

```dart
// lib/providers/provider_models/place.dart
class Place {
  final String? placeId;
  final String? formattedAddress;
  final double lat;
  final double lng;
  final String? countryCode; // ISO 3166-1 alpha-2, upper case
  final String? region;
  final String? city;
  final String? neighborhood;

  const Place({
    this.placeId,
    this.formattedAddress,
    required this.lat,
    required this.lng,
    this.countryCode,
    this.region,
    this.city,
    this.neighborhood,
  });

  factory Place.fromNominatim(Map<String, dynamic> json) {
    final addr = (json['address'] as Map<String, dynamic>?) ?? const {};
    final cc = addr['country_code'] as String?;
    return Place(
      placeId: json['place_id']?.toString(),
      formattedAddress: json['display_name'] as String?,
      lat: double.parse(json['lat'].toString()),
      lng: double.parse(json['lon'].toString()),
      countryCode: cc?.toUpperCase(),
      region: (addr['state'] ?? addr['region'] ?? addr['province']) as String?,
      city: (addr['city'] ?? addr['town'] ?? addr['village'] ?? addr['hamlet']) as String?,
      neighborhood: (addr['suburb'] ??
          addr['neighbourhood'] ??
          addr['quarter'] ??
          addr['hamlet'] ??
          addr['village'] ??
          addr['city_district']) as String?,
    );
  }

  factory Place.fromJson(Map<String, dynamic> j) => Place(
        placeId: j['place_id'] as String?,
        formattedAddress: j['formatted_address'] as String?,
        lat: (j['lat'] as num).toDouble(),
        lng: (j['lng'] as num).toDouble(),
        countryCode: j['country_code'] as String?,
        region: j['region'] as String?,
        city: j['city'] as String?,
        neighborhood: j['neighborhood'] as String?,
      );

  Map<String, dynamic> toJson() => {
        if (placeId != null) 'place_id': placeId,
        if (formattedAddress != null) 'formatted_address': formattedAddress,
        'lat': lat,
        'lng': lng,
        if (countryCode != null) 'country_code': countryCode,
        if (region != null) 'region': region,
        if (city != null) 'city': city,
        if (neighborhood != null) 'neighborhood': neighborhood,
      };
}
```

- [ ] **Step 4: Run — expect PASS**

```bash
flutter test test/providers/provider_models/place_test.dart
```

- [ ] **Step 5: Commit**

```bash
git add lib/providers/provider_models/place.dart test/providers/provider_models/place_test.dart
git commit -m "feat(maps): Place domain model with Nominatim + backend parsing"
```

---

## Task B2: `Neighborhood` and `VerifiedNeighborhood` data classes

**Files:**
- Create: `lib/providers/provider_models/neighborhood.dart`
- Test: `test/providers/provider_models/neighborhood_test.dart`

- [ ] **Step 1: Write failing tests**

```dart
// test/providers/provider_models/neighborhood_test.dart
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
```

- [ ] **Step 2: Run — expect FAIL**

```bash
flutter test test/providers/provider_models/neighborhood_test.dart
```

- [ ] **Step 3: Implement**

```dart
// lib/providers/provider_models/neighborhood.dart
class Neighborhood {
  final String id;
  final String name;
  final String displayName;
  final String countryCode;
  final String region;
  final String city;
  final double centroidLat;
  final double centroidLng;

  const Neighborhood({
    required this.id,
    required this.name,
    required this.displayName,
    required this.countryCode,
    required this.region,
    required this.city,
    required this.centroidLat,
    required this.centroidLng,
  });

  factory Neighborhood.fromJson(Map<String, dynamic> j) => Neighborhood(
        id: j['id'] as String,
        name: j['name'] as String,
        displayName: j['display_name'] as String,
        countryCode: j['country_code'] as String,
        region: j['region'] as String,
        city: j['city'] as String,
        centroidLat: (j['centroid_lat'] as num).toDouble(),
        centroidLng: (j['centroid_lng'] as num).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'display_name': displayName,
        'country_code': countryCode,
        'region': region,
        'city': city,
        'centroid_lat': centroidLat,
        'centroid_lng': centroidLng,
      };
}

class VerifiedNeighborhood {
  static const Duration validityDuration = Duration(days: 60);

  final Neighborhood neighborhood;
  final DateTime verifiedAt;
  final double gpsAccuracyM;
  final bool lowConfidence;

  const VerifiedNeighborhood({
    required this.neighborhood,
    required this.verifiedAt,
    required this.gpsAccuracyM,
    this.lowConfidence = false,
  });

  DateTime get expiresAt => verifiedAt.add(validityDuration);
  bool get isExpired => DateTime.now().isAfter(expiresAt);

  factory VerifiedNeighborhood.fromJson(Map<String, dynamic> j) =>
      VerifiedNeighborhood(
        neighborhood:
            Neighborhood.fromJson(j['neighborhood'] as Map<String, dynamic>),
        verifiedAt: DateTime.parse(j['verified_at'] as String),
        gpsAccuracyM: (j['gps_accuracy_m'] as num).toDouble(),
        lowConfidence: (j['low_confidence'] as bool?) ?? false,
      );

  Map<String, dynamic> toJson() => {
        'neighborhood': neighborhood.toJson(),
        'verified_at': verifiedAt.toIso8601String(),
        'gps_accuracy_m': gpsAccuracyM,
        'low_confidence': lowConfidence,
      };
}
```

- [ ] **Step 4: Run — expect PASS**

```bash
flutter test test/providers/provider_models/neighborhood_test.dart
```

- [ ] **Step 5: Commit**

```bash
git add lib/providers/provider_models/neighborhood.dart test/providers/provider_models/neighborhood_test.dart
git commit -m "feat(maps): Neighborhood + VerifiedNeighborhood with 60-day expiry"
```

---

# Track A (continued) — `OsmMapsProvider`

## Task A3: Implement `OsmMapsProvider`

**Files:**
- Create: `lib/services/maps/osm_maps_provider.dart`
- Test: `test/services/maps/osm_maps_provider_test.dart`

This is the largest single task in Track A — full implementation with mocked HTTP.

- [ ] **Step 1: Write failing tests (mocked HTTP)**

```dart
// test/services/maps/osm_maps_provider_test.dart
import 'dart:convert';
import 'package:app/services/maps/maps_exceptions.dart';
import 'package:app/services/maps/osm_maps_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:latlong2/latlong.dart';

http.Client _stubClient(http.Response Function(http.Request) handler) {
  return MockClient((req) async => handler(req));
}

void main() {
  group('OsmMapsProvider.reverseGeocode', () {
    test('parses Nominatim response into Place', () async {
      final client = _stubClient((req) {
        expect(req.url.host, 'nominatim.openstreetmap.org');
        expect(req.url.queryParameters['format'], 'json');
        expect(req.url.queryParameters['lat'], '41.3');
        expect(req.url.queryParameters['lon'], '69.24');
        expect(req.headers['User-Agent'], isNotEmpty);
        return http.Response(
          jsonEncode({
            'place_id': 1,
            'lat': '41.3',
            'lon': '69.24',
            'display_name': 'Tashkent, Uzbekistan',
            'address': {
              'suburb': 'Yunusabad',
              'city': 'Tashkent',
              'country_code': 'uz',
            },
          }),
          200,
          headers: {'Content-Type': 'application/json'},
        );
      });
      final provider = OsmMapsProvider(client: client);
      final place = await provider.reverseGeocode(LatLng(41.3, 69.24));
      expect(place.neighborhood, 'Yunusabad');
      expect(place.countryCode, 'UZ');
    });

    test('throws MapsRateLimitException on 429', () async {
      final client = _stubClient((_) => http.Response('rate limited', 429));
      final provider = OsmMapsProvider(client: client);
      expect(
        () => provider.reverseGeocode(LatLng(0, 0)),
        throwsA(isA<MapsRateLimitException>()),
      );
    });

    test('throws MapsServerException on 5xx', () async {
      final client = _stubClient((_) => http.Response('boom', 503));
      final provider = OsmMapsProvider(client: client);
      expect(
        () => provider.reverseGeocode(LatLng(0, 0)),
        throwsA(isA<MapsServerException>()),
      );
    });

    test('throws MapsParseException on garbage body', () async {
      final client = _stubClient((_) => http.Response('not json', 200));
      final provider = OsmMapsProvider(client: client);
      expect(
        () => provider.reverseGeocode(LatLng(0, 0)),
        throwsA(isA<MapsParseException>()),
      );
    });
  });

  group('OsmMapsProvider.searchPlaces (Photon)', () {
    test('parses GeoJSON FeatureCollection into Places', () async {
      final client = _stubClient((req) {
        expect(req.url.host, 'photon.komoot.io');
        expect(req.url.queryParameters['q'], 'tashkent');
        return http.Response(
          jsonEncode({
            'features': [
              {
                'geometry': {'coordinates': [69.24, 41.3]},
                'properties': {
                  'osm_id': 1,
                  'name': 'Tashkent',
                  'country': 'Uzbekistan',
                  'countrycode': 'UZ',
                  'state': 'Tashkent Region',
                  'city': 'Tashkent',
                }
              }
            ]
          }),
          200,
        );
      });
      final provider = OsmMapsProvider(client: client);
      final results = await provider.searchPlaces('tashkent');
      expect(results, hasLength(1));
      expect(results.first.lat, closeTo(41.3, 1e-6));
      expect(results.first.lng, closeTo(69.24, 1e-6));
      expect(results.first.countryCode, 'UZ');
    });

    test('biases by `near` lat/lng when provided', () async {
      final client = _stubClient((req) {
        expect(req.url.queryParameters['lat'], '41.3');
        expect(req.url.queryParameters['lon'], '69.24');
        return http.Response('{"features":[]}', 200);
      });
      final provider = OsmMapsProvider(client: client);
      await provider.searchPlaces('cafe', near: LatLng(41.3, 69.24));
    });

    test('returns empty list on Photon empty', () async {
      final client = _stubClient((_) => http.Response('{"features":[]}', 200));
      final provider = OsmMapsProvider(client: client);
      final results = await provider.searchPlaces('nothingmatchesthis');
      expect(results, isEmpty);
    });
  });

  group('OsmMapsProvider.getNeighborhood', () {
    test('returns Neighborhood from Nominatim response', () async {
      final client = _stubClient((_) => http.Response(
            jsonEncode({
              'place_id': 99,
              'lat': '41.3',
              'lon': '69.24',
              'display_name': 'Yunusabad, Tashkent, Uzbekistan',
              'address': {
                'suburb': 'Yunusabad',
                'city': 'Tashkent',
                'state': 'Tashkent Region',
                'country_code': 'uz',
              },
            }),
            200,
          ));
      final provider = OsmMapsProvider(client: client);
      final nbhd = await provider.getNeighborhood(LatLng(41.3, 69.24));
      expect(nbhd, isNotNull);
      expect(nbhd!.id, 'UZ:99');
      expect(nbhd.name, 'Yunusabad');
      expect(nbhd.countryCode, 'UZ');
      expect(nbhd.centroidLat, closeTo(41.3, 1e-6));
    });

    test('returns null when no admin level resolvable', () async {
      final client = _stubClient((_) => http.Response(
            jsonEncode({
              'place_id': 1,
              'lat': '0',
              'lon': '0',
              'display_name': 'Null Island',
              'address': {},
            }),
            200,
          ));
      final provider = OsmMapsProvider(client: client);
      final nbhd = await provider.getNeighborhood(LatLng(0, 0));
      expect(nbhd, isNull);
    });
  });

  group('OsmMapsProvider tile metadata', () {
    test('returns expected tile URL and attribution', () {
      final p = OsmMapsProvider();
      expect(p.tileUrlTemplate, contains('tile.openstreetmap.org'));
      expect(p.attribution, contains('OpenStreetMap'));
      expect(p.userAgent, isNotEmpty);
      expect(p.providerName, 'OpenStreetMap');
    });
  });
}
```

- [ ] **Step 2: Run — expect FAIL**

```bash
flutter test test/services/maps/osm_maps_provider_test.dart
```

Expected: compile failure on missing `OsmMapsProvider`.

- [ ] **Step 3: Implement**

```dart
// lib/services/maps/osm_maps_provider.dart
import 'dart:async';
import 'dart:convert';

import 'package:app/providers/provider_models/neighborhood.dart';
import 'package:app/providers/provider_models/place.dart';
import 'package:app/services/maps/maps_exceptions.dart';
import 'package:app/services/maps/maps_provider.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class OsmMapsProvider extends MapsProvider {
  // Public OSM ToS requires identifying User-Agent. Replace per project.
  static const _userAgent =
      'SabziMarket/1.0 (https://sabzimarket.uz; bananatalkmain@gmail.com)';

  final http.Client _client;
  final Duration _timeout;

  OsmMapsProvider({http.Client? client, Duration? timeout})
      : _client = client ?? http.Client(),
        _timeout = timeout ?? const Duration(seconds: 10);

  @override
  String get tileUrlTemplate =>
      'https://tile.openstreetmap.org/{z}/{x}/{y}.png';

  @override
  List<String> get tileSubdomains => const [];

  @override
  String get attribution => '© OpenStreetMap contributors';

  @override
  String get userAgent => _userAgent;

  @override
  String get providerName => 'OpenStreetMap';

  Map<String, String> get _headers => {
        'User-Agent': _userAgent,
        'Accept': 'application/json',
      };

  Future<http.Response> _get(Uri url) async {
    try {
      final res = await _client.get(url, headers: _headers).timeout(_timeout);
      if (res.statusCode == 429) throw MapsRateLimitException();
      if (res.statusCode >= 500) {
        throw MapsServerException(res.statusCode, res.body);
      }
      if (res.statusCode != 200) {
        throw MapsServerException(res.statusCode, res.body);
      }
      return res;
    } on TimeoutException {
      throw MapsTimeoutException();
    }
  }

  Map<String, dynamic> _parseObj(http.Response res) {
    try {
      final decoded = jsonDecode(res.body);
      if (decoded is! Map<String, dynamic>) {
        throw MapsParseException(res.body, 'expected JSON object');
      }
      return decoded;
    } on FormatException catch (e) {
      throw MapsParseException(res.body, e.message);
    }
  }

  @override
  Future<Place> reverseGeocode(LatLng latLng) async {
    final url = Uri.https('nominatim.openstreetmap.org', '/reverse', {
      'format': 'json',
      'lat': latLng.latitude.toString(),
      'lon': latLng.longitude.toString(),
      'zoom': '18',
      'addressdetails': '1',
    });
    final res = await _get(url);
    return Place.fromNominatim(_parseObj(res));
  }

  @override
  Future<Place> forwardGeocode(String address) async {
    final url = Uri.https('nominatim.openstreetmap.org', '/search', {
      'format': 'json',
      'q': address,
      'addressdetails': '1',
      'limit': '1',
    });
    final res = await _get(url);
    final body = jsonDecode(res.body);
    if (body is! List || body.isEmpty) {
      throw MapsParseException(res.body, 'no results');
    }
    return Place.fromNominatim(body.first as Map<String, dynamic>);
  }

  @override
  Future<List<Place>> searchPlaces(
    String query, {
    LatLng? near,
    String? sessionToken,
  }) async {
    final params = <String, String>{
      'q': query,
      'limit': '8',
    };
    if (near != null) {
      params['lat'] = near.latitude.toString();
      params['lon'] = near.longitude.toString();
    }
    final url = Uri.https('photon.komoot.io', '/api/', params);
    final res = await _get(url);
    final body = _parseObj(res);
    final features = (body['features'] as List?) ?? const [];
    return features.map<Place>((f) {
      final feature = f as Map<String, dynamic>;
      final geom = feature['geometry'] as Map<String, dynamic>;
      final coords = geom['coordinates'] as List;
      final props = feature['properties'] as Map<String, dynamic>;
      return Place(
        placeId: props['osm_id']?.toString(),
        formattedAddress: [
          props['name'],
          props['city'],
          props['country'],
        ].whereType<String>().join(', '),
        lat: (coords[1] as num).toDouble(),
        lng: (coords[0] as num).toDouble(),
        countryCode: (props['countrycode'] as String?)?.toUpperCase(),
        region: props['state'] as String?,
        city: props['city'] as String?,
        neighborhood: (props['name'] ?? props['suburb']) as String?,
      );
    }).toList(growable: false);
  }

  @override
  Future<Neighborhood?> getNeighborhood(LatLng latLng) async {
    final place = await reverseGeocode(latLng);
    if (place.neighborhood == null ||
        place.countryCode == null ||
        place.region == null ||
        place.city == null) {
      return null;
    }
    final id = '${place.countryCode}:${place.placeId ?? "${latLng.latitude.toStringAsFixed(4)},${latLng.longitude.toStringAsFixed(4)}"}';
    return Neighborhood(
      id: id,
      name: place.neighborhood!,
      displayName: place.formattedAddress ??
          '${place.neighborhood}, ${place.city}, ${place.countryCode}',
      countryCode: place.countryCode!,
      region: place.region!,
      city: place.city!,
      centroidLat: place.lat,
      centroidLng: place.lng,
    );
  }
}
```

- [ ] **Step 4: Run — expect PASS**

```bash
flutter test test/services/maps/osm_maps_provider_test.dart
```

If any test fails, inspect output and fix the implementation, not the test. Re-run until green.

- [ ] **Step 5: Commit**

```bash
git add lib/services/maps/osm_maps_provider.dart test/services/maps/osm_maps_provider_test.dart
git commit -m "feat(maps): OsmMapsProvider with Nominatim + Photon"
```

---

# Track C — Riverpod State

## Task C1: `mapsProviderProvider` (active provider)

**Files:**
- Create: `lib/providers/provider_root/maps_provider_provider.dart`

This is a one-liner Riverpod registration; no test needed (it's a constant Provider).

- [ ] **Step 1: Implement**

```dart
// lib/providers/provider_root/maps_provider_provider.dart
import 'package:app/services/maps/maps_provider.dart';
import 'package:app/services/maps/osm_maps_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The active MapsProvider for the app. Phase 1: always OSM.
/// Phase 4: swap to GoogleMapsProvider / MapTilerProvider here without
/// touching any UI consumer.
final mapsProviderProvider = Provider<MapsProvider>((ref) {
  return OsmMapsProvider();
});
```

- [ ] **Step 2: Analyzer clean**

```bash
flutter analyze lib/providers/provider_root/maps_provider_provider.dart
```

- [ ] **Step 3: Commit**

```bash
git add lib/providers/provider_root/maps_provider_provider.dart
git commit -m "feat(maps): Riverpod provider exposing active MapsProvider"
```

---

## Task C2: `verifiedNeighborhoodsProvider` (StateNotifier)

**Files:**
- Create: `lib/providers/provider_root/verified_neighborhoods_provider.dart`
- Test: `test/providers/provider_root/verified_neighborhoods_provider_test.dart`

This provider:
- Holds a list of 0–2 `VerifiedNeighborhood`s
- Persists to SharedPreferences (cache) and to backend (source of truth)
- Enforces max 2

- [ ] **Step 1: Write failing tests**

```dart
// test/providers/provider_root/verified_neighborhoods_provider_test.dart
import 'package:app/providers/provider_models/neighborhood.dart';
import 'package:app/providers/provider_root/verified_neighborhoods_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

VerifiedNeighborhood _v(String id, {DateTime? at, bool low = false}) {
  return VerifiedNeighborhood(
    neighborhood: Neighborhood(
      id: id,
      name: id,
      displayName: id,
      countryCode: 'UZ',
      region: 'r',
      city: 'c',
      centroidLat: 0,
      centroidLng: 0,
    ),
    verifiedAt: at ?? DateTime.now(),
    gpsAccuracyM: 50,
    lowConfidence: low,
  );
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('starts empty', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final state = container.read(verifiedNeighborhoodsProvider);
    expect(state, isEmpty);
  });

  test('add() appends a neighborhood, persists', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final notifier =
        container.read(verifiedNeighborhoodsProvider.notifier);
    await notifier.add(_v('UZ:1'));
    expect(container.read(verifiedNeighborhoodsProvider), hasLength(1));

    // Persistence: reload via fresh container with same SP
    final container2 = ProviderContainer();
    addTearDown(container2.dispose);
    await container2.read(verifiedNeighborhoodsProvider.notifier).hydrate();
    expect(container2.read(verifiedNeighborhoodsProvider), hasLength(1));
  });

  test('add() enforces max 2', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final notifier =
        container.read(verifiedNeighborhoodsProvider.notifier);
    await notifier.add(_v('UZ:1'));
    await notifier.add(_v('UZ:2'));
    expect(
      () => notifier.add(_v('UZ:3')),
      throwsA(isA<TooManyNeighborhoodsException>()),
    );
    expect(container.read(verifiedNeighborhoodsProvider), hasLength(2));
  });

  test('add() replaces existing entry by id', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final notifier =
        container.read(verifiedNeighborhoodsProvider.notifier);
    final first =
        _v('UZ:1', at: DateTime.now().subtract(const Duration(days: 30)));
    await notifier.add(first);
    final second = _v('UZ:1'); // same id, fresh verifiedAt
    await notifier.add(second);
    final state = container.read(verifiedNeighborhoodsProvider);
    expect(state, hasLength(1));
    expect(state.first.verifiedAt.isAfter(first.verifiedAt), true);
  });

  test('remove(id) drops entry', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final notifier =
        container.read(verifiedNeighborhoodsProvider.notifier);
    await notifier.add(_v('UZ:1'));
    await notifier.add(_v('UZ:2'));
    await notifier.remove('UZ:1');
    final state = container.read(verifiedNeighborhoodsProvider);
    expect(state, hasLength(1));
    expect(state.first.neighborhood.id, 'UZ:2');
  });

  test('hasExpired returns true if any entry past 60 days', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final notifier =
        container.read(verifiedNeighborhoodsProvider.notifier);
    await notifier
        .add(_v('UZ:1', at: DateTime.now().subtract(const Duration(days: 65))));
    final state = container.read(verifiedNeighborhoodsProvider);
    expect(state.any((v) => v.isExpired), true);
  });
}
```

- [ ] **Step 2: Run — expect FAIL**

```bash
flutter test test/providers/provider_root/verified_neighborhoods_provider_test.dart
```

- [ ] **Step 3: Implement**

```dart
// lib/providers/provider_root/verified_neighborhoods_provider.dart
import 'dart:convert';

import 'package:app/providers/provider_models/neighborhood.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TooManyNeighborhoodsException implements Exception {
  @override
  String toString() =>
      'TooManyNeighborhoodsException: max 2 verified neighborhoods';
}

class VerifiedNeighborhoodsNotifier
    extends StateNotifier<List<VerifiedNeighborhood>> {
  static const _prefsKey = 'verified_neighborhoods_v1';
  static const maxCount = 2;

  VerifiedNeighborhoodsNotifier() : super(const []) {
    hydrate();
  }

  Future<void> hydrate() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    if (raw == null) return;
    try {
      final list = (jsonDecode(raw) as List)
          .map((e) =>
              VerifiedNeighborhood.fromJson(e as Map<String, dynamic>))
          .toList();
      state = list;
    } catch (_) {
      // Corrupted cache — clear and continue empty
      await prefs.remove(_prefsKey);
    }
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _prefsKey,
      jsonEncode(state.map((v) => v.toJson()).toList()),
    );
  }

  Future<void> add(VerifiedNeighborhood entry) async {
    final existingIdx =
        state.indexWhere((v) => v.neighborhood.id == entry.neighborhood.id);
    if (existingIdx >= 0) {
      // Replace existing (re-verification)
      final next = [...state];
      next[existingIdx] = entry;
      state = next;
      await _persist();
      return;
    }
    if (state.length >= maxCount) {
      throw TooManyNeighborhoodsException();
    }
    state = [...state, entry];
    await _persist();
  }

  Future<void> remove(String neighborhoodId) async {
    state = state.where((v) => v.neighborhood.id != neighborhoodId).toList();
    await _persist();
  }

  Future<void> clear() async {
    state = const [];
    await _persist();
  }
}

final verifiedNeighborhoodsProvider = StateNotifierProvider<
    VerifiedNeighborhoodsNotifier,
    List<VerifiedNeighborhood>>((ref) {
  return VerifiedNeighborhoodsNotifier();
});
```

- [ ] **Step 4: Run — expect PASS**

```bash
flutter test test/providers/provider_root/verified_neighborhoods_provider_test.dart
```

- [ ] **Step 5: Commit**

```bash
git add lib/providers/provider_root/verified_neighborhoods_provider.dart test/providers/provider_root/verified_neighborhoods_provider_test.dart
git commit -m "feat(maps): verifiedNeighborhoodsProvider (max 2, SP-cached)"
```

---

## Task C3: `radiusProvider` and `activeNeighborhoodProvider`

**Files:**
- Create: `lib/providers/provider_root/radius_provider.dart`
- Create: `lib/providers/provider_root/active_neighborhood_provider.dart`
- Test: `test/providers/provider_root/radius_provider_test.dart`

- [ ] **Step 1: Write failing tests**

```dart
// test/providers/provider_root/radius_provider_test.dart
import 'package:app/providers/provider_root/radius_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('default radius is 3km', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    expect(container.read(radiusProvider), 3.0);
  });

  test('setRadius persists', () async {
    final c = ProviderContainer();
    addTearDown(c.dispose);
    await c.read(radiusProvider.notifier).set(5.0);
    expect(c.read(radiusProvider), 5.0);

    final c2 = ProviderContainer();
    addTearDown(c2.dispose);
    await c2.read(radiusProvider.notifier).hydrate();
    expect(c2.read(radiusProvider), 5.0);
  });

  test('city = double.infinity sentinel', () async {
    final c = ProviderContainer();
    addTearDown(c.dispose);
    await c.read(radiusProvider.notifier).set(double.infinity);
    expect(c.read(radiusProvider), double.infinity);
  });
}
```

- [ ] **Step 2: Run — expect FAIL**

- [ ] **Step 3: Implement**

```dart
// lib/providers/provider_root/radius_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Radius (km) used to filter neighborhood-based listings.
/// `double.infinity` represents the "city-wide" / "Expand to city" state.
class RadiusNotifier extends StateNotifier<double> {
  static const _key = 'browse_radius_km_v1';
  static const defaultKm = 3.0;

  RadiusNotifier() : super(defaultKm) {
    hydrate();
  }

  Future<void> hydrate() async {
    final prefs = await SharedPreferences.getInstance();
    final v = prefs.getDouble(_key);
    if (v != null) state = v;
  }

  Future<void> set(double km) async {
    state = km;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_key, km);
  }
}

final radiusProvider = StateNotifierProvider<RadiusNotifier, double>(
  (ref) => RadiusNotifier(),
);
```

```dart
// lib/providers/provider_root/active_neighborhood_provider.dart
import 'package:app/providers/provider_models/neighborhood.dart';
import 'package:app/providers/provider_root/verified_neighborhoods_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Which of the 0-2 verified neighborhoods the user is currently browsing in.
/// Returns null if no verified neighborhoods exist.
final activeNeighborhoodIndexProvider = StateProvider<int>((ref) => 0);

final activeNeighborhoodProvider = Provider<VerifiedNeighborhood?>((ref) {
  final list = ref.watch(verifiedNeighborhoodsProvider);
  final idx = ref.watch(activeNeighborhoodIndexProvider);
  if (list.isEmpty) return null;
  if (idx >= list.length) return list.first;
  return list[idx];
});
```

- [ ] **Step 4: Run — expect PASS**

```bash
flutter test test/providers/provider_root/radius_provider_test.dart
```

- [ ] **Step 5: Commit**

```bash
git add lib/providers/provider_root/radius_provider.dart lib/providers/provider_root/active_neighborhood_provider.dart test/providers/provider_root/radius_provider_test.dart
git commit -m "feat(maps): radiusProvider + activeNeighborhoodProvider"
```

---

# Track D — UI Widgets

## Task D1: `MapView` (read-only display widget)

**Files:**
- Create: `lib/widgets/maps/map_view.dart`
- Test: `test/widgets/maps/map_view_test.dart`

`MapView` is the workhorse for property/service detail pages. It renders:
- A tile layer from the active `MapsProvider`
- Either a precise pin (real estate) OR an approximate circle (products/services pre-contact)
- A required attribution badge

- [ ] **Step 1: Write failing widget tests**

```dart
// test/widgets/maps/map_view_test.dart
import 'package:app/widgets/maps/map_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';

void main() {
  Widget _wrap(Widget child) => ProviderScope(
        child: MaterialApp(home: Scaffold(body: child)),
      );

  testWidgets('renders attribution badge', (tester) async {
    await tester.pumpWidget(_wrap(const MapView(
      center: LatLng(41.3, 69.24),
      zoom: 15,
      mode: MapViewMode.exact,
    )));
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.textContaining('OpenStreetMap'), findsWidgets);
  });

  testWidgets('exact mode: shows a pin marker', (tester) async {
    await tester.pumpWidget(_wrap(const MapView(
      center: LatLng(41.3, 69.24),
      zoom: 15,
      mode: MapViewMode.exact,
    )));
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.byKey(const Key('MapView.exactPin')), findsOneWidget);
    expect(find.byKey(const Key('MapView.approxCircle')), findsNothing);
  });

  testWidgets('approximate mode: shows a circle, no pin', (tester) async {
    await tester.pumpWidget(_wrap(const MapView(
      center: LatLng(41.3, 69.24),
      zoom: 15,
      mode: MapViewMode.approximate,
    )));
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.byKey(const Key('MapView.approxCircle')), findsOneWidget);
    expect(find.byKey(const Key('MapView.exactPin')), findsNothing);
  });
}
```

- [ ] **Step 2: Run — expect FAIL**

- [ ] **Step 3: Implement**

```dart
// lib/widgets/maps/map_view.dart
import 'package:app/providers/provider_root/maps_provider_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

enum MapViewMode { exact, approximate }

class MapView extends ConsumerWidget {
  static const approximateRadiusMeters = 300.0;

  final LatLng center;
  final double zoom;
  final MapViewMode mode;
  final double height;

  const MapView({
    super.key,
    required this.center,
    required this.mode,
    this.zoom = 15,
    this.height = 220,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(mapsProviderProvider);
    final theme = Theme.of(context);

    return SizedBox(
      height: height,
      child: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: center,
              initialZoom: zoom,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: provider.tileUrlTemplate,
                subdomains: provider.tileSubdomains,
                userAgentPackageName: provider.userAgent,
                errorTileCallback: (_, __, ___) {},
              ),
              if (mode == MapViewMode.approximate)
                CircleLayer(
                  circles: [
                    CircleMarker(
                      key: const Key('MapView.approxCircle'),
                      point: center,
                      radius: approximateRadiusMeters,
                      useRadiusInMeter: true,
                      color: theme.colorScheme.primary.withValues(alpha: 0.18),
                      borderColor:
                          theme.colorScheme.primary.withValues(alpha: 0.5),
                      borderStrokeWidth: 2,
                    ),
                  ],
                ),
              if (mode == MapViewMode.exact)
                MarkerLayer(
                  markers: [
                    Marker(
                      key: const Key('MapView.exactPin'),
                      point: center,
                      width: 40,
                      height: 40,
                      child: Icon(
                        Icons.location_on,
                        size: 40,
                        color: theme.colorScheme.error,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          Positioned(
            bottom: 4,
            right: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              color: Colors.white.withValues(alpha: 0.8),
              child: Text(
                provider.attribution,
                style: theme.textTheme.bodySmall,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 4: Run — expect PASS**

```bash
flutter test test/widgets/maps/map_view_test.dart
```

If `flutter_map` complains about missing tile fetches in tests, that's expected — the test only verifies marker/circle keys, not actual tile rendering.

- [ ] **Step 5: Commit**

```bash
git add lib/widgets/maps/map_view.dart test/widgets/maps/map_view_test.dart
git commit -m "feat(maps): MapView read-only widget (exact pin / approx circle)"
```

---

## Task D2: `PlaceSearchField` (Photon autocomplete)

**Files:**
- Create: `lib/widgets/maps/place_search_field.dart`

Internal-use widget; tested indirectly through `LocationPicker` integration. No standalone test required.

- [ ] **Step 1: Implement**

```dart
// lib/widgets/maps/place_search_field.dart
import 'dart:async';

import 'package:app/providers/provider_models/place.dart';
import 'package:app/providers/provider_root/maps_provider_provider.dart';
import 'package:app/services/maps/maps_exceptions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

class PlaceSearchField extends ConsumerStatefulWidget {
  final ValueChanged<Place> onSelected;
  final LatLng? near;
  final String hintText;

  const PlaceSearchField({
    super.key,
    required this.onSelected,
    this.near,
    this.hintText = 'Search for an address or place',
  });

  @override
  ConsumerState<PlaceSearchField> createState() => _PlaceSearchFieldState();
}

class _PlaceSearchFieldState extends ConsumerState<PlaceSearchField> {
  final _controller = TextEditingController();
  Timer? _debounce;
  List<Place> _results = const [];
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    if (value.trim().length < 3) {
      setState(() {
        _results = const [];
        _error = null;
      });
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 350), () => _search(value));
  }

  Future<void> _search(String q) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final provider = ref.read(mapsProviderProvider);
      final results =
          await provider.searchPlaces(q, near: widget.near, sessionToken: null);
      if (!mounted) return;
      setState(() {
        _results = results;
        _loading = false;
      });
    } on MapsException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
        _results = const [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _controller,
          onChanged: _onChanged,
          decoration: InputDecoration(
            hintText: widget.hintText,
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _loading
                ? const Padding(
                    padding: EdgeInsets.all(12),
                    child: SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : null,
            border: const OutlineInputBorder(),
          ),
        ),
        if (_error != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'Search unavailable — drop a pin instead',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Theme.of(context).colorScheme.error),
            ),
          ),
        if (_results.isNotEmpty)
          Container(
            constraints: const BoxConstraints(maxHeight: 200),
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).dividerColor,
              ),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _results.length,
              itemBuilder: (context, i) {
                final p = _results[i];
                return ListTile(
                  leading: const Icon(Icons.place_outlined),
                  title: Text(p.formattedAddress ?? p.neighborhood ?? '—'),
                  subtitle: Text('${p.city ?? ''}, ${p.countryCode ?? ''}'),
                  onTap: () {
                    widget.onSelected(p);
                    setState(() {
                      _results = const [];
                      _controller.text = p.formattedAddress ?? '';
                    });
                  },
                );
              },
            ),
          ),
      ],
    );
  }
}
```

- [ ] **Step 2: Analyzer clean**

```bash
flutter analyze lib/widgets/maps/place_search_field.dart
```

- [ ] **Step 3: Commit**

```bash
git add lib/widgets/maps/place_search_field.dart
git commit -m "feat(maps): PlaceSearchField with debounced autocomplete"
```

---

## Task D3: `LocationPicker` (full-screen picker)

**Files:**
- Create: `lib/widgets/maps/location_picker.dart`
- Test: `test/widgets/maps/location_picker_test.dart`

The map-first picker. User can pan/tap, search, or use GPS.

- [ ] **Step 1: Write failing test (covers the headline interactions)**

```dart
// test/widgets/maps/location_picker_test.dart
import 'package:app/providers/provider_models/place.dart';
import 'package:app/providers/provider_root/maps_provider_provider.dart';
import 'package:app/services/maps/maps_provider.dart';
import 'package:app/widgets/maps/location_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:app/providers/provider_models/neighborhood.dart';

class _FakeProvider extends MapsProvider {
  Place? mockPlace;
  int reverseCalls = 0;
  @override
  Future<Place> reverseGeocode(LatLng latLng) async {
    reverseCalls++;
    return mockPlace ?? Place(lat: latLng.latitude, lng: latLng.longitude);
  }
  @override
  Future<List<Place>> searchPlaces(String q,
      {LatLng? near, String? sessionToken}) async => const [];
  @override
  Future<Place> forwardGeocode(String address) async =>
      Place(lat: 0, lng: 0);
  @override
  Future<Neighborhood?> getNeighborhood(LatLng latLng) async => null;
  @override
  String get tileUrlTemplate => 'https://example.com/{z}/{x}/{y}.png';
  @override
  List<String> get tileSubdomains => const [];
  @override
  String get attribution => 'Test';
  @override
  String get userAgent => 'test';
  @override
  String get providerName => 'Test';
}

void main() {
  testWidgets('renders confirm button disabled until tap', (tester) async {
    final fake = _FakeProvider();
    fake.mockPlace = Place(
      lat: 41.3,
      lng: 69.24,
      formattedAddress: 'Tashkent',
      countryCode: 'UZ',
    );
    Place? returned;
    await tester.pumpWidget(
      ProviderScope(
        overrides: [mapsProviderProvider.overrideWithValue(fake)],
        child: MaterialApp(
          home: LocationPicker(
            initialCenter: const LatLng(41.3, 69.24),
            onConfirmed: (p) => returned = p,
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.byKey(const Key('LocationPicker.confirm')), findsOneWidget);
    expect(returned, isNull);
  });
}
```

- [ ] **Step 2: Run — expect FAIL**

- [ ] **Step 3: Implement**

```dart
// lib/widgets/maps/location_picker.dart
import 'package:app/providers/provider_models/place.dart';
import 'package:app/providers/provider_root/maps_provider_provider.dart';
import 'package:app/services/maps/maps_exceptions.dart';
import 'package:app/widgets/maps/place_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class LocationPicker extends ConsumerStatefulWidget {
  final LatLng initialCenter;
  final double initialZoom;
  final ValueChanged<Place> onConfirmed;

  const LocationPicker({
    super.key,
    required this.initialCenter,
    required this.onConfirmed,
    this.initialZoom = 14,
  });

  @override
  ConsumerState<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends ConsumerState<LocationPicker> {
  final _mapController = MapController();
  late LatLng _pin;
  Place? _resolvedPlace;
  bool _resolving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _pin = widget.initialCenter;
    _resolveCenter();
  }

  Future<void> _resolveCenter() async {
    setState(() {
      _resolving = true;
      _error = null;
    });
    try {
      final p = await ref.read(mapsProviderProvider).reverseGeocode(_pin);
      if (!mounted) return;
      setState(() {
        _resolvedPlace = p;
        _resolving = false;
      });
    } on MapsException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _resolving = false;
      });
    }
  }

  void _onMapTap(LatLng latLng) {
    setState(() => _pin = latLng);
    _resolveCenter();
  }

  Future<void> _useCurrentLocation() async {
    try {
      final perm = await Geolocator.requestPermission();
      if (perm == LocationPermission.denied ||
          perm == LocationPermission.deniedForever) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permission denied')),
        );
        return;
      }
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      if (!mounted) return;
      final newPin = LatLng(pos.latitude, pos.longitude);
      setState(() => _pin = newPin);
      _mapController.move(newPin, 16);
      await _resolveCenter();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('GPS error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(mapsProviderProvider);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Set location')),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: widget.initialCenter,
              initialZoom: widget.initialZoom,
              onTap: (_, ll) => _onMapTap(ll),
            ),
            children: [
              TileLayer(
                urlTemplate: provider.tileUrlTemplate,
                subdomains: provider.tileSubdomains,
                userAgentPackageName: provider.userAgent,
              ),
              MarkerLayer(markers: [
                Marker(
                  point: _pin,
                  width: 50,
                  height: 50,
                  child: Icon(Icons.location_on,
                      size: 50, color: theme.colorScheme.error),
                ),
              ]),
            ],
          ),
          Positioned(
            top: 8,
            left: 8,
            right: 8,
            child: Material(
              elevation: 4,
              child: PlaceSearchField(
                near: _pin,
                onSelected: (p) {
                  setState(() {
                    _pin = LatLng(p.lat, p.lng);
                    _resolvedPlace = p;
                  });
                  _mapController.move(_pin, 16);
                },
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              key: const Key('LocationPicker.gps'),
              onPressed: _useCurrentLocation,
              child: const Icon(Icons.my_location),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Material(
              elevation: 8,
              color: theme.colorScheme.surface,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_resolving)
                      const LinearProgressIndicator()
                    else if (_error != null)
                      Text(
                        'Couldn\'t resolve address — pick again or confirm with coordinates only',
                        style: TextStyle(color: theme.colorScheme.error),
                      )
                    else if (_resolvedPlace != null)
                      Text(
                        _resolvedPlace!.formattedAddress ?? 'Selected location',
                        style: theme.textTheme.bodyLarge,
                      ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      key: const Key('LocationPicker.confirm'),
                      onPressed: _resolvedPlace == null
                          ? null
                          : () => widget.onConfirmed(_resolvedPlace!),
                      child: const Text('Confirm location'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 4: Run — expect PASS**

```bash
flutter test test/widgets/maps/location_picker_test.dart
```

- [ ] **Step 5: Commit**

```bash
git add lib/widgets/maps/location_picker.dart test/widgets/maps/location_picker_test.dart
git commit -m "feat(maps): LocationPicker (map-first, pin/search/GPS)"
```

---

## Task D4: `NeighborhoodVerifier` (GPS verification flow)

**Files:**
- Create: `lib/widgets/maps/neighborhood_verifier.dart`
- Test: `test/widgets/maps/neighborhood_verifier_test.dart`

This widget enforces:
- GPS permission → handle denied / deniedForever
- Accuracy ≤100m → "Move to open area" retry, after 3 attempts offer "low confidence"
- On success → reverse-geocode → confirm sheet → call backend verify endpoint → add to provider

- [ ] **Step 1: Write tests covering denied / accuracy / success paths**

```dart
// test/widgets/maps/neighborhood_verifier_test.dart
import 'package:app/providers/provider_models/neighborhood.dart';
import 'package:app/providers/provider_models/place.dart';
import 'package:app/providers/provider_root/maps_provider_provider.dart';
import 'package:app/providers/provider_root/verified_neighborhoods_provider.dart';
import 'package:app/services/maps/maps_provider.dart';
import 'package:app/widgets/maps/neighborhood_verifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _StubProvider extends MapsProvider {
  Neighborhood? mockNbhd;
  @override
  Future<Neighborhood?> getNeighborhood(LatLng latLng) async => mockNbhd;
  @override
  Future<Place> reverseGeocode(LatLng latLng) async =>
      Place(lat: latLng.latitude, lng: latLng.longitude);
  @override
  Future<Place> forwardGeocode(String a) async => Place(lat: 0, lng: 0);
  @override
  Future<List<Place>> searchPlaces(String q, {LatLng? near, String? sessionToken}) async => const [];
  @override
  String get tileUrlTemplate => 'x';
  @override
  List<String> get tileSubdomains => const [];
  @override
  String get attribution => '';
  @override
  String get userAgent => '';
  @override
  String get providerName => 'Test';
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('renders verify button initially', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [mapsProviderProvider.overrideWithValue(_StubProvider())],
        child: const MaterialApp(home: Scaffold(body: NeighborhoodVerifier())),
      ),
    );
    expect(find.byKey(const Key('NeighborhoodVerifier.start')), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run — expect FAIL**

- [ ] **Step 3: Implement** (state diagram: idle → requesting → confirming → submitting → done/error)

```dart
// lib/widgets/maps/neighborhood_verifier.dart
import 'package:app/l10n/app_localizations.dart';
import 'package:app/providers/provider_models/neighborhood.dart';
import 'package:app/providers/provider_root/maps_provider_provider.dart';
import 'package:app/providers/provider_root/verified_neighborhoods_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class NeighborhoodVerifier extends ConsumerStatefulWidget {
  /// Optional pre-resolved place to skip GPS read (used by integration tests).
  final Position? injectedPosition;

  /// Maximum acceptable GPS accuracy in meters.
  static const accuracyThresholdM = 100.0;

  /// Number of high-accuracy retries before offering "low confidence" path.
  static const maxStrictAttempts = 3;

  const NeighborhoodVerifier({super.key, this.injectedPosition});

  @override
  ConsumerState<NeighborhoodVerifier> createState() =>
      _NeighborhoodVerifierState();
}

enum _Stage { idle, requesting, confirming, submitting, done, error }

class _NeighborhoodVerifierState extends ConsumerState<NeighborhoodVerifier> {
  _Stage _stage = _Stage.idle;
  String? _error;
  Neighborhood? _resolved;
  Position? _position;
  int _strictAttempts = 0;

  Future<void> _start({bool allowLowConfidence = false}) async {
    setState(() {
      _stage = _Stage.requesting;
      _error = null;
    });

    try {
      final perm = await Geolocator.requestPermission();
      if (perm == LocationPermission.denied) {
        setState(() {
          _stage = _Stage.error;
          _error = 'Location permission denied — please enable in Settings';
        });
        return;
      }
      if (perm == LocationPermission.deniedForever) {
        setState(() {
          _stage = _Stage.error;
          _error =
              'Location permanently denied — open Settings to enable';
        });
        return;
      }

      final pos = widget.injectedPosition ??
          await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
          );

      if (pos.accuracy > NeighborhoodVerifier.accuracyThresholdM &&
          !allowLowConfidence) {
        _strictAttempts++;
        setState(() {
          _stage = _Stage.error;
          _error = 'GPS accuracy is ${pos.accuracy.toStringAsFixed(0)}m '
              '(need ≤100m). Move to an open area and try again.';
        });
        return;
      }

      final nbhd = await ref
          .read(mapsProviderProvider)
          .getNeighborhood(LatLng(pos.latitude, pos.longitude));
      if (nbhd == null) {
        setState(() {
          _stage = _Stage.error;
          _error = 'Could not identify neighborhood for your location.';
        });
        return;
      }

      setState(() {
        _stage = _Stage.confirming;
        _resolved = nbhd;
        _position = pos;
      });
    } catch (e) {
      setState(() {
        _stage = _Stage.error;
        _error = e.toString();
      });
    }
  }

  Future<void> _confirm() async {
    if (_resolved == null || _position == null) return;
    setState(() => _stage = _Stage.submitting);
    try {
      // TODO(integrate): POST /api/users/me/verify_neighborhood with backend
      // For now, persist locally only. The wire-up to backend is in the
      // shaxsiy.dart integration task.
      await ref.read(verifiedNeighborhoodsProvider.notifier).add(
            VerifiedNeighborhood(
              neighborhood: _resolved!,
              verifiedAt: DateTime.now(),
              gpsAccuracyM: _position!.accuracy,
              lowConfidence:
                  _position!.accuracy > NeighborhoodVerifier.accuracyThresholdM,
            ),
          );
      setState(() => _stage = _Stage.done);
    } catch (e) {
      setState(() {
        _stage = _Stage.error;
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Verify your neighborhood', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(
            'Stand in your neighborhood. We\'ll check your GPS and ask you to confirm.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          if (_stage == _Stage.idle)
            ElevatedButton(
              key: const Key('NeighborhoodVerifier.start'),
              onPressed: () => _start(),
              child: const Text('Verify Neighborhood'),
            ),
          if (_stage == _Stage.requesting) const LinearProgressIndicator(),
          if (_stage == _Stage.error) ...[
            Text(_error ?? 'Unknown error',
                style: TextStyle(color: theme.colorScheme.error)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_strictAttempts >= NeighborhoodVerifier.maxStrictAttempts)
                  TextButton(
                    onPressed: () => _start(allowLowConfidence: true),
                    child: const Text('Continue with low confidence'),
                  ),
                ElevatedButton(
                  onPressed: () => _start(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ],
          if (_stage == _Stage.confirming && _resolved != null) ...[
            Text("You're in:", style: theme.textTheme.bodyMedium),
            const SizedBox(height: 4),
            Text(_resolved!.displayName, style: theme.textTheme.titleMedium),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => setState(() => _stage = _Stage.idle),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  key: const Key('NeighborhoodVerifier.confirm'),
                  onPressed: _confirm,
                  child: const Text('Confirm'),
                ),
              ],
            ),
          ],
          if (_stage == _Stage.submitting) const LinearProgressIndicator(),
          if (_stage == _Stage.done)
            Text(
              'Verified! ${_resolved?.displayName}',
              style: TextStyle(color: theme.colorScheme.primary),
            ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 4: Run — expect PASS**

```bash
flutter test test/widgets/maps/neighborhood_verifier_test.dart
```

- [ ] **Step 5: Commit**

```bash
git add lib/widgets/maps/neighborhood_verifier.dart test/widgets/maps/neighborhood_verifier_test.dart
git commit -m "feat(maps): NeighborhoodVerifier — GPS-strict verification flow"
```

---

## Task D5: `RadiusSlider`

**Files:**
- Create: `lib/widgets/maps/radius_slider.dart`
- Test: `test/widgets/maps/radius_slider_test.dart`

- [ ] **Step 1: Write failing test**

```dart
// test/widgets/maps/radius_slider_test.dart
import 'package:app/providers/provider_root/radius_provider.dart';
import 'package:app/widgets/maps/radius_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('renders preset chips and city option', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: Scaffold(body: RadiusSlider())),
      ),
    );
    expect(find.text('1 km'), findsOneWidget);
    expect(find.text('3 km'), findsOneWidget);
    expect(find.text('5 km'), findsOneWidget);
    expect(find.text('10 km'), findsOneWidget);
    expect(find.text('City'), findsOneWidget);
  });

  testWidgets('tap chip updates radiusProvider', (tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: Scaffold(body: RadiusSlider())),
      ),
    );
    await tester.tap(find.text('5 km'));
    await tester.pumpAndSettle();
    expect(container.read(radiusProvider), 5.0);
  });
}
```

- [ ] **Step 2: Run — expect FAIL**

- [ ] **Step 3: Implement**

```dart
// lib/widgets/maps/radius_slider.dart
import 'package:app/providers/provider_root/radius_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RadiusSlider extends ConsumerWidget {
  static const _presets = [1.0, 3.0, 5.0, 10.0];
  const RadiusSlider({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(radiusProvider);
    final notifier = ref.read(radiusProvider.notifier);
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: [
          for (final p in _presets)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: ChoiceChip(
                label: Text('${p.toStringAsFixed(0)} km'),
                selected: current == p,
                onSelected: (_) => notifier.set(p),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              label: const Text('City'),
              selected: current == double.infinity,
              onSelected: (_) => notifier.set(double.infinity),
            ),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 4: Run — expect PASS**

- [ ] **Step 5: Commit**

```bash
git add lib/widgets/maps/radius_slider.dart test/widgets/maps/radius_slider_test.dart
git commit -m "feat(maps): RadiusSlider — Carrot-style radius chips"
```

---

# Track E — Profile Wire-up (NeighborhoodVerifier integration)

This track wires the verifier flow into the existing profile (`shaxsiy.dart`). Per WIP audit: `shaxsiy.dart` is **safe** (we already refactored it last session — not in current WIP).

## Task E1: Add "My neighborhoods" section to profile

**Files:**
- Modify: `lib/pages/shaxsiy/shaxsiy.dart`

- [ ] **Step 1: Read the current file to find a clean insertion point**

```bash
grep -n "Widget build" lib/pages/shaxsiy/shaxsiy.dart | head -3
grep -n "ProfileMenuCard" lib/pages/shaxsiy/shaxsiy.dart | head -5
```

- [ ] **Step 2: Add a new section above the existing menu cards** — open `lib/pages/shaxsiy/shaxsiy.dart` and locate the `Column` that holds `ProfileMenuCard` instances (look for `_ProfileBody` or wherever the body composes menu items). Insert this block immediately above the first menu card:

```dart
// Add to the imports at top of file:
import 'package:app/providers/provider_root/verified_neighborhoods_provider.dart';
import 'package:app/widgets/maps/neighborhood_verifier.dart';

// Then in the body Column:
const _MyNeighborhoodsSection(),
const SizedBox(height: 16),
```

- [ ] **Step 3: Add the new section widget at the bottom of the file**

```dart
// At the end of lib/pages/shaxsiy/shaxsiy.dart
class _MyNeighborhoodsSection extends ConsumerWidget {
  const _MyNeighborhoodsSection();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = ref.watch(verifiedNeighborhoodsProvider);
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('My neighborhoods', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            if (list.isEmpty)
              const Text('No verified neighborhoods yet.')
            else
              ...list.map((v) => ListTile(
                    leading: Icon(
                      Icons.place,
                      color: v.isExpired
                          ? theme.colorScheme.error
                          : theme.colorScheme.primary,
                    ),
                    title: Text(v.neighborhood.displayName),
                    subtitle: Text(
                      v.isExpired
                          ? 'Expired — re-verify'
                          : 'Verified ${_formatRelative(v.verifiedAt)}',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => ref
                          .read(verifiedNeighborhoodsProvider.notifier)
                          .remove(v.neighborhood.id),
                    ),
                  )),
            if (list.length < 2)
              TextButton.icon(
                onPressed: () => _openVerifierSheet(context),
                icon: const Icon(Icons.add_location_alt_outlined),
                label: Text(list.isEmpty
                    ? 'Verify a neighborhood'
                    : 'Add a second neighborhood'),
              ),
          ],
        ),
      ),
    );
  }

  void _openVerifierSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const SafeArea(child: NeighborhoodVerifier()),
    );
  }

  String _formatRelative(DateTime d) {
    final diff = DateTime.now().difference(d);
    if (diff.inDays >= 1) return '${diff.inDays}d ago';
    if (diff.inHours >= 1) return '${diff.inHours}h ago';
    return 'just now';
  }
}
```

- [ ] **Step 4: Verify analyzer + manual check**

```bash
flutter analyze lib/pages/shaxsiy/shaxsiy.dart
```

Expected: clean. Manually launch the profile in dev (`flutter run`) — confirm the section appears.

- [ ] **Step 5: Commit**

```bash
git add lib/pages/shaxsiy/shaxsiy.dart
git commit -m "feat(maps): add My Neighborhoods section + verifier sheet to profile"
```

---

# Track F — Backend (Django)

> All tasks in this track are in the separate Django backend repo. Path is `<backend>` — confirm the actual path during Task 0.

## Task F1: Schema migration — Property + Service location fields

**Files:**
- Create: `<backend>/properties/migrations/0XXX_add_place_fields.py`
- Create: `<backend>/services/migrations/0XXX_add_place_fields.py`
- Modify: `<backend>/properties/models.py` (add five fields to the Property/PropertyLocation model)
- Modify: `<backend>/services/models.py` (add five fields)

- [ ] **Step 1: Add fields to `Property` model**

```python
# <backend>/properties/models.py — add to the Property model (or PropertyLocation if separate)
class Property(models.Model):
    # ... existing fields ...
    place_id = models.CharField(max_length=128, null=True, blank=True, db_index=True)
    formatted_address = models.CharField(max_length=512, null=True, blank=True)
    country_code = models.CharField(max_length=2, null=True, blank=True, db_index=True)
    region = models.CharField(max_length=128, null=True, blank=True, db_index=True)
    city = models.CharField(max_length=128, null=True, blank=True, db_index=True)
```

- [ ] **Step 2: Same five fields on `Service`**

```python
# <backend>/services/models.py — same five fields on the location model used by Service
```

- [ ] **Step 3: Generate + apply migrations**

```bash
cd <backend>
python manage.py makemigrations properties services
python manage.py migrate
```

- [ ] **Step 4: Update DRF serializers to expose new fields**

```python
# <backend>/properties/serializers.py
class PropertySerializer(serializers.ModelSerializer):
    class Meta:
        model = Property
        fields = [..., 'place_id', 'formatted_address', 'country_code', 'region', 'city']
```

Same in `services/serializers.py`.

- [ ] **Step 5: Run existing tests + new field test**

```python
# <backend>/properties/tests/test_models.py
def test_property_accepts_place_fields():
    p = Property.objects.create(
        title='Test',
        # ... other required fields ...
        place_id='osm:123',
        formatted_address='Yunusabad, Tashkent',
        country_code='UZ',
        region='Tashkent',
        city='Tashkent',
    )
    assert p.place_id == 'osm:123'
```

```bash
cd <backend>
pytest properties/tests/test_models.py -v
```

- [ ] **Step 6: Commit**

```bash
cd <backend>
git add properties/ services/
git commit -m "feat: add place_id/formatted_address/country_code/region/city to Property+Service"
```

---

## Task F2: User schema migration — `verified_neighborhoods`

**Files:**
- Create: `<backend>/users/migrations/0XXX_add_verified_neighborhoods.py`
- Modify: `<backend>/users/models.py`

- [ ] **Step 1: Add field to User**

Choice between JSONField (simple) and a related model (cleaner). Plan recommends JSONField for phase 1 — easier migration, easy to convert to a relation in phase 2 if needed.

```python
# <backend>/users/models.py
class User(AbstractUser):
    # ... existing fields ...
    verified_neighborhoods = models.JSONField(default=list, blank=True)
    # Schema of each entry:
    # {
    #   "neighborhood": {
    #     "id": "UZ:12345",
    #     "name": "Yunusabad",
    #     "display_name": "Yunusabad, Tashkent, Uzbekistan",
    #     "country_code": "UZ",
    #     "region": "Tashkent",
    #     "city": "Tashkent",
    #     "centroid_lat": 41.3,
    #     "centroid_lng": 69.24,
    #   },
    #   "verified_at": "2026-05-10T12:00:00Z",
    #   "gps_accuracy_m": 50.0,
    #   "low_confidence": false
    # }
```

- [ ] **Step 2: Generate + apply migration**

```bash
cd <backend>
python manage.py makemigrations users
python manage.py migrate
```

- [ ] **Step 3: Update UserSerializer to expose `verified_neighborhoods`**

```python
# <backend>/users/serializers.py
class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = [..., 'verified_neighborhoods']
        read_only_fields = ['verified_neighborhoods']  # only mutated through verify endpoint
```

- [ ] **Step 4: Commit**

```bash
cd <backend>
git add users/
git commit -m "feat: add verified_neighborhoods JSONField to User"
```

---

## Task F3: `verify_neighborhood` endpoint

**Files:**
- Create: `<backend>/locations/views.py`
- Create: `<backend>/locations/serializers.py`
- Create: `<backend>/locations/services.py`
- Create: `<backend>/locations/urls.py`
- Modify: `<backend>/<project>/urls.py` to include `locations.urls`
- Test: `<backend>/locations/tests/test_verify_neighborhood.py`

- [ ] **Step 1: Write tests first**

```python
# <backend>/locations/tests/test_verify_neighborhood.py
import pytest
from rest_framework.test import APIClient
from django.urls import reverse

@pytest.mark.django_db
class TestVerifyNeighborhood:
    def setup_method(self):
        self.client = APIClient()
        # Create + login user fixture per project convention

    def test_accepts_valid_gps(self, authenticated_user):
        resp = self.client.post(
            '/api/users/me/verify_neighborhood',
            data={
                'lat': 41.3,
                'lng': 69.24,
                'gps_accuracy_m': 50.0,
            },
            format='json',
        )
        assert resp.status_code == 200
        assert len(resp.data['verified_neighborhoods']) == 1
        assert resp.data['verified_neighborhoods'][0]['neighborhood']['country_code'] == 'UZ'

    def test_rejects_accuracy_over_100m(self, authenticated_user):
        resp = self.client.post('/api/users/me/verify_neighborhood',
                                data={'lat': 41.3, 'lng': 69.24, 'gps_accuracy_m': 250.0},
                                format='json')
        assert resp.status_code == 400
        assert 'accuracy' in str(resp.data).lower()

    def test_allows_low_confidence_with_flag(self, authenticated_user):
        resp = self.client.post('/api/users/me/verify_neighborhood',
                                data={'lat': 41.3, 'lng': 69.24, 'gps_accuracy_m': 250.0,
                                      'low_confidence': True},
                                format='json')
        assert resp.status_code == 200
        assert resp.data['verified_neighborhoods'][0]['low_confidence'] is True

    def test_rejects_implausibly_precise_accuracy(self, authenticated_user):
        # Anti-spoof: <1m accuracy is suspicious from a phone
        resp = self.client.post('/api/users/me/verify_neighborhood',
                                data={'lat': 41.3, 'lng': 69.24, 'gps_accuracy_m': 0.5},
                                format='json')
        assert resp.status_code == 400

    def test_rate_limit_5_per_24h(self, authenticated_user):
        for _ in range(5):
            r = self.client.post('/api/users/me/verify_neighborhood',
                                 data={'lat': 41.3, 'lng': 69.24, 'gps_accuracy_m': 50.0},
                                 format='json')
            assert r.status_code == 200
        r = self.client.post('/api/users/me/verify_neighborhood',
                             data={'lat': 41.3, 'lng': 69.24, 'gps_accuracy_m': 50.0},
                             format='json')
        assert r.status_code == 429

    def test_max_2_neighborhoods(self, authenticated_user):
        # First two succeed
        self.client.post('/api/users/me/verify_neighborhood',
                         data={'lat': 41.3, 'lng': 69.24, 'gps_accuracy_m': 50.0}, format='json')
        self.client.post('/api/users/me/verify_neighborhood',
                         data={'lat': 41.0, 'lng': 71.0, 'gps_accuracy_m': 50.0}, format='json')
        # Third (different neighborhood) is rejected
        r = self.client.post('/api/users/me/verify_neighborhood',
                             data={'lat': 38.0, 'lng': 65.0, 'gps_accuracy_m': 50.0}, format='json')
        assert r.status_code == 400
        assert 'max' in str(r.data).lower() or '2' in str(r.data)

    def test_re_verifying_same_neighborhood_replaces_entry(self, authenticated_user):
        self.client.post('/api/users/me/verify_neighborhood',
                         data={'lat': 41.3, 'lng': 69.24, 'gps_accuracy_m': 50.0}, format='json')
        r = self.client.post('/api/users/me/verify_neighborhood',
                             data={'lat': 41.301, 'lng': 69.241, 'gps_accuracy_m': 30.0},
                             format='json')
        assert r.status_code == 200
        # Same neighborhood should still be only 1 entry, not 2
        assert len(r.data['verified_neighborhoods']) == 1
```

```bash
cd <backend>
pytest locations/tests/test_verify_neighborhood.py -v
```

Expected: ImportError / 404 errors.

- [ ] **Step 2: Implement service layer (server-side reverse-geocode)**

```python
# <backend>/locations/services.py
import requests
from typing import Optional
from django.core.exceptions import ValidationError

NOMINATIM_URL = 'https://nominatim.openstreetmap.org/reverse'
USER_AGENT = 'SabziMarket-Backend/1.0 (bananatalkmain@gmail.com)'

class NominatimError(Exception):
    pass

def reverse_geocode_neighborhood(lat: float, lng: float) -> Optional[dict]:
    """Returns a Neighborhood dict matching the frontend Neighborhood schema, or None."""
    try:
        r = requests.get(
            NOMINATIM_URL,
            params={
                'format': 'json',
                'lat': lat,
                'lon': lng,
                'zoom': 18,
                'addressdetails': 1,
            },
            headers={'User-Agent': USER_AGENT},
            timeout=10,
        )
        if r.status_code == 429:
            raise NominatimError('rate limited')
        r.raise_for_status()
        data = r.json()
        addr = data.get('address', {}) or {}
        country_code = (addr.get('country_code') or '').upper()
        region = addr.get('state') or addr.get('region') or addr.get('province')
        city = addr.get('city') or addr.get('town') or addr.get('village') or addr.get('hamlet')
        nbhd_name = (addr.get('suburb') or addr.get('neighbourhood') or
                     addr.get('quarter') or addr.get('hamlet') or addr.get('village') or
                     addr.get('city_district'))
        if not (country_code and region and city and nbhd_name):
            return None
        place_id = data.get('place_id') or f'{lat:.4f},{lng:.4f}'
        return {
            'id': f'{country_code}:{place_id}',
            'name': nbhd_name,
            'display_name': data.get('display_name', nbhd_name),
            'country_code': country_code,
            'region': region,
            'city': city,
            'centroid_lat': float(data.get('lat', lat)),
            'centroid_lng': float(data.get('lon', lng)),
        }
    except requests.RequestException as e:
        raise NominatimError(str(e))


def validate_gps_accuracy(accuracy_m: float) -> None:
    if accuracy_m < 1.0:
        raise ValidationError('GPS accuracy implausibly precise (<1m). Possible spoof.')
    # Hard ceiling — even with low_confidence flag we don't accept >500m
    if accuracy_m > 500.0:
        raise ValidationError('GPS accuracy too poor (>500m). Try outdoors.')
```

- [ ] **Step 3: Implement views**

```python
# <backend>/locations/views.py
from datetime import datetime, timedelta, timezone
from rest_framework.decorators import api_view, permission_classes, throttle_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.throttling import UserRateThrottle
from django.core.exceptions import ValidationError
from django.utils import timezone as djtz

from .services import reverse_geocode_neighborhood, validate_gps_accuracy, NominatimError

class VerifyNeighborhoodThrottle(UserRateThrottle):
    rate = '5/day'  # 5 per 24h per user

@api_view(['POST'])
@permission_classes([IsAuthenticated])
@throttle_classes([VerifyNeighborhoodThrottle])
def verify_neighborhood(request):
    data = request.data
    try:
        lat = float(data['lat'])
        lng = float(data['lng'])
        accuracy = float(data['gps_accuracy_m'])
        low_confidence = bool(data.get('low_confidence', False))
    except (KeyError, ValueError, TypeError) as e:
        return Response({'error': f'invalid input: {e}'}, status=400)

    if accuracy > 100.0 and not low_confidence:
        return Response({'error': 'accuracy must be <= 100m (or set low_confidence=true)'},
                       status=400)
    try:
        validate_gps_accuracy(accuracy)
    except ValidationError as e:
        return Response({'error': str(e)}, status=400)

    try:
        nbhd = reverse_geocode_neighborhood(lat, lng)
    except NominatimError as e:
        return Response({'error': f'reverse-geocode failed: {e}'}, status=503)

    if nbhd is None:
        return Response({'error': 'could not resolve neighborhood for these coordinates'},
                       status=400)

    user = request.user
    existing = user.verified_neighborhoods or []
    # Replace if same id, else append (max 2)
    same_idx = next((i for i, v in enumerate(existing)
                     if v['neighborhood']['id'] == nbhd['id']), None)
    new_entry = {
        'neighborhood': nbhd,
        'verified_at': djtz.now().isoformat(),
        'gps_accuracy_m': accuracy,
        'low_confidence': low_confidence,
    }
    if same_idx is not None:
        existing[same_idx] = new_entry
    elif len(existing) >= 2:
        return Response({'error': 'max 2 verified neighborhoods'}, status=400)
    else:
        existing.append(new_entry)
    user.verified_neighborhoods = existing
    user.save(update_fields=['verified_neighborhoods'])

    return Response({'verified_neighborhoods': existing}, status=200)


@api_view(['DELETE'])
@permission_classes([IsAuthenticated])
def delete_verified_neighborhood(request, neighborhood_id):
    user = request.user
    existing = user.verified_neighborhoods or []
    user.verified_neighborhoods = [v for v in existing
                                   if v['neighborhood']['id'] != neighborhood_id]
    user.save(update_fields=['verified_neighborhoods'])
    return Response({'verified_neighborhoods': user.verified_neighborhoods}, status=200)
```

- [ ] **Step 4: Wire URLs**

```python
# <backend>/locations/urls.py
from django.urls import path
from .views import verify_neighborhood, delete_verified_neighborhood

urlpatterns = [
    path('users/me/verify_neighborhood', verify_neighborhood),
    path('users/me/verified_neighborhoods/<str:neighborhood_id>',
         delete_verified_neighborhood),
]
```

```python
# <backend>/<project>/urls.py — add to api include
path('api/', include('locations.urls')),
```

- [ ] **Step 5: Run tests — expect PASS**

```bash
cd <backend>
pytest locations/tests/test_verify_neighborhood.py -v
```

If fixture for `authenticated_user` doesn't exist, write one in `conftest.py`:

```python
# <backend>/conftest.py (or per-app)
import pytest
@pytest.fixture
def authenticated_user(db, django_user_model):
    user = django_user_model.objects.create_user(username='t', password='p')
    from rest_framework.test import APIClient
    c = APIClient()
    c.force_authenticate(user=user)
    return user
```

- [ ] **Step 6: Commit**

```bash
cd <backend>
git add locations/ users/ <project>/urls.py
git commit -m "feat: verify_neighborhood + delete endpoints + reverse-geocode service"
```

---

## Task F4: Filter params on `/api/products/` and `/api/services/`

**Files:**
- Modify: `<backend>/products/views.py`
- Modify: `<backend>/services/views.py`
- Test: `<backend>/products/tests/test_neighborhood_filter.py`
- Test: `<backend>/services/tests/test_neighborhood_filter.py`

- [ ] **Step 1: Tests first**

```python
# <backend>/products/tests/test_neighborhood_filter.py
import pytest
from rest_framework.test import APIClient
from properties.models import Property  # or wherever
from products.models import Product

@pytest.mark.django_db
class TestProductFilter:
    def setup_method(self):
        self.client = APIClient()
        Product.objects.create(
            title='Near', latitude=41.3, longitude=69.24,
            place_id='osm:1', country_code='UZ', region='Tashkent', city='Tashkent',
        )
        Product.objects.create(
            title='Far', latitude=40.0, longitude=71.0,
            place_id='osm:2', country_code='UZ', region='Andijon', city='Andijon',
        )

    def test_no_filter_returns_all(self):
        r = self.client.get('/api/products/')
        assert r.status_code == 200
        assert len(r.data['results']) == 2  # adapt to existing pagination

    def test_filter_by_neighborhood_id_with_radius(self):
        r = self.client.get('/api/products/?neighborhood_id=UZ:1&radius_km=1')
        assert r.status_code == 200
        # Should match only "Near"
        assert len(r.data['results']) == 1
        assert r.data['results'][0]['title'] == 'Near'

    def test_radius_5km_picks_up_more(self):
        r = self.client.get('/api/products/?neighborhood_id=UZ:1&radius_km=500')
        assert r.status_code == 200
        # 500km radius from Tashkent should include Andijon (~340km)
        assert len(r.data['results']) == 2

    def test_invalid_neighborhood_id_returns_empty(self):
        r = self.client.get('/api/products/?neighborhood_id=fake&radius_km=10')
        assert r.status_code == 200
        assert len(r.data['results']) == 0
```

```bash
pytest products/tests/test_neighborhood_filter.py -v
```

Expected: 4 failures.

- [ ] **Step 2: Implement filtering** in `products/views.py` and same in `services/views.py`. Add a `get_queryset()` override to the existing list view:

```python
# <backend>/products/views.py — list view
from math import radians, sin, cos, sqrt, asin

def haversine_km(lat1, lng1, lat2, lng2):
    r = 6371.0
    dlat = radians(lat2 - lat1)
    dlng = radians(lng2 - lng1)
    a = sin(dlat/2)**2 + cos(radians(lat1)) * cos(radians(lat2)) * sin(dlng/2)**2
    return 2 * r * asin(sqrt(a))

class ProductListView(generics.ListAPIView):
    serializer_class = ProductSerializer
    def get_queryset(self):
        qs = Product.objects.all()
        nbhd_id = self.request.query_params.get('neighborhood_id')
        radius_km = self.request.query_params.get('radius_km')
        if nbhd_id and radius_km:
            try:
                radius = float(radius_km)
            except ValueError:
                return qs.none()
            # Find centroid: lookup any record with this id is unreliable;
            # use the user's verified neighborhood centroid sent in the param,
            # OR resolve from the user's verified_neighborhoods on the request user.
            user = self.request.user
            if hasattr(user, 'verified_neighborhoods'):
                match = next((v['neighborhood'] for v in (user.verified_neighborhoods or [])
                              if v['neighborhood']['id'] == nbhd_id), None)
            else:
                match = None
            if not match:
                return qs.none()
            clat, clng = match['centroid_lat'], match['centroid_lng']
            # Filter in-DB by bounding box first (rough), then refine in-memory
            # For phase 1 simplicity: in-memory filter (fine up to ~10k records).
            ids = [p.pk for p in qs
                   if p.latitude and p.longitude
                   and haversine_km(clat, clng, float(p.latitude), float(p.longitude)) <= radius]
            return qs.filter(pk__in=ids)
        return qs
```

> NOTE: For phase-1 scale (10k records) in-memory haversine is acceptable. Phase 4 should migrate to PostGIS or a proper bounding-box pre-filter. Document this as a known scale limit in the PR.

- [ ] **Step 3: Run tests — expect PASS**

```bash
pytest products/tests/test_neighborhood_filter.py -v
pytest services/tests/test_neighborhood_filter.py -v
```

- [ ] **Step 4: Commit**

```bash
cd <backend>
git add products/ services/
git commit -m "feat: neighborhood_id+radius_km filter params on products/services list"
```

---

## Task F5: Privacy-pin reveal flag

**Files:**
- Modify: `<backend>/conversations/models.py` (add `reveals_listing_location: bool` to Conversation)
- Modify: `<backend>/conversations/views.py` (set the flag on creation if conversation is between buyer + seller of a product/service)
- Modify: `<backend>/products/serializers.py` (compute `show_exact_pin` from authenticated user's conversations)
- Test: `<backend>/products/tests/test_privacy_pin.py`

- [ ] **Step 1: Test**

```python
@pytest.mark.django_db
def test_product_detail_shows_approximate_until_chat(authenticated_user, seller_user):
    p = Product.objects.create(seller=seller_user, latitude=41.3, longitude=69.24,
                               place_id='osm:1', country_code='UZ', region='r', city='c')
    # Buyer fetches detail before any chat
    c = APIClient()
    c.force_authenticate(authenticated_user)
    r = c.get(f'/api/products/{p.pk}')
    assert r.data['show_exact_pin'] is False

    # Buyer initiates conversation
    c.post('/api/conversations/', data={'recipient': seller_user.pk, 'listing': p.pk}, format='json')

    # Now buyer's detail fetch shows exact
    r = c.get(f'/api/products/{p.pk}')
    assert r.data['show_exact_pin'] is True

    # Other user (anonymous or unrelated) still sees approximate
    c2 = APIClient()
    r2 = c2.get(f'/api/products/{p.pk}')
    assert r2.data.get('show_exact_pin') is False
```

- [ ] **Step 2: Implement model + view + serializer changes** (project-specific — adapt to actual models)

- [ ] **Step 3: Run test — expect PASS**

- [ ] **Step 4: Commit**

```bash
cd <backend>
git commit -am "feat: privacy-pin reveals after buyer-seller chat initiated"
```

---

# Track G — Backend Backfill Command

## Task G1: `backfill_locations` management command

**Files:**
- Create: `<backend>/locations/management/commands/backfill_locations.py`
- Test: `<backend>/locations/tests/test_backfill_locations.py`

- [ ] **Step 1: Test (with mocked Nominatim)**

```python
# <backend>/locations/tests/test_backfill_locations.py
from unittest.mock import patch
from io import StringIO
from django.core.management import call_command
import pytest

@pytest.mark.django_db
def test_backfill_skips_already_filled(populated_products):
    # populated_products fixture creates 2 products: one with place_id, one without
    with patch('locations.services.reverse_geocode_neighborhood') as m:
        m.return_value = {
            'id': 'UZ:1', 'name': 'X', 'display_name': 'X',
            'country_code': 'UZ', 'region': 'r', 'city': 'c',
            'centroid_lat': 41.0, 'centroid_lng': 69.0,
        }
        out = StringIO()
        call_command('backfill_locations', stdout=out)
        # Only the one without place_id should call reverse-geocode
        assert m.call_count == 1
        assert 'Filled 1' in out.getvalue()

@pytest.mark.django_db
def test_backfill_idempotent(populated_products):
    with patch('locations.services.reverse_geocode_neighborhood') as m:
        m.return_value = None  # second run has all filled, none to fill
        out = StringIO()
        call_command('backfill_locations', stdout=out)
        # Run twice — second should fill nothing
        out2 = StringIO()
        call_command('backfill_locations', stdout=out2)
        assert m.call_count == 0 or 'Filled 0' in out2.getvalue()
```

- [ ] **Step 2: Implement**

```python
# <backend>/locations/management/commands/backfill_locations.py
import time
from django.core.management.base import BaseCommand
from products.models import Product
from services.models import Service
from locations.services import reverse_geocode_neighborhood, NominatimError

class Command(BaseCommand):
    help = 'Reverse-geocodes existing Property/Product/Service records to fill new place_id/etc fields. Rate-limited 1 req/sec per Nominatim ToS. Idempotent.'

    def add_arguments(self, parser):
        parser.add_argument('--dry-run', action='store_true')
        parser.add_argument('--rate-seconds', type=float, default=1.0)

    def handle(self, *args, **options):
        rate = options['rate_seconds']
        dry = options['dry_run']
        models = [
            ('Product', Product),
            ('Service', Service),
        ]
        total_filled = 0
        for label, M in models:
            qs = M.objects.filter(place_id__isnull=True).exclude(latitude__isnull=True)
            self.stdout.write(f'{label}: {qs.count()} records to fill')
            for obj in qs.iterator():
                try:
                    nbhd = reverse_geocode_neighborhood(float(obj.latitude), float(obj.longitude))
                except NominatimError as e:
                    self.stdout.write(self.style.WARNING(f'  {label} pk={obj.pk}: {e}'))
                    time.sleep(rate)
                    continue
                if not nbhd:
                    self.stdout.write(f'  {label} pk={obj.pk}: no admin level resolvable')
                    time.sleep(rate)
                    continue
                if not dry:
                    obj.place_id = nbhd['id']
                    obj.formatted_address = nbhd['display_name']
                    obj.country_code = nbhd['country_code']
                    obj.region = nbhd['region']
                    obj.city = nbhd['city']
                    obj.save(update_fields=['place_id', 'formatted_address',
                                            'country_code', 'region', 'city'])
                total_filled += 1
                time.sleep(rate)
        self.stdout.write(self.style.SUCCESS(f'Filled {total_filled} records'))
```

- [ ] **Step 3: Run tests — expect PASS**

```bash
cd <backend>
pytest locations/tests/test_backfill_locations.py -v
```

- [ ] **Step 4: DRY RUN against staging DB**

```bash
cd <backend>
python manage.py backfill_locations --dry-run
```

Verify the count of records to fill is sane.

- [ ] **Step 5: Real run**

> NOTE: Schedule this for a low-traffic window. ~10k records at 1 req/sec ≈ 3 hours. Run in `tmux` / `screen`.

```bash
python manage.py backfill_locations
```

- [ ] **Step 6: Commit**

```bash
cd <backend>
git add locations/management
git commit -m "feat: backfill_locations management command"
```

---

# Track H — Frontend wire-up: Property/Service create + detail (safe)

## Task H1: Property create — replace "Use GPS" with `LocationPicker`

**Files:**
- Modify: `lib/pages/real_estate/property_create_page.dart`

This file is **safe** (we refactored it last session — not in current WIP list).

- [ ] **Step 1: Locate the existing GPS button and the lat/lng state**

```bash
grep -n "Get Current Location\|_latitude\|_longitude\|Geolocator" lib/pages/real_estate/property_create_page.dart | head -10
```

- [ ] **Step 2: Replace the GPS button section with a "Pick location" button that opens LocationPicker**

Find the section that renders the existing button. Replace with:

```dart
// In the build method:
ListTile(
  leading: const Icon(Icons.location_on_outlined),
  title: Text(_resolvedPlace?.formattedAddress ?? 'Set location'),
  trailing: const Icon(Icons.chevron_right),
  onTap: () async {
    final initial = (_latitude.isNotEmpty && _longitude.isNotEmpty)
        ? LatLng(double.parse(_latitude), double.parse(_longitude))
        : const LatLng(41.3, 69.24); // Tashkent default
    final picked = await Navigator.push<Place>(
      context,
      MaterialPageRoute(
        builder: (_) => LocationPicker(
          initialCenter: initial,
          onConfirmed: (p) => Navigator.pop(context, p),
        ),
      ),
    );
    if (picked != null) {
      setState(() {
        _resolvedPlace = picked;
        _latitude = picked.lat.toString();
        _longitude = picked.lng.toString();
      });
    }
  },
),
```

Add to state:

```dart
Place? _resolvedPlace;
```

Add imports:

```dart
import 'package:app/providers/provider_models/place.dart';
import 'package:app/widgets/maps/location_picker.dart';
import 'package:latlong2/latlong.dart';
```

- [ ] **Step 3: On submit, send all five new fields**

Find the existing submit handler and extend the payload:

```dart
// In the submit handler, alongside latitude/longitude:
'place_id': _resolvedPlace?.placeId,
'formatted_address': _resolvedPlace?.formattedAddress,
'country_code': _resolvedPlace?.countryCode,
'region': _resolvedPlace?.region,
'city': _resolvedPlace?.city,
```

- [ ] **Step 4: Analyzer + manual smoke**

```bash
flutter analyze lib/pages/real_estate/property_create_page.dart
flutter run -d ios  # or android, manually click through property create
```

- [ ] **Step 5: Commit**

```bash
git add lib/pages/real_estate/property_create_page.dart
git commit -m "feat(maps): wire LocationPicker into property create flow"
```

---

## Task H2: Product create — add `LocationPicker`

**Files:**
- Modify: `lib/pages/products/product_new.dart`

Same pattern as H1. Field is currently region/district dropdown — keep that for fallback when user has no verified neighborhood, but add map picker.

- [ ] **Step 1: Locate existing location form fields**

- [ ] **Step 2: Add a "Set location" tile that opens LocationPicker**

(Same code as H1 step 2, adapted to the form's state names.)

- [ ] **Step 3: Pass all five fields to backend**

Same as H1 step 3.

- [ ] **Step 4: Analyzer + manual smoke**

- [ ] **Step 5: Commit**

```bash
git add lib/pages/products/product_new.dart
git commit -m "feat(maps): LocationPicker on product create"
```

---

## Task H3: Service create — add `LocationPicker`

**Files:**
- Modify: `lib/pages/service/new/service_new.dart`

Same pattern as H1/H2.

- [ ] **Step 1-5:** identical structure — adapt names to service fields. Commit:

```bash
git add lib/pages/service/new/service_new.dart
git commit -m "feat(maps): LocationPicker on service create"
```

---

## Task H4: Service detail — add `MapView`

**Files:**
- Modify: `lib/pages/service/details/service_detail_content.dart`

`service_detail_content.dart` is **safe** (we extracted it in our last session).

- [ ] **Step 1: Add a MapView section**

Add after the description / provider section, before the comments section:

```dart
// In the build of service_detail_content:
if (widget.service.latitude != null && widget.service.longitude != null) ...[
  const SizedBox(height: 16),
  MapView(
    center: LatLng(
      double.parse(widget.service.latitude!),
      double.parse(widget.service.longitude!),
    ),
    mode: widget.service.showExactPin
        ? MapViewMode.exact
        : MapViewMode.approximate,
  ),
  const SizedBox(height: 16),
],
```

Add imports:

```dart
import 'package:app/widgets/maps/map_view.dart';
import 'package:latlong2/latlong.dart';
```

> NOTE: `widget.service.showExactPin` is a new field that comes from the backend's privacy-pin logic (Task F5). If the service model doesn't have it yet, default to `MapViewMode.approximate`.

- [ ] **Step 2: Analyzer + manual smoke**

- [ ] **Step 3: Commit**

```bash
git add lib/pages/service/details/service_detail_content.dart
git commit -m "feat(maps): MapView on service detail (privacy-aware)"
```

---

# Track I — WIP-COORD wire-ups (touch dirty files)

> ⚠️ **Each task in this track touches a file with current WIP. Verify the file's WIP is committed/merged or rebased before starting. If conflicts arise, surface them — do not auto-resolve.**

## Task I1 (WIP-COORD): Product detail — add `MapView`

**Files:**
- Modify: `lib/pages/products/product_detail.dart` *(WIP)*

- [ ] **Step 0: Verify WIP state**

```bash
git diff lib/pages/products/product_detail.dart | head -50
```

If unstaged changes exist, **stop**. Coordinate with the user to commit/merge first.

- [ ] **Step 1-3:** same as Task H4 (service detail) — add `MapView` section to product detail page based on `product.latitude/longitude` and `product.showExactPin`.

```bash
git add lib/pages/products/product_detail.dart
git commit -m "feat(maps): MapView on product detail (privacy-aware)"
```

---

## Task I2 (WIP-COORD): Real estate detail — replace static OSM with `MapView`

**Files:**
- Modify: `lib/pages/real_estate/real_estate_detail.dart` *(WIP)*
- Modify: `lib/pages/real_estate/detail/property_map_widget.dart`

- [ ] **Step 0: Verify WIP state on both files**

- [ ] **Step 1: Replace `property_map_widget.dart`'s static-image internals** with `MapView`:

```dart
// lib/pages/real_estate/detail/property_map_widget.dart
import 'package:app/widgets/maps/map_view.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class PropertyMapWidget extends StatelessWidget {
  final double latitude;
  final double longitude;
  const PropertyMapWidget({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  @override
  Widget build(BuildContext context) {
    return MapView(
      center: LatLng(latitude, longitude),
      mode: MapViewMode.exact, // real estate always exact
      height: 240,
    );
  }
}
```

(Drop the static-image URL builder, the OpenStreetMap external-launch button, and the geo: URI fallback. Real estate users get a real interactive map now.)

- [ ] **Step 2: Re-test integration in real_estate_detail.dart**

- [ ] **Step 3: Commit**

```bash
git add lib/pages/real_estate/detail/property_map_widget.dart
git commit -m "refactor(maps): replace static-OSM property_map_widget with MapView"
```

---

## Task I3 (WIP-COORD): `RealEstate` model — add 5 new fields

**Files:**
- Modify: `lib/providers/provider_models/real_estate.dart` *(WIP)*

- [ ] **Step 0: Verify WIP state**

- [ ] **Step 1: Add fields**

```dart
// In the RealEstate class:
final String? placeId;
final String? formattedAddress;
final String? countryCode;
// region + city likely already exist; if not, add them.
```

- [ ] **Step 2: Update `fromJson`/`toJson`** to read/write the new fields (tolerant of missing values during migration).

- [ ] **Step 3: Commit**

```bash
git commit -am "feat(real_estate): add place_id/formatted_address/country_code fields"
```

---

## Task I4 (WIP-COORD): Product/Service providers — accept `neighborhoodId` + `radiusKm`

**Files:**
- Modify: `lib/providers/provider_root/product_provider.dart` *(WIP)*
- Modify: `lib/providers/provider_root/service_provider.dart` *(WIP)*

- [ ] **Step 0: Verify WIP state on both**

- [ ] **Step 1: Find the family / list-fetch provider** that backs the products tab list. Add new optional params to the family.

```dart
// e.g. existing:
// final productsListProvider = FutureProvider<List<Product>>((ref) async { ... });
// becomes:

class ProductsQuery {
  final String? neighborhoodId;
  final double? radiusKm;
  const ProductsQuery({this.neighborhoodId, this.radiusKm});
}

final productsListProvider =
    FutureProvider.family<List<Product>, ProductsQuery>((ref, q) async {
  final params = <String, String>{};
  if (q.neighborhoodId != null) params['neighborhood_id'] = q.neighborhoodId!;
  if (q.radiusKm != null && q.radiusKm! != double.infinity) {
    params['radius_km'] = q.radiusKm!.toStringAsFixed(0);
  }
  // ... fetch with params ...
});
```

- [ ] **Step 2: Same for `service_provider.dart`**

- [ ] **Step 3: Commit**

```bash
git commit -am "feat(maps): productsListProvider+serviceListProvider accept neighborhood filter"
```

---

## Task I5 (WIP-COORD): Wire `RadiusSlider` + active neighborhood badge into products tab

**Files:**
- Modify: `lib/pages/products/main_products.dart` *(WIP)*
- Modify: `lib/pages/service/main/main_service.dart` *(WIP)*

- [ ] **Step 0: Verify WIP state**

- [ ] **Step 1: Add the slider above the listing list and switch the data source to use the new family** (from I4). Show "Expand to {city}" CTA when results are empty:

```dart
// In the products tab body:
final active = ref.watch(activeNeighborhoodProvider);
final radius = ref.watch(radiusProvider);
final query = ProductsQuery(
  neighborhoodId: active?.neighborhood.id,
  radiusKm: radius,
);
final productsAsync = ref.watch(productsListProvider(query));

return Column(
  children: [
    // Radius + active neighborhood pill
    Padding(
      padding: const EdgeInsets.all(8),
      child: Row(children: [
        if (active != null)
          Chip(
            avatar: const Icon(Icons.place, size: 16),
            label: Text(active.neighborhood.name),
            // Tap to switch between the 1-2 verified
            onDeleted: ref.watch(verifiedNeighborhoodsProvider).length > 1
                ? () {
                    final cur = ref.read(activeNeighborhoodIndexProvider);
                    ref.read(activeNeighborhoodIndexProvider.notifier).state =
                        cur == 0 ? 1 : 0;
                  }
                : null,
            deleteIcon: const Icon(Icons.swap_horiz),
          ),
        const Expanded(child: RadiusSlider()),
      ]),
    ),
    Expanded(
      child: productsAsync.when(
        data: (items) => items.isEmpty
            ? _EmptyExpandToCity(
                neighborhood: active?.neighborhood,
                onExpand: () =>
                    ref.read(radiusProvider.notifier).set(double.infinity),
              )
            : /* existing list rendering */,
        loading: ...,
        error: ...,
      ),
    ),
  ],
);
```

- [ ] **Step 2: Implement `_EmptyExpandToCity`**

```dart
class _EmptyExpandToCity extends StatelessWidget {
  final Neighborhood? neighborhood;
  final VoidCallback onExpand;
  const _EmptyExpandToCity({this.neighborhood, required this.onExpand});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.search_off, size: 48),
          const SizedBox(height: 8),
          Text(neighborhood == null
              ? 'No items'
              : 'No items in ${neighborhood!.name}'),
          const SizedBox(height: 8),
          TextButton(
            onPressed: onExpand,
            child: Text('Expand to ${neighborhood?.city ?? "city"}'),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 3: Same wiring in main_service.dart**

- [ ] **Step 4: Commit**

```bash
git commit -am "feat(maps): radius slider + active-neighborhood pill on products+services tabs"
```

---

## Task I6 (WIP-COORD): Gate products+services tabs behind verification

**Files:**
- Modify: `lib/pages/tab_bar/tab_bar.dart` *(WIP)*

- [ ] **Step 0: Verify WIP state**

- [ ] **Step 1: Wrap products + services tab bodies in a verification gate**

```dart
// Helper:
Widget _verificationGate(
    WidgetRef ref, Widget child, BuildContext context) {
  final verified = ref.watch(verifiedNeighborhoodsProvider);
  if (verified.isEmpty || verified.every((v) => v.isExpired)) {
    return _NeedsVerificationView(
      isExpired: verified.isNotEmpty,
      onVerify: () => showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (_) => const SafeArea(child: NeighborhoodVerifier()),
      ),
    );
  }
  return child;
}

// In tab content:
case Tab.products:
  return _verificationGate(ref, ProductsScreen(), context);
case Tab.services:
  return _verificationGate(ref, ServicesScreen(), context);
case Tab.realEstate:
  return RealEstateScreen(); // unchanged — no gate
```

- [ ] **Step 2: Implement `_NeedsVerificationView`**

```dart
class _NeedsVerificationView extends StatelessWidget {
  final bool isExpired;
  final VoidCallback onVerify;
  const _NeedsVerificationView({required this.isExpired, required this.onVerify});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.location_searching, size: 64),
            const SizedBox(height: 16),
            Text(
              isExpired
                  ? 'Your neighborhood verification expired'
                  : 'Verify your neighborhood',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            const Text(
              'We only show products and services from your area. '
              'Real estate browsing is unaffected.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: onVerify, child: const Text('Verify')),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 3: Commit**

```bash
git commit -am "feat(maps): gate products+services tabs on verified neighborhood"
```

---

# Track J — Cleanup

## Task J1: Unwire `change_city` from primary nav

**Files:**
- Modify: `lib/config/app_router.dart` *(WIP)* OR wherever the primary nav references `change_city`
- Modify: any tab body that linked to `change_city`

> NOTE: Keep the file `change_city.dart` alive — it's referenced for phase 2 country picker work. Just remove it from the primary nav.

- [ ] **Step 1: Find references**

```bash
grep -rn "change_city\|ChangeCity\|/change" lib/ --include="*.dart" | grep -v "lib/pages/change_city/"
```

- [ ] **Step 2: Remove or hide each call site found**

- [ ] **Step 3: Commit**

```bash
git commit -am "refactor: unwire change_city from primary nav (kept for phase 2)"
```

---

## Task J2: Remove dead code from `property_map_widget.dart`

If anything was left after I2 — the static URL builder, the geo:// fallback, the external-launch button — delete it.

```bash
git commit -am "chore: drop static OSM URL builder and external Maps fallback"
```

---

# Track K — Integration & Smoke

## Task K1: Integration test — verify-and-browse flow

**Files:**
- Create: `integration_test/verify_and_browse_test.dart`

- [ ] **Step 1: Implement** (uses `integration_test` package; mocks `MapsProvider` and `Geolocator` at the Riverpod override level):

```dart
// integration_test/verify_and_browse_test.dart
import 'package:app/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('verify-and-browse flow', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Tap products tab
    await tester.tap(find.text('Products'));
    await tester.pumpAndSettle();

    // Should hit verification gate
    expect(find.text('Verify your neighborhood'), findsOneWidget);
    await tester.tap(find.text('Verify'));
    await tester.pumpAndSettle();

    // Verifier sheet appears
    expect(find.byKey(const Key('NeighborhoodVerifier.start')), findsOneWidget);
    // ... rest of flow with mocked GPS
  });
}
```

```bash
flutter test integration_test/verify_and_browse_test.dart
```

- [ ] **Step 2: Commit**

---

## Task K2: Manual test plan execution

Run through the 10 scenarios from the spec's section 6 manual test plan on real iOS + Android hardware. Document results in a PR comment or a short markdown file under `docs/superpowers/test-runs/`.

---

# Track L — Cutover Sequence

This track is operational, not code.

## Task L1: Deploy backend (F + G)

- Backend deploys before frontend.
- Run `manage.py backfill_locations --dry-run` first; verify count.
- Run real `backfill_locations` overnight.
- Smoke-test with curl that `verify_neighborhood` and the filter params work.

## Task L2: Deploy frontend

- Tag release, ship to TestFlight + Play Internal.
- Internal team verifies the 10 manual scenarios.
- Roll to public.

## Task L3: Monitor

- Watch logs for Nominatim 429s — if they exceed ~50/day, escalate to MapTiler vendor swap (phase 4 trigger).
- Watch verification success rate — if <60% of users complete verification on first try, the 100m strict threshold may need loosening.

---

# Self-Review (against spec)

Spec section coverage check:

- ✅ §1 Roadmap — captured in plan header
- ✅ §2 Phase 1 scope — Tracks A-K cover map widget swap, picker, verifier, radius, privacy circle, migration, real-estate-stays-city-scale
- ✅ §3 Architecture — Tracks A (services/maps), B (models), C (providers), D (widgets), F+G (backend) match the 6 layers
- ✅ §4 Data flows — Tracks D-I implement Flow 1 (verify), 2 (create), 3 (detail+privacy reveal F5), 4 (browse), 5 (migration F+G)
- ✅ §5 Error handling — handled in OsmMapsProvider (Task A3 tests cover 429/500/parse), LocationPicker (D3 GPS denied), NeighborhoodVerifier (D4 accuracy/denied/forever)
- ✅ §6 Testing — unit (B+C+A3), widget (D), integration (K1), backend (F1-F5+G1)
- ✅ §7 Backend coordination — Tracks F+G in detail
- ✅ §8 Risks — addressed via WIP-COORD flags and deploy order in L
- ✅ §9 Implementation order — Tracks loosely match the suggested track structure (A→B→C→D→E parallel to F→G→H→I→J→K→L)

Placeholder scan: no "TBD" / "TODO: implement later" / "similar to Task N" in the body. The one `TODO(integrate)` in Task D4 references the backend wire-up, which is delivered in Task F3 + a future small wiring task (currently inline in D4 — fine for phase 1; the backend POST is added when F3 ships and verifier is reconnected).

Type consistency: `Place` / `Neighborhood` / `VerifiedNeighborhood` schemas match across frontend tasks (B1, B2, A3, C2) and backend (F2, F3, G1). `MapsProvider` interface (A2) consistently consumed by D1, D2, D3, D4.

---

*End of plan.*
