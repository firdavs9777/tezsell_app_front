import 'dart:convert';
import 'dart:typed_data';

import 'package:app/providers/provider_root/map_tile_provider.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A 1x1 fully transparent PNG, served for every tile request.
final Uint8List _transparentPixelPng = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA'
  '60e6kgAAAABJRU5ErkJggg==',
);

/// Serves every map tile from memory so widget tests never touch the network.
class FakeTileProvider extends TileProvider {
  @override
  ImageProvider getImage(TileCoordinates coordinates, TileLayer options) {
    return MemoryImage(_transparentPixelPng);
  }
}

/// Drop this into a `ProviderScope(overrides: ...)` in any test that pumps a
/// widget containing a map. Without it the real [NetworkTileProvider] fires
/// HTTP requests at tile.openstreetmap.org, making the test network-dependent
/// and filling the log with `ClientException ... status 400` noise.
Override fakeMapTilesOverride() {
  return mapTileProviderProvider.overrideWithValue(FakeTileProvider());
}
