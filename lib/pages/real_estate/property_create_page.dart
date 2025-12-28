import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app/providers/provider_root/real_estate_provider.dart';
import 'package:app/providers/provider_root/profile_provider.dart';
import 'package:app/providers/provider_models/location_model.dart';
import 'package:app/utils/content_filter.dart';
import 'package:app/utils/error_handler.dart';
import 'package:app/utils/app_logger.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/pages/tab_bar/tab_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  List<File> _selectedImages = [];
  final _picker = ImagePicker();
  bool _isUploading = false;

  String _selectedPropertyType = 'apartment';
  String _selectedListingType = 'sale';
  String _selectedCurrency = 'UZS';
  String? _latitude;
  String? _longitude;
  int? _userLocationId;

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

  // Currencies
  final List<String> _currencies = ['UZS', 'USD', 'EUR'];

  @override
  void initState() {
    super.initState();
    _loadUserLocation();
    _fetchRegions();
    _loadUserLocationsCache();
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
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
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

      Position position = await Geolocator.getCurrentPosition(
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
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.blue),
              title: Text(AppLocalizations.of(context)?.camera ?? 'Camera'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.purple),
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
        if (pickedFiles != null && mounted) {
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

    // Validate region and district are selected
    if (_selectedRegion == null || _selectedDistrict == null) {
      AppErrorHandler.showWarning(
        context,
        localizations?.property_create_required ?? 'Please select region and district',
      );
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

    try {
      final realEstateService = ref.read(realEstateServiceProvider);
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

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
        price: _priceController.text.trim(),
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

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              localizations?.success_property_created_success ??
                  'Property created successfully!',
            ),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate back or to property detail
        Navigator.of(context).pop();
        
        // Optionally navigate to the property detail page
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => RealEstateDetailPage(propertyId: result['id']),
        //   ),
        // );
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
          style: const TextStyle(fontWeight: FontWeight.w600),
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
              _buildImagesSection(theme, localizations),
              const SizedBox(height: 20),

              // Basic Information Card
              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader(
                        localizations?.property_create_basic_information ??
                            'Basic Information',
                        Icons.info_outline,
                        theme),
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
                        fillColor: colorScheme.surfaceContainerHighest.withOpacity(0.3),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return localizations?.property_create_property_title_required ??
                              'Please enter property title';
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
                        fillColor: colorScheme.surfaceContainerHighest.withOpacity(0.3),
                      ),
                      maxLines: 4,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return localizations?.property_create_description_required ??
                              'Please enter description';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Property Type & Listing Type Card
              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader(
                        localizations?.property_create_property_type ?? 'Property Type',
                        Icons.category,
                        theme),
                    const SizedBox(height: 16),
                    // Stack vertically on small screens to avoid overflow
                    LayoutBuilder(
                      builder: (context, constraints) {
                        if (constraints.maxWidth < 400) {
                          return Column(
                            children: [
                              _buildDropdownField(
                                label: localizations?.property_create_property_type_required ??
                                    'Property Type *',
                                value: _selectedPropertyType,
                                items: _propertyTypes,
                                icon: Icons.home,
                                onChanged: (value) {
                                  setState(() => _selectedPropertyType = value!);
                                },
                                theme: theme,
                                localizations: localizations,
                              ),
                              const SizedBox(height: 16),
                              _buildDropdownField(
                                label: localizations?.property_create_listing_type_required ??
                                    'Listing Type *',
                                value: _selectedListingType,
                                items: _listingTypes,
                                icon: Icons.sell,
                                onChanged: (value) {
                                  setState(() => _selectedListingType = value!);
                                },
                                theme: theme,
                                localizations: localizations,
                              ),
                            ],
                          );
                        }
                        return Row(
                          children: [
                            Expanded(
                              child: _buildDropdownField(
                                label: localizations?.property_create_property_type_required ??
                                    'Property Type *',
                                value: _selectedPropertyType,
                                items: _propertyTypes,
                                icon: Icons.home,
                                onChanged: (value) {
                                  setState(() => _selectedPropertyType = value!);
                                },
                                theme: theme,
                                localizations: localizations,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildDropdownField(
                                label: localizations?.property_create_listing_type_required ??
                                    'Listing Type *',
                                value: _selectedListingType,
                                items: _listingTypes,
                                icon: Icons.sell,
                                onChanged: (value) {
                                  setState(() => _selectedListingType = value!);
                                },
                                theme: theme,
                                localizations: localizations,
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
              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader(
                        localizations?.property_create_pricing ?? 'Pricing',
                        Icons.attach_money,
                        theme),
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
                              fillColor: colorScheme.surfaceContainerHighest.withOpacity(0.3),
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
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
                            value: _selectedCurrency,
                            decoration: InputDecoration(
                              labelText: localizations?.property_create_currency ?? 'Currency',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: colorScheme.surfaceContainerHighest.withOpacity(0.3),
                            ),
                            items: _currencies.map((currency) {
                              return DropdownMenuItem(
                                value: currency,
                                child: Text(currency),
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
              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader(
                        localizations?.property_create_property_details ?? 'Property Details',
                        Icons.home_work,
                        theme),
                    const SizedBox(height: 16),
                    _buildPropertyDetailGrid(),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Location Card
              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader(
                        localizations?.property_create_location ?? 'Location',
                        Icons.location_on,
                        theme),
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
                        fillColor: colorScheme.surfaceContainerHighest.withOpacity(0.3),
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
                    // Region Dropdown (Required)
                    DropdownButtonFormField<String>(
                      value: _selectedRegion,
                      decoration: InputDecoration(
                        labelText: '${localizations?.region ?? 'Region'} *',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.location_city),
                        filled: true,
                        fillColor: colorScheme.surfaceContainerHighest.withOpacity(0.3),
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
                      hint: Text(localizations?.selectRegion ?? 'Select Region'),
                      items: _regionsList.map((region) {
                        return DropdownMenuItem<String>(
                          value: region.region,
                          child: Text(region.region),
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
                    // District Dropdown (Required)
                    DropdownButtonFormField<Districts>(
                      value: _selectedDistrict,
                      decoration: InputDecoration(
                        labelText: '${localizations?.districtSelectParagraph ?? 'District'} *',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.location_city),
                        filled: true,
                        fillColor: colorScheme.surfaceContainerHighest.withOpacity(0.3),
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
                      ),
                      items: _districtsList.map((district) {
                        return DropdownMenuItem<Districts>(
                          value: district,
                          child: Text(district.district),
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
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.green.shade200),
                        ),
                        child: Row(
                          children: [
                            if (_isGeocoding)
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green.shade700),
                                ),
                              )
                            else
                              Icon(Icons.check_circle, color: Colors.green.shade700, size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _isGeocoding
                                        ? 'Getting Location...'
                                        : (localizations?.property_create_location_detected ?? 'Location Detected'),
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.green.shade900,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  if (_selectedRegion != null && _selectedDistrict != null)
                                    Text(
                                      '$_selectedRegion, ${_selectedDistrict!.district}',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.green.shade700,
                                      ),
                                    ),
                                  if (!_isGeocoding)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Text(
                                        '$_latitude, $_longitude',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.green.shade600,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    else if (_isGeocoding)
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.blue.shade200),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade700),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Getting location coordinates...',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.blue.shade700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Features Card
              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader(
                        localizations?.property_create_features ?? 'Features',
                        Icons.star_outline,
                        theme),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        _buildFeatureChip(
                            localizations?.property_create_feature_balcony ?? 'Balcony',
                            _hasBalcony,
                            Icons.balcony,
                            (value) => setState(() => _hasBalcony = value),
                            theme),
                        _buildFeatureChip(
                            localizations?.property_create_feature_garage ?? 'Garage',
                            _hasGarage,
                            Icons.garage,
                            (value) => setState(() => _hasGarage = value),
                            theme),
                        _buildFeatureChip(
                            localizations?.property_create_feature_garden ?? 'Garden',
                            _hasGarden,
                            Icons.yard,
                            (value) => setState(() => _hasGarden = value),
                            theme),
                        _buildFeatureChip(
                            localizations?.property_create_feature_pool ?? 'Pool',
                            _hasPool,
                            Icons.pool,
                            (value) => setState(() => _hasPool = value),
                            theme),
                        _buildFeatureChip(
                            localizations?.property_create_feature_elevator ?? 'Elevator',
                            _hasElevator,
                            Icons.elevator,
                            (value) => setState(() => _hasElevator = value),
                            theme),
                        _buildFeatureChip(
                            localizations?.property_create_feature_furnished ?? 'Furnished',
                            _isFurnished,
                            Icons.chair,
                            (value) => setState(() => _isFurnished = value),
                            theme),
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
                          style: const TextStyle(
                            fontSize: 17,
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

  Widget _buildCard({required Widget child}) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, ThemeData theme) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: theme.colorScheme.primary),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<Map<String, String>> items,
    required IconData icon,
    required Function(String?) onChanged,
    required ThemeData theme,
    AppLocalizations? localizations,
  }) {
    // Helper function to get localized label
    String getLocalizedLabel(String value, String defaultLabel) {
      if (localizations == null) return defaultLabel;
      
      // Property types
      switch (value) {
        case 'apartment':
          return localizations.property_types_apartment;
        case 'house':
          return localizations.property_types_house;
        case 'townhouse':
          return localizations.property_types_townhouse;
        case 'villa':
          return localizations.property_types_villa;
        case 'commercial':
          return localizations.property_types_commercial;
        case 'office':
          return localizations.property_types_office;
        case 'land':
          return localizations.property_types_land;
        case 'warehouse':
          return localizations.property_types_warehouse;
        // Listing types
        case 'sale':
          return localizations.listing_types_for_sale;
        case 'rent':
          return localizations.listing_types_for_rent;
        default:
          return defaultLabel;
      }
    }

    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
      ),
      items: items.map((item) {
        return DropdownMenuItem(
          value: item['value'],
          child: Text(getLocalizedLabel(item['value']!, item['label']!)),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildPropertyDetailGrid() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final localizations = AppLocalizations.of(context);

    return Column(
      children: [
        // Row 1: Square Meters, Bedrooms
        Row(
          children: [
            Expanded(
              child: _buildDetailInputField(
                controller: _squareMetersController,
                label: localizations?.property_create_square_meters ?? 'Sq. Meters *',
                icon: Icons.square_foot,
                isRequired: true,
                theme: theme,
                localizations: localizations,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildDetailInputField(
                controller: _bedroomsController,
                label: localizations?.property_create_bedrooms ?? 'Bedrooms *',
                icon: Icons.bed,
                isRequired: true,
                theme: theme,
                localizations: localizations,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Row 2: Bathrooms, Floor
        Row(
          children: [
            Expanded(
              child: _buildDetailInputField(
                controller: _bathroomsController,
                label: localizations?.property_create_bathrooms ?? 'Bathrooms *',
                icon: Icons.bathroom,
                isRequired: true,
                theme: theme,
                localizations: localizations,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildDetailInputField(
                controller: _floorController,
                label: localizations?.property_create_floor ?? 'Floor',
                icon: Icons.layers,
                isRequired: false,
                theme: theme,
                localizations: localizations,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Row 3: Total Floors, Parking
        Row(
          children: [
            Expanded(
              child: _buildDetailInputField(
                controller: _totalFloorsController,
                label: localizations?.property_create_total_floors ?? 'Total Floors',
                icon: Icons.business,
                isRequired: false,
                theme: theme,
                localizations: localizations,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildDetailInputField(
                controller: _parkingSpacesController,
                label: localizations?.property_create_parking ?? 'Parking',
                icon: Icons.local_parking,
                isRequired: false,
                theme: theme,
                localizations: localizations,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Row 4: Year Built
        Row(
          children: [
            Expanded(
              child: _buildDetailInputField(
                controller: _yearBuiltController,
                label: localizations?.property_create_year_built ?? 'Year Built',
                icon: Icons.calendar_today,
                isRequired: false,
                theme: theme,
                localizations: localizations,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool isRequired,
    required ThemeData theme,
    AppLocalizations? localizations,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        prefixIcon: Icon(icon, size: 20),
        filled: true,
        fillColor: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      validator: isRequired
          ? (value) {
              if (value == null || value.trim().isEmpty) {
                return localizations?.property_create_required ?? 'Required';
              }
              return null;
            }
          : null,
    );
  }

  Widget _buildImagesSection(ThemeData theme, AppLocalizations? localizations) {
    final colorScheme = theme.colorScheme;

    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
              localizations?.property_create_images ?? 'Property Images',
              Icons.photo_library,
              theme),
          const SizedBox(height: 16),
          if (_selectedImages.isEmpty)
            GestureDetector(
              onTap: _showImageSourceDialog,
              child: Container(
                height: 180,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: colorScheme.outline.withOpacity(0.3),
                    style: BorderStyle.solid,
                    width: 2,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_photo_alternate,
                      size: 56,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      localizations?.property_create_tap_to_add_images ??
                          'Tap to add images',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      localizations?.property_create_at_least_one_image ??
                          'At least 1 image required',
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurfaceVariant.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _selectedImages.length + 1,
                itemBuilder: (context, index) {
                  if (index == _selectedImages.length) {
                    return GestureDetector(
                      onTap: _showImageSourceDialog,
                      child: Container(
                        width: 160,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: colorScheme.outline.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add, size: 36, color: colorScheme.primary),
                            const SizedBox(height: 8),
                            Text(
                              localizations?.property_create_add_more ?? 'Add More',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return Container(
                    width: 160,
                    margin: const EdgeInsets.only(right: 12),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.file(
                            _selectedImages[index],
                            fit: BoxFit.cover,
                            height: 200,
                            width: 160,
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedImages.removeAt(index);
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.red.shade600,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${index + 1}/${_selectedImages.length}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFeatureChip(
    String label,
    bool value,
    IconData icon,
    Function(bool) onChanged,
    ThemeData theme,
  ) {
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 6),
          Text(label),
        ],
      ),
      selected: value,
      onSelected: onChanged,
      selectedColor: theme.colorScheme.primaryContainer,
      checkmarkColor: theme.colorScheme.onPrimaryContainer,
      labelStyle: TextStyle(
        color: value
            ? theme.colorScheme.onPrimaryContainer
            : theme.colorScheme.onSurface,
        fontWeight: value ? FontWeight.w600 : FontWeight.normal,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: value
              ? theme.colorScheme.primary
              : theme.colorScheme.outline.withOpacity(0.3),
          width: value ? 1.5 : 1,
        ),
      ),
    );
  }
}
