import 'package:app/pages/real_estate/real_estate_detail.dart';
import 'package:app/pages/real_estate/property_create_page.dart';
import 'package:app/pages/real_estate/real_estate_map_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/providers/provider_models/real_estate.dart';
import 'package:app/providers/provider_models/neighborhood.dart';
import 'package:app/providers/provider_root/active_neighborhood_provider.dart';
import 'package:app/providers/provider_root/radius_provider.dart';
import 'package:app/providers/provider_root/real_estate_provider.dart';
import 'package:app/widgets/fresh_nearest_toggle.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:latlong2/latlong.dart';

class RealEstateMain extends ConsumerStatefulWidget {
  final String regionName;
  final String districtName;
  final int? districtId;

  const RealEstateMain({
    super.key,
    required this.regionName,
    required this.districtName,
    this.districtId,
  });

  @override
  ConsumerState<RealEstateMain> createState() => _RealEstateMainState();
}

enum _BrowseMode { list, map }

class _RealEstateMainState extends ConsumerState<RealEstateMain>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late TabController _tabController;
  List<RealEstate> _allProperties = [];
  int _currentPage = 1;
  bool _isLoadingMore = false;
  bool _hasMoreData = true;
  bool _isInitialLoading = true;
  _BrowseMode _browseMode = _BrowseMode.list;

  String _selectedPropertyType = '';
  String _selectedListingType = '';
  // In-memory only (per-screen) — resets on navigation away, per Plan B Task 3.
  ListingSort _sortMode = ListingSort.fresh;

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
      // Karrot priority: active map pick wins over backend district.
      final activeNbhd = ref.read(activeNeighborhoodProvider);
      final radius = ref.read(radiusProvider);
      final useNeighborhood = activeNbhd != null;
      if (useNeighborhood) {
        print('🏠 [RealEstateMain] GEO filter: ${activeNbhd.neighborhood.displayName} (${activeNbhd.neighborhood.centroidLat}, ${activeNbhd.neighborhood.centroidLng}) r=${radius}km');
      } else if (widget.districtId != null && widget.districtId! > 0) {
        print('🏠 [RealEstateMain] DISTRICT filter: id=${widget.districtId}');
      } else {
        print('🏠 [RealEstateMain] NO filter — loading all properties');
      }
      final rawProperties =
          await ref.read(realEstateServiceProvider).getFilteredProperties(
                currentPage: 1,
                pageSize: 12,
                propertyType: _selectedPropertyType,
                listingType: _selectedListingType,
                regionName: useNeighborhood ? '' : widget.regionName,
                districtName: useNeighborhood ? '' : widget.districtName,
                districtId: useNeighborhood ? null : widget.districtId,
                neighborhoodId: useNeighborhood ? activeNbhd.neighborhood.id : null,
                centerLat: useNeighborhood
                    ? activeNbhd.neighborhood.centroidLat
                    : null,
                centerLng: useNeighborhood
                    ? activeNbhd.neighborhood.centroidLng
                    : null,
                radiusKm: useNeighborhood ? radius : null,
                ordering: (useNeighborhood && _sortMode == ListingSort.nearest)
                    ? 'nearest'
                    : null,
              );

      final serverHasMore = rawProperties.length >= 12;
      final properties = useNeighborhood
          ? rawProperties.where((p) => _matchesNeighbourhood(p, activeNbhd)).toList()
          : rawProperties;

      if (mounted) {
        setState(() {
          _allProperties = properties;
          _currentPage = 1;
          _hasMoreData = serverHasMore;
          _isInitialLoading = false;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _isInitialLoading = false;
        });
      }
    }
  }

  Future<void> _loadMoreProperties() async {
    if (_isLoadingMore || !_hasMoreData) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final nextPage = _currentPage + 1;
      final activeNbhd = ref.read(activeNeighborhoodProvider);
      final radius = ref.read(radiusProvider);
      final useNeighborhood = activeNbhd != null;
      final rawNewProperties =
          await ref.read(realEstateServiceProvider).getFilteredProperties(
                currentPage: nextPage,
                pageSize: 12,
                propertyType: _selectedPropertyType,
                listingType: _selectedListingType,
                regionName: useNeighborhood ? '' : widget.regionName,
                districtName: useNeighborhood ? '' : widget.districtName,
                districtId: useNeighborhood ? null : widget.districtId,
                neighborhoodId: useNeighborhood ? activeNbhd.neighborhood.id : null,
                centerLat: useNeighborhood
                    ? activeNbhd.neighborhood.centroidLat
                    : null,
                centerLng: useNeighborhood
                    ? activeNbhd.neighborhood.centroidLng
                    : null,
                radiusKm: useNeighborhood ? radius : null,
                ordering: (useNeighborhood && _sortMode == ListingSort.nearest)
                    ? 'nearest'
                    : null,
              );

      final serverHasMore = rawNewProperties.length >= 12;
      final newProperties = useNeighborhood
          ? rawNewProperties.where((p) => _matchesNeighbourhood(p, activeNbhd)).toList()
          : rawNewProperties;

      setState(() {
        if (rawNewProperties.isNotEmpty) {
          _allProperties.addAll(newProperties);
          _currentPage = nextPage;
          _hasMoreData = serverHasMore;
        } else {
          _hasMoreData = false;
        }
        _isLoadingMore = false;
      });
    } catch (error) {
      if (mounted) {
        setState(() {
          _isLoadingMore = false;
          _hasMoreData = false;
        });
      }
    }
  }

  bool _matchesNeighbourhood(RealEstate property, VerifiedNeighborhood nbhd) {
    final city = nbhd.neighborhood.city.toLowerCase();
    final region = nbhd.neighborhood.region.toLowerCase();
    final propCity = property.city.toLowerCase();
    final propDistrict = property.district.toLowerCase();
    final propRegion = property.region.toLowerCase();
    // NOTE: property.address is the OSM map-picked address set at listing time
    // (not the registered city), so it must NOT be used for city matching.
    if (propCity.isNotEmpty && (propCity.contains(city) || city.contains(propCity))) return true;
    if (propDistrict.isNotEmpty && (propDistrict.contains(city) || city.contains(propDistrict))) return true;
    if (propCity.isEmpty && propDistrict.isEmpty && propRegion.isNotEmpty &&
        (propRegion.contains(region) || region.contains(propRegion))) return true;
    return false;
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

  void _onSortChanged(ListingSort mode) {
    if (_sortMode == mode) return;
    HapticFeedback.selectionClick();
    setState(() => _sortMode = mode);
    _loadInitialProperties();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context);

    // Listen for refresh trigger from property creation
    ref.listen<int>(realEstateRefreshProvider, (previous, next) {
      if (previous != null && previous != next) {
        _loadInitialProperties();
      }
    });
    ref.listen(activeNeighborhoodProvider, (prev, next) {
      if (prev?.neighborhood.id != next?.neighborhood.id) {
        // A geo center is required for "nearest" — fall back to fresh when
        // it's cleared so the toggle doesn't sit on a disabled option.
        if (next == null && _sortMode == ListingSort.nearest) {
          setState(() => _sortMode = ListingSort.fresh);
        }
        _loadInitialProperties();
      }
    });
    ref.listen<double>(radiusProvider, (prev, next) {
      if (prev != next) _loadInitialProperties();
    });
    final hasGeoCenter = ref.watch(activeNeighborhoodProvider) != null;

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
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 16,
                          color: theme.colorScheme.primary,
                        ),
                        SizedBox(width: 4),
                        Text(
                          widget.districtName.isNotEmpty ? widget.districtName : widget.regionName,
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Spacer(),
                        Text(
                          localizations?.n_properties(_allProperties.length) ?? '${_allProperties.length} properties',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),

                // Browse mode (List | Map) + Sort toggle (Fresh | Nearest)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Row(
                    children: [
                      _RealEstateBrowseModeToggle(
                        mode: _browseMode,
                        onChanged: (m) => setState(() => _browseMode = m),
                      ),
                      const Spacer(),
                      FreshNearestToggle(
                        mode: _sortMode,
                        nearestEnabled: hasGeoCenter,
                        onChanged: _onSortChanged,
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
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelColor: theme.colorScheme.onPrimary,
                    unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
                    labelStyle: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    unselectedLabelStyle: theme.textTheme.labelMedium?.copyWith(
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
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.colorScheme.onPrimary,
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
    final theme = Theme.of(context);
    if (_isInitialLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: theme.colorScheme.primary,
            ),
            SizedBox(height: 16),
            Text(
              localizations?.properties_loading ?? 'Loading properties...',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
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
                    color: theme.colorScheme.surfaceContainerHighest,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.apartment,
                    size: 48,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  localizations?.no_properties_found ??
                      'No properties found',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  localizations?.no_category_properties ??
                      'No properties in this category',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                if (widget.regionName.isNotEmpty ||
                    widget.districtName.isNotEmpty) ...[
                  SizedBox(height: 16),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: theme.colorScheme.primary.withOpacity(0.3)),
                    ),
                    child: Text(
                      '${widget.districtName.isNotEmpty ? widget.districtName : widget.regionName} ${localizations?.in_area ?? 'in area'}',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.primary,
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

    if (_browseMode == _BrowseMode.map) {
      return _buildPropertiesMap();
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
                      color: theme.colorScheme.primary,
                    )
                  : SizedBox.shrink(),
            ),
          );
        }

        return Container(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              localizations?.all_properties_loaded ?? 'All properties loaded',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        );
      },
    );
  }

  /// Karrot-style map browse (Plan B Task 4). Initial camera priority:
  /// active neighborhood center (zoom ~13) → first loaded property's
  /// coordinates → a country-level default (Tashkent, matching the
  /// default used by [ItemsMapView] elsewhere in the app).
  Widget _buildPropertiesMap() {
    final active = ref.read(activeNeighborhoodProvider);

    LatLng center;
    double zoom;
    if (active != null) {
      center = LatLng(
          active.neighborhood.centroidLat, active.neighborhood.centroidLng);
      zoom = 13.0;
    } else {
      final withCoords = _allProperties.where((p) {
        final lat = double.tryParse(p.latitude);
        final lng = double.tryParse(p.longitude);
        return lat != null && lng != null && lat != 0 && lng != 0;
      });
      if (withCoords.isNotEmpty) {
        final first = withCoords.first;
        center =
            LatLng(double.parse(first.latitude), double.parse(first.longitude));
        zoom = 13.0;
      } else {
        // Country-level default.
        center = const LatLng(41.3, 69.24);
        zoom = 6.0;
      }
    }

    return RealEstateMapView(
      key: ValueKey('re_map_${active?.neighborhood.id ?? 'default'}'),
      initialCenter: center,
      initialZoom: zoom,
      propertyType:
          _selectedPropertyType.isNotEmpty ? _selectedPropertyType : null,
      listingType:
          _selectedListingType.isNotEmpty ? _selectedListingType : null,
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
        onTap: () {
          debugPrint('[RealEstateMain] Tapped property: id=${property.id}, title=${property.title}');
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PropertyDetail(
                      propertyId: property.id,
                    )),
          );
        },
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
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      property.listingTypeDisplay,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.white,
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
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: Colors.white,
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
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
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
                        color: theme.colorScheme.error,
                      ),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${property.city}, ${property.district}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (property.distanceKm != null)
                        _buildDistanceChip(property.distanceKm!),
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
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
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

  /// Small "📍 {km} km" chip shown on property cards when distance is known.
  Widget _buildDistanceChip(double distanceKm) {
    final theme = Theme.of(context);
    final label = AppLocalizations.of(context)
            ?.distanceKm(distanceKm.toStringAsFixed(1)) ??
        '${distanceKm.toStringAsFixed(1)} km';
    return Container(
      margin: const EdgeInsets.only(left: 6),
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 3.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.location_on_rounded,
            color: theme.colorScheme.primary,
            size: 12.0,
          ),
          const SizedBox(width: 3.0),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.0,
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
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
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

/// List/Map browse toggle — mirrors `_ProductBrowseModeToggle` (products)
/// and `_BrowseModeToggle` (services) so all three verticals share the same
/// icons/position/behavior (Plan B Task 4).
class _RealEstateBrowseModeToggle extends StatelessWidget {
  const _RealEstateBrowseModeToggle(
      {required this.mode, required this.onChanged});

  final _BrowseMode mode;
  final ValueChanged<_BrowseMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    Widget btn(IconData icon, _BrowseMode m) {
      final active = mode == m;
      return InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => onChanged(m),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: active ? colorScheme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon,
              size: 18,
              color: active ? colorScheme.onPrimary : colorScheme.primary),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          btn(Icons.list, _BrowseMode.list),
          btn(Icons.map_outlined, _BrowseMode.map),
        ],
      ),
    );
  }
}
