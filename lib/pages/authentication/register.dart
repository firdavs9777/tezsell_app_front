import 'dart:convert';

import 'package:app/pages/city/city_list.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  final String URL = 'https://api.webtezsell.com/accounts/regions/';
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
      print(URL);
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

      print(response.body);

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
      print('Error fetching data: $error');

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
        appBar: AppBar(
          backgroundColor: Colors.orange,
          title: Text(
            AppLocalizations.of(context)?.appTitle ?? 'Tezsell',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 30),
            SizedBox(height: 10),
            Text(
              AppLocalizations.of(context)?.selectRegion ??
                  'Iltimos Viloyatingizni tanlang',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: TextField(
                controller: searchController,
                onChanged: _filterCities,
                enabled: !isLoading, // Disable search while loading
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)?.search ?? 'Izlash',
                  hintText: AppLocalizations.of(context)?.searchHint ??
                      'Tuman yoki shaharni qidirish',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            // Show loading indicator, error message, or city list
            Expanded(
              child: isLoading
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            color: Colors.orange,
                          ),
                          SizedBox(height: 16),
                          Text(
                            AppLocalizations.of(context)?.loading ??
                                'Yuklanmoqda...',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    )
                  : errorMessage != null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline,
                                size: 64,
                                color: Colors.red,
                              ),
                              SizedBox(height: 16),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 32),
                                child: Text(
                                  AppLocalizations.of(context)
                                          ?.dataLoadingError ??
                                      'Ma\'lumotlarni yuklashda xatolik',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              SizedBox(height: 24),
                              ElevatedButton.icon(
                                onPressed: fetchData,
                                icon: Icon(Icons.refresh),
                                label: Text(
                                    AppLocalizations.of(context)?.retry ??
                                        'Qayta urinish'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        )
                      : CityList(
                          cityList: filteredCities, cityId: filteredCityId),
            ),
          ],
        ));
  }
}
