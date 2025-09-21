import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/providers/provider_models/real_estate.dart';
import 'package:app/providers/provider_root/real_estate_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

// Add PropertyMapWidget import - you'll need to create this file
// import 'package:app/widgets/property_map_widget.dart';

// Add this class for property images
class PropertyImage {
  final int id;
  final String image;
  final String caption;

  const PropertyImage({
    required this.id,
    required this.image,
    required this.caption,
  });

  factory PropertyImage.fromJson(Map<String, dynamic> json) {
    return PropertyImage(
      id: json['id'] ?? 0,
      image: json['image'] ?? '',
      caption: json['caption'] ?? '',
    );
  }
}

// Placeholder PropertyMapWidget - replace with actual import
class PropertyMapWidget extends StatefulWidget {
  final RealEstate property;
  final double height;
  final bool showControls;
  final VoidCallback? onFullscreenToggle;

  const PropertyMapWidget({
    Key? key,
    required this.property,
    this.height = 300,
    this.showControls = true,
    this.onFullscreenToggle,
  }) : super(key: key);

  @override
  State<PropertyMapWidget> createState() => _PropertyMapWidgetState();
}

class _PropertyMapWidgetState extends State<PropertyMapWidget> {
  late MapController _mapController;
  double _currentZoom = 15.0;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  LatLng get _propertyLocation {
    final lat = double.tryParse(widget.property.latitude);
    final lng = double.tryParse(widget.property.longitude);

    if (lat != null && lng != null) {
      return LatLng(lat, lng);
    }

    return LatLng(41.2995, 69.2401); // Fallback
  }

  void _zoomIn() {
    setState(() {
      _currentZoom = (_currentZoom + 1).clamp(1.0, 18.0);
    });
    _mapController.move(_propertyLocation, _currentZoom);
  }

  void _zoomOut() {
    setState(() {
      _currentZoom = (_currentZoom - 1).clamp(1.0, 18.0);
    });
    _mapController.move(_propertyLocation, _currentZoom);
  }

  void _centerOnProperty() {
    _mapController.move(_propertyLocation, _currentZoom);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            // Map
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _propertyLocation,
                initialZoom: _currentZoom,
                minZoom: 1.0,
                maxZoom: 18.0,
                onMapEvent: (event) {
                  if (event is MapEventMoveEnd) {
                    setState(() {
                      _currentZoom = event.camera.zoom;
                    });
                  }
                },
              ),
              children: [
                // Alternative tile providers - choose one that works best for you

                // Option 1: CartoDB Positron (clean, light theme)
                TileLayer(
                  urlTemplate:
                      'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
                  subdomains: ['a', 'b', 'c', 'd'],
                  userAgentPackageName: 'com.yourcompany.yourapp',
                  maxZoom: 18,
                ),

                // Option 2: If CartoDB doesn't work, uncomment this for OpenStreetMap with proper setup:
                /*
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.yourcompany.yourapp', // Use your actual package name
                  maxZoom: 18,
                  additionalOptions: {
                    'attribution': '© OpenStreetMap contributors',
                  },
                ),
                */

                // Option 3: Alternative - Stamen Terrain (if others don't work)
                /*
                TileLayer(
                  urlTemplate: 'https://stamen-tiles.a.ssl.fastly.net/terrain/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.yourcompany.yourapp',
                  maxZoom: 16,
                ),
                */

                // Property Marker
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _propertyLocation,
                      width: 60,
                      height: 60,
                      child: _buildPropertyMarker(),
                    ),
                  ],
                ),
              ],
            ),

            // Map Controls
            if (widget.showControls) ...[
              // Zoom Controls
              Positioned(
                right: 16,
                top: 16,
                child: Column(
                  children: [
                    _buildMapButton(
                      icon: Icons.add,
                      onPressed: _zoomIn,
                      tooltip: 'Zoom In',
                    ),
                    SizedBox(height: 8),
                    _buildMapButton(
                      icon: Icons.remove,
                      onPressed: _zoomOut,
                      tooltip: 'Zoom Out',
                    ),
                    SizedBox(height: 8),
                    _buildMapButton(
                      icon: Icons.my_location,
                      onPressed: _centerOnProperty,
                      tooltip: 'Center on Property',
                    ),
                  ],
                ),
              ),

              // Fullscreen Toggle
              if (widget.onFullscreenToggle != null)
                Positioned(
                  right: 16,
                  bottom: 16,
                  child: _buildMapButton(
                    icon: Icons.fullscreen,
                    onPressed: widget.onFullscreenToggle,
                    tooltip: 'Fullscreen',
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPropertyMarker() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Icon(
        Icons.location_on,
        color: Colors.white,
        size: 30,
      ),
    );
  }

  Widget _buildMapButton({
    required IconData icon,
    required VoidCallback? onPressed,
    required String tooltip,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 40,
            height: 40,
            child: Icon(
              icon,
              color: Colors.grey[700],
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}

class FullscreenMapModal extends StatelessWidget {
  final RealEstate property;
  final VoidCallback onClose;

  const FullscreenMapModal({
    Key? key,
    required this.property,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PropertyMapWidget(
            property: property,
            height: double.infinity,
            showControls: true,
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: onClose,
              backgroundColor: Colors.black.withOpacity(0.7),
              child: Icon(Icons.close, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class PropertyDetail extends ConsumerStatefulWidget {
  const PropertyDetail({super.key, required this.propertyId});
  final String propertyId;

  @override
  ConsumerState<PropertyDetail> createState() => _PropertyDetailState();
}

class _PropertyDetailState extends ConsumerState<PropertyDetail> {
  RealEstate? property;
  List<RealEstate> relatedProperties = [];
  bool isLoading = true;
  String? errorMessage;
  bool isSaved = false;
  String? description;
  int? floor;
  int? totalFloors;
  int? yearBuilt;
  int parkingSpaces = 0;
  bool hasBalcony = false;
  bool hasGarage = false;
  bool hasGarden = false;
  bool hasPool = false;
  bool hasElevator = false;
  bool isFurnished = false;
  List<PropertyImage> images = [];
  bool isActive = true;
  bool isSold = false;

  @override
  void initState() {
    super.initState();
    _loadPropertyDetails();
  }

  Future<void> _loadPropertyDetails() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      // Get the full API response that includes all the additional fields
      final response = await ref
          .read(realEstateServiceProvider)
          .fetchSingleFilteredProperty(propertyId: widget.propertyId);

      setState(() {
        property = response;
        isSaved =
            response.isFeatured; // Use actual is_saved from API when available

        // Extract additional fields from the full API response
        // These should ideally be added to your RealEstate model
        description = "Test"; // Use actual response.description
        floor = 1; // Use actual response.floor
        totalFloors = 3; // Use actual response.totalFloors
        yearBuilt = 1997; // Use actual response.yearBuilt
        parkingSpaces = 12323; // Use actual response.parkingSpaces
        hasBalcony = true; // Use actual response.hasBalcony
        hasGarage = true; // Use actual response.hasGarage
        hasGarden = false; // Use actual response.hasGarden
        hasPool = false; // Use actual response.hasPool
        hasElevator = false; // Use actual response.hasElevator
        isFurnished = false; // Use actual response.isFurnished
        isActive = true; // Use actual response.isActive
        isSold = false; // Use actual response.isSold

        // Parse images from API response
        images = [
          PropertyImage(
              id: 1,
              image:
                  "https://api.webtezsell.com/media/properties/images/Properties.png",
              caption: "main_home")
        ];

        isLoading = false;
      });
    } catch (error) {
      setState(() {
        errorMessage = error.toString();
        isLoading = false;
      });
    }
  }

  Future<void> _toggleSave() async {
    if (property == null) return;

    try {
      // Optimistic update
      setState(() {
        isSaved = !isSaved;
      });

      // Call your save/unsave API here
      // await ref.read(realEstateServiceProvider).toggleSaveProperty(property!.id);

      HapticFeedback.selectionClick();

      final localizations = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isSaved
              ? localizations?.success_property_saved ??
                  'Property saved successfully!'
              : localizations?.success_property_unsaved ??
                  'Property removed from saved list'),
          backgroundColor: isSaved ? Colors.green : Colors.orange,
        ),
      );
    } catch (error) {
      // Revert optimistic update on error
      setState(() {
        isSaved = !isSaved;
      });

      final localizations = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localizations?.alerts_save_property_failed ??
              'Failed to save property: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _copyPhoneNumber(String phoneNumber) {
    Clipboard.setData(ClipboardData(text: phoneNumber));
    final localizations = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(localizations?.alerts_phone_copied ??
            'Phone number copied to clipboard!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showFullscreenMap() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FullscreenMapModal(
          property: property!,
          onClose: () => Navigator.of(context).pop(),
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with Image
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: theme.primaryColor,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Property images - use images array from API
                  if (images.isNotEmpty)
                    Image.network(
                      images.first.image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[300],
                        child: Icon(
                          Icons.apartment,
                          size: 80,
                          color: Colors.grey[500],
                        ),
                      ),
                    )
                  else
                    Container(
                      color: Colors.grey[300],
                      child: Icon(
                        Icons.apartment,
                        size: 80,
                        color: Colors.grey[500],
                      ),
                    ),

                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.3),
                        ],
                      ),
                    ),
                  ),

                  // Property badges
                  if (property != null) ...[
                    Positioned(
                      top: 60,
                      left: 16,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: theme.primaryColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          property!.listingTypeDisplay,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    if (property!.isFeatured)
                      Positioned(
                        top: 60,
                        right: 16,
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            localizations?.property_card_featured ?? 'Featured',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                  ],
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  isSaved ? Icons.favorite : Icons.favorite_border,
                  color: isSaved ? Colors.red : Colors.white,
                ),
                onPressed: _toggleSave,
              ),
              IconButton(
                icon: Icon(Icons.share, color: Colors.white),
                onPressed: () {
                  // Implement share functionality
                  HapticFeedback.selectionClick();
                },
              ),
            ],
          ),

          // Content
          SliverToBoxAdapter(
            child: _buildContent(context, localizations),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, AppLocalizations? localizations) {
    if (isLoading) {
      return Container(
        height: 400,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text(
                localizations?.loading_loading_details ??
                    'Loading property details...',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

    if (errorMessage != null) {
      return Container(
        height: 400,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red),
              SizedBox(height: 16),
              Text(
                localizations?.loading_property_not_found ??
                    'Property not found',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 8),
              Text(
                localizations?.loading_property_not_found_message ??
                    'The property you are looking for does not exist or has been removed.',
                style: TextStyle(color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(localizations?.loading_back_to_properties ??
                    'Back to Properties'),
              ),
            ],
          ),
        ),
      );
    }

    if (property == null) {
      return SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Property Title and Price
          _buildTitleSection(localizations),
          SizedBox(height: 24),

          // Property Stats
          _buildStatsSection(localizations),
          SizedBox(height: 24),

          // Location Map
          _buildLocationSection(localizations),
          SizedBox(height: 24),

          // Description
          _buildDescriptionSection(localizations),
          SizedBox(height: 24),

          // Features
          _buildFeaturesSection(localizations),
          SizedBox(height: 24),

          // Nearby Amenities (using API data)
          _buildNearbyAmenitiesSection(localizations),
          SizedBox(height: 24),

          // Property Details
          _buildDetailsSection(localizations),
          SizedBox(height: 24),

          // Contact Information
          _buildContactSection(localizations),
          SizedBox(height: 24),

          // Property Status
          _buildStatusSection(localizations),
        ],
      ),
    );
  }

  Widget _buildTitleSection(AppLocalizations? localizations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          property!.title,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.grey[900],
          ),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Text(
              '${property!.price} ${property!.currency}',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.green[600],
              ),
            ),
            Spacer(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.visibility, size: 16, color: Colors.grey[600]),
                  SizedBox(width: 4),
                  Text(
                    '${property!.viewsCount} ${localizations?.property_info_views ?? "views"}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (property!.pricePerSqm != null) ...[
          SizedBox(height: 4),
          Text(
            '${property!.pricePerSqm} ${property!.currency}${localizations?.property_info_price_per_sqm ?? "/m²"}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildNearbyAmenitiesSection(AppLocalizations? localizations) {
    // From your API data: metro_distance: 200, school_distance: 100, hospital_distance: 3, shopping_distance: 6
    final amenities = <String, int>{
      localizations?.amenities_metro ?? 'Metro': 200,
      localizations?.amenities_school ?? 'School': 100,
      localizations?.amenities_hospital ?? 'Hospital': 3,
      localizations?.amenities_shopping ?? 'Shopping': 6,
    };

    // Filter out amenities that are 0 or null
    final availableAmenities =
        amenities.entries.where((e) => e.value > 0).toList();

    if (availableAmenities.isEmpty) return SizedBox.shrink();

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        localizations?.sections_nearby_amenities ?? 'Nearby Amenities',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(height: 12),
      Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          children: availableAmenities.map((amenity) {
            IconData amenityIcon;
            Color amenityColor;

            switch (amenity.key.toLowerCase()) {
              case 'metro':
                amenityIcon = Icons.train;
                amenityColor = Colors.blue;
                break;
              case 'school':
                amenityIcon = Icons.school;
                amenityColor = Colors.green;
                break;
              case 'hospital':
                amenityIcon = Icons.local_hospital;
                amenityColor = Colors.red;
                break;
              case 'shopping':
                amenityIcon = Icons.shopping_cart;
                amenityColor = Colors.orange;
                break;
              default:
                amenityIcon = Icons.location_on;
                amenityColor = Colors.grey;
            }

            return Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: amenityColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      amenityIcon,
                      color: amenityColor,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      amenity.key,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Text(
                    '${amenity.value}m ${localizations?.amenities_away ?? "away"}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    ]);
  }

  Widget _buildStatsSection(AppLocalizations? localizations) {
    return Row(
      children: [
        _buildStatItem(
          Icons.bed,
          '${property!.bedrooms}',
          localizations?.property_card_bed ?? 'bed',
        ),
        SizedBox(width: 24),
        _buildStatItem(
          Icons.bathroom,
          '${property!.bathrooms}',
          localizations?.property_card_bath ?? 'bath',
        ),
        SizedBox(width: 24),
        _buildStatItem(
          Icons.square_foot,
          '${property!.squareMeters}m²',
          'area',
        ),
        if (parkingSpaces > 0) ...[
          SizedBox(width: 24),
          _buildStatItem(
            Icons.local_parking,
            '$parkingSpaces',
            localizations?.property_card_parking ?? 'parking',
          ),
        ],
      ],
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, size: 24, color: Colors.grey[600]),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[900],
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildLocationSection(AppLocalizations? localizations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Address Info
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.location_on, color: Colors.red[400]),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${property!.address}, ${property!.city}, ${property!.district}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              if (floor != null && totalFloors != null) ...[
                SizedBox(height: 8),
                Text(
                  '${localizations?.property_details_floor ?? "Floor"}: $floor ${localizations?.property_details_of ?? "of"} $totalFloors',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ],
          ),
        ),

        SizedBox(height: 16),

        // Map Section
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Location',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: _showFullscreenMap,
                    icon: Icon(Icons.fullscreen, size: 16),
                    label: Text(
                      'View Fullscreen',
                      style: TextStyle(fontSize: 12),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).primaryColor,
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),

              // Map Widget
              PropertyMapWidget(
                property: property!,
                height: 250,
                showControls: true,
                onFullscreenToggle: _showFullscreenMap,
              ),

              SizedBox(height: 12),

              // Map Footer Info
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.red[400],
                      size: 16,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            property!.address,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            '${property!.district}, ${property!.city}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionSection(AppLocalizations? localizations) {
    if (description == null || description!.isEmpty) {
      return SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations?.sections_description ?? 'Description',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12),
        Text(
          description!,
          style: TextStyle(
            fontSize: 16,
            height: 1.5,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturesSection(AppLocalizations? localizations) {
    final features = <String, bool>{
      localizations?.property_card_balcony ?? 'Balcony': hasBalcony,
      localizations?.property_card_garage ?? 'Garage': hasGarage,
      localizations?.property_card_garden ?? 'Garden': hasGarden,
      localizations?.property_card_pool ?? 'Pool': hasPool,
      localizations?.property_card_elevator ?? 'Elevator': hasElevator,
      localizations?.property_card_furnished ?? 'Furnished': isFurnished,
    };

    final availableFeatures = features.entries.where((e) => e.value).toList();

    if (availableFeatures.isEmpty) return SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations?.property_details_features_amenities ??
              'Features & Amenities',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: availableFeatures.map((feature) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Text(
                feature.key,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.blue[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDetailsSection(AppLocalizations? localizations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations?.property_details_basic_information ??
              'Basic Information',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12),
        _buildDetailRow(
          localizations?.property_details_property_type ?? 'Property Type:',
          property!.propertyTypeDisplay,
        ),
        _buildDetailRow(
          localizations?.property_details_listing_type ?? 'Listing Type:',
          property!.listingTypeDisplay,
        ),
        if (yearBuilt != null)
          _buildDetailRow(
            localizations?.property_details_year_built ?? 'Year Built:',
            yearBuilt.toString(),
          ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.grey[900],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection(AppLocalizations? localizations) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizations?.contact_title ?? 'Contact Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          if (property!.agent != null) ...[
            // Agent contact
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.blue[100],
                  child: Icon(Icons.person, color: Colors.blue[600]),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localizations?.contact_modal_agent ?? 'Agent',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        property!.agent!.username,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () =>
                      _copyPhoneNumber(property!.agent!.phoneNumber),
                  icon: Icon(Icons.phone, color: Colors.green),
                ),
              ],
            ),
          ] else ...[
            // Owner contact
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.green[100],
                  child: Icon(Icons.home, color: Colors.green[600]),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localizations?.contact_property_owner ??
                            'Property Owner',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        property!.owner.username,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () =>
                      _copyPhoneNumber(property!.owner.phoneNumber),
                  icon: Icon(Icons.phone, color: Colors.green),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusSection(AppLocalizations? localizations) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizations?.property_status_title ?? 'Property Status',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          _buildDetailRow(
            localizations?.property_status_availability ?? 'Availability:',
            isActive
                ? (localizations?.property_status_available ?? 'Available')
                : (localizations?.property_status_not_available ??
                    'Not Available'),
          ),
          _buildDetailRow(
            localizations?.property_status_property_id ?? 'Property ID:',
            property!.id,
          ),
          _buildDetailRow(
            localizations?.property_info_listed ?? 'Listed:',
            property!.createdAt.toString().split(' ')[0],
          ),
        ],
      ),
    );
  }
}
