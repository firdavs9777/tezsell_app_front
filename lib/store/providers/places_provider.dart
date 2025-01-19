import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final String URL = 'http://localhost:5002/api/v1/cities';
final fetchDataProvider =
    StateNotifierProvider<FetchDataNotifier, FetchDataState>((ref) {
  return FetchDataNotifier();
});

class FetchDataState {
  final List<String> cities;
  final List<String> cityId;
  final List<String> filteredCities;
  final List<String> filteredCityId;

  FetchDataState({
    required this.cities,
    required this.cityId,
    required this.filteredCities,
    required this.filteredCityId,
  });

  FetchDataState copyWith({
    List<String>? cities,
    List<String>? cityId,
    List<String>? filteredCities,
    List<String>? filteredCityId,
  }) {
    return FetchDataState(
      cities: cities ?? this.cities,
      cityId: cityId ?? this.cityId,
      filteredCities: filteredCities ?? this.filteredCities,
      filteredCityId: filteredCityId ?? this.filteredCityId,
    );
  }

  FetchDataState filterCities(String searchText) {
    final List<String> filteredCities = cities
        .where((city) => city.toLowerCase().contains(searchText.toLowerCase()))
        .toSet()
        .toList()
      ..sort();
    final List<String> filteredCityId = [];
    for (String city in filteredCities) {
      int index = cities.indexOf(city);
      if (index != -1) {
        filteredCityId.add(cityId[index]);
      }
    }
    return copyWith(
        filteredCities: filteredCities, filteredCityId: filteredCityId);
  }
}

class FetchDataNotifier extends StateNotifier<FetchDataState> {
  FetchDataNotifier()
      : super(FetchDataState(
            cities: [], cityId: [], filteredCities: [], filteredCityId: []));

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse(URL));
      if (response.statusCode == 200) {
        final List<dynamic>? data = json.decode(response.body)['data'];
        final List<String> cities = data
                ?.map<String>((cityData) => cityData?['name']?.toString() ?? '')
                .toList() ??
            [];
        final List<String> cityId = data
                ?.map<String>((cityData) => cityData?['_id']?.toString() ?? '')
                .toList() ??
            [];
        state = FetchDataState(
          cities: cities,
          cityId: cityId,
          filteredCities: List.from(cities),
          filteredCityId: List.from(cityId),
        );
      }
    } catch (error) {
      print(error);
      // Handle exceptions
      _showErrorDialog('Failed to load data. Error: $error');
    }
  }

  void filterCities(String searchText) {
    state = state.filterCities(searchText);
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xato'),
          content: Text('Api chaqirganda muamo yuzaga keldi'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
