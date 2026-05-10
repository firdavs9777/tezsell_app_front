import 'package:app/providers/provider_models/neighborhood.dart';
import 'package:app/providers/provider_root/verified_neighborhoods_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Index into verifiedNeighborhoodsProvider for the currently-browsing
/// neighborhood. `-1` means "deactivated" — used when the user has picked
/// a custom location via the /change-city map filter and the verified
/// neighborhood should not also win the products fetch.
final activeNeighborhoodIndexProvider = StateProvider<int>((ref) => 0);

/// The verified neighborhood the user is currently browsing in.
/// Returns null if no verified neighborhoods exist OR the active index has
/// been explicitly cleared (idx < 0).
final activeNeighborhoodProvider = Provider<VerifiedNeighborhood?>((ref) {
  final list = ref.watch(verifiedNeighborhoodsProvider);
  final idx = ref.watch(activeNeighborhoodIndexProvider);
  if (list.isEmpty || idx < 0) return null;
  if (idx >= list.length) return list.first;
  return list[idx];
});
