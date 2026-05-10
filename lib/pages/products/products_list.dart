import 'package:app/pages/products/main_products.dart';
import 'package:app/pages/products/product_new.dart';
import 'package:app/providers/provider_models/product_model.dart';
import 'package:app/providers/provider_models/category_model.dart';
import 'package:app/providers/provider_root/active_neighborhood_provider.dart';
import 'package:app/providers/provider_root/product_provider.dart';
import 'package:app/providers/provider_root/profile_provider.dart';
import 'package:app/providers/provider_root/radius_provider.dart';
import 'package:app/providers/provider_root/verified_neighborhoods_provider.dart';
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

    final hasLocationFilter = widget.districtId != null && widget.districtId! > 0;
    print('📦 [ProductsList] ═══════════════════════════════════════');
    print('📦 [ProductsList] Loading products... (gen=$thisGeneration)');
    print('📦 [ProductsList]   Filter active: $hasLocationFilter');
    if (hasLocationFilter) {
      print('📦 [ProductsList]   districtId: ${widget.districtId}');
      print('📦 [ProductsList]   region: "${widget.regionName}"');
      print('📦 [ProductsList]   district: "${widget.districtName}"');
    } else {
      print('📦 [ProductsList]   Loading ALL products (no location filter)');
    }
    print('📦 [ProductsList] ═══════════════════════════════════════');

    setState(() {
      _isInitialLoading = true;
      _currentPage = 1;
      _allProducts.clear();
      _hasMoreData = true;
    });

    try {
      // Phase-1 OSM/Carrot filter: only applied when user has a verified
      // neighborhood active and is not browsing region/district directly.
      final activeNbhd = ref.read(activeNeighborhoodProvider);
      final radius = ref.read(radiusProvider);
      final hasLegacyFilter =
          (widget.districtId != null && widget.districtId! > 0) ||
              widget.regionName.isNotEmpty ||
              widget.districtName.isNotEmpty;
      final products =
          await ref.read(productsServiceProvider).getFilteredProducts(
                currentPage: 1,
                pageSize: 12,
                regionName: widget.regionName,
                districtName: widget.districtName,
                districtId: widget.districtId,
                neighborhoodId: hasLegacyFilter
                    ? null
                    : activeNbhd?.neighborhood.id,
                radiusKm: hasLegacyFilter ? null : radius,
              );

      // Ignore if a newer load was triggered while this was in-flight
      if (thisGeneration != _loadGeneration) {
        print('📦 [ProductsList] Stale response ignored (gen=$thisGeneration, current=$_loadGeneration)');
        return;
      }

      print('📦 [ProductsList] Filtered products: ${products.length}');

      if (mounted && !_isDisposed) {
        setState(() {
          _allProducts = products;
          _currentPage = 1;
          _hasMoreData =
              products.length >= 12; // If less than pageSize, no more data
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
      final newProducts =
          await ref.read(productsServiceProvider).getFilteredProducts(
                currentPage: nextPage,
                pageSize: 12,
                regionName: widget.regionName,
                districtName: widget.districtName,
                districtId: widget.districtId,
              );

      if (mounted && !_isDisposed) {
        setState(() {
          if (newProducts.isNotEmpty) {
            _allProducts.addAll(newProducts);
            _currentPage = nextPage;
            _hasMoreData = newProducts.length >= 12;
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
        _loadInitialProducts();
      }
    });
    ref.listen<double>(radiusProvider, (prev, next) {
      if (prev != next) _loadInitialProducts();
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
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'No products with location data in this area yet.',
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
