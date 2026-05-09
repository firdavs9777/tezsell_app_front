import 'dart:async';
import 'dart:convert';

import 'package:app/providers/provider_models/neighborhood.dart';
import 'package:app/providers/provider_models/place.dart';
import 'package:app/services/maps/maps_exceptions.dart';
import 'package:app/services/maps/maps_provider.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class OsmMapsProvider extends MapsProvider {
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
    final pidPart = place.placeId ??
        '${latLng.latitude.toStringAsFixed(4)},${latLng.longitude.toStringAsFixed(4)}';
    final id = '${place.countryCode}:$pidPart';
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
