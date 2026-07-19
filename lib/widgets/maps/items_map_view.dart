import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';

import 'cluster_badge.dart';

class MappedItem {
  MappedItem({
    required this.id,
    required this.lat,
    required this.lng,
    required this.title,
    required this.subtitle,
    this.imageUrl,
    required this.onTap,
  });

  final String id;
  final double lat;
  final double lng;
  final String title;
  final String subtitle;
  final String? imageUrl;
  final VoidCallback onTap;
}

class ItemsMapView extends StatefulWidget {
  const ItemsMapView({
    super.key,
    required this.items,
    this.initialCenter,
    this.initialZoom = 12.0,
    this.userAgent = 'SabziMarketApp/1.0',
  });

  final List<MappedItem> items;
  final LatLng? initialCenter;
  final double initialZoom;
  final String userAgent;

  @override
  State<ItemsMapView> createState() => _ItemsMapViewState();
}

class _ItemsMapViewState extends State<ItemsMapView> {
  final _controller = MapController();
  MappedItem? _selected;

  LatLng _center() {
    if (widget.initialCenter != null) return widget.initialCenter!;
    if (widget.items.isNotEmpty) {
      final first = widget.items.first;
      return LatLng(first.lat, first.lng);
    }
    return const LatLng(41.3, 69.24);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      children: [
        FlutterMap(
          mapController: _controller,
          options: MapOptions(
            initialCenter: _center(),
            initialZoom: widget.initialZoom,
            onTap: (_, __) => setState(() => _selected = null),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: widget.userAgent,
            ),
            MarkerClusterLayerWidget(
              options: MarkerClusterLayerOptions(
                maxClusterRadius: 80,
                size: const Size(44, 44),
                markers: widget.items
                    .map((item) => Marker(
                          point: LatLng(item.lat, item.lng),
                          width: 44,
                          height: 44,
                          child: GestureDetector(
                            onTap: () => setState(() => _selected = item),
                            child: Icon(
                              Icons.location_on,
                              size: 40,
                              color: _selected?.id == item.id
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.error,
                            ),
                          ),
                        ))
                    .toList(),
                builder: (context, markers) =>
                    ClusterBadge(count: markers.length),
              ),
            ),
          ],
        ),
        Positioned(
          right: 8,
          bottom: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            color: Colors.white.withValues(alpha: 0.85),
            child: const Text(
              '© OpenStreetMap',
              style: TextStyle(fontSize: 10),
            ),
          ),
        ),
        if (_selected != null)
          Positioned(
            left: 12,
            right: 12,
            bottom: 28,
            child: _PreviewCard(item: _selected!),
          ),
      ],
    );
  }
}

class _PreviewCard extends StatelessWidget {
  const _PreviewCard({required this.item});

  final MappedItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.cardColor,
      elevation: 6,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: item.onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              if (item.imageUrl != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    item.imageUrl!,
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 64,
                      height: 64,
                      color: theme.colorScheme.surfaceContainerHighest,
                      child: const Icon(Icons.image_not_supported),
                    ),
                  ),
                ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
