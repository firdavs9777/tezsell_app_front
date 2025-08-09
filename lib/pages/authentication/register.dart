import 'dart:convert';

import 'package:app/pages/city/city_list.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  void initState() {
    super.initState();
    fetchData();
  }

  List<String> towns = [];
  List<String> filteredCities = []; // List to store filtered towns
  TextEditingController searchController = TextEditingController();

  final String URL = 'https://api.webtezsell.com/accounts/regions/';
  List<String> cities = [];
  // List<List<String>> towns = [];
  List<String> cityId = [];
  List<String> filteredCityId = [];

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse(URL));
      print(response.body);
      if (response.statusCode == 200) {
        setState(() {
          cities = (json.decode(response.body)['regions'] as List)
                  ?.map<String>(
                      (cityData) => cityData?['region']?.toString() ?? '')
                  .toList() ??
              [];
          // List jsonData = json.decode(response.body)['data'] as List;
          // print(jsonData);
          cityId = (json.decode(response.body)['regions'] as List)
                  ?.map<String>(
                      (cityData) => cityData?['region']?.toString() ?? '')
                  .toList() ??
              [];
          print(cityId);
          filteredCities = List.from(cities);
          filteredCityId = List.from(cityId);
          // towns = [];
        });
      }
    } catch (error) {
      print(error);
      // Handle exceptions
      _showErrorDialog('Failed to load data. Error: $error');
    }
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

  void _filterCities(String searchText) {
    setState(() {
      // Filter cities alphabetically and remove duplicates
      filteredCities = cities
          .where(
              (city) => city.toLowerCase().contains(searchText.toLowerCase()))
          .toSet() // Convert to Set to remove duplicates
          .toList() // Convert back to List
        ..sort(); // Sort alphabetically
      // Update filteredCityId based on filteredCities
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
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          title: Text(
            'Tezsell',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            SizedBox(height: 10),
            Text(
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
                decoration: InputDecoration(
                  labelText: 'Izlash',
                  hintText: 'Tuman yoki shaharni qidirish',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            CityList(cityList: filteredCities, cityId: filteredCityId),
          ],
        ));
  }
}
