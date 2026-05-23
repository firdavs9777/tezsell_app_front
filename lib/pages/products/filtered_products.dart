import 'package:app/pages/products/main_products.dart';
import 'package:app/pages/products/product_category.dart';
import 'package:app/pages/products/product_search.dart';
import 'package:app/pages/tab_bar/tab_bar.dart';
import 'package:app/providers/provider_models/category_model.dart';
import 'package:app/providers/provider_models/product_model.dart';
import 'package:app/providers/provider_root/product_provider.dart';
import 'package:app/providers/provider_root/active_neighborhood_provider.dart';
import 'package:app/providers/provider_root/radius_provider.dart';
import 'package:app/widgets/skeleton_loader.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/l10n/app_localizations.dart';

class FilteredProducts extends ConsumerStatefulWidget {
  final String categoryName;
  final String regionName;
  final String districtName;
  final int? districtId;
  const FilteredProducts({
    super.key,
    required this.categoryName,
    required this.regionName,
    required this.districtName,
    this.districtId,
  });

  @override
  ConsumerState<FilteredProducts> createState() => _FilteredProductsState();
}

class _FilteredProductsState extends ConsumerState<FilteredProducts> {
  final ScrollController _scrollController = ScrollController();
  List<Products> _allProducts = [];
  int _currentPage = 1;
  bool _isLoadingMore = false;
  bool _hasMoreData = true;
  bool _isInitialLoading = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadInitialProducts();
  }

  @override
  void dispose() {
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
    setState(() {
      _isInitialLoading = true;
      _currentPage = 1;
      _allProducts.clear();
      _hasMoreData = true;
    });

    try {
      final activeNbhd = ref.read(activeNeighborhoodProvider);
      final radius = ref.read(radiusProvider);
      final useNeighborhood = activeNbhd != null;
      final products =
          await ref.read(productsServiceProvider).getFilteredProducts(
                currentPage: 1,
                pageSize: 12,
                categoryName: widget.categoryName,
                regionName: useNeighborhood ? '' : widget.regionName,
                districtName: useNeighborhood ? '' : widget.districtName,
                districtId: useNeighborhood ? null : widget.districtId,
                neighborhoodId:
                    useNeighborhood ? activeNbhd.neighborhood.id : null,
                radiusKm: useNeighborhood ? radius : null,
                centerLat: useNeighborhood
                    ? activeNbhd.neighborhood.centroidLat
                    : null,
                centerLng: useNeighborhood
                    ? activeNbhd.neighborhood.centroidLng
                    : null,
              );

      setState(() {
        _allProducts = products;
        _currentPage = 1;
        _hasMoreData =
            products.length >= 12; // If less than pageSize, no more data
        _isInitialLoading = false;
      });
    } catch (error) {
      setState(() {
        _isInitialLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading products: $error'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _loadMoreProducts() async {
    if (_isLoadingMore || !_hasMoreData) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final nextPage = _currentPage + 1;
      final activeNbhd = ref.read(activeNeighborhoodProvider);
      final radius = ref.read(radiusProvider);
      final useNeighborhood = activeNbhd != null;
      final newProducts =
          await ref.read(productsServiceProvider).getFilteredProducts(
                currentPage: nextPage,
                pageSize: 12,
                categoryName: widget.categoryName,
                regionName: useNeighborhood ? '' : widget.regionName,
                districtName: useNeighborhood ? '' : widget.districtName,
                districtId: useNeighborhood ? null : widget.districtId,
                neighborhoodId:
                    useNeighborhood ? activeNbhd.neighborhood.id : null,
                radiusKm: useNeighborhood ? radius : null,
                centerLat: useNeighborhood
                    ? activeNbhd.neighborhood.centroidLat
                    : null,
                centerLng: useNeighborhood
                    ? activeNbhd.neighborhood.centroidLng
                    : null,
              );

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
    } catch (error) {
      if (mounted) {
        setState(() {
          _isLoadingMore = false;
          _hasMoreData = false;
        });
      }
    }
  }

  Future<void> refresh() async {
    await _loadInitialProducts();
  }

  /// Get the translated category name based on the current locale
  String _getTranslatedCategoryName(List<CategoryModel> categories) {
    if (categories.isEmpty) return widget.categoryName;

    // Find the category that matches the filter (categoryName is stored in Uzbek)
    CategoryModel? matchedCategory;
    for (final cat in categories) {
      if (cat.nameUz == widget.categoryName ||
          cat.nameEn == widget.categoryName ||
          cat.nameRu == widget.categoryName) {
        matchedCategory = cat;
        break;
      }
    }

    if (matchedCategory == null) return widget.categoryName;

    final locale = Localizations.localeOf(context).languageCode;
    switch (locale) {
      case 'uz':
        return matchedCategory.nameUz;
      case 'ru':
        return matchedCategory.nameRu;
      case 'en':
      default:
        return matchedCategory.nameEn;
    }
  }

  Widget _buildFilterBar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final categoriesAsync = ref.watch(categoriesProvider);

    String displayName = widget.categoryName;

    // Try to get translated name if categories are loaded
    if (categoriesAsync.hasValue) {
      displayName = _getTranslatedCategoryName(categoriesAsync.value!);
    }

    return Container(
      padding: const EdgeInsets.all(8.0),
      color: colorScheme.primaryContainer.withOpacity(0.3),
      child: Row(
        children: [
          Icon(Icons.filter_alt, size: 16, color: colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              displayName,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colorScheme.primary),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (widget.districtName.isNotEmpty) ...[
            const SizedBox(width: 8),
            Text('|', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colorScheme.primary)),
            const SizedBox(width: 8),
            Text(
              widget.districtName,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colorScheme.primary),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            if (context.mounted) {
              context.go('/tabs');
            }
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              context.push('/product/search');
            },
          ),
          IconButton(
            icon: Icon(Icons.category),
            onPressed: () {
              if (context.mounted) {
                context.go('/products?region=${widget.regionName}&district=${widget.districtName}${widget.districtId != null ? '&districtId=${widget.districtId}' : ''}');
              }
            },
          ),
        ],
        title: Text(
          AppLocalizations.of(context)?.filtered_products ??
              "Filtered Products",
        ),
      ),
      body: Column(
        children: [
          // Show current filters with translated category name
          if (widget.categoryName.isNotEmpty)
            _buildFilterBar(context),
          Expanded(
            child: RefreshIndicator(
              onRefresh: refresh,
              child: _buildProductsList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsList() {
    if (_isInitialLoading) {
      return const ProductListSkeleton(itemCount: 6);
    }

    if (_allProducts.isEmpty) {
      final colorScheme = Theme.of(context).colorScheme;
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
                      color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.inventory_2_outlined,
                      size: 64,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    AppLocalizations.of(context)?.productError ??
                        'No products available.',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Try changing your filters or browse all products',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () {
                          context.go('/products?region=${widget.regionName}&district=${widget.districtName}${widget.districtId != null ? '&districtId=${widget.districtId}' : ''}');
                        },
                        icon: const Icon(Icons.category_outlined, size: 18),
                        label: Text(
                          AppLocalizations.of(context)?.searchCategory ?? 'Categories',
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: colorScheme.primary,
                          side: BorderSide(color: colorScheme.primary),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                      const SizedBox(width: 12),
                      FilledButton.icon(
                        onPressed: () {
                          context.go('/tabs');
                        },
                        icon: const Icon(Icons.home_outlined, size: 18),
                        label: Text(
                          AppLocalizations.of(context)?.home ?? 'Home',
                        ),
                        style: FilledButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          foregroundColor: colorScheme.onPrimary,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
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
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              'No more products to load',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        );
      },
    );
  }
}
