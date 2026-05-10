import 'package:app/l10n/app_localizations.dart';
import 'package:app/providers/provider_models/place.dart';
import 'package:app/providers/provider_root/maps_provider_provider.dart';
import 'package:app/services/maps/maps_exceptions.dart';
import 'package:app/widgets/maps/place_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class LocationPicker extends ConsumerStatefulWidget {
  final LatLng initialCenter;
  final double initialZoom;
  final ValueChanged<Place> onConfirmed;

  const LocationPicker({
    super.key,
    required this.initialCenter,
    required this.onConfirmed,
    this.initialZoom = 14,
  });

  @override
  ConsumerState<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends ConsumerState<LocationPicker> {
  final _mapController = MapController();
  late LatLng _pin;
  Place? _resolvedPlace;
  bool _resolving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _pin = widget.initialCenter;
    _resolveCenter();
  }

  Future<void> _resolveCenter() async {
    setState(() {
      _resolving = true;
      _error = null;
    });
    try {
      final p = await ref.read(mapsProviderProvider).reverseGeocode(_pin);
      if (!mounted) return;
      setState(() {
        _resolvedPlace = p;
        _resolving = false;
      });
    } on MapsException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _resolving = false;
      });
    }
  }

  void _onMapTap(LatLng latLng) {
    setState(() => _pin = latLng);
    _resolveCenter();
  }

  Future<void> _useCurrentLocation() async {
    try {
      final perm = await Geolocator.requestPermission();
      if (perm == LocationPermission.denied ||
          perm == LocationPermission.deniedForever) {
        if (!mounted) return;
        final l = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(l?.location_permission_denied ??
                  'Location permission denied')),
        );
        return;
      }
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      if (!mounted) return;
      final newPin = LatLng(pos.latitude, pos.longitude);
      setState(() => _pin = newPin);
      _mapController.move(newPin, 16);
      await _resolveCenter();
    } catch (e) {
      if (!mounted) return;
      final l = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(l?.gps_error(e.toString()) ?? 'GPS error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(mapsProviderProvider);
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
          title: Text(l?.location_picker_title ?? 'Set location')),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: widget.initialCenter,
              initialZoom: widget.initialZoom,
              onTap: (_, ll) => _onMapTap(ll),
            ),
            children: [
              TileLayer(
                urlTemplate: provider.tileUrlTemplate,
                subdomains: provider.tileSubdomains,
                userAgentPackageName: provider.userAgent,
              ),
              MarkerLayer(markers: [
                Marker(
                  point: _pin,
                  width: 50,
                  height: 50,
                  child: Icon(Icons.location_on,
                      size: 50, color: theme.colorScheme.error),
                ),
              ]),
            ],
          ),
          Positioned(
            top: 8,
            left: 8,
            right: 8,
            child: Material(
              elevation: 4,
              child: PlaceSearchField(
                near: _pin,
                onSelected: (p) {
                  setState(() {
                    _pin = LatLng(p.lat, p.lng);
                    _resolvedPlace = p;
                  });
                  _mapController.move(_pin, 16);
                },
              ),
            ),
          ),
          Positioned(
            bottom: 120,
            right: 16,
            child: FloatingActionButton(
              key: const Key('LocationPicker.gps'),
              onPressed: _useCurrentLocation,
              child: const Icon(Icons.my_location),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Material(
              elevation: 8,
              color: theme.colorScheme.surface,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_resolving)
                      const LinearProgressIndicator()
                    else if (_error != null)
                      Text(
                        l?.location_picker_resolve_failed ??
                            "Couldn't resolve address — pick again or confirm with coordinates only",
                        style: TextStyle(color: theme.colorScheme.error),
                      )
                    else if (_resolvedPlace != null)
                      Text(
                        _resolvedPlace!.formattedAddress ??
                            l?.location_picker_selected_fallback ??
                            'Selected location',
                        style: theme.textTheme.bodyLarge,
                      ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      key: const Key('LocationPicker.confirm'),
                      onPressed: _resolvedPlace == null
                          ? null
                          : () => widget.onConfirmed(_resolvedPlace!),
                      child: Text(
                          l?.location_picker_confirm ?? 'Confirm location'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
