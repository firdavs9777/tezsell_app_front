import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/service/country_service.dart';
import 'package:app/providers/provider_models/country_model.dart';
import 'package:app/providers/provider_models/location_model.dart';

/// Country service provider
final countryServiceProvider = Provider<CountryService>((ref) {
  return CountryService();
});

/// Selected country provider
final selectedCountryProvider =
    StateNotifierProvider<SelectedCountryNotifier, CountryModel?>((ref) {
  return SelectedCountryNotifier(ref);
});

class SelectedCountryNotifier extends StateNotifier<CountryModel?> {
  final Ref _ref;

  SelectedCountryNotifier(this._ref) : super(null) {
    _loadSavedCountry();
  }

  /// Load saved country from preferences
  Future<void> _loadSavedCountry() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final countryCode = prefs.getString('selected_country');
      if (countryCode != null) {
        // Try to get from static list first
        final country = CountryModel.getByCode(countryCode);
        if (country != null) {
          state = country;
          return;
        }
        // If not found, fetch from API
        final service = _ref.read(countryServiceProvider);
        final countries = await service.getCountries();
        try {
          state = countries.firstWhere((c) => c.code == countryCode);
        } catch (_) {
          // Country not found, use default
          state = CountryModel.getByCode('UZ');
        }
      }
    } catch (e) {
      // Default to Uzbekistan if error
      state = CountryModel.getByCode('UZ');
    }
  }

  /// Set selected country
  Future<void> setCountry(CountryModel country) async {
    state = country;
    await _saveToPrefs(country.code);
  }

  /// Save country code to preferences
  Future<void> _saveToPrefs(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_country', code);
  }

  /// Check if country is selected
  bool get hasCountry => state != null;

  /// Get country code
  String? get countryCode => state?.code;

  /// Get default currency for selected country
  String get defaultCurrency => state?.currency.code ?? 'UZS';
}

/// Countries list provider
final countriesProvider = FutureProvider<List<CountryModel>>((ref) async {
  final service = ref.watch(countryServiceProvider);
  return await service.getCountries();
});

/// Regions for selected country
final regionsProvider =
    FutureProvider.family<List<Regions>, String>((ref, countryCode) async {
  final service = ref.watch(countryServiceProvider);
  return await service.getRegions(countryCode);
});

/// Districts for selected region
final districtsProvider =
    FutureProvider.family<List<Districts>, int>((ref, regionId) async {
  final service = ref.watch(countryServiceProvider);
  return await service.getDistricts(regionId);
});

/// Selected region provider for location setup
final selectedRegionProvider = StateProvider<Regions?>((ref) => null);

/// Selected district provider for location setup
final selectedDistrictProvider = StateProvider<Districts?>((ref) => null);
