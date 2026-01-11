import 'package:app/constants/constants.dart';
import 'package:app/pages/chat/chat_room.dart';
import 'package:app/pages/products/main_products.dart';
import 'package:app/providers/provider_root/chat_provider.dart';
import 'package:app/providers/provider_root/product_provider.dart';
import 'package:app/providers/provider_root/profile_provider.dart';
import 'package:app/utils/image_utils.dart';
import 'package:app/widgets/cached_network_image_widget.dart';
import 'package:app/widgets/image_viewer.dart';
import 'package:app/widgets/report_content_dialog.dart';
import 'package:app/utils/error_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/providers/provider_models/product_model.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';

class ProductDetail extends ConsumerStatefulWidget {
  const ProductDetail({super.key, required this.product});
  final Products product;

  @override
  ConsumerState<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends ConsumerState<ProductDetail> {
  late PageController _pageController;
  bool _isLiking = false;
  Products? _currentProduct;
  bool? _isLiked;
  bool _isLoadingLikeStatus = false;
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _currentProduct = widget.product;
    _loadLikeStatus();
  }

  Future<void> _loadLikeStatus({bool forceRefresh = false}) async {
    if (_isLoadingLikeStatus || (!forceRefresh && _isLiked != null)) return;

    setState(() {
      _isLoadingLikeStatus = true;
    });

    try {
      final favoriteItems = await ref
          .read(profileServiceProvider)
          .getUserFavoriteItems();

      if (mounted) {
        setState(() {
          _isLiked = favoriteItems.likedProducts
              .any((item) => item.id == widget.product.id);
          _isLoadingLikeStatus = false;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _isLiked = false;
          _isLoadingLikeStatus = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  String getCategoryName() {
    final locale = Localizations.localeOf(context).languageCode;
    switch (locale) {
      case 'uz':
        return widget.product.category?.nameUz ?? '';
      case 'ru':
        return widget.product.category?.nameRu ?? '';
      case 'en':
      default:
        return widget.product.category?.nameEn ?? '';
    }
  }

  String _getTimeAgo(DateTime? date) {
    if (date == null) return '';
    try {
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays > 30) {
        return DateFormat('MMM d').format(date);
      } else if (difference.inDays > 0) {
        return '${difference.inDays}d ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}h ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}m ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return '';
    }
  }

  void _shareProduct() {
    HapticFeedback.selectionClick();
    final localizations = AppLocalizations.of(context);
    final shareText =
        '${localizations?.checkOutProfile ?? "Check out"} ${widget.product.title} ${localizations?.onTezsell ?? "on Tezsell"}\nhttps://webtezsell.com/product/${widget.product.id}';

    final box = context.findRenderObject() as RenderBox?;
    Share.share(
      shareText,
      subject: widget.product.title,
      sharePositionOrigin: box != null
          ? box.localToGlobal(Offset.zero) & box.size
          : const Rect.fromLTWH(0, 0, 100, 100),
    );
  }

  Future<void> _showReportDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => ReportContentDialog(
        contentType: 'product',
        contentId: widget.product.id,
        contentTitle: widget.product.title,
      ),
    );

    if (result == true && mounted) {
      final localizations = AppLocalizations.of(context);
      AppErrorHandler.showSuccess(
        context,
        localizations?.reportSubmitted ??
            'Thank you for your report. We will review it within 24 hours.',
      );
    }
  }

  Future<void> _startChat() async {
    final targetUserId = widget.product.userName.id;
    final userName = widget.product.userName.username ?? 'Seller';
    final localizations = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    await ref.read(chatProvider.notifier).initialize();

    final chatState = ref.read(chatProvider);
    if (!chatState.isAuthenticated) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localizations?.chatLoginMessage ?? 'Please log in to start a chat'),
            backgroundColor: colorScheme.tertiary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
      return;
    }

    if (chatState.currentUserId == targetUserId) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localizations?.cannot_chat_with_yourself ?? 'You cannot chat with yourself'),
            backgroundColor: colorScheme.tertiary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
      return;
    }

    // Show Carrot-style loading bottom sheet
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 48,
              height: 48,
              child: CircularProgressIndicator(strokeWidth: 3),
            ),
            const SizedBox(height: 20),
            Text(
              localizations?.opening_chat_with(userName) ?? 'Opening chat with $userName...',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );

    try {
      final chatRoom = await ref
          .read(chatProvider.notifier)
          .getOrCreateDirectChat(targetUserId);

      if (mounted) Navigator.of(context).pop();

      if (chatRoom != null && mounted) {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChatRoomScreen(chatRoom: chatRoom)),
        );
      } else {
        throw Exception('Failed to create chat room');
      }
    } catch (e) {
      if (mounted && Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }
      if (mounted) {
        final snackColorScheme = Theme.of(context).colorScheme;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localizations?.unable_to_start_chat ?? 'Unable to start chat'),
            backgroundColor: snackColorScheme.error,
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: localizations?.retry ?? 'Retry',
              textColor: snackColorScheme.onError,
              onPressed: _startChat,
            ),
          ),
        );
      }
    }
  }

  Future<void> _toggleLike() async {
    if (_isLiking) return;

    final currentLikeStatus = _isLiked ?? false;

    // Optimistic update
    setState(() {
      _isLiking = true;
      _isLiked = !currentLikeStatus;
    });

    try {
      if (currentLikeStatus) {
        final product = await ref
            .read(profileServiceProvider)
            .dislikeProductItem(productId: widget.product.id.toString());
        if (product != null && mounted) {
          setState(() => _currentProduct = product);
        }
      } else {
        final product = await ref
            .read(profileServiceProvider)
            .likeSingleProduct(productId: widget.product.id.toString());
        if (product != null && mounted) {
          setState(() => _currentProduct = product);
        }
      }
      ref.invalidate(profileServiceProvider);
    } catch (e) {
      // Revert on error
      if (mounted) {
        setState(() => _isLiked = currentLikeStatus);
      }
    } finally {
      if (mounted) {
        setState(() => _isLiking = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final List<String> imageUrls = widget.product.images.isNotEmpty
        ? widget.product.images
            .map((image) => ImageUtils.buildImageUrl(image.image))
            .toList()
        : [];

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          // Carrot-style SliverAppBar with image
          SliverAppBar(
            expandedHeight: 360,
            pinned: true,
            backgroundColor: colorScheme.surface,
            foregroundColor: colorScheme.onSurface,
            elevation: 0,
            leading: _buildCircularButton(
              icon: Icons.arrow_back_ios_new_rounded,
              onTap: () => Navigator.of(context).pop(),
            ),
            actions: [
              _buildCircularButton(
                icon: Icons.share_outlined,
                onTap: _shareProduct,
              ),
              _buildCircularButton(
                icon: Icons.more_horiz_rounded,
                onTap: () => _showMoreOptions(context),
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: _buildImageSlider(imageUrls),
            ),
          ),
          // Content
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSellerSection(),
                _buildDivider(),
                _buildProductInfo(),
                _buildDivider(),
                _buildDescription(),
                _buildDivider(),
                _buildRecommendedProducts(),
                const SizedBox(height: 100), // Space for bottom bar
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildCarrotBottomBar(),
    );
  }

  Widget _buildCircularButton({required IconData icon, required VoidCallback onTap}) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: colorScheme.scrim.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            child: Icon(icon, color: colorScheme.surface, size: 20),
          ),
        ),
      ),
    );
  }

  void _showMoreOptions(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final localizations = AppLocalizations.of(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: Icon(Icons.flag_outlined, color: colorScheme.error),
              title: Text(
                localizations?.reportProduct ?? 'Report',
                style: TextStyle(color: colorScheme.error),
              ),
              onTap: () {
                Navigator.pop(ctx);
                _showReportDialog();
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSlider(List<String> imageUrls) {
    final colorScheme = Theme.of(context).colorScheme;

    if (imageUrls.isEmpty) {
      return Container(
        color: colorScheme.surfaceContainerHighest,
        child: Center(
          child: Icon(
            Icons.image_not_supported_outlined,
            size: 64,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        // Image PageView
        PageView.builder(
          controller: _pageController,
          onPageChanged: (index) => setState(() => _currentImageIndex = index),
          itemCount: imageUrls.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ImageViewer(
                      imageUrls: imageUrls,
                      initialIndex: index,
                    ),
                  ),
                );
              },
              child: CachedNetworkImageWidget(
                imageUrl: imageUrls[index],
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            );
          },
        ),
        // Page indicator - Carrot style (bottom center, simple dots)
        if (imageUrls.length > 1)
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(imageUrls.length, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: _currentImageIndex == index ? 20 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: _currentImageIndex == index
                        ? colorScheme.surface
                        : colorScheme.surface.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(3),
                  ),
                );
              }),
            ),
          ),
        // Image counter badge
        if (imageUrls.length > 1)
          Positioned(
            bottom: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: colorScheme.scrim.withOpacity(0.6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${_currentImageIndex + 1}/${imageUrls.length}',
                style: TextStyle(
                  color: colorScheme.surface,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSellerSection() {
    final colorScheme = Theme.of(context).colorScheme;
    final localizations = AppLocalizations.of(context);
    final seller = widget.product.userName;
    final sellerId = seller.id;

    return InkWell(
      onTap: sellerId > 0 ? () => context.push('/user/$sellerId') : null,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Seller avatar
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: colorScheme.outline.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: ClipOval(
                child: seller.profileImage?.image != null
                    ? CachedNetworkImageWidget(
                        imageUrl: ImageUtils.buildImageUrl(seller.profileImage!.image),
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        color: colorScheme.surfaceContainerHighest,
                        child: Icon(
                          Icons.person,
                          color: colorScheme.onSurfaceVariant,
                          size: 24,
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 12),
            // Seller info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    seller.username ?? (localizations?.username ?? 'Unknown'),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    seller.location != null
                        ? '${seller.location!.region ?? ''}'
                        : (localizations?.searchLocation ?? 'Location'),
                    style: TextStyle(
                      fontSize: 13,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            // Chevron
            Icon(
              Icons.chevron_right_rounded,
              color: colorScheme.onSurfaceVariant,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 8,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
    );
  }

  Widget _buildProductInfo() {
    final colorScheme = Theme.of(context).colorScheme;
    final localizations = AppLocalizations.of(context);
    final product = _currentProduct ?? widget.product;

    // Format price
    final priceValue = int.tryParse(product.price) ?? 0;
    final formattedPrice = NumberFormat('#,###', 'en_US').format(priceValue);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            product.title ?? (localizations?.newProductTitle ?? 'No Title'),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          // Category + Time ago row
          Row(
            children: [
              // Category chip
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  getCategoryName().isNotEmpty
                      ? getCategoryName()
                      : (localizations?.newProductCategory ?? 'Category'),
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Time ago
              Text(
                _getTimeAgo(product.createdAt),
                style: TextStyle(
                  fontSize: 13,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Price - Carrot style (large, bold)
          Text(
            '$formattedPrice ${product.currency}',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: colorScheme.onSurface,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 16),
          // Stats row (likes, views)
          Row(
            children: [
              Icon(
                Icons.favorite_border,
                size: 16,
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
              Text(
                '${product.likeCount}',
                style: TextStyle(
                  fontSize: 13,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.comment_outlined,
                size: 16,
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
              Text(
                '${product.commentCount}',
                style: TextStyle(
                  fontSize: 13,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    final colorScheme = Theme.of(context).colorScheme;
    final localizations = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizations?.newProductDescription ?? 'Description',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            widget.product.description ??
                (localizations?.newProductDescription ?? 'No description'),
            style: TextStyle(
              fontSize: 15,
              color: colorScheme.onSurface.withOpacity(0.85),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendedProducts() {
    final colorScheme = Theme.of(context).colorScheme;
    final localizations = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Text(
            localizations?.recommendedProducts ?? 'Similar items',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
        ),
        FutureBuilder<List<Products>>(
          future: ref
              .read(productsServiceProvider)
              .getSingleProduct(productId: widget.product.id.toString()),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(32.0),
                child: Center(
                  child: Text(
                    localizations?.productError ?? 'No recommendations',
                    style: TextStyle(color: colorScheme.onSurfaceVariant),
                  ),
                ),
              );
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ProductMain(product: snapshot.data![index]);
              },
            );
          },
        ),
      ],
    );
  }

  // Carrot-style bottom bar
  Widget _buildCarrotBottomBar() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final localizations = AppLocalizations.of(context);
    final product = _currentProduct ?? widget.product;

    // Format price
    final priceValue = int.tryParse(product.price) ?? 0;
    final formattedPrice = NumberFormat('#,###', 'en_US').format(priceValue);

    final currentLikeStatus = _isLiked ?? false;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: colorScheme.outlineVariant.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Row(
            children: [
              // Heart button (Carrot style)
              GestureDetector(
                onTap: _isLiking ? null : _toggleLike,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: colorScheme.outline.withOpacity(0.3),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _isLiking
                      ? const Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : Icon(
                          currentLikeStatus ? Icons.favorite : Icons.favorite_border,
                          color: currentLikeStatus ? Colors.red : colorScheme.onSurfaceVariant,
                          size: 24,
                        ),
                ),
              ),
              const SizedBox(width: 12),
              // Divider
              Container(
                width: 1,
                height: 36,
                color: colorScheme.outline.withOpacity(0.2),
              ),
              const SizedBox(width: 12),
              // Price
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$formattedPrice ${product.currency}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Chat button (Carrot style - orange)
              SizedBox(
                height: 48,
                child: FilledButton(
                  onPressed: _startChat,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6F0F), // Carrot orange
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                  ),
                  child: Text(
                    localizations?.chat ?? 'Chat',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
