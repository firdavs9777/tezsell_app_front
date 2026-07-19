import 'dart:async';

import 'package:app/l10n/app_localizations.dart';
import 'package:app/providers/provider_models/real_estate.dart';
import 'package:app/providers/provider_root/real_estate_provider.dart';
import 'package:app/widgets/maps/cluster_badge.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

/// Karrot-style map browse for real estate (Plan B Task 4). Fetches
/// lightweight pins for the current viewport via the backend's
/// `PropertyMapBoundsView` (`/real_estate/api/map/bounds/`), debounced on
/// camera movement, and shows compact price-pill markers. Tapping a pin
/// opens a bottom preview card; tapping the card navigates to the detail page.
class RealEstateMapView extends ConsumerStatefulWidget {
  const RealEstateMapView({
    super.key,
    required this.initialCenter,
    this.initialZoom = 13.0,
    this.propertyType,
    this.listingType,
  });

  final LatLng initialCenter;
  final double initialZoom;

  /// Empty/null means "all" — mirrors the `_selectedPropertyType` /
  /// `_selectedListingType` tab state owned by [RealEstateMain].
  final String? propertyType;
  final String? listingType;

  @override
  ConsumerState<RealEstateMapView> createState() => _RealEstateMapViewState();
}

class _RealEstateMapViewState extends ConsumerState<RealEstateMapView> {
  final MapController _controller = MapController();
  Timer? _debounce;
  int _fetchGeneration = 0;
  bool _errorSnackbarShowing = false;
  bool _hasFetchedOnce = false;

  List<RealEstateMapPin> _pins = [];
  RealEstateMapPin? _selected;
  bool _isLoading = false;

  /// Tracks the selected pin id independently of the marker list so tapping a
  /// pin doesn't force a rebuild of all (up to 1000) markers — only the tiny
  /// `_PricePillMarker` subtree listening on this notifier repaints.
  final ValueNotifier<String?> _selectedIdNotifier = ValueNotifier<String?>(
    null,
  );

  // Memoized marker list, rebuilt only when `_pins` gets a new list identity
  // (i.e. after a fresh bounds fetch), not on every build triggered by
  // selection/loading-state changes.
  List<RealEstateMapPin>? _memoPinsRef;
  List<Marker>? _memoMarkers;

  List<Marker> get _markers {
    if (!identical(_memoPinsRef, _pins)) {
      _memoPinsRef = _pins;
      _memoMarkers = _pins
          .map((pin) => Marker(
                point: LatLng(pin.latitude, pin.longitude),
                width: 84,
                height: 40,
                alignment: Alignment.bottomCenter,
                child: _PricePillMarker(
                  pin: pin,
                  selectedId: _selectedIdNotifier,
                  onTap: () => _select(pin),
                ),
              ))
          .toList();
    }
    return _memoMarkers!;
  }

  void _select(RealEstateMapPin? pin) {
    setState(() => _selected = pin);
    _selectedIdNotifier.value = pin?.id;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    _selectedIdNotifier.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant RealEstateMapView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.propertyType != widget.propertyType ||
        oldWidget.listingType != widget.listingType) {
      // Filter tab changed while map is open — refetch using the CURRENT
      // viewport (not the initial center), so the user doesn't lose their pan.
      _fetchBounds(_controller.camera.visibleBounds);
    } else if (oldWidget.initialCenter != widget.initialCenter) {
      // Parent picked a new center (e.g. active neighborhood changed).
      _controller.move(widget.initialCenter, widget.initialZoom);
    }
  }

  void _onPositionChanged(MapPosition position, bool hasGesture) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      final bounds = position.bounds ?? _controller.camera.visibleBounds;
      _fetchBounds(bounds);
    });
  }

  Future<void> _fetchBounds(LatLngBounds bounds) async {
    final generation = ++_fetchGeneration;
    if (mounted) setState(() => _isLoading = true);

    try {
      final pins = await ref.read(realEstateServiceProvider).getMapBounds(
            north: bounds.north,
            south: bounds.south,
            east: bounds.east,
            west: bounds.west,
            propertyType: widget.propertyType,
            listingType: widget.listingType,
          );

      if (!mounted || generation != _fetchGeneration) return;
      setState(() {
        _pins = pins;
        _isLoading = false;
        _hasFetchedOnce = true;
        // Drop the preview if the selected pin scrolled out of the new set.
        if (_selected != null && !pins.any((p) => p.id == _selected!.id)) {
          _selected = null;
          _selectedIdNotifier.value = null;
        }
      });
    } catch (e) {
      if (!mounted || generation != _fetchGeneration) return;
      setState(() {
        _isLoading = false;
        _hasFetchedOnce = true;
      });
      _showErrorOnce();
    }
  }

  void _showErrorOnce() {
    if (_errorSnackbarShowing || !mounted) return;
    _errorSnackbarShowing = true;
    final messenger = ScaffoldMessenger.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    messenger
        .showSnackBar(SnackBar(
          content: Text(
            AppLocalizations.of(context)?.mapLoadError ??
                'Could not load properties on the map',
          ),
          backgroundColor: colorScheme.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ))
        .closed
        .then((_) {
      if (mounted) _errorSnackbarShowing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        FlutterMap(
          mapController: _controller,
          options: MapOptions(
            initialCenter: widget.initialCenter,
            initialZoom: widget.initialZoom,
            onTap: (_, __) => _select(null),
            onPositionChanged: _onPositionChanged,
            onMapReady: () =>
                _fetchBounds(_controller.camera.visibleBounds),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'SabziMarketApp/1.0',
            ),
            MarkerClusterLayerWidget(
              options: MarkerClusterLayerOptions(
                maxClusterRadius: 70,
                size: const Size(48, 48),
                markers: _markers,
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
        if (_isLoading)
          Positioned(
            top: 12,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: theme.shadowColor.withValues(alpha: 0.15),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ),
          ),
        if (_hasFetchedOnce && !_isLoading && _pins.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  AppLocalizations.of(context)?.browse_no_items_with_location ??
                      'No properties with location data in this area yet.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
                ),
              ),
            ),
          ),
        if (_selected != null)
          Positioned(
            left: 12,
            right: 12,
            bottom: 28,
            child: _PropertyPreviewCard(
              pin: _selected!,
              onTap: () => context.push('/real-estate/${_selected!.id}'),
            ),
          ),
      ],
    );
  }
}

/// Wraps [_PricePill] with a [ValueListenableBuilder] so tapping a pin only
/// repaints this one marker's subtree (via [selectedId]) instead of forcing
/// the memoized [_RealEstateMapViewState._markers] list to rebuild.
class _PricePillMarker extends StatelessWidget {
  const _PricePillMarker({
    required this.pin,
    required this.selectedId,
    required this.onTap,
  });

  final RealEstateMapPin pin;
  final ValueListenable<String?> selectedId;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String?>(
      valueListenable: selectedId,
      builder: (context, selected, _) => GestureDetector(
        onTap: onTap,
        child: _PricePill(
          label: pin.priceLabel,
          selected: selected == pin.id,
          featured: pin.isFeatured,
        ),
      ),
    );
  }
}

/// Compact "$420"-style price pill marker.
class _PricePill extends StatelessWidget {
  const _PricePill({
    required this.label,
    required this.selected,
    required this.featured,
  });

  final String label;
  final bool selected;
  final bool featured;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final background = selected
        ? colorScheme.primary
        : featured
            ? colorScheme.tertiary
            : colorScheme.surface;
    final foreground = selected || featured
        ? colorScheme.onPrimary
        : colorScheme.primary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: background,
          elevation: selected ? 4 : 2,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: selected ? colorScheme.primary : colorScheme.outline,
                width: selected ? 1.5 : 1,
              ),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: foreground,
              ),
            ),
          ),
        ),
        Icon(
          Icons.arrow_drop_down,
          size: 18,
          color: selected ? colorScheme.primary : background,
        ),
      ],
    );
  }
}

class _PropertyPreviewCard extends StatelessWidget {
  const _PropertyPreviewCard({required this.pin, required this.onTap});

  final RealEstateMapPin pin;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: theme.cardColor,
      elevation: 6,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: pin.mainImage != null && pin.mainImage!.isNotEmpty
                    ? Image.network(
                        pin.mainImage!,
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _placeholder(theme),
                      )
                    : _placeholder(theme),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pin.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      pin.priceDisplay,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.bed,
                            size: 14,
                            color: theme.colorScheme.onSurfaceVariant),
                        const SizedBox(width: 3),
                        Text('${pin.bedrooms}',
                            style: theme.textTheme.bodySmall),
                        const SizedBox(width: 10),
                        Icon(Icons.square_foot,
                            size: 14,
                            color: theme.colorScheme.onSurfaceVariant),
                        const SizedBox(width: 3),
                        Text('${pin.squareMeters}m²',
                            style: theme.textTheme.bodySmall),
                        if (pin.district.isNotEmpty || pin.city.isNotEmpty) ...[
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              pin.district.isNotEmpty ? pin.district : pin.city,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ],
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

  Widget _placeholder(ThemeData theme) => Container(
        width: 64,
        height: 64,
        color: theme.colorScheme.surfaceContainerHighest,
        child: Icon(Icons.apartment,
            color: theme.colorScheme.onSurfaceVariant),
      );
}
