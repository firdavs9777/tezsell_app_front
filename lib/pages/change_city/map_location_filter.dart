import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:app/l10n/app_localizations.dart';
import 'package:app/providers/provider_models/country_model.dart';
import 'package:app/providers/provider_models/location_model.dart';
import 'package:app/providers/provider_models/place.dart';
import 'package:app/providers/provider_root/active_neighborhood_provider.dart';
import 'package:app/service/country_service.dart';
import 'package:app/widgets/maps/location_picker.dart';

/// Map-first replacement for the legacy /change-city dropdown flow.
/// Auto-launches the picker on entry; on confirm, persists location to the
/// SharedPreferences keys legacy ChangeCity wrote AND deactivates any
/// verified-neighborhood (so a stale US: entry from earlier testing doesn't
/// override the user's fresh pick). Pops with `true` so callers refresh.
class MapLocationFilterPage extends ConsumerStatefulWidget {
  const MapLocationFilterPage({super.key});

  @override
  ConsumerState<MapLocationFilterPage> createState() =>
      _MapLocationFilterPageState();
}

class _MapLocationFilterPageState
    extends ConsumerState<MapLocationFilterPage> {
  final _service = CountryService();

  bool _resolving = false;
  String? _error;
  bool _pickerLaunched = false;

  @override
  void initState() {
    super.initState();
    // Auto-open the picker on entry — the page itself is just the resolution
    // host. No "Pick on map" button gating, no two-step UX.
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
      // User backed out without picking — pop the wrapper too with no result.
      Navigator.of(context).pop(false);
      return;
    }
    await _resolveAndSave(result);
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
    } catch (_) {
      // permission / GPS / timeout — fall through
    }
    return const LatLng(41.3, 69.24);
  }

  Future<void> _resolveAndSave(Place place) async {
    setState(() {
      _resolving = true;
      _error = null;
    });

    try {
      final country = _matchCountry(place.countryCode);
      final countryCode =
          country?.code ?? (place.countryCode ?? '').toUpperCase();

      Regions? region;
      Districts? district;
      if (country != null) {
        final regions = await _service.getRegions(country.code);
        region = _bestMatchRegion(regions, place);
        if (region != null) {
          final districts = await _service.getDistricts(region.id);
          district = _bestMatchDistrict(districts, place);
        }
      }

      final regionName = region?.region ?? place.region ?? place.city ?? '';
      final districtName =
          district?.district ?? place.city ?? place.region ?? '';

      final prefs = await SharedPreferences.getInstance();
      if (district != null) {
        await prefs.setString('userLocation', district.id.toString());
      } else {
        await prefs.remove('userLocation');
      }
      await prefs.setString('localRegionName', regionName);
      await prefs.setString('localDistrictName', districtName);
      await prefs.setString('localCountryCode', countryCode);

      // Deactivate any verified-neighborhood for browse filter purposes —
      // otherwise a stale US: entry from earlier testing keeps winning the
      // first products fetch on app launch. The verified neighborhood itself
      // remains in profile (user can manage from there); only the active
      // index is cleared.
      ref.read(activeNeighborhoodIndexProvider.notifier).state = -1;

      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      if (mounted) {
        setState(() {
          _resolving = false;
          _error = '$e';
        });
      }
    }
  }

  CountryModel? _matchCountry(String? code) {
    if (code == null) return null;
    final upper = code.toUpperCase();
    for (final c in CountryModel.supportedCountries) {
      if (c.code.toUpperCase() == upper) return c;
    }
    return null;
  }

  Regions? _bestMatchRegion(List<Regions> regions, Place place) {
    if (regions.isEmpty) return null;
    final candidates = [place.region, place.city, place.formattedAddress]
        .whereType<String>()
        .map((s) => s.toLowerCase().trim())
        .toList();
    for (final cand in candidates) {
      for (final r in regions) {
        final name = r.region.toLowerCase().trim();
        if (name == cand || cand.contains(name) || name.contains(cand)) {
          return r;
        }
      }
    }
    return null;
  }

  Districts? _bestMatchDistrict(List<Districts> districts, Place place) {
    if (districts.isEmpty) return null;
    final candidates = [place.city, place.region, place.formattedAddress]
        .whereType<String>()
        .map((s) => s.toLowerCase().trim())
        .toList();
    for (final cand in candidates) {
      for (final d in districts) {
        final name = d.district.toLowerCase().trim();
        if (name == cand || cand.contains(name) || name.contains(cand)) {
          return d;
        }
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final localizations = AppLocalizations.of(context);

    // The page is mostly invisible — the picker auto-launches on top.
    // We only show this scaffold while resolving the picked Place or if
    // resolution errored (user can retry via the AppBar action).
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
                  Text(
                      localizations?.resolving_location ?? 'Resolving…',
                      style: theme.textTheme.bodyMedium),
                ] else if (_error != null) ...[
                  Icon(Icons.error_outline,
                      size: 48, color: colorScheme.error),
                  const SizedBox(height: 12),
                  Text(_error!, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      _pickerLaunched = false;
                      _openPicker();
                    },
                    icon: const Icon(Icons.map_outlined),
                    label: Text(
                        localizations?.pick_again ?? 'Pick again'),
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
