import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
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

/// Onboarding location setup — Karrot-style map-first replacement for the
/// country/region/district dropdown chain. Auto-launches picker, server-
/// verifies the pick, persists as the active browse neighborhood, then
/// navigates to /tabs. Reachable after social sign-in for users without
/// a stored location.
class LocationSetupScreen extends ConsumerStatefulWidget {
  const LocationSetupScreen({super.key});

  @override
  ConsumerState<LocationSetupScreen> createState() =>
      _LocationSetupScreenState();
}

class _LocationSetupScreenState
    extends ConsumerState<LocationSetupScreen> {
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
      _pickerLaunched = false;
      setState(() => _error =
          'A location is required to continue. Tap Pick again.');
      return;
    }
    await _resolveAndContinue(result);
  }

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

  Future<void> _resolveAndContinue(Place place) async {
    setState(() {
      _resolving = true;
      _error = null;
    });
    try {
      Neighborhood? neighborhood;
      try {
        neighborhood = await VerifyNeighborhoodService().verify(
          lat: place.lat,
          lng: place.lng,
          gpsAccuracyM: 250.0,
          lowConfidence: true,
        );
      } on MapsException catch (_) {
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

      // Karrot two-neighborhood model — onboarding picks the FIRST entry,
      // user can add a second later via /change-city. FIFO-evict if user
      // somehow has stale entries from earlier installs.
      await ref.read(verifiedNeighborhoodsProvider.notifier).addEvictingOldest(
            VerifiedNeighborhood(
              neighborhood: neighborhood,
              verifiedAt: DateTime.now(),
              gpsAccuracyM: 250.0,
              lowConfidence: true,
            ),
          );
      final list = ref.read(verifiedNeighborhoodsProvider);
      final newIdx =
          list.indexWhere((v) => v.neighborhood.id == neighborhood!.id);
      ref.read(activeNeighborhoodIndexProvider.notifier).state =
          newIdx >= 0 ? newIdx : list.length - 1;

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('userLocation');
      await prefs.remove('localRegionName');
      await prefs.remove('localDistrictName');
      await prefs.setString(
          'localCountryCode', (place.countryCode ?? '').toUpperCase());

      if (!mounted) return;
      context.go('/tabs');
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
        title:
            Text(localizations?.map_register_title ?? 'Where do you live?'),
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
                  Icon(Icons.location_off,
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
