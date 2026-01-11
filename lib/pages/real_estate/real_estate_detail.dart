import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:app/providers/provider_models/real_estate.dart';
import 'package:app/providers/provider_root/real_estate_provider.dart';
import 'package:app/providers/provider_root/chat_provider.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/pages/real_estate/property_inquiry_dialog.dart';
import 'package:app/pages/chat/chat_room.dart' show ChatRoomScreen;
import 'package:app/config/app_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/pages/real_estate/detail/property_image.dart';
import 'package:app/widgets/image_viewer.dart';
import 'package:app/widgets/report_content_dialog.dart';
import 'package:app/widgets/cached_network_image_widget.dart';
import 'package:app/utils/error_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';

class PropertyDetail extends ConsumerStatefulWidget {
  const PropertyDetail({super.key, required this.propertyId});
  final String propertyId;

  @override
  ConsumerState<PropertyDetail> createState() => _PropertyDetailState();
}

class _PropertyDetailState extends ConsumerState<PropertyDetail> {
  // Carrot orange color
  static const Color carrotOrange = Color(0xFFFF6F0F);

  RealEstate? property;
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

      final propertyResponse = await ref
          .read(realEstateServiceProvider)
          .fetchSingleFilteredProperty(propertyId: widget.propertyId);

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

            if (propertyData['images'] != null &&
                propertyData['images'] is List) {
              images = (propertyData['images'] as List).map((img) {
                return PropertyImage(
                  id: img['id'] ?? 0,
                  image: img['image'] ?? '',
                  caption: img['caption'] ?? '',
                );
              }).toList();

              if (images.isNotEmpty) {
                _imagePageController?.dispose();
                _imagePageController = PageController(initialPage: 0);
              }
            } else if (property?.mainImage != null &&
                property!.mainImage.isNotEmpty) {
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
          backgroundColor: Theme.of(context).colorScheme.tertiary,
          action: SnackBarAction(
            label: l10n.authLogin,
            textColor: Theme.of(context).colorScheme.onTertiary,
            onPressed: () {
              Navigator.of(context).pushNamed('/login');
            },
          ),
        ),
      );
      return;
    }

    final previouslySaved = isSaved;
    setState(() {
      isSaved = !isSaved;
    });

    try {
      if (previouslySaved) {
        await ref.read(realEstateServiceProvider).unsaveProperty(
              propertyId: property!.id.toString(),
              token: userToken!,
            );
      } else {
        final result =
            await ref.read(realEstateServiceProvider).toggleSaveProperty(
                  propertyId: property!.id.toString(),
                  token: userToken!,
                );

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
            backgroundColor: isSaved
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.tertiary,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          isSaved = previouslySaved;
        });

        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('${l10n.alertsUnsavePropertyFailed}: ${error.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _shareProperty() {
    if (property == null) return;
    HapticFeedback.selectionClick();

    final l10n = AppLocalizations.of(context)!;
    final shareText =
        '${l10n.checkOutProfile} ${property!.title} ${l10n.onTezsell}\nhttps://webtezsell.com/properties/${property!.id}';

    final box = context.findRenderObject() as RenderBox?;
    Share.share(
      shareText,
      subject: property!.title,
      sharePositionOrigin: box != null
          ? box.localToGlobal(Offset.zero) & box.size
          : const Rect.fromLTWH(0, 0, 100, 100),
    );
  }

  Future<void> _startChatWithOwner() async {
    if (property == null) return;

    final l10n = AppLocalizations.of(context)!;
    final ownerId = property!.agent?.id ?? property!.owner.id;
    final ownerName = property!.agent?.username ?? property!.owner.username;

    await ref.read(chatProvider.notifier).initialize();

    final chatState = ref.read(chatProvider);
    if (!chatState.isAuthenticated) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.chatLoginMessage),
            backgroundColor: Theme.of(context).colorScheme.tertiary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
      return;
    }

    if (chatState.currentUserId == ownerId) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.cannot_chat_with_yourself),
            backgroundColor: Theme.of(context).colorScheme.tertiary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
      return;
    }

    // Show loading bottom sheet
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 48,
              height: 48,
              child: CircularProgressIndicator(strokeWidth: 3),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.opening_chat_with(ownerName),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );

    try {
      final chatRoom = await ref
          .read(chatProvider.notifier)
          .getOrCreateDirectChat(ownerId);

      if (mounted) Navigator.of(context).pop();

      if (chatRoom != null && mounted) {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChatRoomScreen(chatRoom: chatRoom)),
        );
      } else {
        throw Exception('Failed to create chat room');
      }
    } catch (e) {
      if (mounted && Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.unable_to_start_chat),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: l10n.retry,
              textColor: Theme.of(context).colorScheme.onError,
              onPressed: _startChatWithOwner,
            ),
          ),
        );
      }
    }
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

    if (result == true && mounted) {
      final localizations = AppLocalizations.of(context);
      AppErrorHandler.showSuccess(
        context,
        localizations?.reportSubmitted ??
            'Thank you for your report. We will review it within 24 hours.',
      );
    }
  }

  String _getTimeAgo() {
    if (property == null) return '';
    try {
      final date = property!.createdAt;
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays > 30) {
        return DateFormat('MMM d').format(date);
      } else if (difference.inDays > 0) {
        return '${difference.inDays}d ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}h ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}m ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final imageUrls = images.map((img) => img.image).toList();

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Stack(
        children: [
          CustomScrollView(
            physics: const ClampingScrollPhysics(),
            slivers: [
              // Carrot-style SliverAppBar with images
              SliverAppBar(
                expandedHeight: 360,
                pinned: true,
                backgroundColor: colorScheme.surface,
                elevation: 0,
                leading: _buildCircularButton(
                  icon: Icons.arrow_back,
                  onTap: () => Navigator.of(context).pop(),
                ),
                actions: [
                  _buildCircularButton(
                    icon: Icons.share_outlined,
                    onTap: _shareProperty,
                  ),
                  _buildCircularButton(
                    icon: Icons.more_vert,
                    onTap: () => _showMoreOptions(context, l10n),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Image PageView
                      if (imageUrls.isNotEmpty)
                        PageView.builder(
                          controller: _imagePageController,
                          itemCount: imageUrls.length,
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
                              child: CachedNetworkImageWidget(
                                imageUrl: imageUrls[index],
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        )
                      else
                        Container(
                          color: colorScheme.surfaceContainerHighest,
                          child: Icon(Icons.apartment,
                              size: 80, color: colorScheme.onSurfaceVariant),
                        ),

                      // Carrot-style page indicator
                      if (imageUrls.length > 1)
                        Positioned(
                          bottom: 16,
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(imageUrls.length, (index) {
                              final isActive = index == currentImageIndex;
                              return AnimatedContainer(
                                duration: Duration(milliseconds: 200),
                                width: isActive ? 20 : 6,
                                height: 6,
                                margin: EdgeInsets.symmetric(horizontal: 3),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  color: isActive
                                      ? Colors.white
                                      : Colors.white.withOpacity(0.5),
                                ),
                              );
                            }),
                          ),
                        ),

                      // Image counter badge
                      if (imageUrls.length > 1)
                        Positioned(
                          right: 16,
                          bottom: 16,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${currentImageIndex + 1}/${imageUrls.length}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),

                      // Badges (listing type, featured)
                      if (property != null) ...[
                        Positioned(
                          top: 100,
                          left: 16,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: carrotOrange,
                              borderRadius: BorderRadius.circular(6),
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
                            top: 100,
                            right: 16,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.star,
                                      color: Colors.white, size: 14),
                                  SizedBox(width: 4),
                                  Text(
                                    l10n.propertyCardFeatured,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
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

              // Content
              SliverToBoxAdapter(
                child: _buildContent(context, l10n),
              ),
            ],
          ),

          // Carrot-style bottom bar
          if (property != null && !isLoading)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _buildCarrotBottomBar(context, l10n),
            ),
        ],
      ),
    );
  }

  Widget _buildCircularButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.all(8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: colorScheme.surface.withOpacity(0.9),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withOpacity(0.1),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Icon(icon, color: colorScheme.onSurface, size: 22),
        ),
      ),
    );
  }

  void _showMoreOptions(BuildContext context, AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: Icon(Icons.flag_outlined, color: Theme.of(context).colorScheme.error),
              title: Text(l10n.reportProduct ?? 'Report Property'),
              onTap: () {
                Navigator.pop(context);
                _showReportDialog();
              },
            ),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, AppLocalizations l10n) {
    if (isLoading) {
      return Container(
        height: 400,
        child: Center(
          child: CircularProgressIndicator(color: carrotOrange),
        ),
      );
    }

    if (errorMessage != null) {
      return Container(
        height: 400,
        padding: EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Theme.of(context).colorScheme.onSurfaceVariant),
              SizedBox(height: 16),
              Text(
                l10n.loading_property_not_found ?? 'Property not found',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 8),
              Text(
                l10n.loading_property_not_found_message ??
                    'The property you are looking for does not exist or has been removed.',
                style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  l10n.loading_back_to_properties ?? 'Back to Properties',
                  style: TextStyle(color: carrotOrange),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (property == null) return SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Owner/Agent Section
        _buildOwnerSection(context, l10n),
        _buildSectionDivider(),

        // Property Info Section
        _buildPropertyInfoSection(context, l10n),
        _buildSectionDivider(),

        // Stats Section
        _buildStatsSection(context, l10n),
        _buildSectionDivider(),

        // Location Section
        _buildLocationSection(context, l10n),
        _buildSectionDivider(),

        // Description Section
        if (description != null && description!.isNotEmpty) ...[
          _buildDescriptionSection(context, l10n),
          _buildSectionDivider(),
        ],

        // Features Section
        _buildFeaturesSection(context, l10n),
        _buildSectionDivider(),

        // Nearby Amenities Section
        if (_hasNearbyAmenities()) ...[
          _buildAmenitiesSection(context, l10n),
          _buildSectionDivider(),
        ],

        // Property Details Section
        _buildDetailsSection(context, l10n),

        // Bottom padding for the fixed bottom bar
        SizedBox(height: 100),
      ],
    );
  }

  Widget _buildSectionDivider() {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      height: 8,
      color: colorScheme.surfaceContainerHighest,
    );
  }

  Widget _buildOwnerSection(BuildContext context, AppLocalizations l10n) {
    final colorScheme = Theme.of(context).colorScheme;
    final isAgent = property!.agent != null;
    final ownerId = isAgent ? property!.agent!.id : property!.owner.id;
    final ownerName = isAgent ? property!.agent!.username : property!.owner.username;

    return Container(
      color: colorScheme.surface,
      padding: EdgeInsets.all(16),
      child: InkWell(
        onTap: () => context.push('/user/$ownerId'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: isAgent
                    ? colorScheme.primaryContainer
                    : colorScheme.secondaryContainer,
                child: Icon(
                  isAgent ? Icons.person : Icons.home,
                  color: isAgent
                      ? colorScheme.onPrimaryContainer
                      : colorScheme.onSecondaryContainer,
                  size: 24,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ownerName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      isAgent
                          ? (l10n.contact_modal_agent ?? 'Agent')
                          : (l10n.contact_property_owner ?? 'Property Owner'),
                      style: TextStyle(
                        fontSize: 13,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: colorScheme.onSurfaceVariant,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPropertyInfoSection(
      BuildContext context, AppLocalizations l10n) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      color: colorScheme.surface,
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Property type chip and time
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  property!.propertyTypeDisplay,
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(width: 8),
              Text(
                _getTimeAgo(),
                style: TextStyle(
                  fontSize: 13,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),

          // Title
          Text(
            property!.title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
              height: 1.3,
            ),
          ),
          SizedBox(height: 16),

          // Price
          Text(
            '${_formatPrice(property!.price)} ${property!.currency}',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),

          // Price per sqm
          if (property!.pricePerSqm != null &&
              property!.pricePerSqm.isNotEmpty) ...[
            SizedBox(height: 4),
            Text(
              '${property!.pricePerSqm} ${property!.currency}${l10n.property_info_price_per_sqm ?? "/m²"}',
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],

          SizedBox(height: 16),

          // Views row
          Row(
            children: [
              Icon(Icons.visibility_outlined,
                  size: 18, color: colorScheme.onSurfaceVariant),
              SizedBox(width: 4),
              Text(
                '${property!.viewsCount} ${l10n.property_info_views}',
                style: TextStyle(
                  fontSize: 13,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context, AppLocalizations l10n) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      color: colorScheme.surface,
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            icon: Icons.bed_outlined,
            value: '${property!.bedrooms}',
            label: l10n.property_details_bedrooms,
          ),
          _buildStatDivider(),
          _buildStatItem(
            icon: Icons.bathtub_outlined,
            value: '${property!.bathrooms}',
            label: l10n.property_details_bathrooms,
          ),
          _buildStatDivider(),
          _buildStatItem(
            icon: Icons.square_foot,
            value: '${property!.squareMeters}',
            label: 'm²',
          ),
          if (parkingSpaces > 0) ...[
            _buildStatDivider(),
            _buildStatItem(
              icon: Icons.local_parking,
              value: '$parkingSpaces',
              label: l10n.property_details_parking,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Icon(icon, size: 24, color: colorScheme.onSurfaceVariant),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildStatDivider() {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: 1,
      height: 40,
      color: colorScheme.outlineVariant,
    );
  }

  Widget _buildLocationSection(BuildContext context, AppLocalizations l10n) {
    final colorScheme = Theme.of(context).colorScheme;
    // Build location string from available fields
    final locationParts = <String>[];
    if (property!.address.isNotEmpty) locationParts.add(property!.address);
    if (property!.district.isNotEmpty) locationParts.add(property!.district);
    if (property!.city.isNotEmpty) locationParts.add(property!.city);
    final locationString = locationParts.isNotEmpty
        ? locationParts.join(', ')
        : property!.region;

    return Container(
      color: colorScheme.surface,
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.property_create_location,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.location_on_outlined, size: 20, color: colorScheme.onSurfaceVariant),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  locationString,
                  style: TextStyle(
                    fontSize: 14,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
          if (floor != null || totalFloors != null) ...[
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.apartment, size: 20, color: colorScheme.onSurfaceVariant),
                SizedBox(width: 8),
                Text(
                  floor != null && totalFloors != null
                      ? '${l10n.property_details_floor} $floor ${l10n.property_details_of} $totalFloors'
                      : floor != null
                          ? '${l10n.property_details_floor} $floor'
                          : '${l10n.property_details_total_floors}: $totalFloors',
                  style: TextStyle(
                    fontSize: 14,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDescriptionSection(
      BuildContext context, AppLocalizations l10n) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      color: colorScheme.surface,
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.sections_description,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 12),
          Text(
            description!,
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.onSurface,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesSection(BuildContext context, AppLocalizations l10n) {
    final colorScheme = Theme.of(context).colorScheme;
    final features = <Map<String, dynamic>>[
      if (hasBalcony)
        {'icon': Icons.balcony, 'label': l10n.property_card_balcony},
      if (hasGarage)
        {'icon': Icons.garage, 'label': l10n.property_card_garage},
      if (hasGarden)
        {'icon': Icons.grass, 'label': l10n.property_card_garden},
      if (hasPool)
        {'icon': Icons.pool, 'label': l10n.property_card_pool},
      if (hasElevator)
        {'icon': Icons.elevator, 'label': l10n.property_card_elevator},
      if (isFurnished)
        {'icon': Icons.chair, 'label': l10n.property_card_furnished},
    ];

    if (features.isEmpty) {
      return Container(
        color: colorScheme.surface,
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.property_create_features,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 12),
            Text(
              l10n.no_description,
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      color: colorScheme.surface,
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.property_create_features,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: features.map((feature) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(feature['icon'] as IconData,
                        size: 18, color: colorScheme.onSurfaceVariant),
                    SizedBox(width: 6),
                    Text(
                      feature['label'] as String,
                      style: TextStyle(
                        fontSize: 13,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  bool _hasNearbyAmenities() {
    return metroDistance != null ||
        schoolDistance != null ||
        hospitalDistance != null ||
        shoppingDistance != null;
  }

  Widget _buildAmenitiesSection(BuildContext context, AppLocalizations l10n) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      color: colorScheme.surface,
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.sections_nearby_amenities,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 12),
          if (metroDistance != null)
            _buildAmenityRow(Icons.subway, l10n.amenities_metro, '$metroDistance m'),
          if (schoolDistance != null)
            _buildAmenityRow(Icons.school, l10n.amenities_school, '$schoolDistance m'),
          if (hospitalDistance != null)
            _buildAmenityRow(Icons.local_hospital, l10n.amenities_hospital, '$hospitalDistance m'),
          if (shoppingDistance != null)
            _buildAmenityRow(Icons.shopping_bag, l10n.amenities_shopping, '$shoppingDistance m'),
        ],
      ),
    );
  }

  Widget _buildAmenityRow(IconData icon, String label, String distance) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: colorScheme.onSurfaceVariant),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          Text(
            distance,
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsSection(BuildContext context, AppLocalizations l10n) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      color: colorScheme.surface,
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.property_details_title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 12),
          _buildDetailRow(l10n.property_details_property_type, property!.propertyTypeDisplay),
          _buildDetailRow(l10n.property_details_listing_type, property!.listingTypeDisplay),
          if (yearBuilt != null)
            _buildDetailRow(l10n.property_details_year_built, '$yearBuilt'),
          _buildDetailRow(
            l10n.property_status_availability,
            isSold ? l10n.property_status_not_available : isActive ? l10n.property_status_available : l10n.property_status_not_available,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarrotBottomBar(BuildContext context, AppLocalizations l10n) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.fromLTRB(16, 12, 16, 12 + MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(color: colorScheme.outlineVariant, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Heart button
          GestureDetector(
            onTap: _toggleSave,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                border: Border.all(color: colorScheme.outlineVariant),
                borderRadius: BorderRadius.circular(8),
              ),
              child: isCheckingSaved
                  ? Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    )
                  : Icon(
                      isSaved ? Icons.favorite : Icons.favorite_border,
                      color: isSaved ? colorScheme.error : colorScheme.onSurfaceVariant,
                      size: 24,
                    ),
            ),
          ),

          SizedBox(width: 12),

          // Vertical divider
          Container(
            width: 1,
            height: 32,
            color: colorScheme.outlineVariant,
          ),

          SizedBox(width: 12),

          // Price section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${_formatPrice(property!.price)} ${property!.currency}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                Text(
                  property!.listingTypeDisplay,
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          // Orange inquiry button
          GestureDetector(
            onTap: _startChatWithOwner,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              decoration: BoxDecoration(
                color: carrotOrange,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                l10n.contact_send_inquiry ?? 'Contact',
                style: TextStyle(
                  color: colorScheme.onPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatPrice(dynamic price) {
    if (price == null) return '0';
    final numPrice = price is String ? double.tryParse(price) ?? 0 : price;
    final intPrice = numPrice.toInt();

    if (intPrice >= 1000000000) {
      return '${(intPrice / 1000000000).toStringAsFixed(1)}B';
    } else if (intPrice >= 1000000) {
      return '${(intPrice / 1000000).toStringAsFixed(1)}M';
    } else if (intPrice >= 1000) {
      return '${(intPrice / 1000).toStringAsFixed(0)}K';
    }
    return intPrice.toString();
  }
}
