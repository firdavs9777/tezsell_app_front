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
      final place = await provider.reverseGeocode(const LatLng(41.3, 69.24));
      expect(place.neighborhood, 'Yunusabad');
      expect(place.countryCode, 'UZ');
    });

    test('throws MapsRateLimitException on 429', () async {
      final client = _stubClient((_) => http.Response('rate limited', 429));
      final provider = OsmMapsProvider(client: client);
      expect(
        () => provider.reverseGeocode(const LatLng(0, 0)),
        throwsA(isA<MapsRateLimitException>()),
      );
    });

    test('throws MapsServerException on 5xx', () async {
      final client = _stubClient((_) => http.Response('boom', 503));
      final provider = OsmMapsProvider(client: client);
      expect(
        () => provider.reverseGeocode(const LatLng(0, 0)),
        throwsA(isA<MapsServerException>()),
      );
    });

    test('throws MapsParseException on garbage body', () async {
      final client = _stubClient((_) => http.Response('not json', 200));
      final provider = OsmMapsProvider(client: client);
      expect(
        () => provider.reverseGeocode(const LatLng(0, 0)),
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
                'geometry': {
                  'coordinates': [69.24, 41.3]
                },
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
      await provider.searchPlaces('cafe', near: const LatLng(41.3, 69.24));
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
      final nbhd = await provider.getNeighborhood(const LatLng(41.3, 69.24));
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
      final nbhd = await provider.getNeighborhood(const LatLng(0, 0));
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
