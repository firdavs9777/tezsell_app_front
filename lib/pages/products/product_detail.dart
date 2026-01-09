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

class ProductDetail extends ConsumerStatefulWidget {
  const ProductDetail({super.key, required this.product});
  final Products product;

  @override
  ConsumerState<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends ConsumerState<ProductDetail> {
  late PageController _pageController;
  bool _isLiking = false;
  Products? _currentProduct; // Track current product state with updated like count
  bool? _isLiked; // Track if product is liked
  bool _isLoadingLikeStatus = false; // Track loading state for like status

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _currentProduct = widget.product; // Initialize with passed product
    _loadLikeStatus(); // Load like status on init
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

  Future<void> _showReportDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => ReportContentDialog(
        contentType: 'product',
        contentId: widget.product.id,
        contentTitle: widget.product.title,
      ),
    );
    
    // Show success message if report was successful
    if (result == true && mounted) {
      final localizations = AppLocalizations.of(context);
      AppErrorHandler.showSuccess(
        context,
        localizations?.reportSubmitted ??
            'Thank you for your report. We will review it within 24 hours.',
      );
    }
  }

  // Add chat functionality
  Future<void> _startChat() async {
    final targetUserId = widget.product.userName.id;
    final userName = widget.product.userName.username ?? 'Product Seller';
    final localizations = AppLocalizations.of(context);

    // Initialize chat provider if not already initialized
    await ref.read(chatProvider.notifier).initialize();

    // Check authentication after initialization
    final chatState = ref.read(chatProvider);
    if (!chatState.isAuthenticated) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localizations?.chatLoginMessage ?? 'Please log in to start a chat'),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
      return;
    }

    // Prevent chatting with yourself
    if (chatState.currentUserId == targetUserId) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('You cannot chat with yourself'),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
      return;
    }

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
              const SizedBox(height: 16),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Opening chat...',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    try {
      // Get or create chat room
      final chatRoom = await ref
          .read(chatProvider.notifier)
          .getOrCreateDirectChat(targetUserId);

      // Close loading dialog
      if (mounted) Navigator.of(context).pop();

      if (chatRoom != null) {
        if (mounted) {
          // Navigate to chat room
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatRoomScreen(chatRoom: chatRoom),
            ),
          );
        }
      } else {
        throw Exception('Failed to create chat room');
      }
    } catch (e) {
      // Close loading dialog if still open
      if (mounted && Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }

      // Show error with retry option
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(localizations?.error ?? 'Chat Error'),
            content: Text(
              e.toString().contains('Failed to create')
                  ? 'Failed to start chat. Please try again.'
                  : e.toString(),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(localizations?.cancel ?? 'Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _startChat(); // Retry
                },
                child: Text(localizations?.retry ?? 'Retry'),
              ),
            ],
          ),
        );
      }
    }
  }


  Future<void> _likeProduct() async {
    if (_isLiking) return;

    setState(() {
      _isLiking = true;
    });

    try {
      final localizations = AppLocalizations.of(context);
      final product = await ref
          .read(profileServiceProvider)
          .likeSingleProduct(productId: widget.product.id.toString());

      if (product != null && mounted) {
        setState(() {
          _currentProduct = product; // Update product with new like count
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(milliseconds: 1000),
            content: Text(localizations?.productLikeSuccess ??
                'Product liked successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        ref.invalidate(profileServiceProvider);
      }
    } catch (e) {
      if (mounted) {
        final localizations = AppLocalizations.of(context);
        final errorMessage = e.toString();
        
        // Don't show error if already liked (this is expected behavior)
        if (!errorMessage.contains('already liked')) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: const Duration(milliseconds: 2000),
              content: Text(
                  localizations?.likeProductError ?? 'Error liking product: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLiking = false;
        });
      }
    }
  }

  Future<void> _dislikeProduct() async {
    if (_isLiking) return;

    setState(() {
      _isLiking = true;
    });

    try {
      final localizations = AppLocalizations.of(context);
      final product = await ref
          .read(profileServiceProvider)
          .dislikeProductItem(productId: widget.product.id.toString());

      if (product != null && mounted) {
        setState(() {
          _currentProduct = product; // Update product with new like count
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(milliseconds: 1000),
            content: Text(localizations?.productDislikeSuccess ??
                'Product disliked successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        ref.invalidate(profileServiceProvider);
      }
    } catch (e) {
      if (mounted) {
        final localizations = AppLocalizations.of(context);
        final errorMessage = e.toString();
        
        // Don't show error if already disliked (this is expected behavior)
        if (!errorMessage.contains('already disliked')) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: const Duration(milliseconds: 2000),
              content: Text(localizations?.dislikeProductError ??
                  'Error disliking product: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLiking = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    // Build image URLs for cached image slider
    final List<String> imageUrls = widget.product.images.isNotEmpty
        ? widget.product.images
            .map((image) => ImageUtils.buildImageUrl(image.image))
            .toList()
        : [];

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        foregroundColor: colorScheme.onSurface,
        title: Text(
          localizations?.productDetail ?? 'Detail Page',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.3,
          ),
        ),
        actions: [
          _buildLikeButton(),
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert_rounded,
              color: colorScheme.onSurface,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            onSelected: (value) {
              if (value == 'report') {
                _showReportDialog();
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'report',
                child: Row(
                  children: [
                    Icon(
                      Icons.flag_rounded,
                      color: colorScheme.error,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      localizations?.reportProduct ?? 'Report Product',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _buildImageSlider(imageUrls),
            _buildUserProfile(),
            _buildProductTitle(),
            _buildProductCategory(),
            _buildProductDescription(),
            _buildRecommendedProducts(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildImageSlider(List<String> imageUrls) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Container(
      height: 380,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
      ),
      child: Stack(
        children: [
          CachedImageSlider(
            imageUrls: imageUrls,
            height: 380,
            fit: BoxFit.contain,
            pageController: _pageController,
            borderRadius: BorderRadius.zero,
            onImageTap: (index) {
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
          ),
          // Gradient overlay at bottom for better text readability
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.3),
                  ],
                ),
              ),
            ),
          ),
          if (imageUrls.length > 1) ...[
            // Left navigation button
            Positioned(
              left: 16,
              top: 0,
              bottom: 0,
              child: Center(
                child: Material(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(24),
                  elevation: 2,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(24),
                    onTap: () {
                      if (_pageController.hasClients &&
                          _pageController.page != null) {
                        int currentPage = _pageController.page!.toInt();
                        if (currentPage > 0) {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      }
                    },
                    child: Container(
                      width: 48,
                      height: 48,
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.chevron_left_rounded,
                        color: colorScheme.onSurface,
                        size: 28,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Right navigation button
            Positioned(
              right: 16,
              top: 0,
              bottom: 0,
              child: Center(
                child: Material(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(24),
                  elevation: 2,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(24),
                    onTap: () {
                      if (_pageController.hasClients &&
                          _pageController.page != null) {
                        int currentPage = _pageController.page!.toInt();
                        if (currentPage < imageUrls.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      }
                    },
                    child: Container(
                      width: 48,
                      height: 48,
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.chevron_right_rounded,
                        color: colorScheme.onSurface,
                        size: 28,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Page indicator at bottom
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Center(
                child: SmoothPageIndicator(
                  controller: _pageController,
                  count: imageUrls.length,
                  effect: WormEffect(
                    dotWidth: 8.0,
                    dotHeight: 8.0,
                    spacing: 6.0,
                    dotColor: Colors.white.withOpacity(0.4),
                    activeDotColor: Colors.white,
                    paintStyle: PaintingStyle.fill,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildUserProfile() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final localizations = AppLocalizations.of(context);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.08),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: colorScheme.primary.withOpacity(0.2),
                width: 2,
              ),
            ),
            child: CachedNetworkImageWidget.circular(
              imageUrl: widget.product.userName?.profileImage?.image,
              radius: 28,
              onTap: widget.product.userName?.profileImage?.image != null
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ImageViewer(
                            imageUrl: widget.product.userName!.profileImage!.image,
                            title: widget.product.userName?.username ?? 'Profile Picture',
                          ),
                        ),
                      );
                    }
                  : null,
              errorWidget: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.surfaceContainerHighest,
                ),
                child: Icon(
                  Icons.person_rounded,
                  color: colorScheme.onSurface.withOpacity(0.5),
                  size: 28,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.product.userName?.username ??
                      (localizations?.username ?? 'Unknown User'),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 17,
                    color: colorScheme.onSurface,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      size: 16,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        widget.product.userName?.location != null
                            ? '${widget.product.userName!.location!.region ?? ''}, ${widget.product.userName!.location!.district ?? ''}'
                            : (localizations?.searchLocation ??
                                'Location not available'),
                        style: TextStyle(
                          fontSize: 14,
                          color: colorScheme.onSurface.withOpacity(0.7),
                          fontWeight: FontWeight.w400,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductTitle() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final localizations = AppLocalizations.of(context);

    // Format price
    final priceValue = int.tryParse(widget.product.price) ?? 0;
    final formattedPrice = NumberFormat('#,##0', 'ko_KR').format(priceValue);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Price display - prominent at top
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: colorScheme.primary.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$formattedPrice',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onPrimaryContainer,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  widget.product.currency,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onPrimaryContainer.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Title
          Text(
            widget.product.title ??
                (localizations?.newProductTitle ?? 'No Title'),
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
              height: 1.3,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCategory() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final localizations = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Align(
        alignment: Alignment.topLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: colorScheme.primary.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.category_rounded,
                size: 16,
                color: colorScheme.onPrimaryContainer,
              ),
              const SizedBox(width: 6),
              Text(
                getCategoryName().isNotEmpty
                    ? getCategoryName()
                    : (localizations?.newProductCategory ?? 'No Category'),
                style: TextStyle(
                  color: colorScheme.onPrimaryContainer,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductDescription() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final localizations = AppLocalizations.of(context);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.08),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.description_rounded,
                size: 20,
                color: colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                localizations?.newProductDescription ?? 'Description',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            widget.product.description ??
                (localizations?.newProductDescription ?? 'No Description'),
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: colorScheme.onSurface.withOpacity(0.8),
              height: 1.6,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendedProducts() {
    final localizations = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            localizations?.recommendedProducts ?? 'Recommended Products',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          FutureBuilder<List<Products>>(
            future: ref
                .read(productsServiceProvider)
                .getSingleProduct(productId: widget.product.id.toString()),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        const Icon(Icons.error, color: Colors.red),
                        const SizedBox(height: 8),
                        Text(
                            '${localizations?.error ?? "Error"}: ${snapshot.error}'),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () => setState(() {}),
                          child: Text(localizations?.retry ?? 'Retry'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(localizations?.productError ??
                        'No recommended products available.'),
                  ),
                );
              }

              final recommendedProducts = snapshot.data!;

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: recommendedProducts.length,
                itemBuilder: (context, index) {
                  return ProductMain(product: recommendedProducts[index]);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final localizations = AppLocalizations.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            color: colorScheme.outline.withOpacity(0.08),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Row(
            children: [
              // Chat button - expanded to take full width
              Expanded(
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.primary.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: _startChat,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chat_bubble_outline_rounded,
                            color: colorScheme.onPrimary,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            localizations?.chat ?? 'Chat',
                            style: TextStyle(
                              color: colorScheme.onPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
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

  Widget _buildLikeButton() {
    final product = _currentProduct ?? widget.product;
    final likeCount = product.likeCount;

    // Show loading indicator while checking like status or during like/unlike action
    if ((_isLiked == null && _isLoadingLikeStatus) || _isLiking) {
      return const SizedBox(
        width: 48,
        height: 48,
        child: Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    final currentLikeStatus = _isLiked ?? false;

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 300),
      tween: Tween<double>(begin: 1.0, end: currentLikeStatus ? 1.1 : 1.0),
      curve: Curves.elasticInOut,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  currentLikeStatus ? Icons.favorite : Icons.favorite_border,
                  color: Colors.red,
                  size: 28.0,
                ),
                onPressed: () async {
                  // Optimistic update
                  setState(() {
                    _isLiked = !currentLikeStatus;
                  });

                  try {
                    if (currentLikeStatus) {
                      await _dislikeProduct();
                    } else {
                      await _likeProduct();
                    }
                    // Refresh like status after action to ensure sync
                    await _loadLikeStatus(forceRefresh: true);
                  } catch (e) {
                    // Revert on error
                    setState(() {
                      _isLiked = currentLikeStatus;
                    });
                  }
                },
              ),
              if (likeCount > 0)
                Text(
                  likeCount.toString(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
