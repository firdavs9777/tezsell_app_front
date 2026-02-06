# Frontend Internationalization Guide

## Target Markets: 15 Former Soviet Union Countries

This document outlines all frontend changes needed to support internationalization across 15 countries.

---

## 1. Currency Support

### 1.1 Update currency_utils.dart

**File:** `/lib/utils/currency_utils.dart`

Add support for all 15 country currencies:

```dart
class CurrencyUtils {
  // All supported currencies with formatting rules
  static const Map<String, CurrencyConfig> currencies = {
    'UZS': CurrencyConfig(
      code: 'UZS',
      symbol: "so'm",
      symbolPosition: SymbolPosition.after,
      thousandsSeparator: ' ',
      decimalSeparator: ',',
      decimals: 0,
      minPrice: 1000,
      maxPrice: 10000000000000,
    ),
    'USD': CurrencyConfig(
      code: 'USD',
      symbol: '\$',
      symbolPosition: SymbolPosition.before,
      thousandsSeparator: ',',
      decimalSeparator: '.',
      decimals: 2,
      minPrice: 1,
      maxPrice: 10000000,
    ),
    'EUR': CurrencyConfig(
      code: 'EUR',
      symbol: '€',
      symbolPosition: SymbolPosition.before,
      thousandsSeparator: ' ',
      decimalSeparator: ',',
      decimals: 2,
      minPrice: 1,
      maxPrice: 10000000,
    ),
    'RUB': CurrencyConfig(
      code: 'RUB',
      symbol: '₽',
      symbolPosition: SymbolPosition.after,
      thousandsSeparator: ' ',
      decimalSeparator: ',',
      decimals: 0,
      minPrice: 100,
      maxPrice: 100000000000,
    ),
    'UAH': CurrencyConfig(
      code: 'UAH',
      symbol: '₴',
      symbolPosition: SymbolPosition.after,
      thousandsSeparator: ' ',
      decimalSeparator: ',',
      decimals: 0,
      minPrice: 100,
      maxPrice: 10000000000,
    ),
    'BYN': CurrencyConfig(
      code: 'BYN',
      symbol: 'Br',
      symbolPosition: SymbolPosition.after,
      thousandsSeparator: ' ',
      decimalSeparator: ',',
      decimals: 2,
      minPrice: 1,
      maxPrice: 100000000,
    ),
    'MDL': CurrencyConfig(
      code: 'MDL',
      symbol: 'L',
      symbolPosition: SymbolPosition.after,
      thousandsSeparator: ' ',
      decimalSeparator: ',',
      decimals: 0,
      minPrice: 10,
      maxPrice: 1000000000,
    ),
    'GEL': CurrencyConfig(
      code: 'GEL',
      symbol: '₾',
      symbolPosition: SymbolPosition.after,
      thousandsSeparator: ' ',
      decimalSeparator: ',',
      decimals: 2,
      minPrice: 1,
      maxPrice: 100000000,
    ),
    'AMD': CurrencyConfig(
      code: 'AMD',
      symbol: '֏',
      symbolPosition: SymbolPosition.after,
      thousandsSeparator: ' ',
      decimalSeparator: ',',
      decimals: 0,
      minPrice: 100,
      maxPrice: 10000000000,
    ),
    'AZN': CurrencyConfig(
      code: 'AZN',
      symbol: '₼',
      symbolPosition: SymbolPosition.after,
      thousandsSeparator: ' ',
      decimalSeparator: ',',
      decimals: 2,
      minPrice: 1,
      maxPrice: 100000000,
    ),
    'KZT': CurrencyConfig(
      code: 'KZT',
      symbol: '₸',
      symbolPosition: SymbolPosition.after,
      thousandsSeparator: ' ',
      decimalSeparator: ',',
      decimals: 0,
      minPrice: 100,
      maxPrice: 10000000000,
    ),
    'TMT': CurrencyConfig(
      code: 'TMT',
      symbol: 'm',
      symbolPosition: SymbolPosition.after,
      thousandsSeparator: ' ',
      decimalSeparator: ',',
      decimals: 2,
      minPrice: 1,
      maxPrice: 100000000,
    ),
    'KGS': CurrencyConfig(
      code: 'KGS',
      symbol: 'с',
      symbolPosition: SymbolPosition.after,
      thousandsSeparator: ' ',
      decimalSeparator: ',',
      decimals: 0,
      minPrice: 10,
      maxPrice: 10000000000,
    ),
    'TJS': CurrencyConfig(
      code: 'TJS',
      symbol: 'ЅМ',
      symbolPosition: SymbolPosition.after,
      thousandsSeparator: ' ',
      decimalSeparator: ',',
      decimals: 2,
      minPrice: 1,
      maxPrice: 1000000000,
    ),
  };

  // Map country codes to default currencies
  static const Map<String, String> countryDefaultCurrency = {
    'RU': 'RUB',
    'UA': 'UAH',
    'BY': 'BYN',
    'MD': 'MDL',
    'EE': 'EUR',
    'LV': 'EUR',
    'LT': 'EUR',
    'GE': 'GEL',
    'AM': 'AMD',
    'AZ': 'AZN',
    'KZ': 'KZT',
    'UZ': 'UZS',
    'TM': 'TMT',
    'KG': 'KGS',
    'TJ': 'TJS',
  };

  /// Get available currencies for a country
  static List<String> getCurrenciesForCountry(String countryCode) {
    final defaultCurrency = countryDefaultCurrency[countryCode] ?? 'USD';
    // Always include USD and local currency
    return [defaultCurrency, 'USD', 'EUR'].toSet().toList();
  }

  /// Format price with proper currency formatting
  static String formatPrice(num price, String currencyCode) {
    final config = currencies[currencyCode] ?? currencies['USD']!;

    final formattedNumber = _formatNumber(
      price,
      thousandsSeparator: config.thousandsSeparator,
      decimalSeparator: config.decimalSeparator,
      decimals: config.decimals,
    );

    if (config.symbolPosition == SymbolPosition.before) {
      return '${config.symbol}$formattedNumber';
    } else {
      return '$formattedNumber ${config.symbol}';
    }
  }

  static String _formatNumber(
    num number, {
    required String thousandsSeparator,
    required String decimalSeparator,
    required int decimals,
  }) {
    final parts = number.toStringAsFixed(decimals).split('.');
    final integerPart = parts[0].replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}$thousandsSeparator',
    );

    if (decimals > 0 && parts.length > 1) {
      return '$integerPart$decimalSeparator${parts[1]}';
    }
    return integerPart;
  }
}

class CurrencyConfig {
  final String code;
  final String symbol;
  final SymbolPosition symbolPosition;
  final String thousandsSeparator;
  final String decimalSeparator;
  final int decimals;
  final num minPrice;
  final num maxPrice;

  const CurrencyConfig({
    required this.code,
    required this.symbol,
    required this.symbolPosition,
    required this.thousandsSeparator,
    required this.decimalSeparator,
    required this.decimals,
    required this.minPrice,
    required this.maxPrice,
  });
}

enum SymbolPosition { before, after }
```

---

## 2. Country Model & Provider

### 2.1 Create Country Model

**File:** `/lib/providers/provider_models/country_model.dart`

```dart
class CountryModel {
  final int id;
  final String code;
  final String name;
  final String nameEn;
  final String nameRu;
  final CurrencyInfo currency;
  final String phoneCode;
  final String flagEmoji;

  CountryModel({
    required this.id,
    required this.code,
    required this.name,
    required this.nameEn,
    required this.nameRu,
    required this.currency,
    required this.phoneCode,
    required this.flagEmoji,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      id: json['id'],
      code: json['code'],
      name: json['name'],
      nameEn: json['name_en'],
      nameRu: json['name_ru'],
      currency: CurrencyInfo.fromJson(json['currency']),
      phoneCode: json['phone_code'],
      flagEmoji: json['flag_emoji'] ?? _codeToEmoji(json['code']),
    );
  }

  static String _codeToEmoji(String countryCode) {
    return countryCode.toUpperCase().codeUnits
        .map((c) => String.fromCharCode(c + 127397))
        .join();
  }
}

class CurrencyInfo {
  final String code;
  final String symbol;
  final String name;

  CurrencyInfo({
    required this.code,
    required this.symbol,
    required this.name,
  });

  factory CurrencyInfo.fromJson(Map<String, dynamic> json) {
    return CurrencyInfo(
      code: json['code'],
      symbol: json['symbol'],
      name: json['name'],
    );
  }
}
```

### 2.2 Create Country Provider

**File:** `/lib/providers/country_provider.dart`

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../service/country_service.dart';
import 'provider_models/country_model.dart';

// Selected country provider
final selectedCountryProvider = StateNotifierProvider<SelectedCountryNotifier, CountryModel?>((ref) {
  return SelectedCountryNotifier();
});

class SelectedCountryNotifier extends StateNotifier<CountryModel?> {
  SelectedCountryNotifier() : super(null);

  void setCountry(CountryModel country) {
    state = country;
    // Save to SharedPreferences
    _saveToPrefs(country.code);
  }

  Future<void> loadSavedCountry() async {
    // Load from SharedPreferences and fetch country details
  }

  void _saveToPrefs(String code) {
    // Save country code to SharedPreferences
  }
}

// Countries list provider
final countriesProvider = FutureProvider<List<CountryModel>>((ref) async {
  final service = CountryService();
  return await service.getCountries();
});

// Regions for selected country
final regionsProvider = FutureProvider.family<List<RegionModel>, String>((ref, countryCode) async {
  final service = CountryService();
  return await service.getRegions(countryCode);
});
```

### 2.3 Create Country Service

**File:** `/lib/service/country_service.dart`

```dart
import 'package:dio/dio.dart';
import '../config/app_config.dart';
import '../providers/provider_models/country_model.dart';

class CountryService {
  final Dio _dio = Dio();

  Future<List<CountryModel>> getCountries() async {
    try {
      final response = await _dio.get('${AppConfig.baseUrl}/api/countries/');
      final List data = response.data['results'];
      return data.map((json) => CountryModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load countries: $e');
    }
  }

  Future<List<RegionModel>> getRegions(String countryCode) async {
    try {
      final response = await _dio.get(
        '${AppConfig.baseUrl}/accounts/regions/',
        queryParameters: {'country': countryCode},
      );
      final List data = response.data['results'];
      return data.map((json) => RegionModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load regions: $e');
    }
  }
}
```

---

## 3. Update Location Model

**File:** `/lib/providers/provider_models/location_model.dart`

```dart
class LocationModel {
  final String? country;        // NEW: Country code (UZ, KZ, etc.)
  final String? countryName;    // NEW: Country name for display
  final int? region;
  final String? regionName;
  final int? district;
  final String? districtName;
  final String? fullAddress;

  LocationModel({
    this.country,
    this.countryName,
    this.region,
    this.regionName,
    this.district,
    this.districtName,
    this.fullAddress,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      country: json['country'],
      countryName: json['country_name'],
      region: json['region'],
      regionName: json['region_name'],
      district: json['district'],
      districtName: json['district_name'],
      fullAddress: json['full_address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'country': country,
      'region': region,
      'district': district,
      'full_address': fullAddress,
    };
  }

  /// Get formatted location string
  String get displayLocation {
    final parts = <String>[];
    if (districtName != null) parts.add(districtName!);
    if (regionName != null) parts.add(regionName!);
    if (countryName != null) parts.add(countryName!);
    return parts.join(', ');
  }
}
```

---

## 4. Update Onboarding/Location Setup

### 4.1 Add Country Selection Step

**File:** `/lib/pages/onboarding/location_setup.dart`

Add a country selection step before region selection:

```dart
// Country selection widget
class CountrySelector extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final countriesAsync = ref.watch(countriesProvider);

    return countriesAsync.when(
      data: (countries) => ListView.builder(
        itemCount: countries.length,
        itemBuilder: (context, index) {
          final country = countries[index];
          return ListTile(
            leading: Text(country.flagEmoji, style: TextStyle(fontSize: 32)),
            title: Text(country.name),
            subtitle: Text(country.currency.code),
            onTap: () {
              ref.read(selectedCountryProvider.notifier).setCountry(country);
              // Navigate to region selection
            },
          );
        },
      ),
      loading: () => CircularProgressIndicator(),
      error: (err, stack) => Text('Error: $err'),
    );
  }
}
```

---

## 5. Remove Hardcoded "Uzbekistan" References

### 5.1 Files to Update

Search and update these hardcoded strings:

| File | Current Text | Replace With |
|------|--------------|--------------|
| `lib/l10n/app_en.arb` | "Your Fast & Easy Marketplace for Uzbekistan" | "Your Fast & Easy Marketplace" |
| `lib/pages/shaxsiy/profile-terms/terms_and_conditions.dart` | "Tashkent, Uzbekistan" | Dynamic based on user country |
| `lib/pages/shaxsiy/profile-terms/terms_and_conditions.dart` | "laws of the Republic of Uzbekistan" | "applicable local laws" |
| `lib/service/places_service.dart` | Appending "Uzbekistan" to geocoding | Use user's selected country |
| `lib/config/app_config.dart` | `support@tezsell.uz` | `support@tezsell.com` |

### 5.2 Update Geocoding Service

**File:** `/lib/service/places_service.dart`

```dart
// Before:
String query = "$address, Uzbekistan";

// After:
String query = "$address, ${userCountry}";
// Or use coordinates-based lookup without country appending
```

---

## 6. Phone Number Input with Country Code

### 6.1 Add Country Code Picker

The package `country_code_picker` is already in `pubspec.yaml`. Use it:

```dart
import 'package:country_code_picker/country_code_picker.dart';

class PhoneInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CountryCodePicker(
          onChanged: (code) {
            // Handle country code change
          },
          initialSelection: 'UZ',
          favorite: ['UZ', 'KZ', 'RU', 'KG', 'TJ'],
          showCountryOnly: false,
          showOnlyCountryWhenClosed: false,
          alignLeft: false,
          // Filter to only show target countries
          countryFilter: [
            'RU', 'UA', 'BY', 'MD', 'EE', 'LV', 'LT',
            'GE', 'AM', 'AZ', 'KZ', 'UZ', 'TM', 'KG', 'TJ'
          ],
        ),
        Expanded(
          child: TextField(
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintText: 'Phone number',
            ),
          ),
        ),
      ],
    );
  }
}
```

---

## 7. Update Product/Service Creation

### 7.1 Update Currency Dropdown

**Files:**
- `/lib/pages/elon-berish/product_create.dart`
- `/lib/pages/elon-berish/service_create.dart`
- `/lib/pages/elon-berish/real_estate_create.dart`

```dart
// Get currencies based on user's country
final userCountry = ref.watch(selectedCountryProvider);
final availableCurrencies = CurrencyUtils.getCurrenciesForCountry(
  userCountry?.code ?? 'UZ'
);

DropdownButton<String>(
  value: selectedCurrency,
  items: availableCurrencies.map((currency) {
    final config = CurrencyUtils.currencies[currency]!;
    return DropdownMenuItem(
      value: currency,
      child: Text('$currency (${config.symbol})'),
    );
  }).toList(),
  onChanged: (value) {
    setState(() => selectedCurrency = value!);
  },
)
```

---

## 8. Localization Updates

### 8.1 Add New Translation Keys

**File:** `/lib/l10n/app_en.arb`

```json
{
  "selectCountry": "Select your country",
  "selectRegion": "Select your region",
  "selectDistrict": "Select your district",
  "changeCountry": "Change country",
  "country": "Country",
  "allCountries": "All countries",

  "currencyRUB": "Russian Ruble",
  "currencyUAH": "Ukrainian Hryvnia",
  "currencyBYN": "Belarusian Ruble",
  "currencyMDL": "Moldovan Leu",
  "currencyGEL": "Georgian Lari",
  "currencyAMD": "Armenian Dram",
  "currencyAZN": "Azerbaijani Manat",
  "currencyKZT": "Kazakhstani Tenge",
  "currencyTMT": "Turkmen Manat",
  "currencyKGS": "Kyrgyzstani Som",
  "currencyTJS": "Tajikistani Somoni",

  "phoneNumberHint": "Enter phone number",
  "invalidPhoneFormat": "Invalid phone number format"
}
```

Add corresponding translations to `app_ru.arb` and `app_uz.arb`.

---

## 9. Filter Products by Country

### 9.1 Update Product List Provider

**File:** `/lib/providers/product_provider.dart`

```dart
// Add country filter to product fetching
Future<List<ProductModel>> fetchProducts({
  String? countryCode,
  int? regionId,
  int? districtId,
  String? category,
}) async {
  final queryParams = <String, dynamic>{};

  if (countryCode != null) queryParams['country'] = countryCode;
  if (regionId != null) queryParams['region'] = regionId;
  if (districtId != null) queryParams['district'] = districtId;
  if (category != null) queryParams['category'] = category;

  final response = await dio.get(
    '${AppConfig.baseUrl}/products/',
    queryParameters: queryParams,
  );
  // ...
}
```

### 9.2 Update Search/Filter UI

Add country filter to product search and discovery screens.

---

## 10. App Config Updates

**File:** `/lib/config/app_config.dart`

```dart
class AppConfig {
  static const String baseUrl = 'https://api.webtezsell.com';

  // Supported countries (can be fetched from API)
  static const List<String> supportedCountries = [
    'UZ', 'KZ', 'KG', 'TJ', 'TM',  // Central Asia (priority)
    'RU', 'UA', 'BY', 'MD',         // Eastern Europe
    'GE', 'AM', 'AZ',               // Caucasus
    'EE', 'LV', 'LT',               // Baltic
  ];

  // Default country for new users (can be auto-detected)
  static const String defaultCountry = 'UZ';

  // Support email (international)
  static const String supportEmail = 'support@tezsell.com';
}
```

---

## 11. UI Components

### 11.1 Country Flag Widget

```dart
class CountryFlag extends StatelessWidget {
  final String countryCode;
  final double size;

  const CountryFlag({
    required this.countryCode,
    this.size = 24,
  });

  String get flagEmoji {
    return countryCode.toUpperCase().codeUnits
        .map((c) => String.fromCharCode(c + 127397))
        .join();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      flagEmoji,
      style: TextStyle(fontSize: size),
    );
  }
}
```

### 11.2 Currency Display Widget

```dart
class PriceDisplay extends StatelessWidget {
  final num price;
  final String currencyCode;
  final TextStyle? style;

  const PriceDisplay({
    required this.price,
    required this.currencyCode,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      CurrencyUtils.formatPrice(price, currencyCode),
      style: style,
    );
  }
}
```

---

## 12. Testing Checklist

### Manual Testing per Country

For each country, test:
- [ ] Country selection in onboarding
- [ ] Region/district loading
- [ ] Currency formatting in listings
- [ ] Price validation (min/max)
- [ ] Phone number input with country code
- [ ] Product creation with local currency
- [ ] Product filtering by country/region
- [ ] Search within country
- [ ] Location display format
- [ ] Map/geocoding works correctly

### Countries to Test

Priority 1 (Central Asia):
- [ ] Uzbekistan (UZ)
- [ ] Kazakhstan (KZ)
- [ ] Kyrgyzstan (KG)
- [ ] Tajikistan (TJ)
- [ ] Turkmenistan (TM)

Priority 2 (Large markets):
- [ ] Russia (RU)
- [ ] Ukraine (UA)

Priority 3 (Others):
- [ ] Belarus (BY)
- [ ] Moldova (MD)
- [ ] Georgia (GE)
- [ ] Armenia (AM)
- [ ] Azerbaijan (AZ)
- [ ] Estonia (EE)
- [ ] Latvia (LV)
- [ ] Lithuania (LT)

---

## 13. Implementation Order

### Phase 1: Core Infrastructure
1. Add currency configurations
2. Create country model and provider
3. Update location model

### Phase 2: Country Selection
4. Add country selection to onboarding
5. Update region fetching to use country filter
6. Save selected country to user preferences

### Phase 3: Listings
7. Update product/service creation with country-aware currencies
8. Add country filter to product/service lists
9. Update search to filter by country

### Phase 4: Polish
10. Remove hardcoded Uzbekistan references
11. Add phone number country code picker
12. Update geocoding service
13. Add country flags throughout UI

### Phase 5: Testing & Launch
14. Test each country thoroughly
15. Phased rollout starting with Central Asia
