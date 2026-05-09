import 'package:app/providers/provider_models/neighborhood.dart';
import 'package:app/providers/provider_models/place.dart';
import 'package:latlong2/latlong.dart';

abstract class MapsProvider {
  Future<List<Place>> searchPlaces(
    String query, {
    LatLng? near,
    String? sessionToken,
  });

  Future<Place> reverseGeocode(LatLng latLng);

  Future<Place> forwardGeocode(String address);

  Future<Neighborhood?> getNeighborhood(LatLng latLng);

  String get tileUrlTemplate;

  List<String> get tileSubdomains;

  String get attribution;

  String get userAgent;

  String get providerName;
}
