import 'package:app/constants/constants.dart';
import 'package:app/providers/provider_models/location_model.dart';
import 'package:app/providers/provider_models/user_model.dart';
import 'package:app/providers/provider_root/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileEditScreen extends ConsumerStatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();

  UserInfo? currentUser;
  List<Regions> regionsList = [];
  List<Districts> districtsList = [];
  String? selectedRegion;
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
      // Fetch user info and regions concurrently
      final results = await Future.wait([
        ref.read(profileServiceProvider).getUserInfo(),
        _fetchRegions(),
      ]);

      currentUser = results[0] as UserInfo;
      _usernameController.text = currentUser!.username;
      selectedRegion = currentUser!.location.region;

      // Load districts for current region
      if (selectedRegion != null) {
        await _fetchDistricts(selectedRegion!);
        // Set current district
        selectedDistrict = districtsList.firstWhere(
          (district) => district.district == currentUser!.location.district,
          orElse: () => districtsList.isNotEmpty
              ? districtsList.first
              : Districts(id: 0, district: ''),
        );
      }
    } catch (e) {
      _showError('Failed to load profile data: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _fetchRegions() async {
    setState(() => isLoadingRegions = true);
    try {
      regionsList = await ref.read(profileServiceProvider).getRegionsList();
    } catch (e) {
      _showError('Failed to load regions: $e');
    } finally {
      setState(() => isLoadingRegions = false);
    }
  }

  Future<void> _fetchDistricts(String regionName) async {
    setState(() => isLoadingDistricts = true);
    try {
      districtsList = await ref
          .read(profileServiceProvider)
          .getDistrictsList(regionName: regionName);
    } catch (e) {
      _showError('Failed to load districts: $e');
      districtsList = [];
    } finally {
      setState(() => isLoadingDistricts = false);
    }
  }

  Future<void> _onRegionChanged(String? newRegion) async {
    if (newRegion == null || newRegion == selectedRegion) return;

    setState(() {
      selectedRegion = newRegion;
      selectedDistrict = null; // Reset district when region changes
      districtsList = []; // Clear previous districts
    });

    // Fetch districts for new region
    await _fetchDistricts(newRegion);
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
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: Colors.green,
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
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
            title:
                Text(localizations?.editProfileModalTitle ?? 'Edit Profile')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (currentUser == null) {
      return Scaffold(
        appBar: AppBar(
            title:
                Text(localizations?.editProfileModalTitle ?? 'Edit Profile')),
        body: Center(
            child: Text(
                localizations?.errorMessage ?? 'Failed to load profile data')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations?.editProfileModalTitle ?? 'Edit Profile'),
        actions: [
          TextButton(
            onPressed: isSaving ? null : _saveProfile,
            child: isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(localizations?.saveLabel ?? 'Save',
                    style: TextStyle(color: Colors.white)),
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
                      backgroundImage: _getProfileImage(),
                      child: _getProfileImage() == null
                          ? const Icon(Icons.person, size: 60)
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
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
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              const SizedBox(height: 32),

              // Username Field
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: localizations?.username ?? 'Username',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
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
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
                enabled: false,
              ),
              const SizedBox(height: 20),

              // Region Dropdown
              DropdownButtonFormField<String>(
                value: selectedRegion,
                decoration: InputDecoration(
                  labelText: localizations?.region ?? 'Region',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on),
                ),
                hint: Text(localizations?.selectRegion ?? 'Select a region'),
                items: isLoadingRegions
                    ? [
                        const DropdownMenuItem(
                          value: null,
                          child: Text('Loading regions...'),
                        )
                      ]
                    : regionsList.map((Regions region) {
                        return DropdownMenuItem<String>(
                          value: region.region,
                          child: Text(region.region),
                        );
                      }).toList(),
                onChanged: isLoadingRegions ? null : _onRegionChanged,
                validator: (value) {
                  if (value == null || value.isEmpty) {
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
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: Padding(
                            padding: EdgeInsets.all(12.0),
                            child: CircularProgressIndicator(strokeWidth: 2),
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
      return NetworkImage("$baseUrl${currentUser!.profileImage!.image}");
    }
    return null;
  }
}
