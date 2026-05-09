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
  static const _prefsKey = 'verified_neighborhoods_v1';
  static const maxCount = 2;

  VerifiedNeighborhoodsNotifier() : super(const []) {
    hydrate();
  }

  Future<void> hydrate() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    if (raw == null) return;
    try {
      final list = (jsonDecode(raw) as List)
          .map((e) =>
              VerifiedNeighborhood.fromJson(e as Map<String, dynamic>))
          .toList();
      state = list;
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
