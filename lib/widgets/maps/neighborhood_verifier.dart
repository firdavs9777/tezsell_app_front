import 'package:app/l10n/app_localizations.dart';
import 'package:app/providers/provider_models/neighborhood.dart';
import 'package:app/providers/provider_root/maps_provider_provider.dart';
import 'package:app/providers/provider_root/verified_neighborhoods_provider.dart';
import 'package:app/services/maps/maps_exceptions.dart';
import 'package:app/services/maps/verify_neighborhood_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class NeighborhoodVerifier extends ConsumerStatefulWidget {
  /// Optional pre-resolved Position to skip GPS read (used by integration tests).
  final Position? injectedPosition;

  /// Called when verification succeeds (stage transitions to done).
  final VoidCallback? onDone;

  /// Maximum acceptable GPS accuracy in meters.
  static const accuracyThresholdM = 100.0;

  /// Number of high-accuracy retries before offering "low confidence" path.
  static const maxStrictAttempts = 3;

  const NeighborhoodVerifier({super.key, this.injectedPosition, this.onDone});

  @override
  ConsumerState<NeighborhoodVerifier> createState() =>
      _NeighborhoodVerifierState();
}

enum _Stage { idle, requesting, confirming, submitting, done, error }

class _NeighborhoodVerifierState extends ConsumerState<NeighborhoodVerifier> {
  _Stage _stage = _Stage.idle;
  String? _error;
  Neighborhood? _resolved;
  Position? _position;
  int _strictAttempts = 0;

  Future<void> _start({bool allowLowConfidence = false}) async {
    setState(() {
      _stage = _Stage.requesting;
      _error = null;
    });

    final l = AppLocalizations.of(context);
    try {
      final perm = await Geolocator.requestPermission();
      if (perm == LocationPermission.denied) {
        setState(() {
          _stage = _Stage.error;
          _error = l?.location_permission_denied_settings ??
              'Location permission denied — please enable in Settings';
        });
        return;
      }
      if (perm == LocationPermission.deniedForever) {
        setState(() {
          _stage = _Stage.error;
          _error = l?.location_permission_permanent ??
              'Location permanently denied — open Settings to enable';
        });
        return;
      }

      final pos = widget.injectedPosition ??
          await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
          );

      if (pos.accuracy > NeighborhoodVerifier.accuracyThresholdM &&
          !allowLowConfidence) {
        _strictAttempts++;
        setState(() {
          _stage = _Stage.error;
          _error = l?.gps_accuracy_too_low(pos.accuracy.toStringAsFixed(0)) ??
              'GPS accuracy is ${pos.accuracy.toStringAsFixed(0)}m '
                  '(need ≤100m). Move to an open area and try again.';
        });
        return;
      }

      final nbhd = await ref
          .read(mapsProviderProvider)
          .getNeighborhood(LatLng(pos.latitude, pos.longitude));
      if (nbhd == null) {
        setState(() {
          _stage = _Stage.error;
          _error = l?.neighborhood_not_identified ??
              'Could not identify neighborhood for your location.';
        });
        return;
      }

      setState(() {
        _stage = _Stage.confirming;
        _resolved = nbhd;
        _position = pos;
      });
    } catch (e) {
      setState(() {
        _stage = _Stage.error;
        _error = e.toString();
      });
    }
  }

  Future<void> _confirm() async {
    if (_resolved == null || _position == null) return;
    setState(() => _stage = _Stage.submitting);
    final lowConfidence =
        _position!.accuracy > NeighborhoodVerifier.accuracyThresholdM;
    try {
      // Backend is authoritative — server validates GPS, reverse-geocodes
      // independently (anti-spoof), and persists to the user's profile.
      // Local state only updates on backend success.
      final serverNeighborhood =
          await VerifyNeighborhoodService().verify(
        lat: _position!.latitude,
        lng: _position!.longitude,
        gpsAccuracyM: _position!.accuracy,
        lowConfidence: lowConfidence,
      );
      await ref.read(verifiedNeighborhoodsProvider.notifier).addEvictingOldest(
            VerifiedNeighborhood(
              neighborhood: serverNeighborhood,
              verifiedAt: DateTime.now(),
              gpsAccuracyM: _position!.accuracy,
              lowConfidence: lowConfidence,
            ),
          );
      setState(() {
        _resolved = serverNeighborhood;
        _stage = _Stage.done;
      });
      widget.onDone?.call();
    } on MapsException catch (e) {
      setState(() {
        _stage = _Stage.error;
        _error = e.message;
      });
    } catch (e) {
      setState(() {
        _stage = _Stage.error;
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l?.verify_neighborhood_title ?? 'Verify your neighborhood',
              style: theme.textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(
            l?.verify_neighborhood_subtitle ??
                "Stand in your neighborhood. We'll check your GPS and ask you to confirm.",
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          if (_stage == _Stage.idle)
            ElevatedButton(
              key: const Key('NeighborhoodVerifier.start'),
              onPressed: () => _start(),
              child: Text(
                  l?.verify_neighborhood_button ?? 'Verify Neighborhood'),
            ),
          if (_stage == _Stage.requesting) const LinearProgressIndicator(),
          if (_stage == _Stage.error) ...[
            Text(_error ?? l?.unknown_error ?? 'Unknown error',
                style: TextStyle(color: theme.colorScheme.error)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_strictAttempts >= NeighborhoodVerifier.maxStrictAttempts)
                  TextButton(
                    onPressed: () => _start(allowLowConfidence: true),
                    child: Text(l?.verify_neighborhood_low_confidence ??
                        'Continue with low confidence'),
                  ),
                ElevatedButton(
                  onPressed: () => _start(),
                  child:
                      Text(l?.verify_neighborhood_retry ?? 'Retry'),
                ),
              ],
            ),
          ],
          if (_stage == _Stage.confirming && _resolved != null) ...[
            Text(l?.verify_neighborhood_youre_in ?? "You're in:",
                style: theme.textTheme.bodyMedium),
            const SizedBox(height: 4),
            Text(_resolved!.displayName, style: theme.textTheme.titleMedium),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => setState(() => _stage = _Stage.idle),
                  child: Text(l?.cancel ?? 'Cancel'),
                ),
                ElevatedButton(
                  key: const Key('NeighborhoodVerifier.confirm'),
                  onPressed: _confirm,
                  child: Text(l?.confirm ?? 'Confirm'),
                ),
              ],
            ),
          ],
          if (_stage == _Stage.submitting) const LinearProgressIndicator(),
          if (_stage == _Stage.done)
            Text(
              l?.verify_neighborhood_done(_resolved?.displayName ?? '') ??
                  'Verified! ${_resolved?.displayName}',
              style: TextStyle(color: theme.colorScheme.primary),
            ),
        ],
      ),
    );
  }
}
