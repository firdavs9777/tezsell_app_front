import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/providers/provider_models/real_estate.dart';
import 'package:app/providers/provider_root/real_estate_provider.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/pages/real_estate/property_inquiry_dialog.dart';
import 'package:app/config/app_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Import detail widgets
import 'package:app/pages/real_estate/detail/property_image.dart';
import 'package:app/pages/real_estate/detail/property_map_widget.dart';
import 'package:app/pages/real_estate/detail/property_title_section.dart';
import 'package:app/pages/real_estate/detail/property_stats_section.dart';
import 'package:app/pages/real_estate/detail/property_location_section.dart';
import 'package:app/pages/real_estate/detail/property_description_section.dart';
import 'package:app/pages/real_estate/detail/property_features_section.dart';
import 'package:app/pages/real_estate/detail/property_amenities_section.dart';
import 'package:app/pages/real_estate/detail/property_details_section.dart';
import 'package:app/pages/real_estate/detail/property_contact_section.dart';
import 'package:app/pages/real_estate/detail/property_status_section.dart';
import 'package:app/widgets/image_viewer.dart';
import 'package:app/widgets/report_content_dialog.dart';
import 'package:app/utils/error_handler.dart';

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
  bool isCheckingSaved = true;
  String? userToken;
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
  int? metroDistance;
  int? schoolDistance;
  int? hospitalDistance;
  int? shoppingDistance;
  int currentImageIndex = 0;
  PageController? _imagePageController;

  @override
  void initState() {
    super.initState();
    _imagePageController = PageController(initialPage: 0);
    _initialize();
  }

  @override
  void dispose() {
    _imagePageController?.dispose();
    super.dispose();
  }

  Future<void> _initialize() async {
    await _loadUserToken();
    await _loadPropertyDetails();
    // isSaved is now set from API response in _loadPropertyDetails
    // Only check if not already set
    if (userToken != null && property != null && !isSaved) {
      await _checkIfPropertySaved();
    }
  }

  Future<void> _loadUserToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (mounted) {
        setState(() {
          userToken = prefs.getString('token');
        });
      }
    } catch (e) {}
  }

  Future<void> _checkIfPropertySaved() async {
    if (userToken == null || property == null) {
      if (mounted) {
        setState(() {
          isCheckingSaved = false;
        });
      }
      return;
    }

    try {
      setState(() {
        isCheckingSaved = true;
      });

      final saved = await ref.read(realEstateServiceProvider).isPropertySaved(
            propertyId: property!.id.toString(),
            token: userToken!,
          );

      if (mounted) {
        setState(() {
          isSaved = saved;
          isCheckingSaved = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isCheckingSaved = false;
          isSaved = false;
        });
      }
    }
  }

  Future<void> _loadPropertyDetails() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      // Fetch property using the service
      final propertyResponse = await ref
          .read(realEstateServiceProvider)
          .fetchSingleFilteredProperty(propertyId: widget.propertyId);

      // Also fetch raw response to get all fields
      final realEstateService = ref.read(realEstateServiceProvider);
      final rawResponse = await realEstateService.dio.get(
        '${AppConfig.baseUrl}${AppConfig.realEstatePropertiesPath}${widget.propertyId}/',
      );

      if (mounted && rawResponse.statusCode == 200) {
        final data = rawResponse.data;
        if (data['success'] == true && data['property'] != null) {
          final propertyData = data['property'];

          setState(() {
            property = propertyResponse;

            // Extract all additional fields from raw response
            description = propertyData['description'] ?? '';
            floor = propertyData['floor'];
            totalFloors = propertyData['total_floors'];
            yearBuilt = propertyData['year_built'];
            parkingSpaces = propertyData['parking_spaces'] ?? 0;
            hasBalcony = propertyData['has_balcony'] ?? false;
            hasGarage = propertyData['has_garage'] ?? false;
            hasGarden = propertyData['has_garden'] ?? false;
            hasPool = propertyData['has_pool'] ?? false;
            hasElevator = propertyData['has_elevator'] ?? false;
            isFurnished = propertyData['is_furnished'] ?? false;
            isActive = propertyData['is_active'] ?? true;
            isSold = propertyData['is_sold'] ?? false;
            isSaved = propertyData['is_saved'] ?? false;
            metroDistance = propertyData['metro_distance'];
            schoolDistance = propertyData['school_distance'];
            hospitalDistance = propertyData['hospital_distance'];
            shoppingDistance = propertyData['shopping_distance'];

            // Parse images array
            if (propertyData['images'] != null &&
                propertyData['images'] is List) {
              images = (propertyData['images'] as List).map((img) {
                return PropertyImage(
                  id: img['id'] ?? 0,
                  image: img['image'] ?? '',
                  caption: img['caption'] ?? '',
                );
              }).toList();

              // Initialize PageController after images are loaded
              if (images.isNotEmpty) {
                _imagePageController?.dispose();
                _imagePageController = PageController(initialPage: 0);
              }
            } else if (property?.mainImage != null &&
                property!.mainImage.isNotEmpty) {
              // Fallback to main image if images array is empty
              images = [
                PropertyImage(
                  id: 0,
                  image: property!.mainImage,
                  caption: '',
                )
              ];
            }

            isLoading = false;
          });
        } else {
          throw Exception('Invalid response structure');
        }
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          errorMessage = error.toString();
          isLoading = false;
        });
      }
    }
  }

  Future<void> _toggleSave() async {
    if (property == null) return;

    if (userToken == null) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.authLoginRequired),
          backgroundColor: Colors.orange,
          action: SnackBarAction(
            label: l10n.authLogin,
            textColor: Colors.white,
            onPressed: () {
              Navigator.of(context).pushNamed('/login');
            },
          ),
        ),
      );
      return;
    }

    // Optimistic update
    final previouslySaved = isSaved;
    setState(() {
      isSaved = !isSaved;
    });

    try {
      // Use appropriate method based on current state
      if (previouslySaved) {
        // Was saved, now unsaving - use DELETE

        await ref.read(realEstateServiceProvider).unsaveProperty(
              propertyId: property!.id.toString(),
              token: userToken!,
            );
      } else {
        // Was not saved, now saving - use POST (toggle)

        final result =
            await ref.read(realEstateServiceProvider).toggleSaveProperty(
                  propertyId: property!.id.toString(),
                  token: userToken!,
                );

        // Verify the result matches expectation
        final actualSaved = result['is_saved'] ?? false;
        if (actualSaved != isSaved) {
          setState(() {
            isSaved = actualSaved;
          });
        }
      }

      if (mounted) {
        HapticFeedback.selectionClick();

        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isSaved
                  ? l10n.success_property_saved
                  : l10n.successPropertyUnsaved,
            ),
            backgroundColor: isSaved ? Colors.green : Colors.orange,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (error) {
      // Revert optimistic update on error
      if (mounted) {
        setState(() {
          isSaved = previouslySaved;
        });

        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('${l10n.alertsUnsavePropertyFailed}: ${error.toString()}'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _copyPhoneNumber(String phoneNumber) {
    Clipboard.setData(ClipboardData(text: phoneNumber));
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.alerts_phone_copied),
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
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            backgroundColor: theme.primaryColor,
            actions: [
              isCheckingSaved
                  ? Padding(
                      padding: EdgeInsets.all(8),
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                    )
                  : IconButton(
                      icon: Icon(
                        isSaved ? Icons.favorite : Icons.favorite_border,
                        color: Colors.red,
                      ),
                      onPressed: _toggleSave,
                    ),
              IconButton(
                icon: Icon(Icons.share, color: Colors.white),
                onPressed: () {
                  HapticFeedback.selectionClick();
                },
              ),
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, color: Colors.white),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                onSelected: (value) {
                  if (value == 'report') {
                    _showReportDialog();
                  }
                },
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem<String>(
                    value: 'report',
                    child: Row(
                      children: [
                        Icon(
                          Icons.flag_rounded,
                          color: Theme.of(context).colorScheme.error,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          l10n.reportProduct ?? 'Report Property',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Image Gallery with PageView
                  if (images.isNotEmpty)
                    Positioned.fill(
                      child: GestureDetector(
                        onHorizontalDragUpdate: (details) {
                          // This captures horizontal drags for the PageView
                        },
                        child: PageView.builder(
                          itemCount: images.length,
                          controller: _imagePageController,
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          onPageChanged: (index) {
                            if (mounted) {
                              setState(() {
                                currentImageIndex = index;
                              });
                            }
                          },
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                final imageUrls = images.map((img) => img.image).toList();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ImageViewer(
                                      imageUrls: imageUrls,
                                      initialIndex: index,
                                    ),
                                  ),
                                );
                              },
                              child: Image.network(
                                images[index].image,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                  color: Colors.grey[300],
                                  child: Icon(Icons.apartment,
                                      size: 80, color: Colors.grey[500]),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  else if (property?.mainImage != null &&
                      property!.mainImage.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ImageViewer(
                              imageUrl: property!.mainImage,
                              title: property!.title,
                            ),
                          ),
                        );
                      },
                      child: Image.network(
                        property!.mainImage,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey[300],
                          child: Icon(Icons.apartment,
                              size: 80, color: Colors.grey[500]),
                        ),
                      ),
                    )
                  else
                    Container(
                      color: Colors.grey[300],
                      child: Icon(Icons.apartment,
                          size: 80, color: Colors.grey[500]),
                    ),
                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.5)
                        ],
                      ),
                    ),
                  ),
                  // Image indicator
                  if (images.length > 1)
                    Positioned(
                      bottom: 16,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(images.length, (index) {
                          return Container(
                            width: 8,
                            height: 8,
                            margin: EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: currentImageIndex == index
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.4),
                            ),
                          );
                        }),
                      ),
                    ),
                  // Badges
                  if (property != null) ...[
                    Positioned(
                      top: 60,
                      left: 16,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: theme.primaryColor.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          property!.listingTypeDisplay,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
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
                            color: Colors.orange.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.star, color: Colors.white, size: 14),
                              SizedBox(width: 4),
                              Text(
                                l10n.propertyCardFeatured,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: _buildContent(context, l10n),
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
                    color: Colors.grey[700]),
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
          PropertyTitleSection(
            property: property!,
            localizations: localizations,
          ),
          SizedBox(height: 24),
          PropertyStatsSection(
            bedrooms: property!.bedrooms,
            bathrooms: property!.bathrooms,
            squareMeters: property!.squareMeters,
            parkingSpaces: parkingSpaces,
            localizations: localizations,
          ),
          SizedBox(height: 24),
          PropertyLocationSection(
            property: property!,
            floor: floor,
            totalFloors: totalFloors,
            onFullscreenMap: _showFullscreenMap,
            localizations: localizations,
          ),
          SizedBox(height: 24),
          PropertyDescriptionSection(
            description: description,
            localizations: localizations,
          ),
          SizedBox(height: 24),
          PropertyFeaturesSection(
            hasBalcony: hasBalcony,
            hasGarage: hasGarage,
            hasGarden: hasGarden,
            hasPool: hasPool,
            hasElevator: hasElevator,
            isFurnished: isFurnished,
            localizations: localizations,
          ),
          SizedBox(height: 24),
          PropertyAmenitiesSection(
            metroDistance: metroDistance,
            schoolDistance: schoolDistance,
            hospitalDistance: hospitalDistance,
            shoppingDistance: shoppingDistance,
            localizations: localizations,
          ),
          SizedBox(height: 24),
          PropertyDetailsSection(
            property: property!,
            yearBuilt: yearBuilt,
            localizations: localizations,
          ),
          SizedBox(height: 24),
          PropertyContactSection(
            property: property!,
            onInquiry: _showInquiryDialog,
            localizations: localizations,
          ),
          SizedBox(height: 24),
          PropertyStatusSection(
            property: property!,
            isActive: isActive,
            localizations: localizations,
          ),
        ],
      ),
    );
  }

  void _showInquiryDialog() {
    showDialog(
      context: context,
      builder: (context) => PropertyInquiryDialog(
        propertyId: property!.id,
        propertyTitle: property!.title,
      ),
    ).then((success) {
      if (success == true) {
        // Inquiry was submitted successfully
        HapticFeedback.mediumImpact();
      }
    });
  }

  Future<void> _showReportDialog() async {
    if (property == null) return;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => ReportContentDialog(
        contentType: 'property',
        contentId: property!.id,
        contentTitle: property!.title,
      ),
    );

    // Show success message if report was successful
    if (result == true && mounted) {
      final localizations = AppLocalizations.of(context);
      AppErrorHandler.showSuccess(
        context,
        localizations?.reportSubmitted ??
            'Thank you for your report. We will review it within 24 hours.',
      );
    }
  }
}
