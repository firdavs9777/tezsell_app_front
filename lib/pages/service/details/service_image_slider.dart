// Keep the existing classes (ServiceImageSlider, ServiceDetailsSection, RecommendedServicesSection)
import 'package:app/constants/constants.dart';
import 'package:app/providers/provider_models/service_model.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ServiceImageSlider extends StatelessWidget {
  const ServiceImageSlider({
    super.key,
    required this.service,
    required this.pageController,
  });

  final Services service;
  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    List<ImageProvider> images = service.images.isNotEmpty
        ? service.images
            .map((image) =>
                NetworkImage('${baseUrl}${image.image}') as ImageProvider)
            .toList()
        : [
            const AssetImage('assets/logo/logo_no_background.png')
                as ImageProvider
          ];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: Container(
            height: 250,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
            child: Stack(
              children: [
                PageView.builder(
                  controller: pageController,
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    return Image(image: images[index], fit: BoxFit.cover);
                  },
                ),
                Positioned(
                  left: 10,
                  top: 100,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      if (pageController.page!.toInt() > 0) {
                        pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
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
                      if (pageController.page!.toInt() < images.length - 1) {
                        pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        SmoothPageIndicator(
          controller: pageController,
          count: images.length,
          effect: const WormEffect(
              dotWidth: 8.0,
              dotHeight: 8.0,
              dotColor: Colors.grey,
              activeDotColor: Colors.blue),
        ),
      ],
    );
  }
}
