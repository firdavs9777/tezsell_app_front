import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Supported language codes — 15 locales covering Karrot's actual + planned markets.
const supportedLocaleCodes = <String>{
  'en', 'ru', 'uz', // existing
  'ko', 'ja', 'zh', 'es', 'pt', 'fr', 'de',
  'tr', 'ar', 'hi', 'id', 'vi',
};

const supportedLocales = <Locale>[
  Locale('en'),
  Locale('ru'),
  Locale('uz'),
  Locale('ko'),
  Locale('ja'),
  Locale('zh'),
  Locale('es'),
  Locale('pt'),
  Locale('fr'),
  Locale('de'),
  Locale('tr'),
  Locale('ar'),
  Locale('hi'),
  Locale('id'),
  Locale('vi'),
];

// RTL languages — used by MaterialApp via flutter_localizations Directionality.
const rtlLocaleCodes = <String>{'ar'};

const _kPrefsKey = 'language_code';

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale?>((ref) {
  return LocaleNotifier();
});

class LocaleNotifier extends StateNotifier<Locale?> {
  LocaleNotifier() : super(null) {
    _loadSavedLocale();
    // React to live OS locale changes (user toggles phone language while app is open).
    ui.PlatformDispatcher.instance.onLocaleChanged = _onSystemLocaleChanged;
  }

  Future<void> _onSystemLocaleChanged() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(_kPrefsKey)) return; // user has manual override
    state = _detectDeviceLocale();
  }

  Future<void> _loadSavedLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(_kPrefsKey);
      if (saved != null && supportedLocaleCodes.contains(saved)) {
        state = Locale(saved);
        return;
      }
      state = _detectDeviceLocale();
    } catch (_) {
      state = const Locale('en');
    }
  }

  // Walks the platform's locale preference list and picks the first match.
  // This honors a user with e.g. [pt-BR, en-US] system order.
  Locale _detectDeviceLocale() {
    final preferred = ui.PlatformDispatcher.instance.locales;
    for (final l in preferred) {
      final code = l.languageCode;
      if (supportedLocaleCodes.contains(code)) return Locale(code);
    }
    return const Locale('en');
  }

  Future<void> setLocale(Locale locale) async {
    if (!supportedLocaleCodes.contains(locale.languageCode)) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kPrefsKey, locale.languageCode);
    state = locale;
  }

  // Clear manual override and re-detect from device.
  Future<void> resetToDeviceLocale() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kPrefsKey);
    state = _detectDeviceLocale();
  }

  Future<bool> hasManualOverride() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_kPrefsKey);
  }
}
