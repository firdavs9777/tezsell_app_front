import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:app/providers/provider_models/real_estate.dart';

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

  String get _mapImageUrl {
    if (!_hasValidCoordinates) return '';

    final lat = _latitude!;
    final lng = _longitude!;
    final zoom = 15;
    final width = 600;
    final height = 400;

    // Using OpenStreetMap Static Map
    return 'https://staticmap.openstreetmap.de/staticmap.php?center=$lat,$lng&zoom=$zoom&size=${width}x$height&markers=$lat,$lng,red-pushpin';
  }

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
                  // Static map image
                  Positioned.fill(
                    child: Image.network(
                      _mapImageUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Loading map...',
                                style: TextStyle(color: colorScheme.onSurfaceVariant),
                              ),
                            ],
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return _buildFallbackMap();
                      },
                    ),
                  ),
                  // Overlay with location info
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.location_on,
                                  color: Colors.white, size: 20),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  widget.property.address,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: _openInMaps,
                                  icon: Icon(Icons.directions, size: 18),
                                  label: Text('Get Directions'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 12),
                                  ),
                                ),
                              ),
                              if (widget.onFullscreenToggle != null) ...[
                                SizedBox(width: 8),
                                IconButton(
                                  onPressed: widget.onFullscreenToggle,
                                  icon: Icon(Icons.fullscreen,
                                      color: Colors.white),
                                  style: IconButton.styleFrom(
                                    backgroundColor:
                                        Colors.white.withOpacity(0.2),
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

    return Container(
      color: colorScheme.surfaceContainerHighest,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.map, size: 64, color: colorScheme.onSurfaceVariant),
            SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                widget.property.address,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '${widget.property.district}, ${widget.property.city}',
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _openInMaps,
              icon: Icon(Icons.directions, size: 18),
              label: Text('Open in Maps'),
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

    return Container(
      color: colorScheme.surfaceContainerHighest,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_off, size: 64, color: colorScheme.onSurfaceVariant),
            SizedBox(height: 16),
            Text(
              'Location not available',
              style: TextStyle(
                fontSize: 16,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                widget.property.address,
                style: TextStyle(
                  fontSize: 14,
                  color: colorScheme.onSurfaceVariant.withOpacity(0.7),
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
        backgroundColor: Colors.black.withOpacity(0.7),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.white),
          onPressed: onClose,
        ),
        title: Text(
          property.address,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.directions, color: Colors.white),
            onPressed: _openInMaps,
            tooltip: 'Get Directions',
          ),
        ],
      ),
      body: Center(
        child: _hasValidCoordinates
            ? InteractiveViewer(
                minScale: 0.5,
                maxScale: 4.0,
                child: Image.network(
                  'https://staticmap.openstreetmap.de/staticmap.php?center=${_latitude!},${_longitude!}&zoom=15&size=800x800&markers=${_latitude!},${_longitude!},red-pushpin',
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                        color: Colors.white,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.map, size: 80, color: Colors.white),
                        SizedBox(height: 16),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 32),
                          child: Text(
                            property.address,
                            style: TextStyle(color: Colors.white, fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: _openInMaps,
                          icon: Icon(Icons.directions),
                          label: Text('Open in Maps App'),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_off, size: 80, color: Colors.white),
                  SizedBox(height: 16),
                  Text(
                    'Location coordinates not available',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
      ),
    );
  }
}
