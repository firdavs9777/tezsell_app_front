import 'dart:math' as math;

import 'package:app/l10n/app_localizations.dart';
import 'package:app/providers/provider_root/active_neighborhood_provider.dart';
import 'package:app/providers/provider_root/maps_provider_provider.dart';
import 'package:app/providers/provider_root/radius_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

/// Advanced radius picker: a draggable bottom sheet with a live map preview
/// of the search radius. Opened from the quick-preset chip row
/// (`radius_slider.dart`) via a trailing "tune" chip — the presets remain
/// the fast path, this sheet is for dialing in a custom value while seeing
/// it on the map.
class RadiusPickerSheet extends ConsumerStatefulWidget {
  const RadiusPickerSheet({super.key});

  /// Opens the sheet as a modal bottom sheet, draggable to ~65% height.
  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const RadiusPickerSheet(),
    );
  }

  @override
  ConsumerState<RadiusPickerSheet> createState() => _RadiusPickerSheetState();
}

class _RadiusPickerSheetState extends ConsumerState<RadiusPickerSheet> {
  static const double _minKm = 1.0;
  static const double _maxKm = 20.0;
  static const int _divisions = 38;

  late double _km;
  late bool _cityWide;
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    final current = ref.read(radiusProvider);
    _cityWide = current.isInfinite;
    _km = _cityWide ? 5.0 : current.clamp(_minKm, _maxKm);
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  /// Simple log2-based zoom-fit: halving the radius should roughly zoom in
  /// one level so the circle keeps filling the small preview map.
  double _zoomForRadiusKm(double km) {
    final zoom = 16 - (math.log(km) / math.ln2);
    return zoom.clamp(3.0, 17.0);
  }

  void _onSliderChanged(double value) {
    setState(() => _km = value);
    final center = ref.read(activeNeighborhoodProvider);
    if (center != null) {
      _mapController.move(
        LatLng(center.neighborhood.centroidLat, center.neighborhood.centroidLng),
        _zoomForRadiusKm(_km),
      );
    }
  }

  void _apply() {
    ref.read(radiusProvider.notifier).set(_cityWide ? double.infinity : _km);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final activeNbhd = ref.watch(activeNeighborhoodProvider);
    final mapsProvider = ref.watch(mapsProviderProvider);

    final center = activeNbhd == null
        ? null
        : LatLng(
            activeNbhd.neighborhood.centroidLat,
            activeNbhd.neighborhood.centroidLng,
          );

    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SafeArea(
            top: false,
            child: ListView(
              controller: scrollController,
              padding: EdgeInsets.zero,
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 12, bottom: 8),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    l.radiusPickerTitle,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                const SizedBox(height: 12),
                if (center != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: SizedBox(
                        height: 180,
                        child: IgnorePointer(
                          child: FlutterMap(
                            mapController: _mapController,
                            options: MapOptions(
                              initialCenter: center,
                              initialZoom: _zoomForRadiusKm(_km),
                              interactionOptions: const InteractionOptions(
                                flags: InteractiveFlag.none,
                              ),
                            ),
                            children: [
                              TileLayer(
                                urlTemplate: mapsProvider.tileUrlTemplate,
                                subdomains: mapsProvider.tileSubdomains,
                                userAgentPackageName: mapsProvider.userAgent,
                              ),
                              if (!_cityWide)
                                CircleLayer(
                                  circles: [
                                    CircleMarker(
                                      key: const Key(
                                          'RadiusPickerSheet.circle'),
                                      point: center,
                                      radius: _km * 1000,
                                      useRadiusInMeter: true,
                                      color: theme.colorScheme.primary
                                          .withValues(alpha: 0.18),
                                      borderColor: theme.colorScheme.primary
                                          .withValues(alpha: 0.6),
                                      borderStrokeWidth: 2,
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _cityWide
                              ? l.radiusCityWide
                              : l.radius_slider_km(_km.toStringAsFixed(1)),
                          style: theme.textTheme.bodyLarge,
                        ),
                      ),
                      ChoiceChip(
                        label: Text(l.radiusCityWide),
                        selected: _cityWide,
                        onSelected: (selected) {
                          setState(() => _cityWide = selected);
                          if (!selected) {
                            _onSliderChanged(_km);
                          }
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Slider(
                    value: _km,
                    min: _minKm,
                    max: _maxKm,
                    divisions: _divisions,
                    label: '${_km.toStringAsFixed(1)} km',
                    onChanged: _cityWide ? null : _onSliderChanged,
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _apply,
                      child: Text(l.radiusApply),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}
