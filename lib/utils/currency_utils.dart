/// Currency formatting utilities for Uzbekistan
/// Handles UZS (Uzbek Som) and USD formatting

class CurrencyUtils {
  CurrencyUtils._();

  /// Available currencies
  static const String uzs = 'UZS';
  static const String usd = 'USD';

  /// Format price with proper currency symbol and separators
  /// UZS uses space as thousands separator: 1 500 000 so'm
  /// USD uses comma as thousands separator: $1,500,000
  static String formatPrice(dynamic price, {String currency = 'UZS'}) {
    double priceNum;
    if (price is String) {
      priceNum = double.tryParse(price) ?? 0;
    } else if (price is num) {
      priceNum = price.toDouble();
    } else {
      priceNum = 0;
    }

    if (currency == 'UZS') {
      return formatUZS(priceNum);
    } else {
      return formatUSD(priceNum);
    }
  }

  /// Format UZS with space as thousands separator
  /// Example: 15000000 → "15 000 000 so'm"
  static String formatUZS(num price) {
    final intPrice = price.toInt();
    final formatted = intPrice.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]} ',
    );
    return "$formatted so'm";
  }

  /// Format USD with comma separator
  /// Example: 15000 → "$15,000"
  static String formatUSD(num price) {
    final formatted = price.toInt().toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
    return '\$$formatted';
  }

  /// Format price without currency symbol (just number formatting)
  static String formatNumber(num value, {String separator = ' '}) {
    return value.toInt().toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}$separator',
    );
  }

  /// Parse formatted price back to number
  static double parsePrice(String formatted) {
    // Remove currency symbols, spaces, commas, and "so'm"
    final cleaned = formatted
        .replaceAll("so'm", '')
        .replaceAll('\$', '')
        .replaceAll(' ', '')
        .replaceAll(',', '')
        .trim();
    return double.tryParse(cleaned) ?? 0;
  }

  /// Get currency symbol
  static String getSymbol(String currency) {
    switch (currency.toUpperCase()) {
      case 'USD':
        return '\$';
      case 'UZS':
      default:
        return "so'm";
    }
  }

  /// Get currency display name
  static String getDisplayName(String currency) {
    switch (currency.toUpperCase()) {
      case 'USD':
        return 'Dollar';
      case 'UZS':
      default:
        return "So'm";
    }
  }
}

/// Validation rules from backend
class ValidationRules {
  ValidationRules._();

  /// Image upload rules
  static const int maxImagesPerListing = 10;
  static const int maxImageSizeMB = 5;
  static const int maxImageSizeBytes = maxImageSizeMB * 1024 * 1024;
  static const List<String> allowedImageFormats = [
    '.jpg',
    '.jpeg',
    '.png',
    '.gif',
    '.webp'
  ];

  /// Price validation rules (UZS)
  static const int minPriceUZS = 1000;
  static const int maxPriceUZS = 10000000000000; // 10 trillion

  /// Price validation rules (USD)
  static const int minPriceUSD = 1;
  static const int maxPriceUSD = 10000000; // 10 million

  /// Text field validation
  static const int minTitleLength = 3;
  static const int maxTitleLength = 255;
  static const int minDescriptionLength = 10;
  static const int maxDescriptionLength = 5000;

  /// Validate price based on currency
  static String? validatePrice(num price, String currency) {
    if (currency == 'UZS') {
      if (price < minPriceUZS) {
        return "Minimal narx: ${CurrencyUtils.formatUZS(minPriceUZS)}";
      }
      if (price > maxPriceUZS) {
        return "Maksimal narx: ${CurrencyUtils.formatUZS(maxPriceUZS)}";
      }
    } else if (currency == 'USD') {
      if (price < minPriceUSD) {
        return "Minimum price: ${CurrencyUtils.formatUSD(minPriceUSD)}";
      }
      if (price > maxPriceUSD) {
        return "Maximum price: ${CurrencyUtils.formatUSD(maxPriceUSD)}";
      }
    }
    return null; // Valid
  }

  /// Validate title length
  static String? validateTitle(String title) {
    if (title.length < minTitleLength) {
      return "Sarlavha kamida $minTitleLength belgi bo'lishi kerak";
    }
    if (title.length > maxTitleLength) {
      return "Sarlavha $maxTitleLength belgidan oshmasligi kerak";
    }
    return null;
  }

  /// Validate description length
  static String? validateDescription(String description) {
    if (description.length < minDescriptionLength) {
      return "Tavsif kamida $minDescriptionLength belgi bo'lishi kerak";
    }
    if (description.length > maxDescriptionLength) {
      return "Tavsif $maxDescriptionLength belgidan oshmasligi kerak";
    }
    return null;
  }

  /// Validate image count
  static String? validateImageCount(int count) {
    if (count > maxImagesPerListing) {
      return "Maksimal $maxImagesPerListing rasm ruxsat etiladi";
    }
    return null;
  }

  /// Validate image size
  static String? validateImageSize(int sizeBytes) {
    if (sizeBytes > maxImageSizeBytes) {
      return "Rasm hajmi ${maxImageSizeMB}MB dan oshmasligi kerak";
    }
    return null;
  }
}

/// Product condition choices
class ProductCondition {
  ProductCondition._();

  static const String newItem = 'new';
  static const String likeNew = 'like_new';
  static const String used = 'used';
  static const String refurbished = 'refurbished';

  /// Get all conditions
  static List<String> get all => [newItem, likeNew, used, refurbished];

  /// Get localized label for condition
  static String getLabel(String condition, {String lang = 'uz'}) {
    switch (condition) {
      case newItem:
        return lang == 'ru' ? 'Новый' : (lang == 'en' ? 'New' : 'Yangi');
      case likeNew:
        return lang == 'ru'
            ? 'Почти новый'
            : (lang == 'en' ? 'Like New' : 'Deyarli yangi');
      case used:
        return lang == 'ru' ? 'Б/у' : (lang == 'en' ? 'Used' : 'Ishlatilgan');
      case refurbished:
        return lang == 'ru'
            ? 'Восстановленный'
            : (lang == 'en' ? 'Refurbished' : 'Tiklangan');
      default:
        return condition;
    }
  }

  /// Get all conditions with labels
  static Map<String, String> getAllWithLabels({String lang = 'uz'}) {
    return {
      for (final c in all) c: getLabel(c, lang: lang),
    };
  }
}
