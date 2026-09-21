import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The [TileProvider] every map widget renders its base layer through.
///
/// Indirection exists for testability: the default [NetworkTileProvider]
/// issues real HTTP requests to tile.openstreetmap.org, so any widget test
/// that pumped a map reached the live network — slow, offline-hostile, and
/// noisy (rate-limited runs sprayed `ClientException ... status 400` through
/// the test log while still reporting a pass). Widget tests override this
/// with a provider that serves bytes from memory.
final mapTileProviderProvider = Provider<TileProvider>(
  (ref) => NetworkTileProvider(),
);
