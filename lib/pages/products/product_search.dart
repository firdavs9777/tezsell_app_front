import 'package:app/pages/products/main_products.dart';
import 'package:app/providers/provider_root/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:app/providers/provider_models/product_model.dart';
import 'package:app/providers/provider_models/saved_search_model.dart';
import 'package:app/providers/provider_root/saved_searches_provider.dart';
import 'package:app/providers/provider_root/search_alerts_provider.dart';
import 'package:app/l10n/app_localizations.dart';

class ProductSearch extends ConsumerStatefulWidget {
  final String countryCode;
  final String regionName;
  final String districtName;
  final String initialQuery;

  const ProductSearch({
    super.key,
    this.countryCode = '',
    this.regionName = '',
    this.districtName = '',
    this.initialQuery = '',
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
    if (widget.initialQuery.trim().isNotEmpty) {
      // Prefilled from a saved search: run it immediately instead of
      // auto-focusing an empty field.
      _searchController.text = widget.initialQuery;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _searchProducts(widget.initialQuery);
      });
    } else {
      // Auto-focus search field when screen opens
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNode.requestFocus();
      });
    }
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
      if (mounted) {
        setState(() {
          _isLoadingMore = false;
          _hasMoreData = false;
        });
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

  bool get _canSaveSearch =>
      _hasSearched && _searchController.text.trim().isNotEmpty;

  Future<void> _openSaveSearchSheet() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    final l10n = AppLocalizations.of(context);
    final region = widget.regionName.trim();
    final district = widget.districtName.trim();

    final alreadySaved = ref.read(savedSearchesProvider).searches.any((s) =>
        s.query.trim().toLowerCase() == query.toLowerCase() &&
        (s.region ?? '') == region &&
        (s.district ?? '') == district);

    if (alreadySaved) {
      _showResultSnackBar(
        l10n?.savedSearchAlreadySaved ?? 'You already saved this search',
        isError: false,
      );
      return;
    }

    bool notifyMe = true;
    final enableAlert = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (sheetContext, setSheetState) {
            final sheetColorScheme = Theme.of(sheetContext).colorScheme;
            final sheetL10n = AppLocalizations.of(sheetContext);
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sheetL10n?.savedSearchSheetTitle ?? 'Save this search',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: sheetColorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    query,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: sheetColorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    value: notifyMe,
                    onChanged: (value) => setSheetState(() => notifyMe = value),
                    title: Text(
                      sheetL10n?.savedSearchNotifyToggleTitle ??
                          'Notify me about new matches',
                    ),
                    subtitle: Text(
                      sheetL10n?.savedSearchNotifyToggleSubtitle ??
                          "We'll alert you when new listings match this search",
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(sheetContext),
                          child: Text(sheetL10n?.cancel ?? 'Cancel'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () =>
                              Navigator.pop(sheetContext, notifyMe),
                          child: Text(sheetL10n?.save ?? 'Save'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    if (enableAlert == null || !mounted) return;

    await _saveSearch(
      query: query,
      region: region,
      district: district,
      enableAlert: enableAlert,
    );
  }

  Future<void> _saveSearch({
    required String query,
    required String region,
    required String district,
    required bool enableAlert,
  }) async {
    final l10n = AppLocalizations.of(context);

    SavedSearch? saved;
    try {
      saved = await ref.read(savedSearchesProvider.notifier).createSavedSearch(
            query: query,
            itemType: 'product',
            region: region.isNotEmpty ? region : null,
            district: district.isNotEmpty ? district : null,
          );
    } catch (e) {
      if (!mounted) return;
      _showResultSnackBar(
        _friendlyErrorMessage(
          e,
          l10n?.savedSearchSaveGenericError ?? 'Failed to save search',
        ),
        isError: true,
      );
      return;
    }

    if (saved == null) {
      if (!mounted) return;
      _showResultSnackBar(
        l10n?.savedSearchSaveGenericError ?? 'Failed to save search',
        isError: true,
      );
      return;
    }

    bool alertEnabled = false;
    if (enableAlert) {
      try {
        final alert =
            await ref.read(searchAlertsProvider.notifier).createAlert(
                  keyword: query,
                  itemType: 'product',
                  region: region.isNotEmpty ? region : null,
                  district: district.isNotEmpty ? district : null,
                );
        alertEnabled = alert != null;
      } catch (e) {
        if (mounted) {
          _showResultSnackBar(
            _friendlyErrorMessage(
              e,
              l10n?.searchAlertCreateGenericError ?? 'Failed to enable alert',
            ),
            isError: true,
          );
        }
      }
    }

    if (!mounted) return;
    _showResultSnackBar(
      alertEnabled
          ? (l10n?.savedSearchSavedWithAlertSuccess ??
              "Search saved. You'll be notified about new matches.")
          : (l10n?.savedSearchSavedSuccess ?? 'Search saved'),
      isError: false,
    );
  }

  String _friendlyErrorMessage(Object error, String fallback) {
    final message = error.toString().replaceFirst('Exception: ', '');
    return message.isNotEmpty ? message : fallback;
  }

  void _showResultSnackBar(String message, {required bool isError}) {
    final colorScheme = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? colorScheme.error : colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildSaveSearchButton(ColorScheme colorScheme) {
    final l10n = AppLocalizations.of(context);
    return IconButton(
      icon: Icon(
        Icons.notification_add_outlined,
        color: _canSaveSearch
            ? colorScheme.onSurface
            : colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
      ),
      tooltip: l10n?.savedSearchSaveTooltip ?? 'Save search',
      onPressed: _canSaveSearch ? _openSaveSearchSheet : null,
    );
  }

  Widget _buildManageSearchesButton(ColorScheme colorScheme) {
    final l10n = AppLocalizations.of(context);
    return IconButton(
      icon: Icon(Icons.bookmarks_outlined, color: colorScheme.onSurface),
      tooltip: l10n?.savedSearchesManageTooltip ?? 'Saved searches',
      onPressed: () => context.push('/saved-searches'),
    );
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
        actions: [
          _buildSaveSearchButton(colorScheme),
          _buildManageSearchesButton(colorScheme),
          const SizedBox(width: 4),
        ],
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
