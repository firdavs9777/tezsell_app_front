import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:app/l10n/app_localizations.dart';
import 'package:app/providers/provider_models/neighborhood.dart';
import 'package:app/providers/provider_models/place.dart';
import 'package:app/providers/provider_root/active_neighborhood_provider.dart';
import 'package:app/providers/provider_root/maps_provider_provider.dart';
import 'package:app/providers/provider_root/verified_neighborhoods_provider.dart';
import 'package:app/services/maps/maps_exceptions.dart';
import 'package:app/services/maps/verify_neighborhood_service.dart';
import 'package:app/widgets/maps/location_picker.dart';

/// Karrot-style map-first location filter.
/// Auto-launches the picker; on confirm, server-verifies the pick (with
/// low_confidence=true since map picks aren't GPS), persists it as the
/// active browse-neighborhood, and clears legacy district keys so subsequent
/// browse fetches use the neighborhood_id + radius_km query path.
/// The radius slider in the browse pages controls the radius.
class MapLocationFilterPage extends ConsumerStatefulWidget {
  const MapLocationFilterPage({super.key});

  @override
  ConsumerState<MapLocationFilterPage> createState() =>
      _MapLocationFilterPageState();
}

class _MapLocationFilterPageState
    extends ConsumerState<MapLocationFilterPage> {
  bool _resolving = false;
  String? _error;
  bool _pickerLaunched = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _openPicker());
  }

  Future<void> _openPicker() async {
    if (_pickerLaunched) return;
    _pickerLaunched = true;
    final initial = await _detectInitialCenter();
    if (!mounted) return;
    final result = await Navigator.of(context).push<Place>(
      MaterialPageRoute(
        builder: (_) => LocationPicker(
          initialCenter: initial,
          onConfirmed: (p) => Navigator.of(context).pop(p),
        ),
      ),
    );
    if (!mounted) return;
    if (result == null) {
      // User backed out without picking → pop the wrapper too.
      Navigator.of(context).pop(false);
      return;
    }
    await _resolveAndSave(result);
  }

  /// GPS-first center; fall back to Tashkent only if denied/unavailable.
  Future<LatLng> _detectInitialCenter() async {
    try {
      final perm = await Geolocator.requestPermission();
      if (perm == LocationPermission.always ||
          perm == LocationPermission.whileInUse) {
        final pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium,
          timeLimit: const Duration(seconds: 6),
        );
        return LatLng(pos.latitude, pos.longitude);
      }
    } catch (_) {}
    return const LatLng(41.3, 69.24);
  }

  Future<void> _resolveAndSave(Place place) async {
    setState(() {
      _resolving = true;
      _error = null;
    });
    try {
      // Try server-verify first so the resulting neighborhood id is one the
      // backend recognizes. Map picks aren't GPS → low_confidence=true.
      Neighborhood? neighborhood;
      try {
        neighborhood = await VerifyNeighborhoodService().verify(
          lat: place.lat,
          lng: place.lng,
          gpsAccuracyM: 250.0,
          lowConfidence: true,
        );
      } on MapsException catch (_) {
        // Backend unavailable / rate-limited / out-of-coverage. Synthesize
        // a Neighborhood locally so the radius filter still works
        // client-side until a future verify succeeds.
        neighborhood = await ref
            .read(mapsProviderProvider)
            .getNeighborhood(LatLng(place.lat, place.lng));
        neighborhood ??= Neighborhood(
          id: '${(place.countryCode ?? 'XX').toUpperCase()}:'
              '${place.placeId ?? 'pick-${place.lat.toStringAsFixed(4)}-${place.lng.toStringAsFixed(4)}'}',
          name: place.city ?? place.region ?? 'Picked location',
          displayName: place.formattedAddress ??
              '${place.lat.toStringAsFixed(4)}, ${place.lng.toStringAsFixed(4)}',
          countryCode: (place.countryCode ?? 'XX').toUpperCase(),
          region: place.region ?? '',
          city: place.city ?? '',
          centroidLat: place.lat,
          centroidLng: place.lng,
        );
      }

      // Browse filter is "where I'm looking right now" — distinct from the
      // GPS-verified "where I live" identity. Clear stale browse entries
      // (e.g. a US: pick from earlier simulator testing) so the fresh pick
      // is canonical and at index 0. The user can still re-verify a home
      // neighborhood later via the profile flow.
      await ref.read(verifiedNeighborhoodsProvider.notifier).clear();
      await ref.read(verifiedNeighborhoodsProvider.notifier).add(
            VerifiedNeighborhood(
              neighborhood: neighborhood,
              verifiedAt: DateTime.now(),
              gpsAccuracyM: 250.0,
              lowConfidence: true,
            ),
          );
      ref.read(activeNeighborhoodIndexProvider.notifier).state = 0;

      // Clear legacy district keys so browse pages take the
      // neighborhood + radius path (Karrot) instead of district-only.
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('userLocation');
      await prefs.remove('localRegionName');
      await prefs.remove('localDistrictName');
      await prefs.setString(
          'localCountryCode', (place.countryCode ?? '').toUpperCase());

      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      if (mounted) {
        setState(() {
          _resolving = false;
          _error = '$e';
          _pickerLaunched = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        title: Text(localizations?.map_register_title ?? 'Pick your area'),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_resolving) ...[
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(localizations?.resolving_location ?? 'Resolving…',
                      style: theme.textTheme.bodyMedium),
                ] else if (_error != null) ...[
                  Icon(Icons.error_outline,
                      size: 48, color: colorScheme.error),
                  const SizedBox(height: 12),
                  Text(_error!, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _openPicker,
                    icon: const Icon(Icons.map_outlined),
                    label:
                        Text(localizations?.pick_again ?? 'Pick again'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
