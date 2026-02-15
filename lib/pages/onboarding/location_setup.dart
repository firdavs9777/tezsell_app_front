import 'dart:convert';
import 'package:app/config/app_config.dart';
import 'package:app/providers/provider_models/country_model.dart';
import 'package:app/providers/provider_root/country_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:app/providers/provider_root/profile_provider.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:http/http.dart' as http;

class Region {
  final int id;
  final String name;

  Region({required this.id, required this.name});

  factory Region.fromJson(Map<String, dynamic> json) {
    return Region(
      id: json['id'] ?? 0,
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

class LocationSetupScreen extends ConsumerStatefulWidget {
  const LocationSetupScreen({super.key});

  @override
  ConsumerState<LocationSetupScreen> createState() => _LocationSetupScreenState();
}

class _LocationSetupScreenState extends ConsumerState<LocationSetupScreen> {
  CountryModel? selectedCountry;
  Region? selectedRegion;
  District? selectedDistrict;

  List<Region> regions = [];
  List<District> districts = [];
  bool isLoadingRegions = false;
  bool isLoadingDistricts = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // Set default country
    selectedCountry = CountryModel.getByCode(AppConfig.defaultCountry);
    if (selectedCountry != null) {
      _fetchRegions(selectedCountry!.code);
    }
  }

  Future<void> _fetchRegions(String countryCode) async {
    setState(() {
      isLoadingRegions = true;
      regions = [];
      selectedRegion = null;
      districts = [];
      selectedDistrict = null;
    });

    try {
      final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}${AppConfig.regionsPath}?country=$countryCode'),
      );
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
      final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}${AppConfig.districtsPath}$regionName/'),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> districtData = responseData['districts'] ?? responseData['results'] ?? [];

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

  Future<void> _saveLocationAndContinue() async {
    if (selectedCountry == null || selectedRegion == null || selectedDistrict == null) return;

    setState(() => _isSaving = true);

    try {
      // Save selected country
      await ref
          .read(selectedCountryProvider.notifier)
          .setCountry(selectedCountry!);

      // Save location
      await ref
          .read(profileServiceProvider)
          .updateUserInfo(locationId: selectedDistrict!.id);

      HapticFeedback.mediumImpact();

      if (mounted && context.mounted) {
        context.go('/tabs');
      }
    } catch (e) {
      _showError('Failed to save location');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _showCountryPicker() {
    final colorScheme = Theme.of(context).colorScheme;
    final locale = Localizations.localeOf(context).languageCode;
    // Use static list of 15 supported countries
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
                      style: Theme.of(context).textTheme.headlineSmall,
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

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final locale = Localizations.localeOf(context).languageCode;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),

              // Welcome Header
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.location_on_rounded,
                    size: 50,
                    color: colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 24),

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
              const SizedBox(height: 12),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    localizations?.location_subtitle ??
                        'Choose your country, region and district to discover nearby products and services',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 48),

              // Country Selection
              _buildSectionLabel(
                localizations?.country ?? 'Country',
                colorScheme,
              ),
              const SizedBox(height: 10),
              _buildCountrySelector(colorScheme, locale),
              const SizedBox(height: 24),

              // Region Selection
              _buildSectionLabel(
                localizations?.region ?? 'Region',
                colorScheme,
              ),
              const SizedBox(height: 10),
              _buildDropdown<Region>(
                value: selectedRegion,
                hint: localizations?.selectRegion ?? 'Select your region',
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
                hint: localizations?.districtSelectParagraph ?? 'Select your district',
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
              if (selectedCountry != null && selectedRegion != null && selectedDistrict != null)
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
                                  localizations?.selectedLocation ?? 'Your Location',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: isDark
                                        ? colorScheme.onSurface.withOpacity(0.7)
                                        : successColor.withOpacity(0.9),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${selectedDistrict!.name}, ${selectedRegion!.name}',
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: isDark
                                        ? colorScheme.onSurface
                                        : const Color(0xFF2E7D32),
                                  ),
                                ),
                                Text(
                                  '${selectedCountry!.flagEmoji} ${selectedCountry!.getLocalizedName(locale)}',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: isDark
                                        ? colorScheme.onSurface.withOpacity(0.7)
                                        : const Color(0xFF388E3C),
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

              const SizedBox(height: 48),

              // Continue Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton(
                  onPressed: (selectedCountry != null && selectedRegion != null && selectedDistrict != null && !_isSaving)
                      ? _saveLocationAndContinue
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
                          localizations?.continueButton ?? 'Continue',
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCountrySelector(ColorScheme colorScheme, String locale) {
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
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  selectedCountry!.getLocalizedName(locale),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ] else
              Expanded(
                child: Text(
                  AppLocalizations.of(context)?.selectCountry ?? 'Select country',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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

  Widget _buildSectionLabel(String label, ColorScheme colorScheme) {
    return Text(
      label,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
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
          hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
