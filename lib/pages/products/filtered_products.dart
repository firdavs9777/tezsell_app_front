import 'package:app/pages/products/main_products.dart';
import 'package:app/pages/products/product_category.dart';
import 'package:app/pages/products/product_search.dart';
import 'package:app/pages/tab_bar/tab_bar.dart';
import 'package:app/providers/provider_models/product_model.dart';
import 'package:app/providers/provider_root/product_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/l10n/app_localizations.dart';

class FilteredProducts extends ConsumerStatefulWidget {
  final String categoryName;
  final String regionName;
  final String districtName;
  const FilteredProducts({
    super.key,
    required this.categoryName,
    required this.regionName,
    required this.districtName,
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
      final products =
          await ref.read(productsServiceProvider).getFilteredProducts(
                currentPage: 1,
                pageSize: 12,
                categoryName: widget.categoryName,
                regionName: widget.regionName,
                districtName: widget.districtName,
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
      final newProducts =
          await ref.read(productsServiceProvider).getFilteredProducts(
                currentPage: nextPage,
                pageSize: 12,
                categoryName: widget.categoryName,
                regionName: widget.regionName,
                districtName: widget.districtName,
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
      setState(() {
        _isLoadingMore = false;
      });
      if (mounted) {
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
    await _loadInitialProducts();
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
                context.go('/products?region=${widget.regionName}&district=${widget.districtName}');
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
          // Optional: Show current filters
          if (widget.categoryName.isNotEmpty)
            Builder(
              builder: (context) {
                final colorScheme = Theme.of(context).colorScheme;
                return Container(
                  padding: const EdgeInsets.all(8.0),
                  color: colorScheme.primaryContainer.withOpacity(0.3),
                  child: Row(
                    children: [
                      Icon(Icons.filter_alt, size: 16, color: colorScheme.primary),
                      SizedBox(width: 8),
                      Text(
                        'Category: ${widget.categoryName}',
                        style: TextStyle(fontSize: 12, color: colorScheme.primary),
                      ),
                      if (widget.districtName.isNotEmpty) ...[
                        SizedBox(width: 8),
                        Text('|', style: TextStyle(color: colorScheme.primary)),
                        SizedBox(width: 8),
                        Text(
                          '${widget.districtName}',
                          style: TextStyle(fontSize: 12, color: colorScheme.primary),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
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
      return const Center(child: CircularProgressIndicator());
    }

    if (_allProducts.isEmpty) {
      final colorScheme = Theme.of(context).colorScheme;
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.6,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inventory_2_outlined,
                  size: 64,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: 16),
                Text(
                  AppLocalizations.of(context)?.productError ??
                      'No products available.',
                  style: TextStyle(
                    fontSize: 16,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Try changing your filters',
                  style: TextStyle(
                    fontSize: 14,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
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
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: _isLoadingMore
                  ? const CircularProgressIndicator()
                  : const SizedBox.shrink(),
            ),
          );
        }

        // Show "end of list" indicator
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              'No more products to load',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 14,
              ),
            ),
          ),
        );
      },
    );
  }
}
