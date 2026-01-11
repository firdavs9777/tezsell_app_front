import 'package:app/pages/products/main_products.dart';
import 'package:app/providers/provider_root/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/providers/provider_models/product_model.dart';
import 'package:app/l10n/app_localizations.dart';

class ProductSearch extends ConsumerStatefulWidget {
  final String regionName;
  final String districtName;

  const ProductSearch({
    super.key,
    this.regionName = '',
    this.districtName = '',
  });

  @override
  ConsumerState<ProductSearch> createState() => _ProductSearchState();
}

class _ProductSearchState extends ConsumerState<ProductSearch> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  List<Products> _allProducts = [];
  int _currentPage = 1;
  bool _isLoadingMore = false;
  bool _hasMoreData = true;
  bool _isInitialLoading = false;
  bool _hasSearched = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Auto-focus search field when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoadingMore && _hasMoreData && _hasSearched) {
        _loadMoreProducts();
      }
    }
  }

  Future<void> _searchProducts(String _) async {
    if (_searchController.text.trim().isEmpty) return;

    // Unfocus keyboard after search
    _focusNode.unfocus();

    setState(() {
      _isInitialLoading = true;
      _hasSearched = true;
      _currentPage = 1;
      _allProducts.clear();
      _hasMoreData = true;
    });

    try {
      final products =
          await ref.read(productsServiceProvider).getFilteredProducts(
                productTitle: _searchController.text,
                regionName: widget.regionName,
                districtName: widget.districtName,
                currentPage: 1,
                pageSize: 12,
              );

      setState(() {
        _allProducts = products;
        _currentPage = 1;
        _hasMoreData = products.length >= 12;
        _isInitialLoading = false;
      });
    } catch (error) {
      setState(() {
        _isInitialLoading = false;
      });
      if (mounted) {
        final colorScheme = Theme.of(context).colorScheme;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)?.search_products_error ?? 'Error searching products'),
            backgroundColor: colorScheme.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
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
                productTitle: _searchController.text,
                regionName: widget.regionName,
                districtName: widget.districtName,
                currentPage: nextPage,
                pageSize: 12,
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
        final colorScheme = Theme.of(context).colorScheme;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)?.load_more_products_error ?? 'Error loading more products'),
            backgroundColor: colorScheme.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    }
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _hasSearched = false;
      _allProducts.clear();
    });
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: _buildSearchBar(colorScheme),
        titleSpacing: 0,
      ),
      body: Column(
        children: [
          // Divider under search bar
          Divider(height: 1, color: colorScheme.outlineVariant),

          // Show current location filter if active
          if (widget.regionName.isNotEmpty || widget.districtName.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: colorScheme.surfaceVariant.withOpacity(0.3),
              child: Row(
                children: [
                  Icon(Icons.location_on,
                      size: 16, color: colorScheme.onSurfaceVariant),
                  const SizedBox(width: 6),
                  Text(
                    widget.districtName.isNotEmpty ? widget.districtName : widget.regionName,
                    style: TextStyle(
                      fontSize: 13,
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

          Expanded(
            child: _buildSearchResults(colorScheme),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(ColorScheme colorScheme) {
    return Container(
      height: 40,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: _searchController,
        focusNode: _focusNode,
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context)?.searchProductPlaceholder ??
              "Search products",
          hintStyle: TextStyle(
            color: colorScheme.onSurfaceVariant,
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: colorScheme.onSurfaceVariant,
            size: 22,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  onPressed: _clearSearch,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
        ),
        textInputAction: TextInputAction.search,
        style: TextStyle(
          fontSize: 15,
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w400,
        ),
        onSubmitted: _searchProducts,
        onChanged: (value) {
          setState(() {}); // Update to show/hide clear button
          if (value.isEmpty) {
            setState(() {
              _hasSearched = false;
              _allProducts.clear();
            });
          }
        },
      ),
    );
  }

  Widget _buildSearchResults(ColorScheme colorScheme) {
    if (!_hasSearched) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              size: 80,
              color: colorScheme.outlineVariant,
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)?.product_search_placeholder ??
                  "Search for products",
              style: TextStyle(
                fontSize: 16,
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                AppLocalizations.of(context)?.search_products_subtitle ?? "Find great deals in your neighborhood",
                style: TextStyle(
                  fontSize: 14,
                  color: colorScheme.onSurfaceVariant.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );
    }

    if (_isInitialLoading) {
      return Center(child: CircularProgressIndicator(color: colorScheme.primary));
    }

    if (_allProducts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 80,
              color: colorScheme.outlineVariant,
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)?.productError ?? "No products found",
              style: TextStyle(
                fontSize: 16,
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                AppLocalizations.of(context)?.try_different_keywords ?? 'Try different keywords',
                style: TextStyle(
                  fontSize: 14,
                  color: colorScheme.onSurfaceVariant.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: _allProducts.length + (_hasMoreData ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < _allProducts.length) {
          final product = _allProducts[index];
          return ProductMain(product: product);
        }

        if (_hasMoreData) {
          return Container(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: _isLoadingMore
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colorScheme.primary,
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          );
        }

        return Container(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Text(
              '—',
              style: TextStyle(
                color: colorScheme.outlineVariant,
                fontSize: 18,
              ),
            ),
          ),
        );
      },
    );
  }
}
