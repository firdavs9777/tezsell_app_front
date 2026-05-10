import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import 'package:app/l10n/app_localizations.dart';
import 'package:app/pages/authentication/mobile_authentication.dart';
import 'package:app/providers/provider_models/country_model.dart';
import 'package:app/providers/provider_models/location_model.dart';
import 'package:app/providers/provider_models/place.dart';
import 'package:app/service/country_service.dart';
import 'package:app/widgets/maps/location_picker.dart';

/// Carrot/Wallapop-style map-first registration entry.
/// User picks a location on a map; we auto-resolve country/region/district by
/// reverse-geocoding + name matching the existing /accounts/regions and
/// /locations/regions/<id>/districts APIs. If any step fails to match, we
/// hand control back to the legacy dropdown flow at /register.
class MapRegisterPage extends StatefulWidget {
  const MapRegisterPage({super.key});

  @override
  State<MapRegisterPage> createState() => _MapRegisterPageState();
}

class _MapRegisterPageState extends State<MapRegisterPage> {
  final _service = CountryService();

  Place? _picked;
  bool _resolving = false;
  String? _error;

  Future<void> _openPicker() async {
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
    if (result == null || !mounted) return;
    setState(() {
      _picked = result;
      _error = null;
    });
    await _resolveAndContinue(result);
  }

  Future<void> _resolveAndContinue(Place place) async {
    setState(() {
      _resolving = true;
      _error = null;
    });

    try {
      // Best-effort country/region/district matching against the backend's
      // existing tables. International users (e.g. picking a US/EU/JP/KR
      // location) can fall through with the place's reverse-geocoded
      // country_code + region/city strings — backend stores those phase-1
      // fields anyway. No hard gate by supportedCountries.
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

      // Use real DB ids if matched; else fall through with the picked place's
      // human-readable strings so the user can still register.
      final regionName = region?.region ?? place.region ?? place.city ?? '';
      final districtName =
          district?.district ?? place.city ?? place.region ?? '';
      final districtId = district?.id.toString() ?? '';

      if (!mounted) return;
      await Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => MobileAuthentication(
            countryCode: countryCode,
            regionName: regionName,
            districtName: districtName,
            districtId: districtId,
          ),
        ),
      );
    } catch (e) {
      if (mounted) {
        _fallback('Resolution failed: $e');
      }
    } finally {
      if (mounted) setState(() => _resolving = false);
    }
  }

  /// Try GPS first; fall back to a neutral default if denied/unavailable.
  /// International users see their actual location centered, not Tashkent.
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
      // permissions denied / GPS off / timeout — fall through
    }
    return const LatLng(41.3, 69.24);
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

  void _fallback(String reason) {
    setState(() {
      _resolving = false;
      _error = reason;
    });
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
        title: Text(localizations?.map_register_title ?? 'Where do you live?'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Icon(Icons.public, size: 64, color: colorScheme.primary),
              const SizedBox(height: 24),
              Text(
                localizations?.map_register_headline ??
                    'Pick your neighborhood on the map',
                style: theme.textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(
                localizations?.map_register_subtitle ??
                    'We use it to show you nearby buyers and sellers. '
                        'You can adjust your radius later.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 32),
              if (_picked != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.location_on, color: colorScheme.primary),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _picked!.formattedAddress ??
                              '${_picked!.lat.toStringAsFixed(4)}, ${_picked!.lng.toStringAsFixed(4)}',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              if (_error != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline,
                          color: colorScheme.onErrorContainer, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(_error!,
                            style: TextStyle(
                                color: colorScheme.onErrorContainer)),
                      ),
                    ],
                  ),
                ),
              ],
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _resolving ? null : _openPicker,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: _resolving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.map_outlined),
                  label: Text(
                    _resolving
                        ? (localizations?.resolving_location ?? 'Resolving…')
                        : (_picked == null
                            ? (localizations?.pick_on_map ?? 'Pick on map')
                            : (localizations?.pick_again ?? 'Pick again')),
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
