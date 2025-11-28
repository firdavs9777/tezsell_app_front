# Image Widgets Usage Guide

This guide shows how to use the new image widgets for better performance and consistency.

## CachedNetworkImageWidget

A reusable widget for displaying cached network images with proper loading and error states.

### Basic Usage

```dart
import 'package:app/widgets/cached_network_image_widget.dart';

// Simple usage
CachedNetworkImageWidget(
  imageUrl: '/products/image.jpg', // Can be relative or absolute
  width: 100,
  height: 100,
  fit: BoxFit.cover,
)
```

### With Border Radius

```dart
CachedNetworkImageWidget(
  imageUrl: product.images.first.image,
  width: 200,
  height: 200,
  borderRadius: BorderRadius.circular(12),
)
```

### Circular Image (Avatar)

```dart
CachedNetworkImageWidget.circular(
  imageUrl: user.profileImage,
  radius: 40,
)
```

### Custom Placeholder and Error Widget

```dart
CachedNetworkImageWidget(
  imageUrl: imageUrl,
  width: 200,
  height: 200,
  placeholder: Container(
    color: Colors.grey[300],
    child: Center(child: CircularProgressIndicator()),
  ),
  errorWidget: Container(
    color: Colors.grey[200],
    child: Icon(Icons.error),
  ),
)
```

## CachedImageSlider

Display multiple images in a slider/carousel.

```dart
import 'package:app/widgets/cached_network_image_widget.dart';

CachedImageSlider(
  imageUrls: product.images.map((img) => img.image).toList(),
  height: 300,
  fit: BoxFit.cover,
  pageController: _pageController,
)
```

## ImageViewer

Full-screen image viewer with zoom and pan.

```dart
import 'package:app/widgets/image_viewer.dart';

// Navigate to image viewer
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => ImageViewer(
      imageUrl: imageUrl,
      title: 'Product Image',
    ),
  ),
);
```

## ImageUtils

Utility functions for image URL handling.

```dart
import 'package:app/utils/image_utils.dart';

// Build full URL from relative path
final fullUrl = ImageUtils.buildImageUrl('/products/image.jpg');

// Build list of URLs
final urls = ImageUtils.buildImageUrls(['/img1.jpg', '/img2.jpg']);

// Get first image URL
final firstImage = ImageUtils.getFirstImageUrl(imagePaths);

// Check if URL is valid
if (ImageUtils.isValidImageUrl(url)) {
  // Load image
}
```

## Migration Examples

### Before (Old Way)

```dart
// ❌ Old way - no caching, inconsistent error handling
Image.network(
  '$baseUrl${product.images[0].image}',
  width: 100,
  height: 100,
  fit: BoxFit.cover,
  errorBuilder: (context, error, stackTrace) {
    return Image.asset('assets/logo/logo_no_background.png');
  },
)
```

### After (New Way)

```dart
// ✅ New way - cached, consistent, better performance
CachedNetworkImageWidget(
  imageUrl: product.images[0].image, // Relative path is fine!
  width: 100,
  height: 100,
  fit: BoxFit.cover,
)
```

### Before (NetworkImage in CircleAvatar)

```dart
// ❌ Old way
CircleAvatar(
  radius: 40,
  backgroundImage: NetworkImage('$baseUrl${user.profileImage}'),
)
```

### After (Cached Circular Image)

```dart
// ✅ New way
CachedNetworkImageWidget.circular(
  imageUrl: user.profileImage,
  radius: 40,
)
```

## Benefits

1. **Automatic Caching** - Images are cached automatically, reducing network usage
2. **Consistent UI** - Same loading and error states across the app
3. **Better Performance** - Memory efficient with proper cache management
4. **Easy to Use** - Simple API, handles edge cases automatically
5. **URL Handling** - Automatically handles relative/absolute URLs
6. **Theme Aware** - Loading and error states respect app theme

