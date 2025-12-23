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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    List<ImageProvider> images = service.images.isNotEmpty
        ? service.images
            .map((image) => NetworkImage('${image.image}') as ImageProvider)
            .toList()
        : [
            const AssetImage('assets/logo/logo_no_background.png')
                as ImageProvider
          ];

    return Container(
      height: 380,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
      ),
      child: Stack(
        children: [
          PageView.builder(
            controller: pageController,
            itemCount: images.length,
            itemBuilder: (context, index) {
              return Image(image: images[index], fit: BoxFit.cover);
            },
          ),
          // Gradient overlay at bottom
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
          if (images.length > 1) ...[
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
                      if (pageController.hasClients &&
                          pageController.page != null) {
                        int currentPage = pageController.page!.toInt();
                        if (currentPage > 0) {
                          pageController.previousPage(
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
                      if (pageController.hasClients &&
                          pageController.page != null) {
                        int currentPage = pageController.page!.toInt();
                        if (currentPage < images.length - 1) {
                          pageController.nextPage(
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
                  controller: pageController,
                  count: images.length,
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
}
