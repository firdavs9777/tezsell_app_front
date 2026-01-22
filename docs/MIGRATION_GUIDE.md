# Migration Guide

This guide helps you migrate from the old constants/endpoints to the new centralized configuration.

## ✅ Completed Improvements

### 1. Logger Implementation
- **Created:** `lib/utils/app_logger.dart`
- **Usage:** Replace all `print()` statements with `AppLogger.debug()`, `AppLogger.error()`, etc.
- **Example:**
  ```dart
  // Old
  print('Debug message');
  
  // New
  AppLogger.debug('Debug message');
  AppLogger.error('Error occurred', error, stackTrace);
  ```

### 2. Centralized Configuration
- **Created:** `lib/config/app_config.dart`
- **Replaces:** `lib/constants/constants.dart` and `lib/service/endpoints.dart`
- **Usage:**
  ```dart
  // Old
  import 'package:app/constants/constants.dart';
  final url = '$baseUrl$LOGIN_URL';
  
  // New
  import 'package:app/config/app_config.dart';
  final url = AppConfig.getLoginUrl();
  // Or
  final url = '${AppConfig.baseUrl}${AppConfig.loginPath}';
  ```

### 3. Error Handler
- **Created:** `lib/utils/error_handler.dart`
- **Usage:**
  ```dart
  import 'package:app/utils/error_handler.dart';
  
  try {
    // your code
  } catch (e) {
    AppErrorHandler.showError(context, e);
  }
  ```

### 4. Theme Configuration
- **Created:** `lib/theme/app_theme.dart`
- **Fixed:** Dark theme variable name typo (`kDarkColorSchema` → `kDarkColorScheme`)
- **Added:** Missing `scaffoldBackgroundColor` for light theme
- **Usage:** Themes are now centralized and easier to maintain

### 5. Linting Rules
- **Updated:** `analysis_options.yaml`
- **Enabled:**
  - `avoid_print: true` - Enforces use of AppLogger
  - `prefer_single_quotes: true`
  - `require_trailing_commas: true`
  - And more code quality rules

## 🔄 Migration Steps

### Step 1: Update Imports
Replace old imports with new ones:
```dart
// Remove
import 'package:app/constants/constants.dart';
import 'package:app/service/endpoints.dart';

// Add
import 'package:app/config/app_config.dart';
import 'package:app/utils/app_logger.dart';
import 'package:app/utils/error_handler.dart';
```

### Step 2: Replace Constants
```dart
// Old
const url = '$baseUrl$LOGIN_URL';
const wsUrl = Endpoints.wsUrl;

// New
final url = AppConfig.getLoginUrl();
final wsUrl = AppConfig.wsBaseUrl;
```

### Step 3: Replace Print Statements
```dart
// Old
print('Debug info');
print('Error: $error');

// New
AppLogger.debug('Debug info');
AppLogger.error('Error occurred', error, stackTrace);
```

### Step 4: Use Error Handler
```dart
// Old
try {
  // code
} catch (e) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Error: $e')),
  );
}

// New
try {
  // code
} catch (e) {
  AppErrorHandler.showError(context, e);
}
```

## 📝 Files to Update

The following files still use old constants (marked with deprecation warnings):
- `lib/pages/authentication/register.dart` - uses `baseUrl`
- `lib/pages/service/main/services_list.dart` - uses `baseUrl`
- `lib/providers/provider_root/message_provider.dart` - uses `Endpoints`

These files should be updated to use `AppConfig` instead.

## 🎨 Theme Improvements

### Fixed Issues:
1. ✅ Fixed typo: `kDarkColorSchema` → `kDarkColorScheme`
2. ✅ Added missing `scaffoldBackgroundColor` for light theme
3. ✅ Centralized theme configuration in `lib/theme/app_theme.dart`
4. ✅ Both themes now properly configured with all Material 3 components

### Theme Colors:
- **Brand Color:** Carrot Orange (#FF6F00)
- **Light Theme:** Uses Material 3 light color scheme
- **Dark Theme:** Uses Material 3 dark color scheme
- Both themes are consistent and properly configured

## 🚀 Next Steps

1. Gradually migrate files from old constants to `AppConfig`
2. Replace remaining `print()` statements with `AppLogger`
3. Use `AppErrorHandler` for consistent error handling
4. Test dark/light theme switching
5. Run `flutter analyze` to check for linting issues

## 📚 Documentation

- **AppConfig:** See `lib/config/app_config.dart` for all available endpoints
- **AppLogger:** See `lib/utils/app_logger.dart` for logging methods
- **ErrorHandler:** See `lib/utils/error_handler.dart` for error handling
- **AppTheme:** See `lib/theme/app_theme.dart` for theme configuration

