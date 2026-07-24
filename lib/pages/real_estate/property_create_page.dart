import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app/pages/real_estate/widgets/property_detail_grid.dart';
import 'package:app/pages/real_estate/widgets/property_form_widgets.dart';
import 'package:app/pages/real_estate/widgets/property_image_picker.dart';
import 'package:app/providers/provider_root/active_neighborhood_provider.dart';
import 'package:app/providers/provider_root/real_estate_provider.dart';
import 'package:app/providers/provider_root/profile_provider.dart';
import 'package:app/providers/provider_root/country_provider.dart';
import 'package:app/providers/provider_models/location_model.dart';
import 'package:app/providers/provider_models/place.dart';
import 'package:app/widgets/maps/location_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:app/utils/content_filter.dart';
import 'package:app/utils/error_handler.dart';
import 'package:app/utils/app_logger.dart';
import 'package:app/utils/thousand_separator.dart';
import 'package:app/utils/currency_utils.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/service/token_store.dart';

class PropertyCreatePage extends ConsumerStatefulWidget {
  const PropertyCreatePage({super.key});

  @override
  ConsumerState<PropertyCreatePage> createState() => _PropertyCreatePageState();
}

class _PropertyCreatePageState extends ConsumerState<PropertyCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _addressController = TextEditingController();
  final _squareMetersController = TextEditingController();
  final _bedroomsController = TextEditingController();
  final _bathroomsController = TextEditingController();
  final _floorController = TextEditingController();
  final _totalFloorsController = TextEditingController();
  final _yearBuiltController = TextEditingController();
  final _parkingSpacesController = TextEditingController();

  final List<File> _selectedImages = [];
  final _picker = ImagePicker();
  bool _isUploading = false;

  String _selectedPropertyType = 'apartment';
  String _selectedListingType = 'sale';
  String _selectedCurrency = 'UZS';
  String? _latitude;
  String? _longitude;
  int? _userLocationId;
  Place? _pickedPlace;

  // Location selection
  List<Regions> _regionsList = [];
  List<Districts> _districtsList = [];
  String? _selectedRegion;
  Districts? _selectedDistrict;
  bool _isLoadingRegions = false;
  bool _isLoadingDistricts = false;
  bool _isGeocoding = false;
  List<Map<String, dynamic>> _userLocationsCache = []; // Cache for UserLocations with coordinates

  // Features
  bool _hasBalcony = false;
  bool _hasGarage = false;
  bool _hasGarden = false;
  bool _hasPool = false;
  bool _hasElevator = false;
  bool _isFurnished = false;

  // Property types
  final List<Map<String, String>> _propertyTypes = [
    {'value': 'apartment', 'label': 'Apartment'},
    {'value': 'house', 'label': 'House'},
    {'value': 'townhouse', 'label': 'Townhouse'},
    {'value': 'villa', 'label': 'Villa'},
    {'value': 'commercial', 'label': 'Commercial'},
    {'value': 'office', 'label': 'Office'},
    {'value': 'land', 'label': 'Land'},
    {'value': 'warehouse', 'label': 'Warehouse'},
  ];

  // Listing types
  final List<Map<String, String>> _listingTypes = [
    {'value': 'sale', 'label': 'For Sale'},
    {'value': 'rent', 'label': 'For Rent'},
  ];

  // Currencies - dynamically loaded based on country
  List<String> _currencies = ['UZS', 'USD', 'EUR'];

  @override
  void initState() {
    super.initState();
    _loadUserLocation();
    _fetchRegions();
    _loadUserLocationsCache();
    _loadCurrencies();
    // Pre-fill from the user's active map pick (Karrot pattern).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final active = ref.read(activeNeighborhoodProvider);
      if (active != null) {
        setState(() {
          _pickedPlace = Place(
            lat: active.neighborhood.centroidLat,
            lng: active.neighborhood.centroidLng,
            placeId: active.neighborhood.id,
            formattedAddress: active.neighborhood.displayName,
            countryCode: active.neighborhood.countryCode,
            region: active.neighborhood.region,
            city: active.neighborhood.city,
          );
          _latitude = active.neighborhood.centroidLat.toStringAsFixed(6);
          _longitude = active.neighborhood.centroidLng.toStringAsFixed(6);
          if (_addressController.text.isEmpty) {
            _addressController.text = active.neighborhood.displayName;
          }
        });
      }
    });
  }

  /// Load available currencies based on user's country
  void _loadCurrencies() {
    final selectedCountry = ref.read(selectedCountryProvider);
    final countryCode = selectedCountry?.code ?? 'UZ';

    setState(() {
      // Show all available currencies since backend now supports them
      _currencies = CurrencyUtils.getAllCurrencies();
      // Set default currency based on user's country
      final countryCurrency = CurrencyUtils.getCurrencyForCountry(countryCode);
      _selectedCurrency = countryCurrency ?? 'UZS';
    });
  }

  /// Pre-load UserLocations cache for coordinate lookup
  Future<void> _loadUserLocationsCache() async {
    try {
      final realEstateService = ref.read(realEstateServiceProvider);
      final userLocations = await realEstateService.getUserLocations();
      if (mounted) {
        setState(() {
          _userLocationsCache = userLocations;
        });
      }
      AppLogger.info('Pre-loaded ${userLocations.length} user locations for coordinate lookup');
      if (userLocations.isNotEmpty) {
        AppLogger.info('Sample location keys: ${userLocations.first.keys.toList()}');
        AppLogger.info('Sample location data: ${userLocations.first}');
      } else {
        AppLogger.warning('UserLocations cache is empty - endpoint may require authentication');
      }
    } catch (e) {
      AppLogger.error('Error pre-loading user locations: $e');
      // Not critical, will try again when districts are fetched
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _addressController.dispose();
    _squareMetersController.dispose();
    _bedroomsController.dispose();
    _bathroomsController.dispose();
    _floorController.dispose();
    _totalFloorsController.dispose();
    _yearBuiltController.dispose();
    _parkingSpacesController.dispose();
    super.dispose();
  }

  Future<void> _openMapPicker() async {
    final initial = (_latitude != null && _longitude != null)
        ? LatLng(double.parse(_latitude!), double.parse(_longitude!))
        : const LatLng(41.3, 69.24); // Tashkent default
    final picked = await Navigator.of(context).push<Place>(
      MaterialPageRoute(
        builder: (_) => LocationPicker(
          initialCenter: initial,
          onConfirmed: (p) => Navigator.of(context).pop(p),
        ),
      ),
    );
    if (picked != null && mounted) {
      setState(() {
        _pickedPlace = picked;
        _latitude = picked.lat.toStringAsFixed(6);
        _longitude = picked.lng.toStringAsFixed(6);
        if (_addressController.text.isEmpty &&
            picked.formattedAddress != null) {
          _addressController.text = picked.formattedAddress!;
        }
      });
    }
  }

  Future<void> _loadUserLocation() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final locationId = prefs.getString('userLocation');
      if (locationId != null) {
        setState(() {
          _userLocationId = int.tryParse(locationId);
        });
      }
    } catch (e) {
      AppLogger.error('Error loading user location: $e');
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Location services are disabled. Please enable them.'),
            ),
          );
        }
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Location permissions are denied.'),
              ),
            );
          }
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'Location permissions are permanently denied. Please enable in settings.'),
            ),
          );
        }
        return;
      }

      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _latitude = position.latitude.toStringAsFixed(6);
        _longitude = position.longitude.toStringAsFixed(6);
      });
    } catch (e) {
      AppLogger.error('Error getting location: $e');
    }
  }

  Future<void> _fetchRegions() async {
    setState(() {
      _isLoadingRegions = true;
    });

    try {
      final profileService = ref.read(profileServiceProvider);
      final regions = await profileService.getRegionsList();
      
      setState(() {
        _regionsList = regions;
        _isLoadingRegions = false;
      });
    } catch (e) {
      AppLogger.error('Error fetching regions: $e');
      setState(() {
        _isLoadingRegions = false;
      });
    }
  }

  Future<void> _fetchDistricts(String regionName) async {
    setState(() {
      _isLoadingDistricts = true;
      _districtsList = [];
      _selectedDistrict = null;
    });

    try {
      final profileService = ref.read(profileServiceProvider);
      final districts = await profileService.getDistrictsList(regionName: regionName);
      
      // Now fetch UserLocations to get IDs and coordinates for the districts
      final realEstateService = ref.read(realEstateServiceProvider);
      List<Map<String, dynamic>> userLocations = [];
      try {
        userLocations = await realEstateService.getUserLocations();
        // Cache user locations for coordinate lookup (update cache if we got data)
        if (userLocations.isNotEmpty) {
          setState(() {
            _userLocationsCache = userLocations;
          });
          AppLogger.info('Fetched ${userLocations.length} user locations during district fetch');
          AppLogger.info('Sample location data: ${userLocations.first}');
        } else {
          AppLogger.warning('UserLocations returned empty list - may require authentication');
        }
      } catch (e) {
        AppLogger.error('Error fetching user locations: $e');
        // Continue without IDs - we'll try to match by name
        // Don't clear cache if it was already populated
      }

      // Match districts with UserLocations to get IDs
      final districtsWithIds = districts.map((district) {
        // Find matching UserLocation by district name and region
        final matchingLocation = userLocations.firstWhere(
          (location) {
            final locDistrict = location['district'] ?? '';
            final locRegion = location['region'] ?? '';
            return locDistrict.toLowerCase() == district.district.toLowerCase() &&
                   locRegion.toLowerCase() == regionName.toLowerCase();
          },
          orElse: () => <String, dynamic>{},
        );
        
        // Create a Districts object with ID if found
        return Districts(
          id: matchingLocation['id'] ?? district.id,
          district: district.district,
        );
      }).toList();

      setState(() {
        _districtsList = districtsWithIds;
        _isLoadingDistricts = false;
      });
    } catch (e) {
      AppLogger.error('Error fetching districts: $e');
      setState(() {
        _isLoadingDistricts = false;
      });
    }
  }

  void _onRegionChanged(String? newRegion) {
    if (newRegion == null || newRegion == _selectedRegion) return;

    setState(() {
      _selectedRegion = newRegion;
      _selectedDistrict = null;
      _userLocationId = null;
      // Clear coordinates when region changes
      _latitude = null;
      _longitude = null;
    });

    // Fetch districts for the selected region
    _fetchDistricts(newRegion);
  }

  void _onDistrictChanged(Districts? newDistrict) {
    setState(() {
      _selectedDistrict = newDistrict;
      _userLocationId = newDistrict?.id;
    });

    // Geocode coordinates from region and district
    _geocodeLocation();
  }

  /// Geocode coordinates from region/district only
  Future<void> _geocodeLocation() async {
    if (_isGeocoding) return;

    // Build query string for geocoding - only use region and district
    String query = '';
    
    // Use region and district (both required)
    if (_selectedRegion != null && _selectedDistrict != null) {
      query = '${_selectedDistrict!.district}, $_selectedRegion, Uzbekistan';
    }
    // Fallback: Use just region if district not selected yet
    else if (_selectedRegion != null) {
      query = '$_selectedRegion, Uzbekistan';
    }
    
    if (query.isEmpty) {
      setState(() {
        _latitude = null;
        _longitude = null;
      });
      return;
    }

    setState(() {
      _isGeocoding = true;
    });

    try {
      // Use OpenStreetMap Nominatim API (free, no API key needed)
      final encodedQuery = Uri.encodeComponent(query);
      final url = 'https://nominatim.openstreetmap.org/search?q=$encodedQuery&format=json&limit=1';
      
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'User-Agent': 'SabziMarketApp/1.0', // Required by Nominatim
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> results = json.decode(response.body);
        
        if (results.isNotEmpty) {
          final location = results[0];
          final lat = location['lat']?.toString();
          final lon = location['lon']?.toString();
          
          if (lat != null && lon != null) {
            setState(() {
              _latitude = double.parse(lat).toStringAsFixed(6);
              _longitude = double.parse(lon).toStringAsFixed(6);
            });
            AppLogger.info('Geocoded coordinates: $_latitude, $_longitude for "$query"');
          } else {
            setState(() {
              _latitude = null;
              _longitude = null;
            });
          }
        } else {
          setState(() {
            _latitude = null;
            _longitude = null;
          });
          AppLogger.warning('No geocoding results for: $query');
        }
      } else {
        setState(() {
          _latitude = null;
          _longitude = null;
        });
        AppLogger.error('Geocoding failed with status: ${response.statusCode}');
      }
    } catch (e) {
      AppLogger.error('Error geocoding location: $e');
      setState(() {
        _latitude = null;
        _longitude = null;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isGeocoding = false;
        });
      }
    }
  }

  Future<void> _showImageSourceDialog() async {
    if (!mounted) return;

    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                AppLocalizations.of(context)?.selectImageSource ??
                    'Select Image Source',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            ListTile(
              leading: Icon(Icons.camera_alt, color: Theme.of(context).colorScheme.primary),
              title: Text(AppLocalizations.of(context)?.camera ?? 'Camera'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: Icon(Icons.photo_library, color: Theme.of(context).colorScheme.secondary),
              title: Text(AppLocalizations.of(context)?.gallery ?? 'Gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );

    if (source != null) {
      await _pickImage(source: source);
    }
  }

  Future<void> _pickImage({required ImageSource source}) async {
    try {
      if (source == ImageSource.gallery) {
        final pickedFiles = await _picker.pickMultiImage(
          maxWidth: 1920,
          maxHeight: 1920,
          imageQuality: 85,
        );
        if (mounted) {
          setState(() {
            _selectedImages.addAll(
              pickedFiles.map((pickedFile) => File(pickedFile.path)),
            );
          });
        }
      } else {
        final pickedFile = await _picker.pickImage(
          source: source,
          maxWidth: 1920,
          maxHeight: 1920,
          imageQuality: 85,
        );
        if (pickedFile != null && mounted) {
          final imageFile = File(pickedFile.path);
          final fileSize = await imageFile.length();
          const maxSize = 10 * 1024 * 1024; // 10MB

          if (fileSize > maxSize) {
            if (mounted) {
              AppErrorHandler.showWarning(
                context,
                'Image is too large. Maximum size is 10MB',
              );
            }
            return;
          }

          setState(() {
            _selectedImages.add(imageFile);
          });
        }
      }
    } catch (e) {
      AppErrorHandler.logError('PropertyCreatePage._pickImage', e);
      AppErrorHandler.showError(context, e);
    }
  }

  Future<void> _submitProperty() async {
    if (_isUploading) return;

    final localizations = AppLocalizations.of(context);

    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Content filtering
    final contentError = ContentFilter.validateContent(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
    );
    if (contentError != null) {
      AppErrorHandler.showWarning(context, contentError);
      return;
    }

    if (_selectedImages.isEmpty) {
      AppErrorHandler.showWarning(
        context,
        localizations?.property_create_image_required ??
            'At least one property image is required',
      );
      return;
    }

    if (_latitude == null || _longitude == null || _latitude == '0.0' || _longitude == '0.0') {
      AppErrorHandler.showWarning(
        context,
        'Please wait for location coordinates to be detected',
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    // Store router reference BEFORE async operation
    final router = GoRouter.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final successMessage = localizations?.success_property_created_success ?? 'Property created successfully!';

    try {
      final realEstateService = ref.read(realEstateServiceProvider);
      final token = await TokenStore.instance.getAccessToken();

      if (token == null) {
        AppErrorHandler.showError(
          context,
          Exception('Authentication required. Please login first.'),
        );
        return;
      }

      final result = await realEstateService.createProperty(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        propertyType: _selectedPropertyType,
        listingType: _selectedListingType,
        address: _addressController.text.trim(),
        squareMeters: int.tryParse(_squareMetersController.text) ?? 0,
        price: _priceController.text.replaceAll(',', '').trim(),
        currency: _selectedCurrency,
        images: _selectedImages,
        latitude: _latitude,
        longitude: _longitude,
        userLocation: _userLocationId,
        bedrooms: int.tryParse(_bedroomsController.text),
        bathrooms: int.tryParse(_bathroomsController.text),
        floor: int.tryParse(_floorController.text),
        totalFloors: int.tryParse(_totalFloorsController.text),
        yearBuilt: int.tryParse(_yearBuiltController.text),
        parkingSpaces: int.tryParse(_parkingSpacesController.text),
        hasBalcony: _hasBalcony,
        hasGarage: _hasGarage,
        hasGarden: _hasGarden,
        hasPool: _hasPool,
        hasElevator: _hasElevator,
        isFurnished: _isFurnished,
        token: token,
      );

      // Trigger refresh in real estate list
      ref.read(realEstateRefreshProvider.notifier).state++;

      // Show success message
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(successMessage),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );

      // Pop this page to go back to real estate list (was opened with Navigator.push)
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (error) {
      AppLogger.error('Error creating property: $error');
      AppErrorHandler.showError(context, error);
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          localizations?.general_create_property ?? 'Create Property',
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Images Section
              PropertyImagePicker(
                images: _selectedImages,
                onAddTap: _showImageSourceDialog,
                onRemove: (index) {
                  setState(() {
                    _selectedImages.removeAt(index);
                  });
                },
              ),
              const SizedBox(height: 20),

              // Basic Information Card
              PropertyFormCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PropertyFormSectionHeader(
                      title: localizations?.property_create_basic_information ??
                            'Basic Information',
                      icon: Icons.info_outline,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: localizations?.property_create_property_title ??
                            'Property Title *',
                        hintText: localizations?.property_create_property_title_hint ??
                            'e.g., Modern 3BR Apartment in City Center',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.title),
                        filled: true,
                        fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return localizations?.property_create_property_title_required ??
                              'Please enter property title';
                        }
                        if (value.trim().length < 3) {
                          return 'Property title must be at least 3 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: localizations?.property_create_description ??
                            'Description *',
                        hintText: localizations?.property_create_description_hint ??
                            'Describe your property in detail...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.description),
                        filled: true,
                        fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                      ),
                      maxLines: 4,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return localizations?.property_create_description_required ??
                              'Please enter description';
                        }
                        if (value.trim().length < 10) {
                          return 'Description must be at least 10 characters';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Property Type & Listing Type Card
              PropertyFormCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PropertyFormSectionHeader(
                      title: localizations?.property_create_property_type ?? 'Property Type',
                      icon: Icons.category,
                    ),
                    const SizedBox(height: 16),
                    // Stack vertically on small screens to avoid overflow
                    LayoutBuilder(
                      builder: (context, constraints) {
                        if (constraints.maxWidth < 400) {
                          return Column(
                            children: [
                              PropertyFormDropdownField(
                                label: localizations?.property_create_property_type_required ??
                                    'Property Type *',
                                value: _selectedPropertyType,
                                items: _propertyTypes,
                                icon: Icons.home,
                                onChanged: (value) {
                                  setState(() => _selectedPropertyType = value!);
                                },
                              ),
                              const SizedBox(height: 16),
                              PropertyFormDropdownField(
                                label: localizations?.property_create_listing_type_required ??
                                    'Listing Type *',
                                value: _selectedListingType,
                                items: _listingTypes,
                                icon: Icons.sell,
                                onChanged: (value) {
                                  setState(() => _selectedListingType = value!);
                                },
                              ),
                            ],
                          );
                        }
                        return Row(
                          children: [
                            Expanded(
                              child: PropertyFormDropdownField(
                                label: localizations?.property_create_property_type_required ??
                                    'Property Type *',
                                value: _selectedPropertyType,
                                items: _propertyTypes,
                                icon: Icons.home,
                                onChanged: (value) {
                                  setState(() => _selectedPropertyType = value!);
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: PropertyFormDropdownField(
                                label: localizations?.property_create_listing_type_required ??
                                    'Listing Type *',
                                value: _selectedListingType,
                                items: _listingTypes,
                                icon: Icons.sell,
                                onChanged: (value) {
                                  setState(() => _selectedListingType = value!);
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Pricing Card
              PropertyFormCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PropertyFormSectionHeader(
                      title: localizations?.property_create_pricing ?? 'Pricing',
                      icon: Icons.attach_money,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            controller: _priceController,
                            decoration: InputDecoration(
                              labelText: localizations?.property_create_price ?? 'Price *',
                              hintText: localizations?.property_create_price_hint ??
                                  'Enter price',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              prefixIcon: const Icon(Icons.attach_money),
                              filled: true,
                              fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              ThousandsFormatter(),
                            ],
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return localizations?.property_create_price_required ??
                                    'Please enter price';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: DropdownButtonFormField<String>(
                            initialValue: _selectedCurrency,
                            isExpanded: true,
                            decoration: InputDecoration(
                              labelText: localizations?.property_create_currency ?? 'Currency',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                            ),
                            items: _currencies.map((currency) {
                              final config = CurrencyUtils.getConfig(currency);
                              return DropdownMenuItem(
                                value: currency,
                                child: Text(
                                  '${config?.symbol ?? ''} $currency',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() => _selectedCurrency = value!);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Property Details Card
              PropertyFormCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PropertyFormSectionHeader(
                      title: localizations?.property_create_property_details ?? 'Property Details',
                      icon: Icons.home_work,
                    ),
                    const SizedBox(height: 16),
                    PropertyDetailGrid(
                      squareMetersController: _squareMetersController,
                      bedroomsController: _bedroomsController,
                      bathroomsController: _bathroomsController,
                      floorController: _floorController,
                      totalFloorsController: _totalFloorsController,
                      parkingSpacesController: _parkingSpacesController,
                      yearBuiltController: _yearBuiltController,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Location Card
              PropertyFormCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PropertyFormSectionHeader(
                      title: localizations?.property_create_location ?? 'Location',
                      icon: Icons.location_on,
                    ),
                    const SizedBox(height: 16),
                    // Map picker — opens LocationPicker, fills lat/lng/address
                    OutlinedButton.icon(
                      key: const Key('PropertyCreate.openMapPicker'),
                      onPressed: _openMapPicker,
                      icon: const Icon(Icons.map_outlined),
                      label: Text(_pickedPlace?.formattedAddress ??
                          (_latitude != null && _longitude != null
                              ? '$_latitude, $_longitude'
                              : 'Pick on map')),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                        alignment: Alignment.centerLeft,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        labelText: localizations?.property_create_address ?? 'Address *',
                        hintText: localizations?.property_create_address_hint ??
                            'Enter property address',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.location_on),
                        filled: true,
                        fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return localizations?.property_create_address_required ??
                              'Please enter address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Region Dropdown removed — map picker above is the
                    // sole location source for property creation.
                    if (false) DropdownButtonFormField<String>(
                      initialValue: _selectedRegion,
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: '${localizations?.region ?? 'Region'} *',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.location_city),
                        filled: true,
                        fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                        suffixIcon: _isLoadingRegions
                            ? const Padding(
                                padding: EdgeInsets.all(12.0),
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                              )
                            : null,
                      ),
                      hint: Text(
                        localizations?.selectRegion ?? 'Select Region',
                        overflow: TextOverflow.ellipsis,
                      ),
                      items: _regionsList.map((region) {
                        return DropdownMenuItem<String>(
                          value: region.region,
                          child: Text(
                            region.region,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: _isLoadingRegions ? null : _onRegionChanged,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return localizations?.property_create_required ?? 'Region is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // District Dropdown removed — map picker above is the
                    // sole location source for property creation.
                    if (false) DropdownButtonFormField<Districts>(
                      initialValue: _selectedDistrict,
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: '${localizations?.districtSelectParagraph ?? 'District'} *',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.location_city),
                        filled: true,
                        fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                        suffixIcon: _isLoadingDistricts
                            ? const Padding(
                                padding: EdgeInsets.all(12.0),
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                              )
                            : null,
                      ),
                      hint: Text(
                        _selectedRegion == null
                            ? (localizations?.selectRegion ?? 'Select region first')
                            : (localizations?.districtSelectParagraph ?? 'Select District'),
                        overflow: TextOverflow.ellipsis,
                      ),
                      items: _districtsList.map((district) {
                        return DropdownMenuItem<Districts>(
                          value: district,
                          child: Text(
                            district.district,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: _selectedRegion == null || _isLoadingDistricts
                          ? null
                          : _onDistrictChanged,
                      validator: (value) {
                        if (value == null) {
                          return localizations?.property_create_required ?? 'District is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    // Show location detected box only when coordinates are available
                    if (_latitude != null && _longitude != null && _latitude != '0.0' && _longitude != '0.0')
                      Builder(
                        builder: (context) {
                          final isDark = Theme.of(context).brightness == Brightness.dark;
                          final successColor = isDark ? colorScheme.primary : const Color(0xFF43A047);
                          final successBgColor = isDark ? colorScheme.primaryContainer.withValues(alpha: 0.3) : const Color(0xFFE8F5E9);
                          final successBorderColor = isDark ? colorScheme.primary.withValues(alpha: 0.5) : const Color(0xFFA5D6A7);
                          return Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: successBgColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: successBorderColor),
                            ),
                            child: Row(
                              children: [
                                if (_isGeocoding)
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(successColor),
                                    ),
                                  )
                                else
                                  Icon(Icons.check_circle, color: successColor, size: 20),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _isGeocoding
                                            ? 'Getting Location...'
                                            : (localizations?.property_create_location_detected ?? 'Location Detected'),
                                        style: theme.textTheme.bodySmall?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: successColor,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      if (_selectedRegion != null && _selectedDistrict != null)
                                        Text(
                                          '$_selectedRegion, ${_selectedDistrict!.district}',
                                          style: theme.textTheme.bodySmall?.copyWith(
                                            color: successColor.withValues(alpha: 0.8),
                                          ),
                                        ),
                                      if (!_isGeocoding)
                                        Padding(
                                          padding: const EdgeInsets.only(top: 4),
                                          child: Text(
                                            '$_latitude, $_longitude',
                                            style: theme.textTheme.bodySmall?.copyWith(
                                              fontSize: 10,
                                              color: successColor.withValues(alpha: 0.7),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      )
                    else if (_isGeocoding)
                      Builder(
                        builder: (context) {
                          final isDark = Theme.of(context).brightness == Brightness.dark;
                          final infoColor = isDark ? colorScheme.tertiary : const Color(0xFF1976D2);
                          final infoBgColor = isDark ? colorScheme.tertiaryContainer.withValues(alpha: 0.3) : const Color(0xFFE3F2FD);
                          final infoBorderColor = isDark ? colorScheme.tertiary.withValues(alpha: 0.5) : const Color(0xFF90CAF9);
                          return Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: infoBgColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: infoBorderColor),
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(infoColor),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Getting location coordinates...',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: infoColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Features Card
              PropertyFormCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PropertyFormSectionHeader(
                      title: localizations?.property_create_features ?? 'Features',
                      icon: Icons.star_outline,
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        PropertyFeatureChip(
                          label: localizations?.property_create_feature_balcony ?? 'Balcony',
                          value: _hasBalcony,
                          icon: Icons.balcony,
                          onChanged: (value) => setState(() => _hasBalcony = value),
                        ),
                        PropertyFeatureChip(
                          label: localizations?.property_create_feature_garage ?? 'Garage',
                          value: _hasGarage,
                          icon: Icons.garage,
                          onChanged: (value) => setState(() => _hasGarage = value),
                        ),
                        PropertyFeatureChip(
                          label: localizations?.property_create_feature_garden ?? 'Garden',
                          value: _hasGarden,
                          icon: Icons.yard,
                          onChanged: (value) => setState(() => _hasGarden = value),
                        ),
                        PropertyFeatureChip(
                          label: localizations?.property_create_feature_pool ?? 'Pool',
                          value: _hasPool,
                          icon: Icons.pool,
                          onChanged: (value) => setState(() => _hasPool = value),
                        ),
                        PropertyFeatureChip(
                          label: localizations?.property_create_feature_elevator ?? 'Elevator',
                          value: _hasElevator,
                          icon: Icons.elevator,
                          onChanged: (value) => setState(() => _hasElevator = value),
                        ),
                        PropertyFeatureChip(
                          label: localizations?.property_create_feature_furnished ?? 'Furnished',
                          value: _isFurnished,
                          icon: Icons.chair,
                          onChanged: (value) => setState(() => _isFurnished = value),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isUploading ? null : _submitProperty,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: _isUploading
                      ? SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                colorScheme.onPrimary),
                          ),
                        )
                      : Text(
                          localizations?.general_create_property ?? 'Create Property',
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

}
