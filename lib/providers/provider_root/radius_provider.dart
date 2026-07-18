import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RadiusNotifier extends StateNotifier<double> {
  static const _key = 'browse_radius_km_v1';
  static const defaultKm = double.infinity;

  RadiusNotifier() : super(defaultKm) {
    hydrate();
  }

  Future<void> hydrate() async {
    final prefs = await SharedPreferences.getInstance();
    final v = prefs.getDouble(_key);
    if (v != null) state = v;
  }

  Future<void> set(double km) async {
    state = km;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_key, km);
  }
}

final radiusProvider = StateNotifierProvider<RadiusNotifier, double>(
  (ref) => RadiusNotifier(),
);
