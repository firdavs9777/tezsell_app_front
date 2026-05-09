import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:app/providers/provider_models/real_estate.dart';
import 'package:app/widgets/maps/map_view.dart';
import 'package:latlong2/latlong.dart';

class PropertyMapWidget extends StatefulWidget {
  final RealEstate property;
  final double height;
  final bool showControls;
  final VoidCallback? onFullscreenToggle;

  const PropertyMapWidget({
    Key? key,
    required this.property,
    this.height = 300,
    this.showControls = true,
    this.onFullscreenToggle,
  }) : super(key: key);

  @override
  State<PropertyMapWidget> createState() => _PropertyMapWidgetState();
}

class _PropertyMapWidgetState extends State<PropertyMapWidget> {
  double? get _latitude {
    final lat = double.tryParse(widget.property.latitude ?? '0');
    return (lat != null && lat != 0.0) ? lat : null;
  }

  double? get _longitude {
    final lng = double.tryParse(widget.property.longitude ?? '0');
    return (lng != null && lng != 0.0) ? lng : null;
  }

  bool get _hasValidCoordinates => _latitude != null && _longitude != null;

  Future<void> _openInMaps() async {
    if (!_hasValidCoordinates) return;

    final lat = _latitude!;
    final lng = _longitude!;

    // Simple Google Maps URL that works on both iOS and Android
    final mapsUrl =
        Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');

    try {
      if (await canLaunchUrl(mapsUrl)) {
        await launchUrl(mapsUrl, mode: LaunchMode.externalApplication);
      } else {
        // Fallback to geo: URI scheme
        final geoUrl = Uri.parse('geo:$lat,$lng?q=$lat,$lng');
        await launchUrl(geoUrl, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      print('Error opening maps: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: _hasValidCoordinates
            ? Stack(
                children: [
                  // Interactive flutter_map (real estate always shows exact pin)
                  Positioned.fill(
                    child: MapView(
                      center: LatLng(_latitude!, _longitude!),
                      mode: MapViewMode.exact,
                      height: widget.height,
                    ),
                  ),
                  // Overlay with location info
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.7),
                          ],
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.location_on,
                                  color: Colors.white, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  widget.property.address,
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: _openInMaps,
                                  icon: const Icon(Icons.directions, size: 18),
                                  label: const Text('Get Directions'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 12),
                                  ),
                                ),
                              ),
                              if (widget.onFullscreenToggle != null) ...[
                                const SizedBox(width: 8),
                                IconButton(
                                  onPressed: widget.onFullscreenToggle,
                                  icon: const Icon(Icons.fullscreen,
                                      color: Colors.white),
                                  style: IconButton.styleFrom(
                                    backgroundColor:
                                        Colors.white.withValues(alpha: 0.2),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : _buildNoLocationView(),
      ),
    );
  }

  Widget _buildFallbackMap() {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      color: colorScheme.surfaceContainerHighest,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.map, size: 64, color: colorScheme.onSurfaceVariant),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                widget.property.address,
                style: textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${widget.property.district}, ${widget.property.city}',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _openInMaps,
              icon: const Icon(Icons.directions, size: 18),
              label: const Text('Open in Maps'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoLocationView() {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      color: colorScheme.surfaceContainerHighest,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_off, size: 64, color: colorScheme.onSurfaceVariant),
            const SizedBox(height: 16),
            Text(
              'Location not available',
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                widget.property.address,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FullscreenMapModal extends StatelessWidget {
  final RealEstate property;
  final VoidCallback onClose;

  const FullscreenMapModal({
    Key? key,
    required this.property,
    required this.onClose,
  }) : super(key: key);

  double? get _latitude {
    final lat = double.tryParse(property.latitude ?? '0');
    return (lat != null && lat != 0.0) ? lat : null;
  }

  double? get _longitude {
    final lng = double.tryParse(property.longitude ?? '0');
    return (lng != null && lng != 0.0) ? lng : null;
  }

  bool get _hasValidCoordinates => _latitude != null && _longitude != null;

  Future<void> _openInMaps() async {
    if (!_hasValidCoordinates) return;

    final lat = _latitude!;
    final lng = _longitude!;

    final mapsUrl =
        Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');

    try {
      if (await canLaunchUrl(mapsUrl)) {
        await launchUrl(mapsUrl, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      print('Error opening maps: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black.withValues(alpha: 0.7),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: onClose,
        ),
        title: Text(
          property.address,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.directions, color: Colors.white),
            onPressed: _openInMaps,
            tooltip: 'Get Directions',
          ),
        ],
      ),
      body: Center(
        child: _hasValidCoordinates
            ? MapView(
                center: LatLng(_latitude!, _longitude!),
                mode: MapViewMode.exact,
                height: MediaQuery.of(context).size.height,
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.location_off, size: 80, color: Colors.white),
                  const SizedBox(height: 16),
                  Text(
                    'Location coordinates not available',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
                  ),
                ],
              ),
      ),
    );
  }
}
