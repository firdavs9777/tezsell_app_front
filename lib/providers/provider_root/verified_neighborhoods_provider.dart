import 'dart:convert';

import 'package:app/providers/provider_models/neighborhood.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TooManyNeighborhoodsException implements Exception {
  @override
  String toString() =>
      'TooManyNeighborhoodsException: max 2 verified neighborhoods';
}

class VerifiedNeighborhoodsNotifier
    extends StateNotifier<List<VerifiedNeighborhood>> {
  // _v2: bumped from _v1 to invalidate the simulator-test cache that was
  // pinning users to stale entries (e.g. US:323854723 from earlier runs).
  // First launch after upgrade hydrates empty; user re-picks via /change-city.
  static const _prefsKey = 'verified_neighborhoods_v2';
  static const _legacyPrefsKey = 'verified_neighborhoods_v1';
  static const maxCount = 2;

  VerifiedNeighborhoodsNotifier() : super(const []) {
    hydrate();
  }

  Future<void> hydrate() async {
    final prefs = await SharedPreferences.getInstance();
    // Wipe the legacy key on first hydrate so old test entries are gone.
    await prefs.remove(_legacyPrefsKey);
    final raw = prefs.getString(_prefsKey);
    if (raw == null) return;
    try {
      final list = (jsonDecode(raw) as List)
          .map((e) =>
              VerifiedNeighborhood.fromJson(e as Map<String, dynamic>))
          .toList();
      // Don't clobber state if something already populated it while hydrate
      // was awaiting (e.g. an add() in tests, or a /change-city pick before
      // hydrate completes).
      if (state.isEmpty) state = list;
    } catch (_) {
      await prefs.remove(_prefsKey);
    }
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _prefsKey,
      jsonEncode(state.map((v) => v.toJson()).toList()),
    );
  }

  Future<void> add(VerifiedNeighborhood entry) async {
    final existingIdx =
        state.indexWhere((v) => v.neighborhood.id == entry.neighborhood.id);
    if (existingIdx >= 0) {
      final next = [...state];
      next[existingIdx] = entry;
      state = next;
      await _persist();
      return;
    }
    if (state.length >= maxCount) {
      throw TooManyNeighborhoodsException();
    }
    state = [...state, entry];
    await _persist();
  }

  /// Karrot-style "always-room-for-one-more": replaces by id if it exists,
  /// otherwise appends — evicting the oldest (FIFO) when already at maxCount.
  /// Used by the /change-city + /location-setup map-pick flows where the
  /// user expects their newest pick to win without an exception.
  Future<void> addEvictingOldest(VerifiedNeighborhood entry) async {
    final existingIdx =
        state.indexWhere((v) => v.neighborhood.id == entry.neighborhood.id);
    if (existingIdx >= 0) {
      final next = [...state];
      next[existingIdx] = entry;
      state = next;
      await _persist();
      return;
    }
    if (state.length >= maxCount) {
      // Drop the oldest entry by verifiedAt to make room.
      final sorted = [...state]
        ..sort((a, b) => a.verifiedAt.compareTo(b.verifiedAt));
      final oldest = sorted.first;
      state = state.where((v) => v.neighborhood.id != oldest.neighborhood.id).toList();
    }
    state = [...state, entry];
    await _persist();
  }

  Future<void> remove(String neighborhoodId) async {
    state = state.where((v) => v.neighborhood.id != neighborhoodId).toList();
    await _persist();
  }

  Future<void> clear() async {
    state = const [];
    await _persist();
  }
}

final verifiedNeighborhoodsProvider = StateNotifierProvider<
    VerifiedNeighborhoodsNotifier, List<VerifiedNeighborhood>>((ref) {
  return VerifiedNeighborhoodsNotifier();
});
