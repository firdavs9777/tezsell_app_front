import 'package:app/pages/service/new/service_new.dart';
import 'package:app/pages/service/main/services_list.dart';
import 'package:app/providers/provider_models/category_model.dart';
import 'package:app/providers/provider_models/service_model.dart';
import 'package:app/providers/provider_root/active_neighborhood_provider.dart';
import 'package:app/providers/provider_root/profile_provider.dart';
import 'package:app/providers/provider_root/radius_provider.dart';
import 'package:app/providers/provider_root/service_provider.dart';
import 'package:app/providers/provider_root/verified_neighborhoods_provider.dart';
import 'package:app/widgets/maps/items_map_view.dart';
import 'package:app/widgets/maps/radius_slider.dart';
import 'package:app/widgets/skeleton_loader.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:app/l10n/app_localizations.dart';

class ServiceMain extends ConsumerStatefulWidget {
  final String regionName;
  final String districtName;
  final int? districtId;

  const ServiceMain({
    super.key,
    required this.regionName,
    required this.districtName,
    this.districtId,
  });

  @override
  _ServiceMainState createState() => _ServiceMainState();
}

enum _BrowseMode { list, map }

class _ServiceMainState extends ConsumerState<ServiceMain> {
  final ScrollController _scrollController = ScrollController();
  List<Services> _allServices = [];
  List<CategoryModel> _categories = [];
  String? _selectedCategory;
  int _currentPage = 1;
  bool _isLoadingMore = false;
  bool _hasMoreData = true;
  bool _isInitialLoading = true;
  bool _isDisposed = false;
  bool _isCategoriesLoading = true;
  _BrowseMode _browseMode = _BrowseMode.list;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadCategories();
    _loadInitialServices();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadCategories() async {
    if (!mounted || _isDisposed) return;

    setState(() => _isCategoriesLoading = true);
    try {
      final categories = await ref.read(serviceMainProvider).getCategories();
      if (mounted && !_isDisposed) {
        setState(() {
          _categories = categories;
          _isCategoriesLoading = false;
        });
      }
    } catch (e) {
      if (mounted && !_isDisposed) {
        setState(() => _isCategoriesLoading = false);
      }
    }
  }

  String _getCategoryName(CategoryModel category) {
    final locale = Localizations.localeOf(context).languageCode;
    switch (locale) {
      case 'uz':
        return category.nameUz;
      case 'ru':
        return category.nameRu;
      case 'en':
      default:
        return category.nameEn;
    }
  }

  void _onCategorySelected(String? categoryName) {
    HapticFeedback.selectionClick();
    setState(() {
      _selectedCategory = categoryName;
    });

    if (categoryName != null) {
      // Navigate to filtered services
      final encodedCategory = Uri.encodeComponent(categoryName);
      final encodedRegion = Uri.encodeComponent(widget.regionName);
      final encodedDistrict = Uri.encodeComponent(widget.districtName);
      final districtIdParam = widget.districtId != null ? '&districtId=${widget.districtId}' : '';
      context.push('/services?category=$encodedCategory&region=$encodedRegion&district=$encodedDistrict$districtIdParam');
      // Reset selection after navigation
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          setState(() => _selectedCategory = null);
        }
      });
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // Load more when user is 200 pixels from bottom
      if (!_isLoadingMore && _hasMoreData) {
        _loadMoreServices();
      }
    }
  }

  Future<void> _loadInitialServices() async {
    if (!mounted || _isDisposed) return;

    setState(() {
      _isInitialLoading = true;
      _currentPage = 1;
      _allServices.clear();
      _hasMoreData = true;
    });

    try {
      // Karrot priority: an active verified-neighborhood (set by the map
      // location filter) wins over the backend-synced district from TabBar.
      final activeNbhd = ref.read(activeNeighborhoodProvider);
      final radius = ref.read(radiusProvider);
      final useNeighborhood = activeNbhd != null;
      if (useNeighborhood) {
        print('🔧 [ServiceMain] GEO filter: ${activeNbhd.neighborhood.displayName} (${activeNbhd.neighborhood.centroidLat}, ${activeNbhd.neighborhood.centroidLng}) r=${radius}km');
      } else if (widget.districtId != null && widget.districtId! > 0) {
        print('🔧 [ServiceMain] DISTRICT filter: ${widget.districtId}');
      } else {
        print('🔧 [ServiceMain] NO filter — loading all services');
      }
      final services = await ref.read(serviceMainProvider).getFilteredServices(
            currentPage: 1,
            pageSize: 12,
            regionName: useNeighborhood ? '' : widget.regionName,
            districtName: useNeighborhood ? '' : widget.districtName,
            districtId: useNeighborhood ? null : widget.districtId,
            neighborhoodId:
                useNeighborhood ? activeNbhd.neighborhood.id : null,
            radiusKm: useNeighborhood ? radius : null,
            centerLat:
                useNeighborhood ? activeNbhd.neighborhood.centroidLat : null,
            centerLng:
                useNeighborhood ? activeNbhd.neighborhood.centroidLng : null,
          );

      if (mounted && !_isDisposed) {
        setState(() {
          _allServices = services;
          _currentPage = 1;
          _hasMoreData =
              services.length >= 12; // If less than pageSize, no more data
          _isInitialLoading = false;
        });
      }
    } catch (error) {
      if (mounted && !_isDisposed) {
        setState(() {
          _isInitialLoading = false;
        });
      }
    }
  }

  Future<void> _loadMoreServices() async {
    if (_isLoadingMore || !_hasMoreData || !mounted || _isDisposed) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final nextPage = _currentPage + 1;
      final activeNbhd = ref.read(activeNeighborhoodProvider);
      final radius = ref.read(radiusProvider);
      final useNeighborhood = activeNbhd != null;
      final newServices =
          await ref.read(serviceMainProvider).getFilteredServices(
                currentPage: nextPage,
                pageSize: 12,
                regionName: useNeighborhood ? '' : widget.regionName,
                districtName: useNeighborhood ? '' : widget.districtName,
                districtId: useNeighborhood ? null : widget.districtId,
                neighborhoodId:
                    useNeighborhood ? activeNbhd.neighborhood.id : null,
                radiusKm: useNeighborhood ? radius : null,
              );

      if (mounted && !_isDisposed) {
        setState(() {
          if (newServices.isNotEmpty) {
            _allServices.addAll(newServices);
            _currentPage = nextPage;
            _hasMoreData = newServices.length >= 12;
          } else {
            _hasMoreData = false;
          }
          _isLoadingMore = false;
        });
      }
    } catch (error) {
      if (mounted && !_isDisposed) {
        setState(() {
          _isLoadingMore = false;
          _hasMoreData = false;
        });
      }
    }
  }

  Future<void> refresh() async {
    await Future.wait([
      _loadInitialServices(),
      _loadCategories(),
    ]);
  }

  @override
  void didUpdateWidget(ServiceMain oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reload services if location changed
    if (oldWidget.regionName != widget.regionName ||
        oldWidget.districtName != widget.districtName) {
      _loadInitialServices();
    }
  }

  Future<void> _navigateToLocationChange() async {
    await context.push<bool>('/change-city');
    ref.invalidate(servicesProvider);
    ref.invalidate(profileServiceProvider);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final localizations = AppLocalizations.of(context);

    // Listen for refresh trigger from service creation
    ref.listen<int>(servicesRefreshProvider, (previous, next) {
      if (previous != null && previous != next) {
        _loadInitialServices();
      }
    });
    // Phase-1: reload when verified-neighborhood or radius changes
    ref.listen(activeNeighborhoodProvider, (prev, next) {
      if (prev?.neighborhood.id != next?.neighborhood.id) {
        _loadInitialServices();
      }
    });
    ref.listen<double>(radiusProvider, (prev, next) {
      if (prev != next) _loadInitialServices();
    });

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          // Enhanced Header
          Container(
            padding: const EdgeInsets.only(
              left: 12.0,
              right: 12.0,
              top: 8.0,
              bottom: 8.0,
            ),
            decoration: BoxDecoration(
              color: theme.cardColor,
              boxShadow: [
                BoxShadow(
                  color: theme.shadowColor.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Row(
                    children: [
                      // Category Filter Button
                      Material(
                        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(12),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            context.push('/service/categories?region=${widget.regionName}&district=${widget.districtName}');
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10.0),
                            child: Icon(
                              Icons.category_rounded,
                              size: 22,
                              color: colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _BrowseModeToggle(
                        mode: _browseMode,
                        onChanged: (m) => setState(() => _browseMode = m),
                      ),
                      const SizedBox(width: 8),
                      // Location Badge
                      if (widget.regionName.isNotEmpty ||
                          widget.districtName.isNotEmpty)
                        Expanded(
                          child: Material(
                            color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(12),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: _navigateToLocationChange,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.location_on_rounded,
                                      size: 16,
                                      color: colorScheme.primary,
                                    ),
                                    const SizedBox(width: 6),
                                    Flexible(
                                      child: Text(
                                        widget.districtName.isNotEmpty
                                            ? widget.districtName
                                            : widget.regionName,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: colorScheme.primary,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Icon(
                                      Icons.arrow_drop_down_rounded,
                                      size: 18,
                                      color: colorScheme.primary,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Quick Category Chips
                  _buildCategoryChips(colorScheme),
                ],
              ),
            ),
          ),
          Consumer(
            builder: (context, ref, _) {
              final active = ref.watch(activeNeighborhoodProvider);
              final verified = ref.watch(verifiedNeighborhoodsProvider);
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                color: theme.cardColor,
                child: Row(
                  children: [
                    if (active != null)
                      InputChip(
                        avatar: const Icon(Icons.place, size: 16),
                        label: Text(active.neighborhood.name),
                        onPressed: verified.length > 1
                            ? () {
                                final cur = ref.read(
                                    activeNeighborhoodIndexProvider);
                                ref
                                    .read(activeNeighborhoodIndexProvider
                                        .notifier)
                                    .state = cur == 0 ? 1 : 0;
                              }
                            : null,
                      ),
                    const SizedBox(width: 4),
                    const Expanded(child: RadiusSlider()),
                  ],
                ),
              );
            },
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: refresh,
              color: colorScheme.primary,
              child: _buildServicesList(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (ctx) => const ServiceNew(),
          ));
        },
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 4,
        icon: const Icon(Icons.add_rounded, size: 24),
        label: Text(
          localizations?.upload ?? 'Yuklash',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildCategoryChips(ColorScheme colorScheme) {
    // Map category keys/icons to IconData - matching API values
    IconData _getCategoryIcon(CategoryModel category) {
      // First try to match by icon field
      final iconValue = category.icon.toLowerCase();
      // Then try to match by key field
      final keyValue = category.key.toLowerCase();
      // Also check name for keywords
      final nameValue = category.nameEn.toLowerCase();

      // Combined lookup using icon, key, and name
      final searchTerms = [iconValue, keyValue, nameValue];

      for (final term in searchTerms) {
        if (term.contains('plumb') || term.contains('santexnik')) return Icons.plumbing;
        if (term.contains('electric') || term.contains('elektr')) return Icons.electrical_services;
        if (term.contains('clean') || term.contains('tozala')) return Icons.cleaning_services;
        if (term.contains('repair') || term.contains('ta\'mir') || term.contains('remont')) return Icons.build;
        if (term.contains('tutor') || term.contains('repetitor') || term.contains('o\'qituvchi') || term.contains('teach')) return Icons.school;
        if (term.contains('beauty') || term.contains('go\'zal') || term.contains('salon')) return Icons.face;
        if (term.contains('fitness') || term.contains('sport') || term.contains('gym')) return Icons.fitness_center;
        if (term.contains('transport') || term.contains('yuk') || term.contains('delivery') || term.contains('yetkazib')) return Icons.local_shipping;
        if (term.contains('cook') || term.contains('oshpaz') || term.contains('restaurant') || term.contains('food')) return Icons.restaurant;
        if (term.contains('tech') || term.contains('computer') || term.contains('kompyuter') || term.contains('it')) return Icons.computer;
        if (term.contains('garden') || term.contains('bog\'') || term.contains('landscape')) return Icons.grass;
        if (term.contains('paint') || term.contains('bo\'yoq')) return Icons.format_paint;
        if (term.contains('photo') || term.contains('video') || term.contains('surat')) return Icons.camera_alt;
        if (term.contains('music') || term.contains('musiqa')) return Icons.music_note;
        if (term.contains('health') || term.contains('sog\'liq') || term.contains('medical') || term.contains('tibbiy')) return Icons.health_and_safety;
        if (term.contains('legal') || term.contains('huquq') || term.contains('lawyer') || term.contains('advokat')) return Icons.gavel;
        if (term.contains('pet') || term.contains('hayvon')) return Icons.pets;
        if (term.contains('event') || term.contains('tadbir') || term.contains('wedding') || term.contains('to\'y')) return Icons.celebration;
        if (term.contains('home') || term.contains('uy') || term.contains('house')) return Icons.home_repair_service;
        if (term.contains('car') || term.contains('avto') || term.contains('auto') || term.contains('mashina')) return Icons.car_repair;
        if (term.contains('ac') || term.contains('konditsioner') || term.contains('hvac')) return Icons.ac_unit;
        if (term.contains('security') || term.contains('xavfsizlik') || term.contains('guard')) return Icons.security;
        if (term.contains('design') || term.contains('dizayn')) return Icons.design_services;
        if (term.contains('move') || term.contains('ko\'chish') || term.contains('relocation')) return Icons.local_shipping;
      }

      return Icons.miscellaneous_services;
    }

    if (_isCategoriesLoading) {
      return const CategoryChipsSkeleton(itemCount: 5);
    }

    if (_categories.isEmpty) {
      return const SizedBox.shrink();
    }

    // Show first 8 categories as quick chips
    final displayCategories = _categories.take(8).toList();

    return SizedBox(
      height: 36,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: displayCategories.length + 1, // +1 for "More" chip
        itemBuilder: (context, index) {
          if (index == displayCategories.length) {
            // "More" chip at the end
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ActionChip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.more_horiz,
                      size: 16,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      AppLocalizations.of(context)?.more_categories ?? 'More',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                backgroundColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                side: BorderSide.none,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                onPressed: () {
                  HapticFeedback.selectionClick();
                  context.push('/service/categories?region=${widget.regionName}&district=${widget.districtName}');
                },
              ),
            );
          }

          final category = displayCategories[index];
          final isSelected = _selectedCategory == category.nameUz;
          final iconData = _getCategoryIcon(category);

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ActionChip(
              avatar: Icon(
                iconData,
                size: 16,
                color: isSelected ? colorScheme.onPrimary : colorScheme.primary,
              ),
              label: Text(
                _getCategoryName(category),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
                ),
              ),
              backgroundColor: isSelected
                  ? colorScheme.primary
                  : colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              side: BorderSide.none,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              onPressed: () => _onCategorySelected(category.nameUz),
            ),
          );
        },
      ),
    );
  }

  Widget _buildServicesList() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final localizations = AppLocalizations.of(context);

    if (_isInitialLoading) {
      return const ServiceListSkeleton(itemCount: 5);
    }

    if (_allServices.isEmpty) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.design_services_outlined,
                      size: 64,
                      color: colorScheme.onSurface.withValues(alpha: 0.4),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    localizations?.serviceError ?? 'No services available.',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  if (widget.regionName.isNotEmpty ||
                      widget.districtName.isNotEmpty)
                    Text(
                      localizations?.no_services_in_location(
                        widget.districtName.isNotEmpty ? widget.districtName : widget.regionName,
                      ) ?? 'No services found in ${widget.districtName.isNotEmpty ? widget.districtName : widget.regionName}',
                      style: TextStyle(
                        fontSize: 14,
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                      textAlign: TextAlign.center,
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    if (_browseMode == _BrowseMode.map) {
      return _buildServicesMap();
    }

    return ListView.builder(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: _allServices.length + (_hasMoreData ? 1 : 0),
      itemBuilder: (context, index) {
        // Show services
        if (index < _allServices.length) {
          final service = _allServices[index];
          return ServiceList(
            key: ValueKey('service_${service.id}'),
            service: service,
            refresh: refresh,
          );
        }

        // Show loading indicator at the bottom
        if (_hasMoreData) {
          return _isLoadingMore
              ? const ServiceSkeletonItem()
              : const SizedBox.shrink();
        }

        // Show "end of list" indicator
        return Container(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: Text(
              localizations?.no_more_services ?? 'No more services to load',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildServicesMap() {
    final theme = Theme.of(context);

    final mapped = <MappedItem>[];
    for (final s in _allServices) {
      if (s.latitude == null || s.longitude == null) continue;
      mapped.add(MappedItem(
        id: s.id.toString(),
        lat: s.latitude!,
        lng: s.longitude!,
        title: s.name,
        subtitle: s.userName.location.region,
        imageUrl: s.images.isNotEmpty ? s.images.first.image : null,
        onTap: () => context.push('/service/${s.id}'),
      ));
    }

    if (mapped.isEmpty) {
      final localizations = AppLocalizations.of(context);
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            localizations?.browse_no_items_with_location ??
                'No items with location data in this area yet.',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
          ),
        ),
      );
    }

    final active = ref.read(activeNeighborhoodProvider);
    final center = active != null
        ? LatLng(active.neighborhood.centroidLat,
            active.neighborhood.centroidLng)
        : LatLng(mapped.first.lat, mapped.first.lng);

    return ItemsMapView(items: mapped, initialCenter: center);
  }
}

class _BrowseModeToggle extends StatelessWidget {
  const _BrowseModeToggle({required this.mode, required this.onChanged});

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
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
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
