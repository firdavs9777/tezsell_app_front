import 'package:app/pages/real_estate/real_estate_detail.dart';
import 'package:app/pages/real_estate/property_create_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/providers/provider_models/real_estate.dart';
import 'package:app/providers/provider_root/real_estate_provider.dart';
import 'package:app/l10n/app_localizations.dart';

class RealEstateMain extends ConsumerStatefulWidget {
  final String regionName;
  final String districtName;

  const RealEstateMain({
    super.key,
    required this.regionName,
    required this.districtName,
  });

  @override
  ConsumerState<RealEstateMain> createState() => _RealEstateMainState();
}

class _RealEstateMainState extends ConsumerState<RealEstateMain>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late TabController _tabController;
  List<RealEstate> _allProperties = [];
  int _currentPage = 1;
  bool _isLoadingMore = false;
  bool _hasMoreData = true;
  bool _isInitialLoading = true;

  String _selectedPropertyType = '';
  String _selectedListingType = '';

  // Updated property types with multilingual support
  final List<Map<String, dynamic>> _propertyTypes = [
    {
      'key': '',
      'labels': {'uz': 'Barchasi', 'ru': 'Все', 'en': 'All'},
      'icon': Icons.home
    },
    {
      'key': 'apartment',
      'labels': {'uz': 'Kvartira', 'ru': 'Квартира', 'en': 'Apartment'},
      'icon': Icons.apartment
    },
    {
      'key': 'house',
      'labels': {'uz': 'Uy', 'ru': 'Дом', 'en': 'House'},
      'icon': Icons.house
    },
    {
      'key': 'office',
      'labels': {'uz': 'Ofis', 'ru': 'Офис', 'en': 'Office'},
      'icon': Icons.business
    },
    {
      'key': 'land',
      'labels': {'uz': 'Yer', 'ru': 'Земля', 'en': 'Land'},
      'icon': Icons.landscape
    },
    {
      'key': 'commercial',
      'labels': {'uz': 'Boshqa', 'ru': 'Другое', 'en': 'Other'},
      'icon': Icons.store
    },
  ];

  // Helper function to get label by language
  String _getPropertyTypeLabel(Map<String, dynamic> propertyType) {
    final localizations = AppLocalizations.of(context);
    final languageCode = localizations?.localeName ?? 'uz';

    // Map locale codes to our property type language codes
    String langKey = 'uz'; // default
    if (languageCode.startsWith('ru')) {
      langKey = 'ru';
    } else if (languageCode.startsWith('en')) {
      langKey = 'en';
    }

    return propertyType['labels'][langKey] ?? propertyType['labels']['uz'];
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _propertyTypes.length, vsync: this);
    _tabController.addListener(_onTabChanged);
    _scrollController.addListener(_onScroll);
    _loadInitialProperties();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging) {
      HapticFeedback.selectionClick();
      _onPropertyTypeChanged(_propertyTypes[_tabController.index]['key']);
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoadingMore && _hasMoreData) {
        _loadMoreProperties();
      }
    }
  }

  Future<void> _loadInitialProperties() async {
    setState(() {
      _isInitialLoading = true;
      _currentPage = 1;
      _allProperties.clear();
      _hasMoreData = true;
    });

    try {
      final properties =
          await ref.read(realEstateServiceProvider).getFilteredProperties(
                currentPage: 1,
                pageSize: 12,
                propertyType: _selectedPropertyType,
                listingType: _selectedListingType,
                regionName: widget.regionName,
                districtName: widget.districtName,
              );

      setState(() {
        _allProperties = properties;
        _currentPage = 1;
        _hasMoreData = properties.length >= 12;
        _isInitialLoading = false;
      });
    } catch (error) {
      setState(() {
        _isInitialLoading = false;
      });
    }
  }

  Future<void> _loadMoreProperties() async {
    if (_isLoadingMore || !_hasMoreData) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final nextPage = _currentPage + 1;
      final newProperties =
          await ref.read(realEstateServiceProvider).getFilteredProperties(
                currentPage: nextPage,
                pageSize: 12,
                propertyType: _selectedPropertyType,
                listingType: _selectedListingType,
                regionName: widget.regionName,
                districtName: widget.districtName,
              );

      setState(() {
        if (newProperties.isNotEmpty) {
          _allProperties.addAll(newProperties);
          _currentPage = nextPage;
          _hasMoreData = newProperties.length >= 12;
        } else {
          _hasMoreData = false;
        }
        _isLoadingMore = false;
      });
    } catch (error) {
      setState(() {
        _isLoadingMore = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading more properties: $error'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> refresh() async {
    await _loadInitialProperties();
  }

  @override
  void didUpdateWidget(RealEstateMain oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.regionName != widget.regionName ||
        oldWidget.districtName != widget.districtName) {
      _loadInitialProperties();
    }
  }

  void _onPropertyTypeChanged(String propertyType) {
    setState(() {
      _selectedPropertyType = propertyType;
    });
    _loadInitialProperties();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Column(
        children: [
          // Modern Tab Bar
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.shadow.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Location indicator
                if (widget.regionName.isNotEmpty ||
                    widget.districtName.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    color: theme.primaryColor.withOpacity(0.1),
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 16,
                          color: theme.primaryColor,
                        ),
                        SizedBox(width: 4),
                        Text(
                          '${widget.districtName.isNotEmpty ? widget.districtName : widget.regionName}',
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Spacer(),
                        Text(
                          '${_allProperties.length} ta mulk',
                          style: TextStyle(
                            fontSize: 11,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),

                // Tab Bar with localized labels
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    indicator: BoxDecoration(
                      color: theme.primaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelColor: theme.colorScheme.onPrimary,
                    unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
                    labelStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    unselectedLabelStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                    tabs: _propertyTypes.map((type) {
                      return Tab(
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                type['icon'],
                                size: 16,
                              ),
                              SizedBox(width: 6),
                              Text(_getPropertyTypeLabel(type)),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 8),
              ],
            ),
          ),

          // Properties List
          Expanded(
            child: RefreshIndicator(
              onRefresh: refresh,
              child: _buildPropertiesList(localizations: localizations),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToCreateProperty(),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        elevation: 4,
        icon: const Icon(Icons.add_rounded, size: 24),
        label: Text(
          localizations?.general_create_property ?? 'Create Property',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void _navigateToCreateProperty() {
    // Check if user is logged in
    // TODO: Add permission check for agent status
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const PropertyCreatePage(),
      ),
    );
  }

  Widget _buildPropertiesList({AppLocalizations? localizations}) {
    if (_isInitialLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(height: 16),
            Text(
              'Mulklar yuklanmoqda...',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    if (_allProperties.isEmpty) {
      return SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.6,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.apartment,
                    size: 48,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  localizations?.no_properties_found ??
                      'Hech qanday mulk topilmadi',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  localizations?.no_category_properties ??
                      'Bu kategoriyada mulklar mavjud emas',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                if (widget.regionName.isNotEmpty ||
                    widget.districtName.isNotEmpty) ...[
                  SizedBox(height: 16),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.blue[200]!),
                    ),
                    child: Text(
                      '${widget.districtName.isNotEmpty ? widget.districtName : widget.regionName} hududida',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      physics: AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.all(16.0),
      itemCount: _allProperties.length + (_hasMoreData ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < _allProperties.length) {
          final property = _allProperties[index];
          return _buildModernPropertyCard(property);
        }

        if (_hasMoreData) {
          return Container(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: _isLoadingMore
                  ? CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                    )
                  : SizedBox.shrink(),
            ),
          );
        }

        return Container(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              localizations?.all_properties_loaded ?? 'Barcha mulklar yuklandi',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildModernPropertyCard(RealEstate property) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(isDark ? 0.3 : 0.08),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PropertyDetail(
                    propertyId: property.id,
                  )),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    child: property.mainImage.isNotEmpty
                        ? Image.network(
                            property.mainImage,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: theme.colorScheme.surfaceContainerHighest,
                                child: Icon(
                                  Icons.apartment,
                                  size: 48,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              );
                            },
                          )
                        : Container(
                            color: theme.colorScheme.surfaceContainerHighest,
                            child: Icon(
                              Icons.apartment,
                              size: 48,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                  ),
                ),

                // Listing Type Badge
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.primaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      property.listingTypeDisplay,
                      style: TextStyle(
                        color: theme.colorScheme.onPrimary,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                // Views Counter
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.visibility,
                          color: Colors.white,
                          size: 12,
                        ),
                        SizedBox(width: 4),
                        Text(
                          '${property.viewsCount}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Content Section
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    property.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: theme.colorScheme.onSurface,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),

                  // Location
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: Colors.red[400],
                      ),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${property.city}, ${property.district}',
                          style: TextStyle(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),

                  // Property Details
                  Row(
                    children: [
                      _buildDetailItem(Icons.bed, '${property.bedrooms}'),
                      SizedBox(width: 16),
                      _buildDetailItem(Icons.bathroom, '${property.bathrooms}'),
                      SizedBox(width: 16),
                      _buildDetailItem(
                          Icons.square_foot, '${property.squareMeters}m²'),
                    ],
                  ),
                  SizedBox(height: 16),

                  // Price
                  Text(
                    '${property.price} ${property.currency}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: isDark ? theme.colorScheme.primary : const Color(0xFF43A047),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String value) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        SizedBox(width: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
