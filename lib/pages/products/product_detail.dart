import 'package:app/constants/constants.dart';
import 'package:app/pages/products/main_products.dart';
import 'package:app/providers/provider_models/favorite_items.dart';
import 'package:app/providers/provider_root/product_provider.dart';
import 'package:app/providers/provider_root/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/providers/provider_models/product_model.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ProductDetail extends ConsumerStatefulWidget {
  const ProductDetail({super.key, required this.product});
  final Products product;

  @override
  ConsumerState<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends ConsumerState<ProductDetail> {
  late PageController _pageController;
  bool _isLiking = false; // Track like/dislike loading state

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

  Future<void> _likeProduct() async {
    if (_isLiking) return; // Prevent multiple simultaneous requests

    setState(() {
      _isLiking = true;
    });

    try {
      final product = await ref
          .read(profileServiceProvider) // Use read instead of watch
          .likeSingleProduct(productId: widget.product.id.toString());

      if (product != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(milliseconds: 1000),
            content: Text('Product liked successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        // Invalidate to refresh the favorite items
        ref.invalidate(profileServiceProvider);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(milliseconds: 1000),
            content: Text('Error liking product: $e'),
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
      final product = await ref
          .read(profileServiceProvider)
          .dislikeProductItem(productId: widget.product.id.toString());

      if (product != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(milliseconds: 1000),
            content: Text('Product disliked successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        ref.invalidate(profileServiceProvider);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(milliseconds: 1000),
            content: Text('Error disliking product: $e'),
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
    // Creating a list of images
    List<ImageProvider> images = widget.product.images.isNotEmpty
        ? widget.product.images
            .map((image) =>
                NetworkImage('${baseUrl}${image.image}') as ImageProvider)
            .toList()
        : [
            const AssetImage('assets/logo/logo_no_background.png')
                as ImageProvider,
          ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Page'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // Optimized Image Slider
            _buildImageSlider(images),

            // Dots Indicator
            if (images.length > 1)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: SmoothPageIndicator(
                  controller: _pageController,
                  count: images.length,
                  effect: const WormEffect(
                    dotWidth: 8.0,
                    dotHeight: 8.0,
                    dotColor: Colors.grey,
                    activeDotColor: Colors.blue,
                  ),
                ),
              ),

            // User Profile and Location
            _buildUserProfile(),

            // Product Title
            _buildProductTitle(),

            // Product Category
            _buildProductCategory(),

            // Product Description
            _buildProductDescription(),

            // Fixed Recommended Products Section
            _buildRecommendedProducts(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildImageSlider(List<ImageProvider> images) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        height: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Stack(
          children: [
            // PageView with images
            PageView.builder(
              controller: _pageController,
              itemCount: images.length,
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image(
                    image: images[index],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey.shade200,
                        child: const Icon(
                          Icons.image_not_supported,
                          color: Colors.grey,
                          size: 50,
                        ),
                      );
                    },
                  ),
                );
              },
            ),

            // Navigation arrows (only show if more than 1 image)
            if (images.length > 1) ...[
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
                        if (currentPage < images.length - 1) {
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            radius: 21,
            backgroundImage: widget
                        .product.userName?.profileImage?.image?.isNotEmpty ==
                    true
                ? NetworkImage(
                    '${baseUrl}${widget.product.userName!.profileImage!.image}')
                : null,
            child:
                widget.product.userName?.profileImage?.image?.isNotEmpty != true
                    ? const Icon(Icons.person, color: Colors.grey)
                    : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.product.userName?.username ?? 'Unknown User',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  widget.product.userName?.location != null
                      ? '${widget.product.userName!.location!.region ?? ''}, ${widget.product.userName!.location!.district ?? ''}'
                      : 'Location not available',
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          widget.product.title ?? 'No Title',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildProductCategory() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 8.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          widget.product.category?.nameUz ?? 'No Category',
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          widget.product.description ?? 'No Description',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildRecommendedProducts() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Recommended Products',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),

          // FIXED: Simplified FutureBuilder without Future.wait
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
                        Text('Error: ${snapshot.error}'),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () => setState(() {}), // Retry
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text('No recommended products available.'),
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
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Colors.black, width: 1.0)),
      ),
      height: 80,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left side: Heart and price
            Row(
              children: [
                // Optimized heart button
                _buildLikeButton(),
                const SizedBox(width: 8),
                Text(
                  '${widget.product.price} So\'m',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            // Right side: Chat button
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: SizedBox(
                height: 50,
                width: 90,
                child: ElevatedButton(
                  onPressed: () {
                    print('Chat button pressed');
                    // Add your chat functionality here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    'Chat',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLikeButton() {
    // Use a simple state-based approach instead of FutureBuilder
    return StatefulBuilder(
      builder: (context, setState) {
        bool? isLiked; // Track like status locally
        bool isLoadingStatus = false;

        // Only load the like status once when first built
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
                isLiked = false; // Default to not liked on error
                isLoadingStatus = false;
              });
            }
          });
        }

        // Show loading only for the initial status check or when liking/disliking
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

        // Show the heart with current status
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
                  // Update UI immediately (optimistic update)
                  setState(() {
                    isLiked = !currentLikeStatus;
                  });

                  // Then perform the actual like/dislike operation
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
