import 'dart:convert';
import 'package:app/constants/constants.dart';
import 'package:app/providers/provider_models/location_model.dart';
import 'package:app/providers/provider_models/user_model.dart';
import 'package:app/providers/provider_models/country_model.dart';
import 'package:app/providers/provider_root/profile_provider.dart';
import 'package:app/providers/provider_root/product_provider.dart';
import 'package:app/providers/provider_root/service_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/l10n/app_localizations.dart';

class ProfileEditScreen extends ConsumerStatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();

  UserInfo? currentUser;

  // Country selection
  List<CountryModel> countriesList = [];
  CountryModel? selectedCountry;
  bool isLoadingCountries = false;

  List<Regions> regionsList = [];
  List<Districts> districtsList = [];
  String? selectedRegion;
  int? selectedRegionId;
  Districts? selectedDistrict;
  File? selectedImage;

  bool isLoading = false;
  bool isLoadingRegions = false;
  bool isLoadingDistricts = false;
  bool isSaving = false;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _initializeData() async {
    setState(() => isLoading = true);

    try {
      // Fetch user info and countries concurrently
      final results = await Future.wait([
        ref.read(profileServiceProvider).getUserInfo(),
        _fetchCountries(),
      ]);

      currentUser = results[0] as UserInfo;
      _usernameController.text = currentUser!.username;

      // Determine country: prioritize user's actual location, then saved prefs, then default
      final prefs = await SharedPreferences.getInstance();
      String countryCode;

      // Use user's actual location country if available
      if (currentUser!.location.countryCode != null &&
          currentUser!.location.countryCode!.isNotEmpty) {
        countryCode = currentUser!.location.countryCode!;
        print('[ProfileEdit] Using country from user location: $countryCode');
      } else {
        // Fall back to saved preferences or default
        countryCode = prefs.getString('selectedCountryCode') ?? 'UZ';
        print('[ProfileEdit] Using country from prefs/default: $countryCode');
      }

      // Find the country in the list
      if (countriesList.isNotEmpty) {
        selectedCountry = countriesList.firstWhere(
          (c) => c.code == countryCode,
          orElse: () => countriesList.first,
        );

        // Fetch regions for this country
        await _fetchRegions(selectedCountry!.code);

        // Set current region if it exists in the list
        if (currentUser!.location.region.isNotEmpty) {
          selectedRegion = currentUser!.location.region;
          final matchingRegion = regionsList.where(
            (r) => r.region.toLowerCase() == selectedRegion!.toLowerCase(),
          );
          if (matchingRegion.isNotEmpty) {
            selectedRegionId = matchingRegion.first.id;
            print('[ProfileEdit] Matched region: $selectedRegion (ID: $selectedRegionId)');
          } else {
            print('[ProfileEdit] Region not found in list: $selectedRegion');
          }
        }

        // Load districts for current region
        if (selectedRegion != null && selectedRegionId != null) {
          await _fetchDistricts(selectedRegionId!);
          // Set current district
          if (currentUser!.location.district.isNotEmpty) {
            final matchingDistrict = districtsList.where(
              (d) => d.district.toLowerCase() == currentUser!.location.district.toLowerCase(),
            );
            if (matchingDistrict.isNotEmpty) {
              selectedDistrict = matchingDistrict.first;
              print('[ProfileEdit] Matched district: ${selectedDistrict!.district} (ID: ${selectedDistrict!.id})');
            } else {
              print('[ProfileEdit] District not found in list: ${currentUser!.location.district}');
            }
          }
        }
      }
    } catch (e) {
      _showError('Failed to load profile data: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _fetchCountries() async {
    setState(() => isLoadingCountries = true);
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/accounts/countries/'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> countriesData = data['countries'] ?? [];
        setState(() {
          countriesList = countriesData
              .map((c) => CountryModel.fromJson(c))
              .toList();
        });
        print('[ProfileEdit] Loaded ${countriesList.length} countries');
      } else {
        // Fallback to static list
        setState(() {
          countriesList = CountryModel.supportedCountries;
        });
      }
    } catch (e) {
      print('[ProfileEdit] Error fetching countries: $e');
      // Fallback to static list
      setState(() {
        countriesList = CountryModel.supportedCountries;
      });
    } finally {
      setState(() => isLoadingCountries = false);
    }
  }

  Future<void> _fetchRegions(String countryCode) async {
    setState(() => isLoadingRegions = true);
    try {
      final url = '$baseUrl/accounts/regions/?country=$countryCode';
      print('[ProfileEdit] Fetching regions from: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> regionsData = data['regions'] ?? [];
        setState(() {
          regionsList = regionsData
              .where((r) => r['id'] != null)
              .map((r) => Regions(
                    id: r['id'] ?? 0,
                    region: r['region'] ?? '',
                  ))
              .toList();
        });
        print('[ProfileEdit] Loaded ${regionsList.length} regions');
      }
    } catch (e) {
      _showError('Failed to load regions: $e');
      setState(() => regionsList = []);
    } finally {
      setState(() => isLoadingRegions = false);
    }
  }

  Future<void> _fetchDistricts(int regionId) async {
    setState(() => isLoadingDistricts = true);
    try {
      final url = '$baseUrl/accounts/districts/$regionId/';
      print('[ProfileEdit] Fetching districts from: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> districtsData = data['districts'] ?? [];
        setState(() {
          districtsList = districtsData
              .map((d) => Districts(
                    id: d['id'] ?? 0,
                    district: d['district'] ?? '',
                  ))
              .toList();
        });
        print('[ProfileEdit] Loaded ${districtsList.length} districts');
      }
    } catch (e) {
      _showError('Failed to load districts: $e');
      setState(() => districtsList = []);
    } finally {
      setState(() => isLoadingDistricts = false);
    }
  }

  Future<void> _onCountryChanged(CountryModel? newCountry) async {
    if (newCountry == null || newCountry.code == selectedCountry?.code) return;

    setState(() {
      selectedCountry = newCountry;
      selectedRegion = null;
      selectedRegionId = null;
      selectedDistrict = null;
      regionsList = [];
      districtsList = [];
    });

    // Save country selection
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedCountryCode', newCountry.code);

    // Fetch regions for new country
    await _fetchRegions(newCountry.code);
  }

  Future<void> _onRegionChanged(Regions? newRegion) async {
    if (newRegion == null) return;

    setState(() {
      selectedRegion = newRegion.region;
      selectedRegionId = newRegion.id;
      selectedDistrict = null;
      districtsList = [];
    });

    // Fetch districts for new region
    await _fetchDistricts(newRegion.id);
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          selectedImage = File(image.path);
        });
      }
    } catch (e) {
      _showError('Failed to pick image: $e');
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate() || currentUser == null) return;

    if (selectedDistrict == null) {
      _showError('Please select a district');
      return;
    }

    setState(() => isSaving = true);

    try {
      await ref.read(profileServiceProvider).updateUserInfo(
            username: _usernameController.text.trim(),
            locationId: selectedDistrict!.id,
            profileImage: selectedImage,
            countryCode: selectedCountry?.code,
          );

      // Clear all caches so new location data is used
      ref.read(productsServiceProvider).clearCache();
      ref.invalidate(servicesProvider);
      ref.invalidate(myProfileProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Profile updated successfully!'),
            backgroundColor: Theme.of(context).colorScheme.primary,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pop(context, true); // Return true to indicate update
      }
    } catch (e) {
      _showError('Failed to update profile: $e');
    } finally {
      setState(() => isSaving = false);
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(localizations?.editProfileModalTitle ?? 'Edit Profile'),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (currentUser == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(localizations?.editProfileModalTitle ?? 'Edit Profile'),
        ),
        body: Center(
          child: Text(
            localizations?.errorMessage ?? 'Failed to load profile data',
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations?.editProfileModalTitle ?? 'Edit Profile'),
        actions: [
          TextButton(
            onPressed: isSaving ? null : _saveProfile,
            child: isSaving
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        colorScheme.onPrimary,
                      ),
                    ),
                  )
                : Text(
                    localizations?.saveLabel ?? 'Save',
                    style: TextStyle(
                      color: colorScheme.secondary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Profile Image Section
              GestureDetector(
                onTap: _pickImage,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: colorScheme.surfaceVariant,
                      backgroundImage: _getProfileImage(),
                      child: _getProfileImage() == null
                          ? Icon(
                              Icons.person,
                              size: 60,
                              color: colorScheme.onSurface.withOpacity(0.6),
                            )
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: colorScheme.surface,
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          color: colorScheme.onPrimary,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                localizations?.tap_change_profile ?? 'Tap to change photo',
                style: TextStyle(
                  color: colorScheme.onSurface.withOpacity(0.6),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 32),

              // Username Field
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: localizations?.username ?? 'Username',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return localizations?.username_required ??
                        'Username is required';
                  }
                  if (value.trim().length < 2) {
                    return localizations?.username_min_length ??
                        'Username must be at least 2 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Phone Number (Read-only)
              TextFormField(
                initialValue: currentUser!.phoneNumber,
                decoration: InputDecoration(
                  labelText: localizations?.phoneNumber,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.phone),
                  fillColor: colorScheme.surfaceVariant.withOpacity(0.3),
                  filled: true,
                ),
                enabled: false,
              ),
              const SizedBox(height: 20),

              // Country Dropdown
              DropdownButtonFormField<CountryModel>(
                value: selectedCountry,
                decoration: InputDecoration(
                  labelText: localizations?.country ?? 'Country',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.flag),
                  suffixIcon: isLoadingCountries
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                colorScheme.primary,
                              ),
                            ),
                          ),
                        )
                      : null,
                ),
                hint: Text(localizations?.selectCountry ?? 'Select a country'),
                items: countriesList.map((CountryModel country) {
                  final locale = Localizations.localeOf(context).languageCode;
                  return DropdownMenuItem<CountryModel>(
                    value: country,
                    child: Text('${country.flagEmoji} ${country.getLocalizedName(locale)}'),
                  );
                }).toList(),
                onChanged: isLoadingCountries ? null : _onCountryChanged,
                validator: (value) {
                  if (value == null) {
                    return localizations?.selectCountry ??
                        'Please select a country';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Region Dropdown
              DropdownButtonFormField<Regions>(
                value: selectedRegion != null && regionsList.isNotEmpty
                    ? regionsList.cast<Regions?>().firstWhere(
                        (r) => r?.region == selectedRegion,
                        orElse: () => null,
                      )
                    : null,
                decoration: InputDecoration(
                  labelText: localizations?.region ?? 'Region',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.location_on),
                  suffixIcon: isLoadingRegions
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                colorScheme.primary,
                              ),
                            ),
                          ),
                        )
                      : null,
                ),
                hint: Text(selectedCountry == null
                    ? localizations?.selectCountryFirst ?? 'Select country first'
                    : localizations?.selectRegion ?? 'Select a region'),
                items: regionsList.isEmpty
                    ? null
                    : regionsList
                        .where((r) => r.region.isNotEmpty)
                        .map((Regions region) {
                          return DropdownMenuItem<Regions>(
                            value: region,
                            child: Text(region.region),
                          );
                        }).toList(),
                onChanged: selectedCountry == null || isLoadingRegions
                    ? null
                    : _onRegionChanged,
                validator: (value) {
                  if (value == null) {
                    return localizations?.selectRegion ??
                        'Please select a region';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // District Dropdown
              DropdownButtonFormField<Districts>(
                value: selectedDistrict,
                decoration: InputDecoration(
                  labelText:
                      localizations?.districtSelectParagraph ?? 'District',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.location_city),
                  suffixIcon: isLoadingDistricts
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                colorScheme.primary,
                              ),
                            ),
                          ),
                        )
                      : null,
                ),
                hint: Text(selectedRegion == null
                    ? localizations?.selectRegion ?? 'Select a region first'
                    : localizations?.districtSelectParagraph ??
                        'Select a district'),
                items: districtsList.isEmpty
                    ? null
                    : districtsList.map((Districts district) {
                        return DropdownMenuItem<Districts>(
                          value: district,
                          child: Text(district.district),
                        );
                      }).toList(),
                onChanged: selectedRegion == null || isLoadingDistricts
                    ? null
                    : (Districts? newValue) {
                        setState(() {
                          selectedDistrict = newValue;
                        });
                      },
                validator: (value) {
                  if (value == null) {
                    return localizations?.districtSelectParagraph ??
                        'Please select a district';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  ImageProvider? _getProfileImage() {
    if (selectedImage != null) {
      return FileImage(selectedImage!);
    } else if (currentUser?.profileImage != null) {
      final imagePath = currentUser!.profileImage!.image;
      final imageUrl = imagePath.startsWith('http://') ||
              imagePath.startsWith('https://')
          ? imagePath
          : "$baseUrl$imagePath";
      return NetworkImage(imageUrl);
    }
    return null;
  }
}
