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
  void _likeProduct() async {
    try {
      final product = await ref
          .watch(profileServiceProvider)
          .likeSingleProduct(productId: widget.product.id.toString());

      if (product != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: Duration(milliseconds: 1000),
            content: Text('Product liked successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        ref.refresh(profileServiceProvider).getUserFavoriteItems();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(milliseconds: 1000),
          content: Text('Error liking product: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _dislikeProduct() async {
    try {
      final product = await ref
          .watch(profileServiceProvider)
          .dislikeProductItem(productId: widget.product.id.toString());

      if (product != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: Duration(milliseconds: 1000),
            content: Text('Product disliked successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        ref.refresh(profileServiceProvider).getUserFavoriteItems();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(milliseconds: 1000),
          content: Text('Error liking product: $e'),
          backgroundColor: Colors.red,
        ),
      );
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

    // PageController for controlling the PageView and page transitions
    PageController _pageController = PageController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Page'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // Image Slider (PageView)
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Container(
                height: 250, // Set height for the image
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
                        return Image(
                          image: images[index],
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                    // Next and Previous buttons (overlayed)
                    Positioned(
                      left: 10,
                      top: 100,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        onPressed: () {
                          if (_pageController.hasClients) {
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
                    Positioned(
                      right: 10,
                      top: 100,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_forward_ios),
                        onPressed: () {
                          if (_pageController.hasClients) {
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
                  ],
                ),
              ),
            ),
            Text(widget.product.id.toString()),
            // Dots Indicator (at the bottom of the image slider)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: SmoothPageIndicator(
                controller: _pageController, // Pass the controller
                count: images.length, // Number of images
                effect: WormEffect(
                  dotWidth: 8.0,
                  dotHeight: 8.0,
                  dotColor: Colors.grey,
                  activeDotColor: Colors.blue,
                ),
              ),
            ),

            // User Profile and Location
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: 21,
                    backgroundImage: widget
                            .product.userName.profileImage.image.isNotEmpty
                        ? NetworkImage(
                            '${baseUrl}${widget.product.userName.profileImage.image}')
                        : null,
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.product.userName.username,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '${widget.product.userName.location.region}, ${widget.product.userName.location.district}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Product Title
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.product.title!,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            // Product Category
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 8.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  widget.product.category.nameRu,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    decoration: TextDecoration.underline,
                    decorationThickness: 2,
                  ),
                ),
              ),
            ),

            // Product Description
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.product.title!,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),

            // Recommended Products Section
            Padding(
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
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: FutureBuilder<List<dynamic>>(
                      future: Future.wait([
                        ref.watch(productsServiceProvider).getSingleProduct(
                              productId: widget.product.id.toString(),
                            ),
                      ]),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        if (snapshot.hasError) {
                          return const Center(
                              child: Text('Error loading products'));
                        }

                        if (snapshot.hasData) {
                          final recommendedProducts = snapshot.data![0];

                          if (recommendedProducts.isEmpty) {
                            return const Center(
                                child:
                                    Text('No recommended products available.'));
                          }
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: recommendedProducts.length,
                            itemBuilder: (context, index) {
                              final recommendedProduct =
                                  recommendedProducts[index];
                              return ProductMain(
                                  product:
                                      recommendedProduct); // Assuming ProductMain widget exists
                            },
                          );
                        }

                        return const Center(
                            child: Text('No recommended products found.'));
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Colors.black, width: 1.0))),
        // Set the background color for the bottom
        height: 80, // Height of the bottom container
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween, // Distribute elements evenly
            children: [
              // Left side: Heart sticker for like and price

              Row(
                children: [
                  FutureBuilder<FavoriteItems>(
                    future: ref
                        .watch(profileServiceProvider)
                        .getUserFavoriteItems(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return const Center(
                            child: Text('Error loading favorite items'));
                      }

                      if (snapshot.hasData) {
                        final likedItems = snapshot.data!;
                        bool isLiked = likedItems.likedProducts
                            .any((item) => item.id == widget.product.id);

                        return TweenAnimationBuilder<double>(
                          duration: Duration(milliseconds: 300),
                          tween: Tween<double>(
                              begin: 1.0, end: isLiked ? 1.1 : 1.0),
                          curve: Curves.elasticInOut, // Adds a bounce effect
                          builder: (context, scale, child) {
                            return Transform.scale(
                              scale: scale,
                              child: IconButton(
                                icon: Icon(
                                  isLiked
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: Colors.red,
                                  size: 24.0, // Make the icon bigger
                                ),
                                onPressed:
                                    isLiked ? _dislikeProduct : _likeProduct,
                              ),
                            );
                          },
                        );
                      }

                      return const Center(
                          child: Text('No favorite items found.'));
                    },
                  ),
                  Text(
                    '${widget.product.price.toString()} So\'m', // Example price
                    style: TextStyle(
                      color: Colors.black, // Price text color
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              // Right side: Chat button
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Container(
                  margin: const EdgeInsets.all(5.0),
                  height: 60.0, // Set the height of the button
                  width: 90.0,
                  child: FloatingActionButton(
                    onPressed: () {
                      // Define action for the chat button, such as navigating to a chat screen
                      print('Chat button pressed');
                    },
                    child: Text('Chat'),
                    backgroundColor: Colors.orange, // Set the chat button color
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
