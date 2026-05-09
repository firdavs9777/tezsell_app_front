import 'package:app/services/maps/maps_provider.dart';
import 'package:app/services/maps/osm_maps_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The active MapsProvider for the app. Phase 1: always OSM.
/// Phase 4: swap to GoogleMapsProvider / MapTilerProvider here without
/// touching any UI consumer.
final mapsProviderProvider = Provider<MapsProvider>((ref) {
  return OsmMapsProvider();
});
