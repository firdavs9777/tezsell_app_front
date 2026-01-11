import 'dart:convert';

import 'package:app/constants/constants.dart';
import 'package:app/pages/city/city_list.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:app/l10n/app_localizations.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  List<String> towns = [];
  List<String> filteredCities = [];
  TextEditingController searchController = TextEditingController();

  final String URL = '$baseUrl/accounts/regions/';
  List<String> cities = [];
  List<String> cityId = [];
  List<String> filteredCityId = [];

  // Add loading state
  bool isLoading = true;
  String? errorMessage;

  Future<void> fetchData() async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await http.get(
        Uri.parse(URL),
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(
        Duration(seconds: 15), // Add timeout to prevent hanging
        onTimeout: () {
          throw Exception(
              'Connection timeout. Please check your internet connection.');
        },
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        setState(() {
          cities = (jsonData['regions'] as List?)
                  ?.map<String>(
                      (cityData) => cityData?['region']?.toString() ?? '')
                  .where((city) => city.isNotEmpty)
                  .toList() ??
              [];

          cityId = (jsonData['regions'] as List?)
                  ?.map<String>(
                      (cityData) => cityData?['region']?.toString() ?? '')
                  .where((city) => city.isNotEmpty)
                  .toList() ??
              [];

          filteredCities = List.from(cities);
          filteredCityId = List.from(cityId);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Server error: ${response.statusCode}';
        });
      }
    } catch (error) {

      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage = error.toString();
      });
    }
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
                fetchData(); // Retry loading data
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
        int index = cities.indexOf(city);
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
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
            ),
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
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 40.0),

            // Search field - matching login style
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: TextField(
                controller: searchController,
                onChanged: _filterCities,
                enabled: !isLoading,
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
                  prefixIcon: Icon(
                    Icons.search,
                    color: isLoading
                        ? Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.4)
                        : Theme.of(context).textTheme.bodySmall?.color,
                  ),
                  hintText: AppLocalizations.of(context)?.searchHint ??
                      'Search for city or region',
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
              child: isLoading
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
                                    onPressed: fetchData,
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
                          cityList: filteredCities, cityId: filteredCityId),
            ),
          ],
        ));
  }
}

