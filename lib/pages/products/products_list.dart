import 'package:app/pages/products/main_products.dart';
import 'package:app/pages/products/product_new.dart';
import 'package:app/providers/provider_models/product_model.dart';
import 'package:app/providers/provider_models/category_model.dart';
import 'package:app/providers/provider_models/neighborhood.dart';
import 'package:app/providers/provider_root/active_neighborhood_provider.dart';
import 'package:app/providers/provider_root/product_provider.dart';
import 'package:app/providers/provider_root/profile_provider.dart';
import 'package:app/providers/provider_root/radius_provider.dart';
import 'package:app/providers/provider_root/verified_neighborhoods_provider.dart';
import 'package:app/pages/products/widgets/product_filter_sheet.dart';
import 'package:app/widgets/maps/items_map_view.dart';
import 'package:app/widgets/maps/radius_slider.dart';
import 'package:app/widgets/skeleton_loader.dart';
import 'package:latlong2/latlong.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/l10n/app_localizations.dart';

class ProductsList extends ConsumerStatefulWidget {
  final String regionName;
  final String districtName;
  final int? districtId;  // Added for locale-independent filtering

  const ProductsList({
    super.key,
    required this.regionName,
    required this.districtName,
    this.districtId,
  });

  @override
  ConsumerState<ProductsList> createState() => _ProductsListState();
}

enum _BrowseMode { list, map }

/// Plan D Task 4 — full sort selector for the products list. Distinct from
/// the shared `ListingSort` (`fresh`/`nearest`) used by services/real-estate
/// so those pages are unaffected by the extra price/popularity options.
enum ProductSort { fresh, nearest, priceAsc, priceDesc, popular }

class _ProductsListState extends ConsumerState<ProductsList> {
  final ScrollController _scrollController = ScrollController();
  List<Products> _allProducts = [];
  List<CategoryModel> _categories = [];
  String? _selectedCategory;
  int _currentPage = 1;
  bool _isLoadingMore = false;
  bool _hasMoreData = true;
  bool _isInitialLoading = true;
  bool _isDisposed = false;
  bool _isCategoriesLoading = true;
  int _loadGeneration = 0; // Prevents stale requests from overwriting newer ones
  _BrowseMode _browseMode = _BrowseMode.list;
  // In-memory only (per-screen) — resets on navigation away, per Plan B Task 3.
  ProductSort _sortMode = ProductSort.fresh;
  // In-memory only (per-screen), Plan D Task 4 — price range + condition.
  ProductFilter _filter = ProductFilter.empty;

  @override
  void initState() {
    super.initState();
    print('📦 ProductsList: initState called, loading initial products...');
    _scrollController.addListener(_onScroll);
    _loadCategories();
    _loadInitialProducts();
  }

  Future<void> _loadCategories() async {
    if (!mounted || _isDisposed) return;

    setState(() => _isCategoriesLoading = true);
    try {
      final categories = await ref.read(productsServiceProvider).getCategories();
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
      // Navigate to filtered products
      final encodedCategory = Uri.encodeComponent(categoryName);
      final encodedRegion = Uri.encodeComponent(widget.regionName);
      final encodedDistrict = Uri.encodeComponent(widget.districtName);
      final districtIdParam = widget.districtId != null ? '&districtId=${widget.districtId}' : '';
      context.push('/products?category=$encodedCategory&region=$encodedRegion&district=$encodedDistrict$districtIdParam');
      // Reset selection after navigation
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          setState(() => _selectedCategory = null);
        }
      });
    }
  }

  void _onSortChanged(ProductSort mode) {
    if (_sortMode == mode) return;
    // Nearest requires an active geo center; ignore taps on a disabled item.
    if (mode == ProductSort.nearest &&
        ref.read(activeNeighborhoodProvider) == null) {
      return;
    }
    HapticFeedback.selectionClick();
    setState(() => _sortMode = mode);
    _loadInitialProducts();
  }

  /// Maps [_sortMode] to the backend's `sort` query param
  /// (fresh|price_asc|price_desc|popular|nearest). `fresh` omits the param
  /// entirely (backend default), matching Plan B's existing convention.
  String? _sortQueryParam(bool useNeighborhood) {
    switch (_sortMode) {
      case ProductSort.nearest:
        return useNeighborhood ? 'nearest' : null;
      case ProductSort.priceAsc:
        return 'price_asc';
      case ProductSort.priceDesc:
        return 'price_desc';
      case ProductSort.popular:
        return 'popular';
      case ProductSort.fresh:
        return null;
    }
  }

  void _updateFilter(ProductFilter next) {
    if (_filter == next) return;
    HapticFeedback.selectionClick();
    setState(() => _filter = next);
    _loadInitialProducts();
  }

  Future<void> _openFilterSheet() async {
    final result = await showModalBottomSheet<ProductFilter>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => ProductFilterSheet(initialFilter: _filter),
    );
    if (result != null) _updateFilter(result);
  }

  @override
  void dispose() {
    _isDisposed = true;
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // Load more when user is 200 pixels from bottom
      if (!_isLoadingMore && _hasMoreData) {
        _loadMoreProducts();
      }
    }
  }

  Future<void> _loadInitialProducts() async {
    if (!mounted || _isDisposed) return;

    // Increment generation so any in-flight older request is ignored
    final thisGeneration = ++_loadGeneration;

    setState(() {
      _isInitialLoading = true;
      _currentPage = 1;
      _allProducts.clear();
      _hasMoreData = true;
    });

    try {
      // Karrot priority: an active verified-neighborhood (set by the map
      // location filter) ALWAYS wins over the backend-synced district that
      // TabBar passes via widget.regionName/districtId. This way a fresh
      // map pick takes effect immediately even though the user's profile
      // location in the DB still says Andijon (or wherever).
      final activeNbhd = ref.read(activeNeighborhoodProvider);
      final radius = ref.read(radiusProvider);
      final useNeighborhood = activeNbhd != null;
      print('📦 [ProductsList] ═══════════════════════════════════════');
      print('📦 [ProductsList] Loading products... (gen=$thisGeneration)');
      if (useNeighborhood) {
        final radiusLabel = radius.isFinite ? '${radius}km' : 'city-wide';
        print('📦 [ProductsList]   GEO filter: ${activeNbhd.neighborhood.displayName} (${activeNbhd.neighborhood.centroidLat}, ${activeNbhd.neighborhood.centroidLng}) r=$radiusLabel');
      } else if (widget.districtId != null && widget.districtId! > 0) {
        print('📦 [ProductsList]   DISTRICT filter: id=${widget.districtId}');
      } else {
        print('📦 [ProductsList]   NO filter — loading all products');
      }
      print('📦 [ProductsList] ═══════════════════════════════════════');
      final rawProducts =
          await ref.read(productsServiceProvider).getFilteredProducts(
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
                sort: _sortQueryParam(useNeighborhood),
                priceMin: _filter.priceMin,
                priceMax: _filter.priceMax,
                condition: _filter.condition,
              );

      // Ignore if a newer load was triggered while this was in-flight
      if (thisGeneration != _loadGeneration) {
        print('📦 [ProductsList] Stale response ignored (gen=$thisGeneration, current=$_loadGeneration)');
        return;
      }

      // Client-side guard: backend neighbourhood filter may return products
      // from other cities. Keep only products whose location matches the
      // active neighbourhood's city. Pagination uses the raw server count so
      // we keep loading pages even when some are filtered out.
      final serverHasMore = rawProducts.length >= 12;
      final products = useNeighborhood
          ? rawProducts.where((p) => _matchesNeighbourhood(p, activeNbhd)).toList()
          : rawProducts;

      print('📦 [ProductsList] After city-guard: ${products.length}/${rawProducts.length} products');

      if (mounted && !_isDisposed) {
        setState(() {
          _allProducts = products;
          _currentPage = 1;
          _hasMoreData = serverHasMore;
          _isInitialLoading = false;
        });
      }
    } catch (error) {
      if (thisGeneration != _loadGeneration) return;
      if (mounted && !_isDisposed) {
        setState(() {
          _isInitialLoading = false;
        });
      }
    }
  }

  Future<void> _loadMoreProducts() async {
    if (_isLoadingMore || !_hasMoreData || !mounted || _isDisposed) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final nextPage = _currentPage + 1;
      final activeNbhd = ref.read(activeNeighborhoodProvider);
      final radius = ref.read(radiusProvider);
      final useNeighborhood = activeNbhd != null;
      final rawNewProducts =
          await ref.read(productsServiceProvider).getFilteredProducts(
                currentPage: nextPage,
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
                sort: _sortQueryParam(useNeighborhood),
                priceMin: _filter.priceMin,
                priceMax: _filter.priceMax,
                condition: _filter.condition,
              );

      final serverHasMore = rawNewProducts.length >= 12;
      final newProducts = useNeighborhood
          ? rawNewProducts.where((p) => _matchesNeighbourhood(p, activeNbhd)).toList()
          : rawNewProducts;

      if (mounted && !_isDisposed) {
        setState(() {
          if (rawNewProducts.isNotEmpty) {
            _allProducts.addAll(newProducts);
            _currentPage = nextPage;
            _hasMoreData = serverHasMore;
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
          _hasMoreData = false; // Stop retrying on error (e.g. 404 = no more pages)
        });
      }
    }
  }

  /// Returns true when a product's location is within the active neighbourhood's
  /// city. Checked client-side because the backend neighbourhood_id filter may
  /// return products from other cities when the backend hasn't fully implemented
  /// the parameter.
  bool _matchesNeighbourhood(Products product, VerifiedNeighborhood nbhd) {
    final city = nbhd.neighborhood.city.toLowerCase();
    final region = nbhd.neighborhood.region.toLowerCase();
    final dist = product.location.district.toLowerCase();
    final reg = product.location.region.toLowerCase();
    final addr = (product.location.fullAddress ?? '').toLowerCase();
    // Match city → district, city in full address, or region as fallback
    if (dist.isNotEmpty && (dist.contains(city) || city.contains(dist))) return true;
    if (addr.contains(city)) return true;
    if (dist.isEmpty && reg.isNotEmpty && (reg.contains(region) || region.contains(reg))) return true;
    return false;
  }

  Future<void> refresh() async {
    await Future.wait([
      _loadInitialProducts(),
      _loadCategories(),
    ]);
  }

  Future<void> _navigateToLocationChange() async {
    await context.push<bool>('/change-city');
    ref.invalidate(productsServiceProvider);
    ref.invalidate(profileServiceProvider);
  }

  @override
  void didUpdateWidget(ProductsList oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reload products if location changed
    if (oldWidget.regionName != widget.regionName ||
        oldWidget.districtName != widget.districtName ||
        oldWidget.districtId != widget.districtId) {
      _loadInitialProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final localizations = AppLocalizations.of(context);

    // Listen for refresh trigger from product creation
    ref.listen<int>(productsRefreshProvider, (previous, next) {
      if (previous != null && previous != next) {
        print('🔄 ProductsList: Refresh triggered! $previous -> $next, reloading products...');
        _loadInitialProducts();
      }
    });
    // Phase-1: reload when verified-neighborhood or radius changes
    ref.listen(activeNeighborhoodProvider, (prev, next) {
      if (prev?.neighborhood.id != next?.neighborhood.id) {
        // A geo center is required for "nearest" — fall back to fresh when
        // it's cleared so the toggle doesn't sit on a disabled option.
        if (next == null && _sortMode == ProductSort.nearest) {
          setState(() => _sortMode = ProductSort.fresh);
        }
        _loadInitialProducts();
      }
    });
    ref.listen<double>(radiusProvider, (prev, next) {
      if (prev != next) _loadInitialProducts();
    });
    final hasGeoCenter = ref.watch(activeNeighborhoodProvider) != null;

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
                  color: theme.shadowColor.withOpacity(0.05),
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
                        color: colorScheme.surfaceVariant.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            context.push('/product/categories?region=${widget.regionName}&district=${widget.districtName}${widget.districtId != null ? '&districtId=${widget.districtId}' : ''}');
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
                      _ProductBrowseModeToggle(
                        mode: _browseMode,
                        onChanged: (m) =>
                            setState(() => _browseMode = m),
                      ),
                      const SizedBox(width: 8),
                      _ProductSortButton(
                        mode: _sortMode,
                        nearestEnabled: hasGeoCenter,
                        onChanged: _onSortChanged,
                      ),
                      const SizedBox(width: 8),
                      Material(
                        color: colorScheme.surfaceVariant.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: _openFilterSheet,
                          child: Container(
                            padding: const EdgeInsets.all(10.0),
                            child: Badge(
                              isLabelVisible: _filter.isActive,
                              label: Text('${_filter.activeCount}'),
                              backgroundColor: colorScheme.primary,
                              child: Icon(
                                Icons.tune_rounded,
                                size: 22,
                                color: colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Location Badge
                      if (widget.regionName.isNotEmpty ||
                          widget.districtName.isNotEmpty)
                        Expanded(
                          child: Material(
                            color: colorScheme.primaryContainer.withOpacity(0.3),
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
                  if (_filter.isActive) _buildAppliedFiltersRow(colorScheme),
                ],
              ),
            ),
          ),
          // Carrot-style neighborhood pill + radius slider (phase 1)
          Consumer(
            builder: (context, ref, _) {
              final active = ref.watch(activeNeighborhoodProvider);
              final verified = ref.watch(verifiedNeighborhoodsProvider);
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
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
              child: _buildProductsList(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (ctx) => const ProductNew(),
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
    final Map<String, IconData> iconMap = {
      'phone_android': Icons.phone_android,
      'directions_car': Icons.directions_car,
      'home': Icons.home,
      'checkroom': Icons.checkroom,
      'kitchen': Icons.kitchen,
      'laptop_mac': Icons.laptop_mac,
      'weekend': Icons.weekend,
      'build': Icons.build,
      'sports_baseball': Icons.sports_baseball,
      'pets': Icons.pets,
    };

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
        itemCount: displayCategories.length + 1, // +1 for "All" chip
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
                backgroundColor: colorScheme.surfaceVariant.withOpacity(0.5),
                side: BorderSide.none,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                onPressed: () {
                  HapticFeedback.selectionClick();
                  context.push('/product/categories?region=${widget.regionName}&district=${widget.districtName}${widget.districtId != null ? '&districtId=${widget.districtId}' : ''}');
                },
              ),
            );
          }

          final category = displayCategories[index];
          final isSelected = _selectedCategory == category.nameUz;
          final IconData? iconData = iconMap[category.icon];

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ActionChip(
              avatar: Icon(
                iconData ?? Icons.category_rounded,
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
                  : colorScheme.surfaceVariant.withOpacity(0.5),
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

  /// Plan D Task 4 — row of dismissible chips for the currently active
  /// price/condition filters, each clearable individually, plus a trailing
  /// "clear all" chip.
  Widget _buildAppliedFiltersRow(ColorScheme colorScheme) {
    final localizations = AppLocalizations.of(context);
    final chips = <Widget>[];

    if (_filter.priceMin != null) {
      chips.add(_filterChip(
        colorScheme,
        label:
            '${localizations?.productFilterPriceMin ?? 'Min'}: ${_filter.priceMin!.toStringAsFixed(0)}',
        onDeleted: () =>
            _updateFilter(_filter.copyWith(clearPriceMin: true)),
      ));
    }
    if (_filter.priceMax != null) {
      chips.add(_filterChip(
        colorScheme,
        label:
            '${localizations?.productFilterPriceMax ?? 'Max'}: ${_filter.priceMax!.toStringAsFixed(0)}',
        onDeleted: () =>
            _updateFilter(_filter.copyWith(clearPriceMax: true)),
      ));
    }
    if (_filter.condition != null && _filter.condition!.isNotEmpty) {
      chips.add(_filterChip(
        colorScheme,
        label: productConditionLabel(localizations, _filter.condition!),
        onDeleted: () =>
            _updateFilter(_filter.copyWith(clearCondition: true)),
      ));
    }

    if (chips.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: SizedBox(
        height: 32,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            for (final chip in chips)
              Padding(padding: const EdgeInsets.only(right: 6), child: chip),
            ActionChip(
              label: Text(localizations?.productFilterReset ?? 'Reset'),
              onPressed: () => _updateFilter(ProductFilter.empty),
              backgroundColor: colorScheme.errorContainer.withOpacity(0.3),
              side: BorderSide.none,
              visualDensity: VisualDensity.compact,
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterChip(
    ColorScheme colorScheme, {
    required String label,
    required VoidCallback onDeleted,
  }) {
    return InputChip(
      label: Text(label, style: const TextStyle(fontSize: 12)),
      onDeleted: onDeleted,
      backgroundColor: colorScheme.primaryContainer.withOpacity(0.3),
      side: BorderSide.none,
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _buildProductsList() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final localizations = AppLocalizations.of(context);

    if (_isInitialLoading) {
      return const ProductListSkeleton(itemCount: 5);
    }

    if (_allProducts.isEmpty) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
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
                      color: colorScheme.surfaceVariant.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.inventory_2_outlined,
                      size: 64,
                      color: colorScheme.onSurface.withOpacity(0.4),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    localizations?.productError ?? 'No products available.',
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
                      localizations?.no_products_in_location(
                        widget.districtName.isNotEmpty ? widget.districtName : widget.regionName,
                      ) ?? 'No products found in ${widget.districtName.isNotEmpty ? widget.districtName : widget.regionName}',
                      style: TextStyle(
                        fontSize: 14,
                        color: colorScheme.onSurface.withOpacity(0.6),
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
      return _buildProductsMap();
    }

    return ListView.builder(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: _allProducts.length + (_hasMoreData ? 1 : 0),
      itemBuilder: (context, index) {
        // Show products
        if (index < _allProducts.length) {
          final product = _allProducts[index];
          return ProductMain(
            key: ValueKey('product_${product.id}'),
            product: product,
          );
        }

        // Show loading indicator at the bottom
        if (_hasMoreData) {
          return _isLoadingMore
              ? const ProductSkeletonItem()
              : const SizedBox.shrink();
        }

        // Show "end of list" indicator
        return Container(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: Text(
              localizations?.no_more_products ?? 'No more products to load',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProductsMap() {
    final theme = Theme.of(context);

    final mapped = <MappedItem>[];
    for (final p in _allProducts) {
      if (p.latitude == null || p.longitude == null) continue;
      mapped.add(MappedItem(
        id: p.id.toString(),
        lat: p.latitude!,
        lng: p.longitude!,
        title: p.title,
        subtitle: '${p.price} ${p.currency}',
        imageUrl: p.images.isNotEmpty ? p.images.first.image : null,
        onTap: () => context.push('/product/${p.id}'),
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
                color: theme.colorScheme.onSurface.withOpacity(0.6)),
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

class _ProductBrowseModeToggle extends StatelessWidget {
  const _ProductBrowseModeToggle(
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
        color: colorScheme.surfaceVariant.withOpacity(0.5),
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

/// Plan D Task 4 — compact sort-selector button (replaces the Plan B
/// Fresh|Nearest segmented toggle) offering Fresh, Nearest (disabled
/// without a geo center), Price ↑, Price ↓ and Popular via a dropdown menu.
class _ProductSortButton extends StatelessWidget {
  const _ProductSortButton({
    required this.mode,
    required this.nearestEnabled,
    required this.onChanged,
  });

  final ProductSort mode;
  final bool nearestEnabled;
  final ValueChanged<ProductSort> onChanged;

  String _label(AppLocalizations? l, ProductSort s) {
    switch (s) {
      case ProductSort.fresh:
        return l?.sortFresh ?? 'Newest';
      case ProductSort.nearest:
        return l?.sortNearest ?? 'Nearest';
      case ProductSort.priceAsc:
        return l?.sortPriceAsc ?? 'Price: low to high';
      case ProductSort.priceDesc:
        return l?.sortPriceDesc ?? 'Price: high to low';
      case ProductSort.popular:
        return l?.sortPopular ?? 'Popular';
    }
  }

  IconData _icon(ProductSort s) {
    switch (s) {
      case ProductSort.fresh:
        return Icons.new_releases_outlined;
      case ProductSort.nearest:
        return Icons.near_me_outlined;
      case ProductSort.priceAsc:
        return Icons.arrow_upward_rounded;
      case ProductSort.priceDesc:
        return Icons.arrow_downward_rounded;
      case ProductSort.popular:
        return Icons.local_fire_department_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l = AppLocalizations.of(context);

    return PopupMenuButton<ProductSort>(
      initialValue: mode,
      tooltip: l?.sortFresh ?? 'Sort',
      onSelected: onChanged,
      itemBuilder: (context) => ProductSort.values.map((s) {
        final enabled = s != ProductSort.nearest || nearestEnabled;
        final selected = mode == s;
        return PopupMenuItem<ProductSort>(
          value: s,
          enabled: enabled,
          child: Row(
            children: [
              Icon(
                _icon(s),
                size: 18,
                color: !enabled
                    ? colorScheme.onSurfaceVariant.withOpacity(0.4)
                    : selected
                        ? colorScheme.primary
                        : colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 10),
              Text(
                _label(l, s),
                style: TextStyle(
                  color: !enabled
                      ? colorScheme.onSurfaceVariant.withOpacity(0.4)
                      : null,
                ),
              ),
              if (selected) ...[
                const Spacer(),
                Icon(Icons.check, size: 16, color: colorScheme.primary),
              ],
            ],
          ),
        );
      }).toList(),
      child: Material(
        color: colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(_icon(mode), size: 18, color: colorScheme.primary),
              const SizedBox(width: 2),
              Icon(Icons.arrow_drop_down_rounded,
                  size: 18, color: colorScheme.primary),
            ],
          ),
        ),
      ),
    );
  }
}
