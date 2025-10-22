import 'dart:convert';
import 'dart:ui';
import 'package:app/pages/authentication/mobile_authentication.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Create a model class for district data
class District {
  final int id;
  final String name;

  District({required this.id, required this.name});

  factory District.fromJson(Map<String, dynamic> json) {
    return District(
      id: json['id'],
      name: json['district'],
    );
  }
}

class TownsList extends StatefulWidget {
  const TownsList({super.key, required this.city_id, required this.city_name});
  final String city_id;
  final String city_name;

  @override
  State<TownsList> createState() => _TownsListState();
}

class _TownsListState extends State<TownsList> {
  final String URL = 'https://api.webtezsell.com/accounts/districts';
  List<District> districts = []; // Changed from List<String> to List<District>
  List<District> filteredDistricts =
      []; // Changed from List<String> to List<District>
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse('$URL/${widget.city_id}/'));
      print(response.body);
      print(URL);
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        List<dynamic> districtData = responseData['districts'];

        setState(() {
          districts = districtData
              .map<District>((district) => District.fromJson(district))
              .toList();
          filteredDistricts = List.from(districts);
        });
      } else {
        _showErrorDialog(AppLocalizations.of(context)
                ?.errorWithCode(response.statusCode.toString()) ??
            'Error: ${response.statusCode}');
      }
    } catch (error) {
      _showErrorDialog(
          AppLocalizations.of(context)?.failedToLoadData(error.toString()) ??
              'Failed to load data. Error: $error');
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
              },
              child: Text(AppLocalizations.of(context)?.ok ?? 'OK'),
            ),
          ],
        );
      },
    );
  }

  void _filterTowns(String searchText) {
    setState(() {
      filteredDistricts = districts
          .where((district) =>
              district.name.toLowerCase().contains(searchText.toLowerCase()))
          .toList()
        ..sort((a, b) => a.name.compareTo(b.name)); // Sort by name
    });
  }

  Future<void> _showConfirmationDialog(District district) async {
    bool? confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: AlertDialog(
            title: Text(AppLocalizations.of(context)?.confirm ?? 'Tasdiqlash'),
            content: Text(AppLocalizations.of(context)
                    ?.confirmDistrictSelection(
                        widget.city_name, district.name) ??
                '${widget.city_name} viloyati -  ${district.name} tanlamoqchimisiz?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false); // User pressed "No"
                },
                child: Text(AppLocalizations.of(context)?.no ?? 'Yo\'q'),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true); // User pressed "Yes"
                  },
                  child: Text(AppLocalizations.of(context)?.yes ?? 'Ha')),
            ],
          ),
        );
      },
    );

    if (confirm ?? false) {
      print('City: ${widget.city_name}');
      print('City ID: ${widget.city_id}');
      print('District: ${district.name}');
      print('District ID: ${district.id}'); // Now you have the district ID!

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MobileAuthentication(
            regionName: widget.city_name,
            districtName: district.name,
            districtId: district.id.toString(), // Pass the district ID
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = Theme.of(context).colorScheme.onPrimary;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(
          widget.city_name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Center(
              child: Text(
                AppLocalizations.of(context)?.selectDistrictOrCity ??
                    'Iltimos, tuman yoki shaharingizni tanlang',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: TextField(
              controller: searchController,
              onChanged: _filterTowns,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)?.search ?? 'Izlash',
                hintText: AppLocalizations.of(context)?.searchHint ??
                    'Tuman yoki shaharni qidirish',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          Expanded(
            child: filteredDistricts.isNotEmpty
                ? ListView.builder(
                    itemCount: filteredDistricts.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: backgroundColor,
                        child: ListTile(
                          onTap: () =>
                              _showConfirmationDialog(filteredDistricts[index]),
                          title: Text(
                            filteredDistricts[index].name,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : Center(
                    child: Text(
                      AppLocalizations.of(context)?.noResultsFound ??
                          'Hech qanday natija topilmadi.',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
