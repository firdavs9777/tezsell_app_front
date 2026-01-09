import 'package:cached_network_image/cached_network_image.dart';
import 'package:app/utils/image_utils.dart';
import 'package:app/utils/app_logger.dart';
import 'package:flutter/material.dart';

/// A reusable widget for displaying cached network images with proper
/// loading and error states.
/// 
/// Features:
/// - Automatic image caching
/// - Loading placeholder
/// - Error placeholder
/// - Customizable appearance
/// - Memory efficient
class CachedNetworkImageWidget extends StatelessWidget {
  /// The image URL (can be relative or absolute)
  final String? imageUrl;

  /// Width of the image
  final double? width;

  /// Height of the image
  final double? height;

  /// How the image should be inscribed into the box
  final BoxFit fit;

  /// Border radius for the image
  final BorderRadius? borderRadius;

  /// Placeholder widget shown while loading
  final Widget? placeholder;

  /// Error widget shown when image fails to load
  final Widget? errorWidget;

  /// Background color while loading
  final Color? placeholderColor;

  /// Background color on error
  final Color? errorColor;

  /// Whether to use fade in animation
  final bool fadeIn;

  /// Duration of fade in animation
  final Duration fadeInDuration;

  /// Whether to show progress indicator
  final bool showProgressIndicator;

  /// Progress indicator color
  final Color? progressIndicatorColor;

  /// Callback when image is tapped
  final VoidCallback? onTap;

  const CachedNetworkImageWidget({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
    this.placeholderColor,
    this.errorColor,
    this.fadeIn = true,
    this.fadeInDuration = const Duration(milliseconds: 300),
    this.showProgressIndicator = true,
    this.progressIndicatorColor,
    this.onTap,
  });

  /// Creates a circular cached network image (useful for avatars)
  factory CachedNetworkImageWidget.circular({
    Key? key,
    required String? imageUrl,
    required double radius,
    Widget? placeholder,
    Widget? errorWidget,
    Color? placeholderColor,
    Color? errorColor,
    VoidCallback? onTap,
  }) {
    return CachedNetworkImageWidget(
      key: key,
      imageUrl: imageUrl,
      width: radius * 2,
      height: radius * 2,
      fit: BoxFit.cover,
      borderRadius: BorderRadius.circular(radius),
      placeholder: placeholder,
      errorWidget: errorWidget,
      placeholderColor: placeholderColor,
      errorColor: errorColor,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final String? fullUrl = imageUrl != null && imageUrl!.isNotEmpty
        ? ImageUtils.buildImageUrl(imageUrl!)
        : null;

    // If no URL, show placeholder
    if (fullUrl == null || !ImageUtils.isValidImageUrl(fullUrl)) {
      return _buildPlaceholder(context);
    }

    Widget imageWidget = CachedNetworkImage(
      imageUrl: fullUrl,
      width: width,
      height: height,
      fit: fit,
      fadeInDuration: fadeInDuration,
      placeholder: (context, url) => _buildLoadingPlaceholder(context),
      errorWidget: (context, url, error) {
        AppLogger.warning('Failed to load image: $url', error);
        return _buildErrorWidget(context);
      },
      // Use 2x resolution for memory cache to improve quality on high-DPI screens
      memCacheWidth: width != null ? (width! * 2).toInt() : null,
      memCacheHeight: height != null ? (height! * 2).toInt() : null,
      // Increase disk cache to preserve higher quality images
      maxWidthDiskCache: 2048,
      maxHeightDiskCache: 2048,
    );

    // Apply border radius if provided
    if (borderRadius != null) {
      imageWidget = ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    // Wrap with GestureDetector if onTap is provided
    if (onTap != null) {
      imageWidget = GestureDetector(
        onTap: onTap,
        child: imageWidget,
      );
    }

    return imageWidget;
  }

  Widget _buildLoadingPlaceholder(BuildContext context) {
    if (placeholder != null) return placeholder!;

    return Container(
      width: width,
      height: height,
      color: placeholderColor ?? Theme.of(context).colorScheme.surfaceVariant,
      child: showProgressIndicator
          ? Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  progressIndicatorColor ??
                      Theme.of(context).colorScheme.primary,
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }

  Widget _buildErrorWidget(BuildContext context) {
    if (errorWidget != null) return errorWidget!;

    return Container(
      width: width,
      height: height,
      color: errorColor ?? Theme.of(context).colorScheme.errorContainer,
      child: Center(
        child: Icon(
          Icons.broken_image,
          size: (width != null && height != null)
              ? (width! < height! ? width! : height!) * 0.4
              : 40,
          color: Theme.of(context).colorScheme.onErrorContainer,
        ),
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    if (placeholder != null) return placeholder!;

    return Container(
      width: width,
      height: height,
      color: placeholderColor ?? Theme.of(context).colorScheme.surfaceVariant,
      child: Center(
        child: Icon(
          Icons.image_not_supported,
          size: (width != null && height != null)
              ? (width! < height! ? width! : height!) * 0.4
              : 40,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

/// A widget for displaying a list of images in a slider/carousel.
class CachedImageSlider extends StatelessWidget {
  final List<String> imageUrls;
  final double? height;
  final BoxFit fit;
  final PageController? pageController;
  final BorderRadius? borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;
  final Function(int index)? onImageTap;

  const CachedImageSlider({
    super.key,
    required this.imageUrls,
    this.height,
    this.fit = BoxFit.cover,
    this.pageController,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
    this.onImageTap,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrls.isEmpty) {
      return _buildEmptyState(context);
    }

    return SizedBox(
      height: height,
      child: PageView.builder(
        controller: pageController,
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => onImageTap?.call(index),
            child: CachedNetworkImageWidget(
              imageUrl: imageUrls[index],
              fit: fit,
              borderRadius: borderRadius,
              placeholder: placeholder,
              errorWidget: errorWidget,
              // For detail views, don't restrict size - use full resolution
              width: null,
              height: null,
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      height: height,
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: Center(
        child: Icon(
          Icons.image_not_supported,
          size: 64,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

