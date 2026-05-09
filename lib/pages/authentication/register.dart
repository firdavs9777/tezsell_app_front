import 'dart:convert';
import 'dart:developer' as developer;

import 'package:app/constants/constants.dart';
import 'package:app/pages/city/city_list.dart';
import 'package:app/providers/provider_models/country_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:app/l10n/app_localizations.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // Country selection
  CountryModel? selectedCountry;
  List<CountryModel> countries = [];

  List<String> towns = [];
  List<String> filteredCities = [];
  TextEditingController searchController = TextEditingController();

  List<String> cities = [];
  List<String> cityId = [];
  List<String> filteredCityId = [];

  // Add loading state
  bool isLoading = false;
  bool isLoadingRegions = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeCountries();
  }

  void _initializeCountries() {
    developer.log('[Register] Initializing countries list', name: 'Register');
    print('[Register] Initializing countries list');
    countries = CountryModel.supportedCountries;
    developer.log('[Register] Loaded ${countries.length} countries', name: 'Register');
    print('[Register] Loaded ${countries.length} countries');
  }

  Future<void> fetchRegions(String countryCode) async {
    if (!mounted) return;

    print('[Register] Fetching regions for country: $countryCode');
    developer.log('[Register] Fetching regions for country: $countryCode', name: 'Register');

    setState(() {
      isLoadingRegions = true;
      errorMessage = null;
      cities = [];
      cityId = [];
      filteredCities = [];
      filteredCityId = [];
    });

    // Try with country filter first, then fallback to without filter
    String url = '$baseUrl/accounts/regions/?country=$countryCode';
    print('[Register] API URL: $url');
    developer.log('[Register] API URL: $url', name: 'Register');

    try {
      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          developer.log('[Register] Request timeout for regions', name: 'Register');
          throw Exception(
              'Connection timeout. Please check your internet connection.');
        },
      );

      print('[Register] Response status: ${response.statusCode}');
      print('[Register] Response body: ${response.body}');
      developer.log('[Register] Response status: ${response.statusCode}', name: 'Register');
      developer.log('[Register] Response body: ${response.body}', name: 'Register');

      // If country filter returns empty or error, try without filter for UZ
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final regionsList = jsonData['regions'] ?? jsonData['results'] ?? [];

        if ((regionsList as List).isEmpty && countryCode == 'UZ') {
          developer.log('[Register] Empty response with country filter, trying without filter', name: 'Register');
          url = '$baseUrl/accounts/regions/';
          response = await http.get(
            Uri.parse(url),
            headers: {'Content-Type': 'application/json'},
          );
          developer.log('[Register] Fallback response: ${response.body}', name: 'Register');
        }
      }

      if (!mounted) return;

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final regionsList = jsonData['regions'] ?? jsonData['results'] ?? [];

        setState(() {
          cities = (regionsList as List)
              .map<String>((cityData) => cityData?['region']?.toString() ?? '')
              .where((city) => city.isNotEmpty)
              .toList();

          // Use region ID if available, otherwise use region name
          cityId = (regionsList)
              .map<String>((cityData) => (cityData?['id'] ?? cityData?['region'])?.toString() ?? '')
              .where((id) => id.isNotEmpty)
              .toList();

          filteredCities = List.from(cities);
          filteredCityId = List.from(cityId);
          isLoadingRegions = false;
        });

        print('[Register] Region IDs: $cityId');

        print('[Register] Loaded ${cities.length} regions: $cities');
        developer.log('[Register] Loaded ${cities.length} regions', name: 'Register');
      } else {
        print('[Register] Error response: ${response.body}');
        developer.log('[Register] Error response: ${response.body}', name: 'Register');
        setState(() {
          isLoadingRegions = false;
          errorMessage = 'Server error: ${response.statusCode}';
        });
      }
    } catch (error) {
      print('[Register] Error fetching regions: $error');
      developer.log('[Register] Error fetching regions: $error', name: 'Register');

      if (!mounted) return;

      setState(() {
        isLoadingRegions = false;
        errorMessage = error.toString();
      });
    }
  }

  void _showCountryPicker() {
    print('[Register] Opening country picker with ${countries.length} countries');
    developer.log('[Register] Opening country picker', name: 'Register');
    final locale = Localizations.localeOf(context).languageCode;
    final colorScheme = Theme.of(context).colorScheme;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.onSurface.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Title
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  AppLocalizations.of(context)?.selectCountry ?? 'Select Country',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Divider(height: 1, color: colorScheme.outlineVariant),
              // Countries list
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: countries.length,
                  itemBuilder: (context, index) {
                    final country = countries[index];
                    final isSelected = selectedCountry?.code == country.code;

                    return ListTile(
                      leading: Text(
                        country.flagEmoji,
                        style: const TextStyle(fontSize: 28),
                      ),
                      title: Text(
                        country.getLocalizedName(locale),
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        '${country.currency.code} (${country.currency.symbol})',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      trailing: isSelected
                          ? Icon(Icons.check_circle, color: colorScheme.primary)
                          : null,
                      onTap: () {
                        print('[Register] Selected country: ${country.code} - ${country.name}');
                        developer.log('[Register] Selected country: ${country.code} - ${country.name}', name: 'Register');
                        Navigator.pop(context);
                        setState(() {
                          selectedCountry = country;
                        });
                        fetchRegions(country.code);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)?.error ?? 'Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (selectedCountry != null) {
                  fetchRegions(selectedCountry!.code);
                }
              },
              child: Text(AppLocalizations.of(context)?.retry ?? 'Retry'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)?.ok ?? 'OK'),
            ),
          ],
        );
      },
    );
  }

  void _filterCities(String searchText) {
    setState(() {
      filteredCities = cities
          .where(
              (city) => city.toLowerCase().contains(searchText.toLowerCase()))
          .toSet()
          .toList()
        ..sort();

      filteredCityId = [];
      for (String city in filteredCities) {
        final int index = cities.indexOf(city);
        if (index != -1) {
          filteredCityId.add(cityId[index]);
        }
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Widget _buildCountrySelector() {
    final colorScheme = Theme.of(context).colorScheme;
    final locale = Localizations.localeOf(context).languageCode;

    return InkWell(
      onTap: _showCountryPicker,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selectedCountry != null
                ? colorScheme.primary.withOpacity(0.3)
                : colorScheme.outline.withOpacity(0.2),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            if (selectedCountry != null) ...[
              Text(
                selectedCountry!.flagEmoji,
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      selectedCountry!.getLocalizedName(locale),
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${selectedCountry!.currency.code} (${selectedCountry!.currency.symbol})',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ] else ...[
              Icon(
                Icons.public,
                color: colorScheme.onSurface.withOpacity(0.5),
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  AppLocalizations.of(context)?.selectCountry ?? 'Select Country',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
            Icon(
              Icons.keyboard_arrow_down,
              color: colorScheme.onSurface.withOpacity(0.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectCountryPrompt() {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.public,
            size: 80,
            color: colorScheme.primary.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)?.selectCountryFirst ?? 'Select your country first',
            style: textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)?.countrySelectionHint ?? 'Then you can choose your region',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            AppLocalizations.of(context)?.appTitle ?? 'Tezsell',
          ),
          centerTitle: true,
          foregroundColor: Theme.of(context).colorScheme.onSurface,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 40.0),
            
            // Logo with circular background matching login
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white.withOpacity(0.1)
                        : Colors.black.withOpacity(0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/logo/logo.png',
                  fit: BoxFit.cover,
                  width: 120,
                  height: 120,
                  errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.location_on,
                        size: 60,
                        color: Theme.of(context).primaryColor,
                      );
                  },
                ),
              ),
            ),

            const SizedBox(height: 32.0),

            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                AppLocalizations.of(context)?.selectRegion ??
                    'Select Your Region',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 24.0),

            // Country selector
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: _buildCountrySelector(),
            ),

            const SizedBox(height: 16.0),

            // Search field - matching login style (only enabled after country selection)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: TextField(
                controller: searchController,
                onChanged: _filterCities,
                enabled: selectedCountry != null && !isLoadingRegions,
                style: Theme.of(context).textTheme.bodyLarge,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: selectedCountry == null
                        ? Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.4)
                        : Theme.of(context).textTheme.bodySmall?.color,
                  ),
                  hintText: selectedCountry == null
                      ? (AppLocalizations.of(context)?.selectCountryFirst ?? 'Select country first')
                      : (AppLocalizations.of(context)?.searchHint ?? 'Search for city or region'),
                  hintStyle: TextStyle(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                    fontWeight: FontWeight.w400,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 16,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24.0),
            // Show loading indicator, error message, or city list
            Expanded(
              child: selectedCountry == null
                  ? _buildSelectCountryPrompt()
                  : isLoadingRegions
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                color: Theme.of(context).primaryColor,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                AppLocalizations.of(context)?.loading ??
                                    'Loading...',
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: Theme.of(context).textTheme.bodySmall?.color,
                                ),
                              ),
                            ],
                          ),
                        )
                      : errorMessage != null
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.error_outline,
                                      size: 64,
                                      color: Theme.of(context).colorScheme.error,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      AppLocalizations.of(context)
                                              ?.dataLoadingError ??
                                          'Error loading data',
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                        color: Theme.of(context).textTheme.bodySmall?.color,
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    Container(
                                      width: double.infinity,
                                      height: 56,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: Theme.of(context).brightness == Brightness.dark
                                            ? []
                                            : [
                                                BoxShadow(
                                                  color: Theme.of(context).primaryColor.withOpacity(0.3),
                                                  blurRadius: 12,
                                                  offset: const Offset(0, 4),
                                                ),
                                              ],
                                      ),
                                      child: ElevatedButton.icon(
                                        onPressed: () {
                                          if (selectedCountry != null) {
                                            fetchRegions(selectedCountry!.code);
                                          }
                                        },
                                        icon: const Icon(Icons.refresh),
                                        label: Text(
                                            AppLocalizations.of(context)?.retry ??
                                                'Retry'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Theme.of(context).primaryColor,
                                          foregroundColor: Theme.of(context).colorScheme.onPrimary,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : CityList(
                              cityList: filteredCities,
                              cityId: filteredCityId,
                              countryCode: selectedCountry?.code ?? '',
                            ),
            ),
          ],
        ));
  }
}

