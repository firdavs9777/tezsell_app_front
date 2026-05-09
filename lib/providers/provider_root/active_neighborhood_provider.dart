import 'package:app/providers/provider_models/neighborhood.dart';
import 'package:app/providers/provider_root/verified_neighborhoods_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Index into verifiedNeighborhoodsProvider for the currently-browsing
/// neighborhood. Defaults to 0 (first verified entry).
final activeNeighborhoodIndexProvider = StateProvider<int>((ref) => 0);

/// The verified neighborhood the user is currently browsing in.
/// Returns null if no verified neighborhoods exist.
final activeNeighborhoodProvider = Provider<VerifiedNeighborhood?>((ref) {
  final list = ref.watch(verifiedNeighborhoodsProvider);
  final idx = ref.watch(activeNeighborhoodIndexProvider);
  if (list.isEmpty) return null;
  if (idx >= list.length) return list.first;
  return list[idx];
});
