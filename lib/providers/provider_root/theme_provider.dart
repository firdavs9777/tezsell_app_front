// Create this file: lib/providers/provider_root/theme_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.system) {
    _loadTheme();
  }

  static const String _themeKey = 'selected_theme';

  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeIndex = prefs.getInt(_themeKey) ?? 0;

      switch (themeIndex) {
        case 0:
          state = ThemeMode.system;
          break;
        case 1:
          state = ThemeMode.light;
          break;
        case 2:
          state = ThemeMode.dark;
          break;
        default:
          state = ThemeMode.system;
      }
    } catch (e) {
      // If there's an error loading preferences, default to system
      state = ThemeMode.system;
    }
  }

  Future<void> setTheme(ThemeMode theme) async {
    state = theme;

    try {
      final prefs = await SharedPreferences.getInstance();
      int themeIndex;

      switch (theme) {
        case ThemeMode.system:
          themeIndex = 0;
          break;
        case ThemeMode.light:
          themeIndex = 1;
          break;
        case ThemeMode.dark:
          themeIndex = 2;
          break;
      }

      await prefs.setInt(_themeKey, themeIndex);
    } catch (e) {
      // Handle error silently - theme will still work for current session
      debugPrint('Error saving theme preference: $e');
    }
  }

  // Helper method to get theme name for display
  String getThemeName(ThemeMode theme) {
    switch (theme) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
      default:
        return 'System Default';
    }
  }
}
