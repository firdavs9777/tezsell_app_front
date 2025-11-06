import 'dart:convert';
import 'package:app/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/providers/provider_root/profile_provider.dart';
import 'package:app/providers/provider_models/user_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;

// Model classes for API data
class Region {
  final String name;

  Region({required this.name});

  factory Region.fromJson(Map<String, dynamic> json) {
    return Region(
      name: json['region'] ?? json['name'] ?? '',
    );
  }
}

class District {
  final int id;
  final String name;

  District({required this.id, required this.name});

  factory District.fromJson(Map<String, dynamic> json) {
    return District(
      id: json['id'],
      name: json['district'] ?? json['name'] ?? '',
    );
  }
}

class MyHomeTown extends ConsumerStatefulWidget {
  const MyHomeTown({super.key});

  @override
  ConsumerState<MyHomeTown> createState() => _MyHomeTownState();
}

class _MyHomeTownState extends ConsumerState<MyHomeTown> {
  Region? selectedRegion;
  District? selectedDistrict;
  late Future<UserInfo> _userInfoFuture;

  List<Region> regions = [];
  List<District> districts = [];
  bool isLoadingRegions = true;
  bool isLoadingDistricts = false;

  final String regionsUrl = '$baseUrl/accounts/regions/';
  final String districtsUrl = '$baseUrl/accounts/districts';

  @override
  void initState() {
    super.initState();
    _userInfoFuture = ref.read(profileServiceProvider).getUserInfo();
    _fetchRegions();
  }

  // Fetch regions from API
  Future<void> _fetchRegions() async {
    try {
      final response = await http.get(Uri.parse(regionsUrl));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> regionData = responseData['regions'] ?? [];

        setState(() {
          regions = regionData
              .map<Region>((region) => Region.fromJson(region))
              .toList();
          isLoadingRegions = false;
        });

        // Initialize location after regions are loaded
        _initializeLocation();
      } else {
        setState(() {
          isLoadingRegions = false;
        });
        _showErrorDialog('Failed to load regions: ${response.statusCode}');
      }
    } catch (error) {
      setState(() {
        isLoadingRegions = false;
      });
      _showErrorDialog('Error loading regions: $error');
    }
  }

  // Fetch districts for selected region
  Future<void> _fetchDistricts(String regionName) async {
    setState(() {
      isLoadingDistricts = true;
      districts = [];
      selectedDistrict = null;
    });

    try {
      final response = await http.get(Uri.parse('$districtsUrl/$regionName/'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> districtData = responseData['districts'] ?? [];

        setState(() {
          districts = districtData
              .map<District>((district) => District.fromJson(district))
              .toList();
          isLoadingDistricts = false;
        });
      } else {
        setState(() {
          isLoadingDistricts = false;
        });
        _showErrorDialog('Failed to load districts: ${response.statusCode}');
      }
    } catch (error) {
      setState(() {
        isLoadingDistricts = false;
      });
      _showErrorDialog('Error loading districts: $error');
    }
  }

  // Initialize location from user data
  Future<void> _initializeLocation() async {
    try {
      final user = await _userInfoFuture;
      if (user.location != null && regions.isNotEmpty) {
        final userRegionName = user.location!.region;
        final userDistrictName = user.location!.district;

        if (userRegionName != null) {
          // Find matching region by name
          final matchingRegion = regions.firstWhere(
            (region) =>
                region.name.toLowerCase() == userRegionName.toLowerCase(),
            orElse: () => Region(name: ''),
          );

          if (matchingRegion.name != '') {
            setState(() {
              selectedRegion = matchingRegion;
            });

            // Load districts for this region
            await _fetchDistricts(matchingRegion.name);

            // Set district if available
            if (userDistrictName != null && districts.isNotEmpty) {
              final matchingDistrict = districts.firstWhere(
                (district) =>
                    district.name.toLowerCase() ==
                    userDistrictName.toLowerCase(),
                orElse: () => District(id: -1, name: ''),
              );

              if (matchingDistrict.id != -1) {
                setState(() {
                  selectedDistrict = matchingDistrict;
                });
              }
            }
          }
        }
      }
    } catch (e) {
      print('Error loading user location: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Save location (you can implement this method to update user's location)
  Future<void> _saveLocation() async {
    if (selectedRegion != null && selectedDistrict != null) {
      // TODO: Implement API call to save user's location
      // You can call your profile service to update the location

      await ref
          .read(profileServiceProvider)
          .updateUserInfo(locationId: selectedDistrict!.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Location set to ${selectedDistrict!.name}, ${selectedRegion!.name}'),
        ),
      );

      // Optionally navigate back
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations?.locationTitle ?? 'Change the Location'),
        backgroundColor: Colors.orange,
      ),
      body: FutureBuilder<UserInfo>(
        future: _userInfoFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              isLoadingRegions) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(localizations?.error ?? 'Error loading user info'),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    localizations?.locationTitle ?? 'Location Change',
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),

                // Show current location if available
                if (snapshot.hasData && snapshot.data!.location != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          localizations?.locationLabel ?? 'Current Location:',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${snapshot.data!.location!.region ?? ''} ${snapshot.data!.location!.district ?? ''}',
                          style:
                              const TextStyle(fontSize: 16, color: Colors.blue),
                        ),
                      ],
                    ),
                  ),

                // Region Dropdown
                Text(localizations?.region ?? 'Region',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                isLoadingRegions
                    ? const Center(child: CircularProgressIndicator())
                    : DropdownButtonFormField<Region>(
                        isExpanded: true,
                        value: selectedRegion,
                        hint: Text(
                            localizations?.selectRegion ?? 'Select Region'),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        items: regions.map((region) {
                          return DropdownMenuItem(
                            value: region,
                            child: Text(region.name),
                          );
                        }).toList(),
                        onChanged: (region) {
                          setState(() {
                            selectedRegion = region;
                            selectedDistrict = null;
                            districts = [];
                          });
                          if (region != null) {
                            _fetchDistricts(region.name);
                          }
                        },
                      ),

                const SizedBox(height: 15),

                // District Dropdown
                Text(localizations?.district ?? 'District',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                isLoadingDistricts
                    ? const Center(child: CircularProgressIndicator())
                    : DropdownButtonFormField<District>(
                        isExpanded: true,
                        value: selectedDistrict,
                        hint: Text(localizations?.districtSelectParagraph ??
                            'Select District'),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        items: districts.map((district) {
                          return DropdownMenuItem(
                            value: district,
                            child: Text(district.name),
                          );
                        }).toList(),
                        onChanged: selectedRegion == null
                            ? null
                            : (district) {
                                setState(() {
                                  selectedDistrict = district;
                                });
                              },
                      ),

                const SizedBox(height: 20),

                // Selected Region & District
                Text(localizations?.selectedLocation ?? 'Selected Location:',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600)),
                Text(
                  selectedRegion != null && selectedDistrict != null
                      ? '${selectedDistrict!.name}, ${selectedRegion!.name}'
                      : 'None',
                  style: const TextStyle(fontSize: 16),
                ),

                const Spacer(),
                Center(
                  child: ElevatedButton(
                    onPressed:
                        (selectedRegion != null && selectedDistrict != null)
                            ? _saveLocation
                            : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 12),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    child: Text(localizations?.saveLabel ?? 'Submit'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
