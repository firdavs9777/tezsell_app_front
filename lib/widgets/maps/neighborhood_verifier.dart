import 'package:app/providers/provider_models/neighborhood.dart';
import 'package:app/providers/provider_root/maps_provider_provider.dart';
import 'package:app/providers/provider_root/verified_neighborhoods_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class NeighborhoodVerifier extends ConsumerStatefulWidget {
  /// Optional pre-resolved Position to skip GPS read (used by integration tests).
  final Position? injectedPosition;

  /// Maximum acceptable GPS accuracy in meters.
  static const accuracyThresholdM = 100.0;

  /// Number of high-accuracy retries before offering "low confidence" path.
  static const maxStrictAttempts = 3;

  const NeighborhoodVerifier({super.key, this.injectedPosition});

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

    try {
      final perm = await Geolocator.requestPermission();
      if (perm == LocationPermission.denied) {
        setState(() {
          _stage = _Stage.error;
          _error = 'Location permission denied — please enable in Settings';
        });
        return;
      }
      if (perm == LocationPermission.deniedForever) {
        setState(() {
          _stage = _Stage.error;
          _error =
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
          _error = 'GPS accuracy is ${pos.accuracy.toStringAsFixed(0)}m '
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
          _error = 'Could not identify neighborhood for your location.';
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
    try {
      // TODO(integrate): once backend verify endpoint is wired, call it here
      // and only update local state on backend success.
      await ref.read(verifiedNeighborhoodsProvider.notifier).add(
            VerifiedNeighborhood(
              neighborhood: _resolved!,
              verifiedAt: DateTime.now(),
              gpsAccuracyM: _position!.accuracy,
              lowConfidence: _position!.accuracy >
                  NeighborhoodVerifier.accuracyThresholdM,
            ),
          );
      setState(() => _stage = _Stage.done);
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
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Verify your neighborhood',
              style: theme.textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(
            "Stand in your neighborhood. We'll check your GPS and ask you to confirm.",
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          if (_stage == _Stage.idle)
            ElevatedButton(
              key: const Key('NeighborhoodVerifier.start'),
              onPressed: () => _start(),
              child: const Text('Verify Neighborhood'),
            ),
          if (_stage == _Stage.requesting) const LinearProgressIndicator(),
          if (_stage == _Stage.error) ...[
            Text(_error ?? 'Unknown error',
                style: TextStyle(color: theme.colorScheme.error)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_strictAttempts >= NeighborhoodVerifier.maxStrictAttempts)
                  TextButton(
                    onPressed: () => _start(allowLowConfidence: true),
                    child: const Text('Continue with low confidence'),
                  ),
                ElevatedButton(
                  onPressed: () => _start(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ],
          if (_stage == _Stage.confirming && _resolved != null) ...[
            Text("You're in:", style: theme.textTheme.bodyMedium),
            const SizedBox(height: 4),
            Text(_resolved!.displayName, style: theme.textTheme.titleMedium),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => setState(() => _stage = _Stage.idle),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  key: const Key('NeighborhoodVerifier.confirm'),
                  onPressed: _confirm,
                  child: const Text('Confirm'),
                ),
              ],
            ),
          ],
          if (_stage == _Stage.submitting) const LinearProgressIndicator(),
          if (_stage == _Stage.done)
            Text(
              'Verified! ${_resolved?.displayName}',
              style: TextStyle(color: theme.colorScheme.primary),
            ),
        ],
      ),
    );
  }
}
