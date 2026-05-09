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
              ),
              if (mode == MapViewMode.approximate)
                CircleLayer(
                  circles: [
                    CircleMarker(
                      key: const Key('MapView.approxCircle'),
                      point: center,
                      radius: approximateRadiusMeters,
                      useRadiusInMeter: true,
                      color:
                          theme.colorScheme.primary.withValues(alpha: 0.18),
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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
