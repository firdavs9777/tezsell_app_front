import 'dart:convert';
import 'package:app/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/providers/provider_root/profile_provider.dart';
import 'package:app/providers/provider_models/user_model.dart';
import 'package:app/l10n/app_localizations.dart';
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
  bool _isSaving = false;

  final String regionsUrl = '$baseUrl/accounts/regions/';
  final String districtsUrl = '$baseUrl/accounts/districts';

  @override
  void initState() {
    super.initState();
    _userInfoFuture = ref.read(profileServiceProvider).getUserInfo();
    _fetchRegions();
  }

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

        _initializeLocation();
      } else {
        setState(() {
          isLoadingRegions = false;
        });
        _showError('Failed to load regions');
      }
    } catch (error) {
      setState(() {
        isLoadingRegions = false;
      });
      _showError('Error loading regions');
    }
  }

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
        _showError('Failed to load districts');
      }
    } catch (error) {
      setState(() {
        isLoadingDistricts = false;
      });
      _showError('Error loading districts');
    }
  }

  Future<void> _initializeLocation() async {
    try {
      final user = await _userInfoFuture;
      if (user.location != null && regions.isNotEmpty) {
        final userRegionName = user.location!.region;
        final userDistrictName = user.location!.district;

        if (userRegionName != null) {
          final matchingRegion = regions.firstWhere(
            (region) =>
                region.name.toLowerCase() == userRegionName.toLowerCase(),
            orElse: () => Region(name: ''),
          );

          if (matchingRegion.name != '') {
            setState(() {
              selectedRegion = matchingRegion;
            });

            await _fetchDistricts(matchingRegion.name);

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
      // Silent fail
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    final colorScheme = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: colorScheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Future<void> _saveLocation() async {
    if (selectedRegion == null || selectedDistrict == null) return;

    setState(() => _isSaving = true);

    try {
      await ref
          .read(profileServiceProvider)
          .updateUserInfo(locationId: selectedDistrict!.id);

      HapticFeedback.mediumImpact();

      if (mounted) {
        final colorScheme = Theme.of(context).colorScheme;
        final isDark = Theme.of(context).brightness == Brightness.dark;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: colorScheme.onPrimary, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Location updated to ${selectedDistrict!.name}',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: isDark ? colorScheme.primary : const Color(0xFF43A047),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.all(16),
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      _showError('Failed to update location');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          localizations?.locationTitle ?? 'Change Location',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<UserInfo>(
        future: _userInfoFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              isLoadingRegions) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Icon
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.location_on_rounded,
                      size: 40,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Title
                Center(
                  child: Text(
                    localizations?.locationTitle ?? 'Set Your Location',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    localizations?.location_subtitle ?? 'Choose your region and district to see nearby listings',
                    style: TextStyle(
                      fontSize: 14,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 32),

                // Current Location Card
                if (snapshot.hasData && snapshot.data!.location != null)
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 24),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: colorScheme.primary.withOpacity(0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.my_location_rounded,
                            size: 20,
                            color: colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                localizations?.locationLabel ?? 'Current Location',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${snapshot.data!.location!.district ?? ''}, ${snapshot.data!.location!.region ?? ''}',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                // Region Selection
                _buildSectionLabel(
                  localizations?.region ?? 'Region',
                  colorScheme,
                ),
                const SizedBox(height: 10),
                _buildDropdown<Region>(
                  value: selectedRegion,
                  hint: localizations?.selectRegion ?? 'Select Region',
                  items: regions,
                  isLoading: isLoadingRegions,
                  itemBuilder: (region) => region.name,
                  onChanged: (region) {
                    HapticFeedback.selectionClick();
                    setState(() {
                      selectedRegion = region;
                      selectedDistrict = null;
                      districts = [];
                    });
                    if (region != null) {
                      _fetchDistricts(region.name);
                    }
                  },
                  colorScheme: colorScheme,
                ),
                const SizedBox(height: 24),

                // District Selection
                _buildSectionLabel(
                  localizations?.district ?? 'District',
                  colorScheme,
                ),
                const SizedBox(height: 10),
                _buildDropdown<District>(
                  value: selectedDistrict,
                  hint: localizations?.districtSelectParagraph ?? 'Select District',
                  items: districts,
                  isLoading: isLoadingDistricts,
                  enabled: selectedRegion != null,
                  itemBuilder: (district) => district.name,
                  onChanged: (district) {
                    HapticFeedback.selectionClick();
                    setState(() {
                      selectedDistrict = district;
                    });
                  },
                  colorScheme: colorScheme,
                ),
                const SizedBox(height: 32),

                // Selected Location Preview
                if (selectedRegion != null && selectedDistrict != null)
                  Builder(
                    builder: (context) {
                      final isDark = Theme.of(context).brightness == Brightness.dark;
                      final successColor = isDark
                          ? colorScheme.primary
                          : const Color(0xFF43A047);
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: successColor.withOpacity(isDark ? 0.15 : 0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: successColor.withOpacity(isDark ? 0.4 : 0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle_rounded,
                              color: successColor,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    localizations?.selectedLocation ?? 'New Location',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: isDark
                                          ? colorScheme.onSurface.withOpacity(0.7)
                                          : successColor.withOpacity(0.9),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${selectedDistrict!.name}, ${selectedRegion!.name}',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: isDark
                                          ? colorScheme.onSurface
                                          : const Color(0xFF2E7D32),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                const SizedBox(height: 40),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: FilledButton(
                    onPressed: (selectedRegion != null && selectedDistrict != null && !_isSaving)
                        ? _saveLocation
                        : null,
                    style: FilledButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      disabledBackgroundColor: colorScheme.surfaceVariant,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: _isSaving
                        ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: colorScheme.onPrimary,
                            ),
                          )
                        : Text(
                            localizations?.saveLabel ?? 'Save Location',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionLabel(String label, ColorScheme colorScheme) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
    );
  }

  Widget _buildDropdown<T>({
    required T? value,
    required String hint,
    required List<T> items,
    required bool isLoading,
    required String Function(T) itemBuilder,
    required void Function(T?) onChanged,
    required ColorScheme colorScheme,
    bool enabled = true,
  }) {
    if (isLoading) {
      return Container(
        height: 56,
        decoration: BoxDecoration(
          color: colorScheme.surfaceVariant.withOpacity(0.3),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
        ),
        child: const Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: enabled
            ? colorScheme.surface
            : colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: enabled
              ? colorScheme.outline.withOpacity(0.3)
              : colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: DropdownButtonFormField<T>(
        value: value,
        isExpanded: true,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: InputBorder.none,
          hintText: hint,
          hintStyle: TextStyle(
            color: colorScheme.onSurfaceVariant.withOpacity(0.6),
            fontSize: 15,
          ),
        ),
        icon: Icon(
          Icons.keyboard_arrow_down_rounded,
          color: enabled ? colorScheme.onSurfaceVariant : colorScheme.outline,
        ),
        dropdownColor: colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        items: items.map((item) {
          return DropdownMenuItem<T>(
            value: item,
            child: Text(
              itemBuilder(item),
              style: TextStyle(
                fontSize: 15,
                color: colorScheme.onSurface,
              ),
            ),
          );
        }).toList(),
        onChanged: enabled ? onChanged : null,
      ),
    );
  }
}
