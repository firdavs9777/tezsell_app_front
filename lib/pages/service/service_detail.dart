import 'package:app/constants/constants.dart';
import 'package:app/pages/products/main_products.dart';
import 'package:app/pages/service/services_list.dart';
import 'package:app/providers/provider_models/service_model.dart';
import 'package:app/providers/provider_root/service_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ServiceDetail extends ConsumerWidget {
  const ServiceDetail({super.key, required this.service});
  final Services service;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Creating a list of images
    List<ImageProvider> images = service.images.isNotEmpty
        ? service.images
            .map((image) => NetworkImage('${baseUrl}/services${image.image}')
                as ImageProvider)
            .toList()
        : [
            const AssetImage('assets/logo/logo_no_background.png')
                as ImageProvider,
          ];

    // PageController for controlling the PageView and page transitions
    PageController _pageController = PageController();

    // Fetching the recommended products
    final productsList = ref
        .watch(serviceMainProvider)
        .getSingleService(serviceId: service.id.toString());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Detail'),
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
                                duration: const Duration(milliseconds: 300),
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
                    backgroundImage: service
                            .userName.profileImage.image.isNotEmpty
                        ? NetworkImage(
                            '${baseUrl}${service.userName.profileImage.image}')
                        : null,
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      service.userName.username,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '${service.userName.location.region}, ${service.userName.location.district}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Product Category
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 8.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  service.category.name,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    decoration: TextDecoration.underline,
                    decorationThickness: 2,
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    service.name!,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
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
                    service.description!,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Comments',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
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
                    padding: const EdgeInsets.all(8.0),
                    child: FutureBuilder<List<Services>>(
                      future: ref.watch(serviceMainProvider).getSingleService(
                            serviceId: service.id.toString(),
                          ),
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
                          final recommendedServices = snapshot.data!;
                          if (recommendedServices.isEmpty) {
                            return const Center(
                                child:
                                    Text('No recommended products available.'));
                          }
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: recommendedServices.length,
                            itemBuilder: (context, index) {
                              final recommendedService =
                                  recommendedServices[index];
                              return ServiceList(
                                  service:
                                      recommendedService); // Assuming ProductMain widget exists
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
                  IconButton(
                    icon: const Icon(Icons.favorite_border,
                        color: Colors.black), // Heart icon
                    onPressed: () {
                      // Define action for liking the product
                      print('Heart button pressed');
                    },
                  )
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
