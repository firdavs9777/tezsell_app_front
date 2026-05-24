import 'dart:async';

import 'package:app/l10n/app_localizations.dart';
import 'package:app/providers/provider_models/neighborhood.dart';
import 'package:app/providers/provider_root/active_neighborhood_provider.dart';
import 'package:app/providers/provider_root/maps_provider_provider.dart';
import 'package:app/providers/provider_root/product_provider.dart';
import 'package:app/providers/provider_root/service_provider.dart';
import 'package:app/providers/provider_root/verified_neighborhoods_provider.dart';
import 'package:app/widgets/maps/neighborhood_verifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class NeighborhoodManagementPage extends ConsumerStatefulWidget {
  const NeighborhoodManagementPage({super.key});

  @override
  ConsumerState<NeighborhoodManagementPage> createState() =>
      _NeighborhoodManagementPageState();
}

class _NeighborhoodManagementPageState
    extends ConsumerState<NeighborhoodManagementPage> {
  final _mapController = MapController();
  StreamSubscription<Position>? _positionSub;
  Position? _currentPosition;
  bool _cameraFitted = false;

  @override
  void initState() {
    super.initState();
    _initGps();
  }

  @override
  void dispose() {
    _positionSub?.cancel();
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _initGps() async {
    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }
    if (perm == LocationPermission.denied ||
        perm == LocationPermission.deniedForever) {
      return;
    }

    final last = await Geolocator.getLastKnownPosition();
    if (last != null && mounted) {
      setState(() => _currentPosition = last);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_cameraFitted) {
          _fitCamera();
          _cameraFitted = true;
        }
      });
    }

    _positionSub = Geolocator.getPositionStream(
      locationSettings:
          const LocationSettings(accuracy: LocationAccuracy.high),
    ).listen((pos) {
      if (!mounted) return;
      setState(() => _currentPosition = pos);
      if (!_cameraFitted) {
        _fitCamera();
        _cameraFitted = true;
      }
    });
  }

  void _fitCamera() {
    final verified = ref.read(verifiedNeighborhoodsProvider);
    final points = <LatLng>[];
    if (_currentPosition != null) {
      points.add(
          LatLng(_currentPosition!.latitude, _currentPosition!.longitude));
    }
    for (final v in verified) {
      points
          .add(LatLng(v.neighborhood.centroidLat, v.neighborhood.centroidLng));
    }
    if (points.isEmpty) return;
    if (points.length == 1) {
      _mapController.move(points.first, 13);
      return;
    }
    _mapController.fitCamera(
      CameraFit.bounds(
        bounds: LatLngBounds.fromPoints(points),
        padding: const EdgeInsets.all(60),
      ),
    );
  }

  LatLng _initialCenter() {
    final verified = ref.read(verifiedNeighborhoodsProvider);
    if (verified.isNotEmpty) {
      final idx = ref
          .read(activeNeighborhoodIndexProvider)
          .clamp(0, verified.length - 1);
      return LatLng(
        verified[idx].neighborhood.centroidLat,
        verified[idx].neighborhood.centroidLng,
      );
    }
    return const LatLng(20.0, 0.0);
  }

  void _switchTo(int idx) {
    ref.read(activeNeighborhoodIndexProvider.notifier).state = idx;
    ref.invalidate(productsProvider);
    ref.invalidate(servicesProvider);
  }

  Future<void> _onVerifyHere() async {
    final perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied ||
        perm == LocationPermission.deniedForever) {
      if (!mounted) return;
      final l = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(l?.location_permission_denied_settings ??
            'Location permission denied — please enable in Settings'),
        action: const SnackBarAction(
          label: 'Settings',
          onPressed: Geolocator.openAppSettings,
        ),
      ));
      return;
    }
    final verified = ref.read(verifiedNeighborhoodsProvider);
    if (verified.length < VerifiedNeighborhoodsNotifier.maxCount) {
      _startVerification();
    } else {
      final oldest = verified.reduce(
          (a, b) => a.verifiedAt.isBefore(b.verifiedAt) ? a : b);
      _showEvictionWarning(oldest);
    }
  }

  void _showEvictionWarning(VerifiedNeighborhood oldest) {
    final l = AppLocalizations.of(context);
    final name = oldest.neighborhood.city.isNotEmpty
        ? oldest.neighborhood.city
        : oldest.neighborhood.name;
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        final cs = Theme.of(ctx).colorScheme;
        return Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(24, 16, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 32,
                  height: 4,
                  decoration: BoxDecoration(
                    color: cs.onSurfaceVariant.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                l?.verify_new_location ?? 'Verify new location',
                style: Theme.of(ctx)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: cs.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  l?.eviction_warning(name) ??
                      'Adding this location will remove $name (your oldest). This cannot be undone.',
                  style: TextStyle(color: cs.onErrorContainer),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: Text(l?.cancel ?? 'Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        _startVerification();
                      },
                      child: Text(l?.verify_here ?? 'Verify'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _startVerification() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: NeighborhoodVerifier(
          onDone: () => Navigator.of(ctx).pop(),
        ),
      ),
    ).then((_) {
      if (!mounted) return;
      final verified = ref.read(verifiedNeighborhoodsProvider);
      if (verified.isNotEmpty) {
        ref.read(activeNeighborhoodIndexProvider.notifier).state =
            verified.length - 1;
      }
      ref.invalidate(productsProvider);
      ref.invalidate(servicesProvider);
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _fitCamera());
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final mapsProvider = ref.watch(mapsProviderProvider);
    final verified = ref.watch(verifiedNeighborhoodsProvider);
    final activeIdx = ref.watch(activeNeighborhoodIndexProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l?.my_neighborhoods ?? 'My Neighborhoods'),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _initialCenter(),
              initialZoom: 13,
            ),
            children: [
              TileLayer(
                urlTemplate: mapsProvider.tileUrlTemplate,
                userAgentPackageName: mapsProvider.userAgent,
              ),
              if (_currentPosition != null) ...[
                CircleLayer(
                  circles: [
                    CircleMarker(
                      point: LatLng(_currentPosition!.latitude,
                          _currentPosition!.longitude),
                      radius: _currentPosition!.accuracy,
                      useRadiusInMeter: true,
                      color: Colors.blue.withValues(alpha: 0.12),
                      borderColor: Colors.blue.withValues(alpha: 0.4),
                      borderStrokeWidth: 1,
                    ),
                  ],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: LatLng(_currentPosition!.latitude,
                          _currentPosition!.longitude),
                      width: 18,
                      height: 18,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.black26,
                                blurRadius: 3,
                                offset: Offset(0, 1))
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              if (verified.isNotEmpty)
                MarkerLayer(
                  markers: List.generate(verified.length, (i) {
                    final v = verified[i];
                    return Marker(
                      point: LatLng(v.neighborhood.centroidLat,
                          v.neighborhood.centroidLng),
                      width: 120,
                      height: 60,
                      alignment: Alignment.bottomCenter,
                      child: GestureDetector(
                        onTap: () => _switchTo(i),
                        child: _NeighborhoodPin(
                          neighborhood: v,
                          isActive: i == activeIdx,
                        ),
                      ),
                    );
                  }),
                ),
              const SimpleAttributionWidget(
                source: Text('© OpenStreetMap contributors'),
              ),
            ],
          ),
          if (verified.isNotEmpty)
            Positioned(
              top: 12,
              left: 12,
              right: 12,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(verified.length, (i) {
                  return _NeighborhoodChip(
                    neighborhood: verified[i],
                    isActive: i == activeIdx,
                    onTap: () => _switchTo(i),
                  );
                }),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _onVerifyHere,
        icon: const Icon(Icons.my_location_rounded),
        label: Text(l?.verify_here ?? 'Verify here'),
      ),
    );
  }
}

class _NeighborhoodPin extends StatelessWidget {
  final VerifiedNeighborhood neighborhood;
  final bool isActive;

  const _NeighborhoodPin({
    required this.neighborhood,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final raw = neighborhood.neighborhood.city.isNotEmpty
        ? neighborhood.neighborhood.city
        : neighborhood.neighborhood.name;
    final label = raw.length > 18 ? '${raw.substring(0, 18)}…' : raw;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsetsDirectional.fromSTEB(6, 3, 6, 3),
          decoration: BoxDecoration(
            color: isActive ? cs.primary : cs.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black26,
                  blurRadius: 2,
                  offset: Offset(0, 1))
            ],
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.white : cs.onSurface,
              fontSize: 11,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Icon(
          Icons.location_on_rounded,
          size: 28,
          color: isActive ? cs.primary : cs.outline,
        ),
      ],
    );
  }
}

class _NeighborhoodChip extends StatelessWidget {
  final VerifiedNeighborhood neighborhood;
  final bool isActive;
  final VoidCallback onTap;

  const _NeighborhoodChip({
    required this.neighborhood,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final name = neighborhood.neighborhood.city.isNotEmpty
        ? neighborhood.neighborhood.city
        : neighborhood.neighborhood.name;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 140),
        padding: const EdgeInsetsDirectional.fromSTEB(12, 6, 12, 6),
        decoration: BoxDecoration(
          color: isActive ? cs.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isActive ? cs.primary : cs.outline),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 4,
                offset: const Offset(0, 2))
          ],
        ),
        child: Text(
          name,
          style: TextStyle(
            color: isActive ? Colors.white : cs.onSurface,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            fontSize: 12,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
