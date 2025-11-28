import 'package:app/constants/constants.dart';
import 'package:app/pages/chat/chat_room.dart';
import 'package:app/pages/products/main_products.dart';
import 'package:app/providers/provider_root/chat_provider.dart';
import 'package:app/providers/provider_root/product_provider.dart';
import 'package:app/providers/provider_root/profile_provider.dart';
import 'package:app/utils/image_utils.dart';
import 'package:app/widgets/cached_network_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/providers/provider_models/product_model.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductDetail extends ConsumerStatefulWidget {
  const ProductDetail({super.key, required this.product});
  final Products product;

  @override
  ConsumerState<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends ConsumerState<ProductDetail> {
  late PageController _pageController;
  bool _isLiking = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
  // Add this helper method to your _ProductDetailState class

  String _maskPhoneNumber(String phoneNumber) {
    if (phoneNumber.isEmpty) return '';

    // Remove any spaces or special characters
    final cleaned = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');

    if (cleaned.length <= 4) return cleaned;

    // Show first 3 and last 2 digits: +998 90 *** ** 45
    if (cleaned.startsWith('+')) {
      // International format: +998 90 123 45 67 → +998 90 *** ** 67
      if (cleaned.length > 7) {
        final countryCode = cleaned.substring(0, 4); // +998
        final firstDigits = cleaned.substring(4, 6); // 90
        final lastDigits = cleaned.substring(cleaned.length - 2); // 67
        return '$countryCode $firstDigits *** ** $lastDigits';
      }
    }

    // Local format: show first 2 and last 2
    final first = cleaned.substring(0, 2);
    final last = cleaned.substring(cleaned.length - 2);
    final maskLength = cleaned.length - 4;
    return '$first${'*' * maskLength}$last';
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

  // Add chat functionality
  Future<void> _startChat() async {
    final targetUserId = widget.product.userName.id;
    final userName = widget.product.userName.username ?? 'Product Seller';
    final localizations = AppLocalizations.of(context);

    // Check authentication
    final chatState = ref.read(chatProvider);
    if (!chatState.isAuthenticated) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please log in to start a chat'),
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

  Future<void> _makePhoneCall() async {
    final phoneNumber = widget.product.userName.phoneNumber;
    final localizations = AppLocalizations.of(context);

    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );

    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        throw Exception('Could not launch phone dialer');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open phone dialer'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(milliseconds: 1000),
            content: Text(
                localizations?.likeProductError ?? 'Error liking product: $e'),
            backgroundColor: Colors.red,
          ),
        );
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(milliseconds: 1000),
            content: Text(localizations?.dislikeProductError ??
                'Error disliking product: $e'),
            backgroundColor: Colors.red,
          ),
        );
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

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations?.productDetail ?? 'Detail Page'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _buildImageSlider(imageUrls),
            if (imageUrls.length > 1)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: SmoothPageIndicator(
                  controller: _pageController,
                  count: imageUrls.length,
                  effect: const WormEffect(
                    dotWidth: 8.0,
                    dotHeight: 8.0,
                    dotColor: Colors.grey,
                    activeDotColor: Colors.blue,
                  ),
                ),
              ),
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
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        height: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Stack(
          children: [
            CachedImageSlider(
              imageUrls: imageUrls,
              height: 250,
              fit: BoxFit.cover,
              pageController: _pageController,
              borderRadius: BorderRadius.circular(8.0),
            ),
            if (imageUrls.length > 1) ...[
              Positioned(
                left: 10,
                top: 100,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () {
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
                  ),
                ),
              ),
              Positioned(
                right: 10,
                top: 100,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_forward_ios,
                        color: Colors.white),
                    onPressed: () {
                      if (_pageController.hasClients &&
                          _pageController.page != null) {
                        int currentPage = _pageController.page!.toInt();
                        if (currentPage < imageUrls.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeInOut,
                          );
                        }
                      }
                    },
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildUserProfile() {
    final localizations = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          CachedNetworkImageWidget.circular(
            imageUrl: widget.product.userName?.profileImage?.image,
            radius: 21,
            errorWidget: const Icon(Icons.person, color: Colors.grey),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.product.userName?.username ??
                      (localizations?.username ?? 'Unknown User'),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  widget.product.userName?.location != null
                      ? '${widget.product.userName!.location!.region ?? ''}, ${widget.product.userName!.location!.district ?? ''}'
                      : (localizations?.searchLocation ??
                          'Location not available'),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductTitle() {
    final localizations = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          widget.product.title ??
              (localizations?.newProductTitle ?? 'No Title'),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildProductCategory() {
    final localizations = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 8.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          getCategoryName().isNotEmpty
              ? getCategoryName()
              : (localizations?.newProductCategory ?? 'No Category'),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
            decoration: TextDecoration.underline,
            decorationThickness: 2,
          ),
        ),
      ),
    );
  }

  Widget _buildProductDescription() {
    final localizations = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          widget.product.description ??
              (localizations?.newProductDescription ?? 'No Description'),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.normal,
          ),
        ),
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
    final localizations = AppLocalizations.of(context);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizations?.contactSeller ?? 'Contact Seller',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(Icons.phone, size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            _maskPhoneNumber(
                                widget.product.userName.phoneNumber),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    // 🔥 Add hint text
                    Text(
                      localizations?.callToReveal ?? 'Tap "Call" to reveal',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.blue[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // Chat button
              ElevatedButton.icon(
                onPressed: _startChat,
                icon: const Icon(Icons.chat_bubble_outline, size: 20),
                label: Text(localizations?.chat ?? 'Chat'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // Call button
              ElevatedButton.icon(
                onPressed: _makePhoneCall,
                icon: const Icon(Icons.phone, size: 20),
                label: Text('Call'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
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
    return StatefulBuilder(
      builder: (context, setState) {
        bool? isLiked;
        bool isLoadingStatus = false;

        if (isLiked == null && !isLoadingStatus) {
          isLoadingStatus = true;
          ref
              .read(profileServiceProvider)
              .getUserFavoriteItems()
              .then((favoriteItems) {
            if (mounted) {
              setState(() {
                isLiked = favoriteItems.likedProducts
                    .any((item) => item.id == widget.product.id);
                isLoadingStatus = false;
              });
            }
          }).catchError((error) {
            if (mounted) {
              setState(() {
                isLiked = false;
                isLoadingStatus = false;
              });
            }
          });
        }

        if ((isLiked == null && isLoadingStatus) || _isLiking) {
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

        final currentLikeStatus = isLiked ?? false;

        return TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 300),
          tween: Tween<double>(begin: 1.0, end: currentLikeStatus ? 1.1 : 1.0),
          curve: Curves.elasticInOut,
          builder: (context, scale, child) {
            return Transform.scale(
              scale: scale,
              child: IconButton(
                icon: Icon(
                  currentLikeStatus ? Icons.favorite : Icons.favorite_border,
                  color: Colors.red,
                  size: 28.0,
                ),
                onPressed: () async {
                  setState(() {
                    isLiked = !currentLikeStatus;
                  });

                  if (currentLikeStatus) {
                    await _dislikeProduct();
                  } else {
                    await _likeProduct();
                  }
                },
              ),
            );
          },
        );
      },
    );
  }
}
