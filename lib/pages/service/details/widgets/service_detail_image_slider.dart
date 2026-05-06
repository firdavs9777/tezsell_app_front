import 'package:app/widgets/cached_network_image_widget.dart';
import 'package:app/widgets/image_viewer.dart';
import 'package:flutter/material.dart';

class ServiceDetailImageSlider extends StatefulWidget {
  const ServiceDetailImageSlider({super.key, required this.imageUrls});

  final List<String> imageUrls;

  @override
  State<ServiceDetailImageSlider> createState() =>
      _ServiceDetailImageSliderState();
}

class _ServiceDetailImageSliderState extends State<ServiceDetailImageSlider> {
  final PageController _pageController = PageController();
  int _currentImageIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final imageUrls = widget.imageUrls;

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
        PageView.builder(
          controller: _pageController,
          onPageChanged: (index) =>
              setState(() => _currentImageIndex = index),
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
                        ? Colors.white
                        : Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(3),
                  ),
                );
              }),
            ),
          ),
        if (imageUrls.length > 1)
          Positioned(
            bottom: 16,
            right: 16,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${_currentImageIndex + 1}/${imageUrls.length}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
          ),
      ],
    );
  }
}
