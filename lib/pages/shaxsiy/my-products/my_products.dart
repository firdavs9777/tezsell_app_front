import 'package:app/l10n/app_localizations.dart';
import 'package:app/pages/shaxsiy/my-products/my_products_helpers.dart';
import 'package:app/pages/shaxsiy/my-products/product_edit.dart';
import 'package:app/pages/shaxsiy/my-products/widgets/mark_sold_sheet.dart';
import 'package:app/pages/shaxsiy/my-products/widgets/my_products_card.dart';
import 'package:app/providers/provider_models/product_model.dart';
import 'package:app/providers/provider_root/product_provider.dart';
import 'package:app/providers/provider_root/profile_provider.dart';
import 'package:app/service/chat_api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MyProducts extends ConsumerStatefulWidget {
  const MyProducts({super.key});

  @override
  ConsumerState<MyProducts> createState() => _MyProductsState();
}

class _MyProductsState extends ConsumerState<MyProducts>
    with SingleTickerProviderStateMixin {
  final List<Products> _products = [];
  late final TabController _tabController;
  bool _isLoading = true;
  bool _hasChanges = false;

  List<Products> get _activeProducts => activeListings(_products);
  List<Products> get _soldProducts => soldListings(_products);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadProducts();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// Returns true if the reload succeeded. [showErrorSnackbar] is disabled for
  /// post-mutation reloads so the caller controls messaging (otherwise a
  /// refresh failure after a successful mutation would fire its own error
  /// snackbar and then the caller's contradictory success snackbar).
  Future<bool> _loadProducts({bool showErrorSnackbar = true}) async {
    try {
      setState(() {
        _isLoading = true;
      });

      // includeInactive: the owner needs to see hidden/sold listings too,
      // not just the public active-only set.
      final products = await ref
          .read(profileServiceProvider)
          .getUserProducts(includeInactive: true);

      if (mounted) {
        setState(() {
          _products
            ..clear()
            ..addAll(products);
          _isLoading = false;
        });
      }
      return true;
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        if (showErrorSnackbar) _showError('Error loading products: $e');
      }
      return false;
    }
  }

  Future<void> _refreshProducts() async {
    await _loadProducts();
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showSuccess(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Future<void> _deleteProduct(Products product) async {
    final localizations = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.errorContainer.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.delete_outline_rounded,
                size: 32,
                color: colorScheme.error,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              localizations?.delete_product ?? 'Delete Product',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              localizations?.delete_confirmation ??
                  'Are you sure you want to delete "${product.title}"?',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context, false),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(localizations?.cancel ?? 'Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: FilledButton.styleFrom(
                      backgroundColor: colorScheme.error,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(localizations?.delete ?? 'Delete'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );

    if (confirmed != true) return;
    if (!mounted) return;

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final success = await ref
          .read(productsServiceProvider)
          .deleteProduct(productId: product.id);

      if (mounted) Navigator.pop(context); // Close loading

      if (success) {
        setState(() {
          _products.removeWhere((p) => p.id == product.id);
          _hasChanges = true;
        });
        if (!mounted) return;
        _showSuccess(
          AppLocalizations.of(context)?.product_deleted_success ??
              'Product deleted successfully',
        );
      }
    } catch (e) {
      if (mounted) Navigator.pop(context);
      _showError('Error deleting product: $e');
    }
  }

  void _editProduct(Products product) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProductEdit(product: product)),
    ).then((updatedProduct) {
      if (updatedProduct != null && updatedProduct is Products) {
        setState(() {
          final index = _products.indexWhere((p) => p.id == updatedProduct.id);
          if (index != -1) {
            _products[index] = updatedProduct;
            _hasChanges = true;
          }
        });
        ref.invalidate(profileServiceProvider);
      }
    });
  }

  void _viewProduct(Products product) {
    context.push('/product/${product.id}');
  }

  /// Shared handler for the Hide/Unhide/Back-to-available actions: all three
  /// are a lightweight `setListingStatus` PATCH followed by a full reload
  /// (so the Active/Sold split and Hidden indicator immediately reflect the
  /// new state) and a snackbar. Guards `context` across every await.
  Future<void> _updateStatus(
    Products product, {
    bool? isSold,
    bool? isActive,
    required String successMessage,
  }) async {
    try {
      await ref
          .read(productsServiceProvider)
          .setListingStatus(
            productId: product.id,
            isSold: isSold,
            isActive: isActive,
          );
      _hasChanges = true;
      final reloaded = await _loadProducts(showErrorSnackbar: false);
      if (!mounted) return;
      if (reloaded) {
        _showSuccess(successMessage);
      } else {
        // The change was saved server-side; only the refresh failed.
        final l = AppLocalizations.of(context);
        _showError(
          l?.listing_updated_refresh_failed ??
              'Updated — pull to refresh to see changes',
        );
      }
    } catch (e) {
      if (!mounted) return;
      final l = AppLocalizations.of(context);
      _showError(
        '${l?.failed_to_update_listing ?? 'Failed to update listing'}: $e',
      );
    }
  }

  Future<void> _backToAvailable(Products product) async {
    final l = AppLocalizations.of(context);
    await _updateStatus(
      product,
      isSold: false,
      successMessage:
          l?.listing_available_again ?? 'Listing is available again',
    );
  }

  Future<void> _hideProduct(Products product) async {
    final l = AppLocalizations.of(context);
    await _updateStatus(
      product,
      isActive: false,
      successMessage: l?.listing_hidden ?? 'Listing hidden',
    );
  }

  Future<void> _unhideProduct(Products product) async {
    final l = AppLocalizations.of(context);
    await _updateStatus(
      product,
      isActive: true,
      successMessage: l?.listing_unhidden ?? 'Listing is visible again',
    );
  }

  /// "Mark as sold" flow: fetches buyers with an existing chat for this
  /// listing, shows the "who did you sell to?" picker, then either POSTs
  /// the chat transaction endpoint (buyer-attributed -- also creates the
  /// completed-transaction review CTA) or falls back to a bare
  /// `setListingStatus(isSold: true)` for "Sold elsewhere".
  Future<void> _markAsSold(Products product) async {
    final l = AppLocalizations.of(context);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    List<ChatBuyer> buyers = [];
    try {
      buyers = await ref
          .read(productsServiceProvider)
          .getProductChatBuyers(product.id);
    } catch (_) {
      // Non-fatal: fall back to "Sold elsewhere" only.
      buyers = [];
    }

    if (!mounted) return;
    Navigator.pop(context); // close loading dialog

    if (!mounted) return;
    final selection = await showMarkSoldSheet(context, buyers: buyers);
    if (selection == null || !mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      if (selection.chatId != null) {
        await ChatApiService().updateTransactionStatus(
          selection.chatId!,
          'sold',
        );
      } else {
        await ref
            .read(productsServiceProvider)
            .setListingStatus(productId: product.id, isSold: true);
      }
      if (mounted) Navigator.pop(context); // close loading
      _hasChanges = true;
      final reloaded = await _loadProducts(showErrorSnackbar: false);
      if (!mounted) return;
      if (reloaded) {
        _showSuccess(l?.marked_as_sold ?? 'Marked as sold');
      } else {
        // Sold server-side; only the refresh failed.
        _showError(
          l?.listing_updated_refresh_failed ??
              'Updated — pull to refresh to see changes',
        );
      }
    } catch (e) {
      if (mounted) Navigator.pop(context);
      if (!mounted) return;
      _showError(
        '${l?.failed_to_update_listing ?? 'Failed to update listing'}: $e',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Navigator.pop(context, _hasChanges);
        }
      },
      child: Scaffold(
        backgroundColor: isDark ? colorScheme.surface : const Color(0xFFF5F5F5),
        appBar: AppBar(
          elevation: 0,
          scrolledUnderElevation: 1,
          backgroundColor: colorScheme.surface,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localizations?.my_products ?? 'My Products',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              if (_products.isNotEmpty)
                Text(
                  '${_products.length} ${_products.length == 1 ? 'item' : 'items'}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.add_rounded),
              onPressed: () => context.push('/product/new'),
              tooltip: 'Add Product',
            ),
          ],
          bottom: (_isLoading || _products.isEmpty)
              ? null
              : TabBar(
                  controller: _tabController,
                  labelColor: colorScheme.primary,
                  unselectedLabelColor: colorScheme.onSurfaceVariant,
                  tabs: [
                    Tab(
                      child: Text(
                        '${localizations?.active_tab ?? 'Active'} (${_activeProducts.length})',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Tab(
                      child: Text(
                        '${localizations?.sold_tab ?? 'Sold'} (${_soldProducts.length})',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_products.isEmpty) {
      return MyProductsEmptyState(
        onAddProduct: () => context.push('/product/new'),
      );
    }

    final localizations = AppLocalizations.of(context);

    return TabBarView(
      controller: _tabController,
      children: [
        _buildProductList(
          _activeProducts,
          emptyText: localizations?.no_active_listings ?? 'No active listings',
        ),
        _buildProductList(
          _soldProducts,
          emptyText: localizations?.no_sold_listings ?? 'No sold items yet',
        ),
      ],
    );
  }

  Widget _buildProductList(
    List<Products> products, {
    required String emptyText,
  }) {
    if (products.isEmpty) {
      return RefreshIndicator(
        onRefresh: _refreshProducts,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const SizedBox(height: 120),
            Center(
              child: Text(
                emptyText,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshProducts,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return MyProductsCard(
            key: ValueKey(product.id),
            product: product,
            onView: () => _viewProduct(product),
            onEdit: () => _editProduct(product),
            onDelete: () => _deleteProduct(product),
            onMarkSold: () => _markAsSold(product),
            onBackToAvailable: () => _backToAvailable(product),
            onHide: () => _hideProduct(product),
            onUnhide: () => _unhideProduct(product),
          );
        },
      ),
    );
  }
}
