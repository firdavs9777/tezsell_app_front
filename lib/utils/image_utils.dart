import 'package:app/config/app_config.dart';

/// Utility class for image-related operations.
class ImageUtils {
  /// Default placeholder image path
  static const String defaultPlaceholder = 'assets/logo/logo_no_background.png';

  /// Builds a full image URL from a relative path.
  /// 
  /// If the path is already a full URL, returns it as is.
  /// Otherwise, prepends the base URL.
  static String buildImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return '';
    }

    // If already a full URL, return as is
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return imagePath;
    }

    // Remove leading slash if present to avoid double slashes
    final cleanPath = imagePath.startsWith('/') ? imagePath.substring(1) : imagePath;
    
    // Build full URL
    return '${AppConfig.baseUrl}/$cleanPath';
  }

  /// Builds a list of full image URLs from relative paths.
  static List<String> buildImageUrls(List<String> imagePaths) {
    return imagePaths.map((path) => buildImageUrl(path)).toList();
  }

  /// Gets the first image URL from a list, or returns empty string.
  static String getFirstImageUrl(List<String>? imagePaths) {
    if (imagePaths == null || imagePaths.isEmpty) {
      return '';
    }
    return buildImageUrl(imagePaths.first);
  }

  /// Checks if a URL is valid for image loading.
  static bool isValidImageUrl(String? url) {
    if (url == null || url.isEmpty) return false;
    return url.startsWith('http://') || url.startsWith('https://');
  }

  /// Gets placeholder image path.
  static String getPlaceholder() {
    return defaultPlaceholder;
  }
}

