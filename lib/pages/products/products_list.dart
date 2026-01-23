import 'package:app/pages/products/main_products.dart';
import 'package:app/pages/products/product_new.dart';
import 'package:app/providers/provider_models/product_model.dart';
import 'package:app/providers/provider_models/category_model.dart';
import 'package:app/providers/provider_root/product_provider.dart';
import 'package:app/providers/provider_root/profile_provider.dart';
import 'package:app/widgets/skeleton_loader.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/l10n/app_localizations.dart';

class ProductsList extends ConsumerStatefulWidget {
  final String regionName;
  final String districtName;

  const ProductsList(
      {super.key, required this.regionName, required this.districtName});

  @override
  ConsumerState<ProductsList> createState() => _ProductsListState();
}

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
      context.push('/products?category=$encodedCategory&region=$encodedRegion&district=$encodedDistrict');
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
    
    setState(() {
      _isInitialLoading = true;
      _currentPage = 1;
      _allProducts.clear();
      _hasMoreData = true;
    });

    try {
      final products =
          await ref.read(productsServiceProvider).getFilteredProducts(
                currentPage: 1,
                pageSize: 12,
                regionName: widget.regionName,
                districtName: widget.districtName,
              );

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
        });
        // Show error snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading more products: $error'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
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
        oldWidget.districtName != widget.districtName) {
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
                            context.push('/product/categories?region=${widget.regionName}&district=${widget.districtName}');
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
                      const SizedBox(width: 12),
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
                      'More',
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
                  context.push('/product/categories?region=${widget.regionName}&district=${widget.districtName}');
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
                      'No products found in ${widget.districtName.isNotEmpty ? widget.districtName : widget.regionName}',
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

    return ListView.builder(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: _allProducts.length + (_hasMoreData ? 1 : 0),
      itemBuilder: (context, index) {
        // Show products
        if (index < _allProducts.length) {
          final product = _allProducts[index];
          return ProductMain(product: product);
        }

        // Show loading indicator at the bottom
        if (_hasMoreData) {
          return Container(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: _isLoadingMore
                  ? CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.primary,
                    )
                  : const SizedBox.shrink(),
            ),
          );
        }

        // Show "end of list" indicator
        return Container(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: Text(
              'No more products to load',
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
}
