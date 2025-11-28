import 'package:cached_network_image/cached_network_image.dart';
import 'package:app/utils/image_utils.dart';
import 'package:app/utils/app_logger.dart';
import 'package:flutter/material.dart';

/// A full-screen image viewer with zoom and pan capabilities.
/// 
/// Usage:
/// ```dart
/// Navigator.push(
///   context,
///   MaterialPageRoute(
///     builder: (_) => ImageViewer(imageUrl: 'https://example.com/image.jpg'),
///   ),
/// );
/// ```
class ImageViewer extends StatelessWidget {
  /// The image URL to display
  final String imageUrl;

  /// Optional title for the app bar
  final String? title;

  const ImageViewer({
    super.key,
    required this.imageUrl,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    final String fullUrl = ImageUtils.buildImageUrl(imageUrl);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: title != null
            ? Text(
                title!,
                style: const TextStyle(color: Colors.white),
              )
            : null,
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 4.0,
          child: CachedNetworkImage(
            imageUrl: fullUrl,
            fit: BoxFit.contain,
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
      ),
    );
  }
}

