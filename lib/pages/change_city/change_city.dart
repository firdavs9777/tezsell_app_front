import 'dart:convert';
import 'dart:developer' as developer;
import 'package:app/config/app_config.dart';
import 'package:app/pages/tab_bar/tab_bar.dart' show localLocationProvider;
import 'package:app/providers/provider_models/country_model.dart';
import 'package:app/providers/provider_root/country_provider.dart';
import 'package:app/providers/provider_root/product_provider.dart';
import 'package:app/providers/provider_root/service_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/providers/provider_root/profile_provider.dart';
import 'package:app/providers/provider_models/user_model.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Model classes for API data
class Region {
  final int? id;
  final String name;

  Region({this.id, required this.name});

  factory Region.fromJson(Map<String, dynamic> json) {
    return Region(
      id: json['id'],
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
  CountryModel? selectedCountry;
  Region? selectedRegion;
  District? selectedDistrict;
  late Future<UserInfo> _userInfoFuture;

  List<Region> regions = [];
  List<District> districts = [];
  bool isLoadingRegions = true;
  bool _locationInitialized = false;
  bool isLoadingDistricts = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _userInfoFuture = ref.read(profileServiceProvider).getUserInfo();
    _initCountry();
  }

  Future<void> _initCountry() async {
    // Read saved country directly from SharedPreferences (synchronous in-memory after first load)
    final prefs = await SharedPreferences.getInstance();
    final savedCode = prefs.getString('localCountryCode') ?? prefs.getString('selected_country');

    if (savedCode != null && savedCode.isNotEmpty) {
      final country = CountryModel.getByCode(savedCode);
      if (country != null) {
        setState(() {
          selectedCountry = country;
        });
        _fetchRegions(country.code);
        return;
      }
    }

    // Fall back to Riverpod provider or default
    final providerCountry = ref.read(selectedCountryProvider);
    setState(() {
      selectedCountry = providerCountry ?? CountryModel.getByCode(AppConfig.defaultCountry);
    });
    if (selectedCountry != null) {
      _fetchRegions(selectedCountry!.code);
    }
  }

  Future<void> _fetchRegions(String countryCode) async {
    print('[ChangeCity] Fetching regions for country: $countryCode');
    setState(() {
      isLoadingRegions = true;
      regions = [];
      selectedRegion = null;
      districts = [];
      selectedDistrict = null;
    });

    try {
      final url = '${AppConfig.baseUrl}${AppConfig.regionsPath}?country=$countryCode';
      print('[ChangeCity] Regions URL: $url');
      final response = await http.get(Uri.parse(url));
      print('[ChangeCity] Regions response status: ${response.statusCode}');
      print('[ChangeCity] Regions response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> regionData = responseData['regions'] ?? responseData['results'] ?? [];
        print('[ChangeCity] Loaded ${regionData.length} regions');

        setState(() {
          regions = regionData
              .map<Region>((region) => Region.fromJson(region))
              .toList();
          isLoadingRegions = false;
        });

        if (!_locationInitialized) {
          _locationInitialized = true;
          _initializeLocation();
        }
      } else {
        setState(() {
          isLoadingRegions = false;
        });
        _showError('Failed to load regions');
      }
    } catch (error) {
      print('[ChangeCity] Error fetching regions: $error');
      setState(() {
        isLoadingRegions = false;
      });
      _showError('Error loading regions');
    }
  }

  Future<void> _fetchDistricts(String regionName, {int? regionId}) async {
    print('[ChangeCity] Fetching districts for region: $regionName (ID: $regionId)');
    setState(() {
      isLoadingDistricts = true;
      districts = [];
      selectedDistrict = null;
    });

    try {
      // Use region ID if available, otherwise use region name
      final regionParam = regionId?.toString() ?? regionName;
      final url = '${AppConfig.baseUrl}${AppConfig.districtsPath}$regionParam/';
      print('[ChangeCity] Districts URL: $url');

      final response = await http.get(Uri.parse(url));
      print('[ChangeCity] Districts response status: ${response.statusCode}');
      print('[ChangeCity] Districts response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> districtData = responseData['districts'] ?? responseData['results'] ?? [];
        print('[ChangeCity] Loaded ${districtData.length} districts');

        setState(() {
          districts = districtData
              .map<District>((district) => District.fromJson(district))
              .toList();
          isLoadingDistricts = false;
        });
      } else {
        print('[ChangeCity] Failed to load districts: ${response.statusCode}');
        setState(() {
          isLoadingDistricts = false;
        });
        _showError('Failed to load districts');
      }
    } catch (error) {
      print('[ChangeCity] Error fetching districts: $error');
      setState(() {
        isLoadingDistricts = false;
      });
      _showError('Error loading districts');
    }
  }

  Future<void> _initializeLocation() async {
    try {
      final user = await _userInfoFuture;
      if (user.location == null) return;

      final userCountryCode = user.location!.countryCode;
      final userRegionName = user.location!.region;
      final userDistrictName = user.location!.district;
      final userDistrictId = user.location!.id;

      print('[ChangeCity] Initializing with user location: country=$userCountryCode, region=$userRegionName, district=$userDistrictName');

      // If user's country is different from selected country, switch to user's country
      if (userCountryCode != null && userCountryCode != selectedCountry?.code) {
        final userCountry = CountryModel.getByCode(userCountryCode);
        if (userCountry != null) {
          print('[ChangeCity] Switching to user\'s country: $userCountryCode');
          setState(() {
            selectedCountry = userCountry;
          });
          // Fetch regions for user's country and wait for it
          await _fetchRegionsAndWait(userCountryCode);
        }
      }

      // Now try to match region
      if (userRegionName != null && regions.isNotEmpty) {
        final userRegionLower = userRegionName.toLowerCase();
        final matchingRegion = regions.firstWhere(
          (region) {
            final name = region.name.toLowerCase();
            // Exact match, or one contains the other (backend may add suffixes)
            return name == userRegionLower ||
                name.contains(userRegionLower) ||
                userRegionLower.contains(name);
          },
          orElse: () => Region(name: ''),
        );

        if (matchingRegion.name != '') {
          setState(() {
            selectedRegion = matchingRegion;
          });

          await _fetchDistricts(matchingRegion.name, regionId: matchingRegion.id);

          if (districts.isNotEmpty) {
            // Prefer matching by ID (unambiguous), fall back to name matching
            var matchingDistrict = districts.firstWhere(
              (district) => userDistrictId > 0 && district.id == userDistrictId,
              orElse: () => District(id: -1, name: ''),
            );

            // Fall back to fuzzy name matching if ID match fails
            if (matchingDistrict.id == -1 && userDistrictName != null) {
              final userDistrictLower = userDistrictName.toLowerCase();
              matchingDistrict = districts.firstWhere(
                (district) {
                  final name = district.name.toLowerCase();
                  return name == userDistrictLower ||
                      name.contains(userDistrictLower) ||
                      userDistrictLower.contains(name);
                },
                orElse: () => District(id: -1, name: ''),
              );
            }

            if (matchingDistrict.id != -1) {
              setState(() {
                selectedDistrict = matchingDistrict;
              });
              print('[ChangeCity] Initialized: region=${matchingRegion.name}, district=${matchingDistrict.name}');
            }
          }
        }
      }
    } catch (e) {
      print('[ChangeCity] Error initializing location: $e');
    }
  }

  /// Fetch regions and wait for completion (used during initialization)
  Future<void> _fetchRegionsAndWait(String countryCode) async {
    setState(() {
      isLoadingRegions = true;
      regions = [];
      selectedRegion = null;
      districts = [];
      selectedDistrict = null;
    });

    try {
      final url = '${AppConfig.baseUrl}${AppConfig.regionsPath}?country=$countryCode';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> regionData = responseData['regions'] ?? responseData['results'] ?? [];

        setState(() {
          regions = regionData
              .map<Region>((region) => Region.fromJson(region))
              .toList();
          isLoadingRegions = false;
        });
      } else {
        setState(() {
          isLoadingRegions = false;
        });
      }
    } catch (error) {
      print('[ChangeCity] Error fetching regions for $countryCode: $error');
      setState(() {
        isLoadingRegions = false;
      });
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
    print('[ChangeCity] _saveLocation called');
    print('[ChangeCity] Country: ${selectedCountry?.code}, Region: ${selectedRegion?.name}, District: ${selectedDistrict?.name} (ID: ${selectedDistrict?.id})');

    if (selectedCountry == null || selectedRegion == null || selectedDistrict == null) {
      print('[ChangeCity] Cannot save - missing selection: country=${selectedCountry != null}, region=${selectedRegion != null}, district=${selectedDistrict != null}');
      return;
    }

    setState(() => _isSaving = true);

    try {
      // Save country selection
      print('[ChangeCity] Saving country: ${selectedCountry!.code}');
      await ref.read(selectedCountryProvider.notifier).setCountry(selectedCountry!);

      // ALWAYS save location locally first (for filtering to work)
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userLocation', selectedDistrict!.id.toString());
      await prefs.setString('localRegionName', selectedRegion!.name);
      await prefs.setString('localDistrictName', selectedDistrict!.name);
      await prefs.setString('localCountryCode', selectedCountry!.code);
      print('[ChangeCity] Saved location locally: region=${selectedRegion!.name}, district=${selectedDistrict!.name}');

      // Try to save location to backend (may fail if backend doesn't support it yet)
      bool backendSaveSuccess = false;
      try {
        print('[ChangeCity] Attempting backend save with district ID: ${selectedDistrict!.id}, country: ${selectedCountry!.code}');
        await ref
            .read(profileServiceProvider)
            .updateUserInfo(
              locationId: selectedDistrict!.id,
              countryCode: selectedCountry!.code,
            );
        backendSaveSuccess = true;
        print('[ChangeCity] Backend save successful');
      } catch (e) {
        print('[ChangeCity] Backend save failed (using local): $e');
        // Continue - local save is enough for filtering to work
      }

      // Clear all caches so new location data is used
      ref.read(productsServiceProvider).clearCache();
      ref.invalidate(servicesProvider);
      ref.invalidate(myProfileProvider);
      ref.invalidate(profileServiceProvider);  // Important: TabBar watches this for location
      ref.invalidate(localLocationProvider);   // Refresh local location fallback
      print('[ChangeCity] Cleared all caches after location update');

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
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
        context.pop(true);
        print('[ChangeCity] Location saved successfully! (backend=${backendSaveSuccess ? "yes" : "local only"})');
      }
    } catch (e) {
      print('[ChangeCity] ERROR saving location: $e');
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
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
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
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    localizations?.location_subtitle ?? 'Choose your region and district to see nearby listings',
                    style: theme.textTheme.bodyMedium?.copyWith(
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
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${snapshot.data!.location!.district ?? ''}, ${snapshot.data!.location!.region ?? ''}',
                                style: theme.textTheme.bodyLarge?.copyWith(
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

                // Country Selection
                _buildSectionLabel(
                  localizations?.country ?? 'Country',
                  colorScheme,
                ),
                const SizedBox(height: 10),
                _buildCountrySelector(colorScheme),
                const SizedBox(height: 24),

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
                  enabled: selectedCountry != null,
                  itemBuilder: (region) => region.name,
                  onChanged: (region) {
                    HapticFeedback.selectionClick();
                    setState(() {
                      selectedRegion = region;
                      selectedDistrict = null;
                      districts = [];
                    });
                    if (region != null) {
                      _fetchDistricts(region.name, regionId: region.id);
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
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: isDark
                                          ? colorScheme.onSurface.withOpacity(0.7)
                                          : successColor.withOpacity(0.9),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${selectedDistrict!.name}, ${selectedRegion!.name}',
                                    style: theme.textTheme.bodyLarge?.copyWith(
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
                            style: theme.textTheme.labelLarge?.copyWith(
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

  Widget _buildCountrySelector(ColorScheme colorScheme) {
    final locale = Localizations.localeOf(context).languageCode;
    return GestureDetector(
      onTap: _showCountryPicker,
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: colorScheme.outline.withOpacity(0.3),
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
                child: Text(
                  selectedCountry!.getLocalizedName(locale),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ] else
              Expanded(
                child: Text(
                  AppLocalizations.of(context)?.selectCountry ?? 'Select country',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant.withOpacity(0.6),
                  ),
                ),
              ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }

  void _showCountryPicker() {
    final colorScheme = Theme.of(context).colorScheme;
    final locale = Localizations.localeOf(context).languageCode;
    final countries = CountryModel.supportedCountries;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Text(
                    AppLocalizations.of(context)?.selectCountry ?? 'Select Country',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
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
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    subtitle: Text(
                      '${country.currency.code} (${country.currency.symbol})',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    trailing: isSelected
                        ? Icon(Icons.check_circle, color: colorScheme.primary)
                        : null,
                    onTap: () {
                      HapticFeedback.selectionClick();
                      Navigator.pop(context);
                      setState(() {
                        selectedCountry = country;
                        selectedRegion = null;
                        selectedDistrict = null;
                        regions = [];
                        districts = [];
                      });
                      _fetchRegions(country.code);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label, ColorScheme colorScheme) {
    return Text(
      label,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
          hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurfaceVariant.withOpacity(0.6),
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
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
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
