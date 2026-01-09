import 'package:cached_network_image/cached_network_image.dart';
import 'package:app/utils/image_utils.dart';
import 'package:app/utils/app_logger.dart';
import 'package:flutter/material.dart';

/// A full-screen image viewer with zoom and pan capabilities.
/// Supports both single image and multiple images with navigation.
/// 
/// Usage (single image):
/// ```dart
/// Navigator.push(
///   context,
///   MaterialPageRoute(
///     builder: (_) => ImageViewer(imageUrl: 'https://example.com/image.jpg'),
///   ),
/// );
/// ```
/// 
/// Usage (multiple images):
/// ```dart
/// Navigator.push(
///   context,
///   MaterialPageRoute(
///     builder: (_) => ImageViewer(
///       imageUrls: ['url1', 'url2', 'url3'],
///       initialIndex: 0,
///     ),
///   ),
/// );
/// ```
class ImageViewer extends StatefulWidget {
  /// Single image URL (for backward compatibility)
  final String? imageUrl;

  /// Multiple image URLs (for gallery view)
  final List<String>? imageUrls;

  /// Initial index when viewing multiple images
  final int initialIndex;

  /// Optional title for the app bar
  final String? title;

  const ImageViewer({
    super.key,
    this.imageUrl,
    this.imageUrls,
    this.initialIndex = 0,
    this.title,
  }) : assert(imageUrl != null || imageUrls != null, 'Either imageUrl or imageUrls must be provided');

  @override
  State<ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    final imageUrls = widget.imageUrls ?? (widget.imageUrl != null ? [widget.imageUrl!] : []);
    _currentIndex = widget.initialIndex.clamp(0, imageUrls.length - 1);
    // Only create PageController if there are multiple images
    if (imageUrls.length > 1) {
      _pageController = PageController(initialPage: _currentIndex);
    } else {
      _pageController = PageController();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final imageUrls = widget.imageUrls ?? (widget.imageUrl != null ? [widget.imageUrl!] : []);
    final theme = Theme.of(context);
    final hasMultipleImages = imageUrls.length > 1;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: widget.title != null
            ? Text(
                widget.title!,
                style: const TextStyle(color: Colors.white),
              )
            : hasMultipleImages
                ? Text(
                    '${_currentIndex + 1} / ${imageUrls.length}',
                    style: const TextStyle(color: Colors.white),
                  )
                : null,
      ),
      body: hasMultipleImages
          ? PageView.builder(
              controller: _pageController,
              itemCount: imageUrls.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return _buildImageView(imageUrls[index], theme);
              },
            )
          : _buildImageView(imageUrls.first, theme),
    );
  }

  Widget _buildImageView(String imageUrl, ThemeData theme) {
    final String fullUrl = ImageUtils.buildImageUrl(imageUrl);

    return Center(
      child: InteractiveViewer(
        minScale: 0.5,
        maxScale: 4.0,
        child: CachedNetworkImage(
          imageUrl: fullUrl,
          fit: BoxFit.contain,
          // Use full resolution for image viewer
          maxWidthDiskCache: 2048,
          maxHeightDiskCache: 2048,
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          ),
          errorWidget: (context, url, error) {
            AppLogger.error('Failed to load image in viewer: $url', error);
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.broken_image,
                    size: 64,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to load image',
                    style: TextStyle(
                      color: theme.colorScheme.onError,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

