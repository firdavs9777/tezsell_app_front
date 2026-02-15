/// Currency formatting utilities for 15 ex-Soviet countries
/// Handles UZS, USD, EUR, RUB, UAH, BYN, MDL, GEL, AMD, AZN, KZT, TMT, KGS, TJS

/// Symbol position for currency formatting
enum SymbolPosition { before, after }

/// Configuration for a currency
class CurrencyConfig {
  final String code;
  final String symbol;
  final SymbolPosition symbolPosition;
  final String thousandsSeparator;
  final String decimalSeparator;
  final int decimals;
  final num minPrice;
  final num maxPrice;

  const CurrencyConfig({
    required this.code,
    required this.symbol,
    required this.symbolPosition,
    required this.thousandsSeparator,
    required this.decimalSeparator,
    required this.decimals,
    required this.minPrice,
    required this.maxPrice,
  });
}

class CurrencyUtils {
  CurrencyUtils._();

  /// All supported currencies with formatting rules
  static const Map<String, CurrencyConfig> currencies = {
    'UZS': CurrencyConfig(
      code: 'UZS',
      symbol: "so'm",
      symbolPosition: SymbolPosition.after,
      thousandsSeparator: ' ',
      decimalSeparator: ',',
      decimals: 0,
      minPrice: 1000,
      maxPrice: 10000000000000,
    ),
    'USD': CurrencyConfig(
      code: 'USD',
      symbol: '\$',
      symbolPosition: SymbolPosition.before,
      thousandsSeparator: ',',
      decimalSeparator: '.',
      decimals: 2,
      minPrice: 1,
      maxPrice: 10000000,
    ),
    'EUR': CurrencyConfig(
      code: 'EUR',
      symbol: '\u20AC',
      symbolPosition: SymbolPosition.before,
      thousandsSeparator: ' ',
      decimalSeparator: ',',
      decimals: 2,
      minPrice: 1,
      maxPrice: 10000000,
    ),
    'RUB': CurrencyConfig(
      code: 'RUB',
      symbol: '\u20BD',
      symbolPosition: SymbolPosition.after,
      thousandsSeparator: ' ',
      decimalSeparator: ',',
      decimals: 0,
      minPrice: 100,
      maxPrice: 100000000000,
    ),
    'UAH': CurrencyConfig(
      code: 'UAH',
      symbol: '\u20B4',
      symbolPosition: SymbolPosition.after,
      thousandsSeparator: ' ',
      decimalSeparator: ',',
      decimals: 0,
      minPrice: 100,
      maxPrice: 10000000000,
    ),
    'BYN': CurrencyConfig(
      code: 'BYN',
      symbol: 'Br',
      symbolPosition: SymbolPosition.after,
      thousandsSeparator: ' ',
      decimalSeparator: ',',
      decimals: 2,
      minPrice: 1,
      maxPrice: 100000000,
    ),
    'MDL': CurrencyConfig(
      code: 'MDL',
      symbol: 'L',
      symbolPosition: SymbolPosition.after,
      thousandsSeparator: ' ',
      decimalSeparator: ',',
      decimals: 0,
      minPrice: 10,
      maxPrice: 1000000000,
    ),
    'GEL': CurrencyConfig(
      code: 'GEL',
      symbol: '\u20BE',
      symbolPosition: SymbolPosition.after,
      thousandsSeparator: ' ',
      decimalSeparator: ',',
      decimals: 2,
      minPrice: 1,
      maxPrice: 100000000,
    ),
    'AMD': CurrencyConfig(
      code: 'AMD',
      symbol: '\u058F',
      symbolPosition: SymbolPosition.after,
      thousandsSeparator: ' ',
      decimalSeparator: ',',
      decimals: 0,
      minPrice: 100,
      maxPrice: 10000000000,
    ),
    'AZN': CurrencyConfig(
      code: 'AZN',
      symbol: '\u20BC',
      symbolPosition: SymbolPosition.after,
      thousandsSeparator: ' ',
      decimalSeparator: ',',
      decimals: 2,
      minPrice: 1,
      maxPrice: 100000000,
    ),
    'KZT': CurrencyConfig(
      code: 'KZT',
      symbol: '\u20B8',
      symbolPosition: SymbolPosition.after,
      thousandsSeparator: ' ',
      decimalSeparator: ',',
      decimals: 0,
      minPrice: 100,
      maxPrice: 10000000000,
    ),
    'TMT': CurrencyConfig(
      code: 'TMT',
      symbol: 'm',
      symbolPosition: SymbolPosition.after,
      thousandsSeparator: ' ',
      decimalSeparator: ',',
      decimals: 2,
      minPrice: 1,
      maxPrice: 100000000,
    ),
    'KGS': CurrencyConfig(
      code: 'KGS',
      symbol: '\u0441',
      symbolPosition: SymbolPosition.after,
      thousandsSeparator: ' ',
      decimalSeparator: ',',
      decimals: 0,
      minPrice: 10,
      maxPrice: 10000000000,
    ),
    'TJS': CurrencyConfig(
      code: 'TJS',
      symbol: 'SM',
      symbolPosition: SymbolPosition.after,
      thousandsSeparator: ' ',
      decimalSeparator: ',',
      decimals: 2,
      minPrice: 1,
      maxPrice: 1000000000,
    ),
  };

  /// Map country codes to default currencies
  static const Map<String, String> countryDefaultCurrency = {
    'RU': 'RUB',
    'UA': 'UAH',
    'BY': 'BYN',
    'MD': 'MDL',
    'EE': 'EUR',
    'LV': 'EUR',
    'LT': 'EUR',
    'GE': 'GEL',
    'AM': 'AMD',
    'AZ': 'AZN',
    'KZ': 'KZT',
    'UZ': 'UZS',
    'TM': 'TMT',
    'KG': 'KGS',
    'TJ': 'TJS',
  };

  /// Get available currencies for a country (limited set: country default + USD + EUR)
  static List<String> getCurrenciesForCountry(String countryCode) {
    final defaultCurrency = countryDefaultCurrency[countryCode] ?? 'USD';
    return [defaultCurrency, 'USD', 'EUR'].toSet().toList();
  }

  /// Get all available currencies
  static List<String> getAllCurrencies() {
    return currencies.keys.toList();
  }

  /// Get default currency for a country
  static String? getCurrencyForCountry(String countryCode) {
    return countryDefaultCurrency[countryCode];
  }

  /// Format price with proper currency symbol and separators
  static String formatPrice(dynamic price, {String currency = 'UZS'}) {
    double priceNum;
    if (price is String) {
      priceNum = double.tryParse(price) ?? 0;
    } else if (price is num) {
      priceNum = price.toDouble();
    } else {
      priceNum = 0;
    }

    final config = currencies[currency] ?? currencies['USD']!;
    final formattedNumber = _formatNumber(
      priceNum,
      thousandsSeparator: config.thousandsSeparator,
      decimalSeparator: config.decimalSeparator,
      decimals: config.decimals,
    );

    if (config.symbolPosition == SymbolPosition.before) {
      return '${config.symbol}$formattedNumber';
    } else {
      return '$formattedNumber ${config.symbol}';
    }
  }

  static String _formatNumber(
    num number, {
    required String thousandsSeparator,
    required String decimalSeparator,
    required int decimals,
  }) {
    final parts = number.toStringAsFixed(decimals).split('.');
    final integerPart = parts[0].replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}$thousandsSeparator',
    );

    if (decimals > 0 && parts.length > 1) {
      return '$integerPart$decimalSeparator${parts[1]}';
    }
    return integerPart;
  }

  /// Format UZS with space as thousands separator (legacy support)
  static String formatUZS(num price) {
    return formatPrice(price, currency: 'UZS');
  }

  /// Format USD with comma separator (legacy support)
  static String formatUSD(num price) {
    return formatPrice(price, currency: 'USD');
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
    // Remove all currency symbols, spaces, commas
    final cleaned = formatted
        .replaceAll("so'm", '')
        .replaceAll('\$', '')
        .replaceAll('\u20AC', '') // EUR
        .replaceAll('\u20BD', '') // RUB
        .replaceAll('\u20B4', '') // UAH
        .replaceAll('Br', '') // BYN
        .replaceAll('L', '') // MDL
        .replaceAll('\u20BE', '') // GEL
        .replaceAll('\u058F', '') // AMD
        .replaceAll('\u20BC', '') // AZN
        .replaceAll('\u20B8', '') // KZT
        .replaceAll('m', '') // TMT
        .replaceAll('\u0441', '') // KGS
        .replaceAll('SM', '') // TJS
        .replaceAll(' ', '')
        .replaceAll(',', '')
        .trim();
    return double.tryParse(cleaned) ?? 0;
  }

  /// Get currency symbol
  static String getSymbol(String currency) {
    return currencies[currency.toUpperCase()]?.symbol ?? currency;
  }

  /// Get currency display name
  static String getDisplayName(String currency) {
    switch (currency.toUpperCase()) {
      case 'USD':
        return 'US Dollar';
      case 'EUR':
        return 'Euro';
      case 'UZS':
        return "So'm";
      case 'RUB':
        return 'Russian Ruble';
      case 'UAH':
        return 'Ukrainian Hryvnia';
      case 'BYN':
        return 'Belarusian Ruble';
      case 'MDL':
        return 'Moldovan Leu';
      case 'GEL':
        return 'Georgian Lari';
      case 'AMD':
        return 'Armenian Dram';
      case 'AZN':
        return 'Azerbaijani Manat';
      case 'KZT':
        return 'Kazakhstani Tenge';
      case 'TMT':
        return 'Turkmen Manat';
      case 'KGS':
        return 'Kyrgyzstani Som';
      case 'TJS':
        return 'Tajikistani Somoni';
      default:
        return currency;
    }
  }

  /// Get currency config
  static CurrencyConfig? getConfig(String currency) {
    return currencies[currency.toUpperCase()];
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

  /// Text field validation
  static const int minTitleLength = 3;
  static const int maxTitleLength = 255;
  static const int minDescriptionLength = 10;
  static const int maxDescriptionLength = 5000;

  /// Validate price based on currency
  static String? validatePrice(num price, String currency) {
    final config = CurrencyUtils.currencies[currency];
    if (config == null) return null;

    if (price < config.minPrice) {
      return "Minimum price: ${CurrencyUtils.formatPrice(config.minPrice, currency: currency)}";
    }
    if (price > config.maxPrice) {
      return "Maximum price: ${CurrencyUtils.formatPrice(config.maxPrice, currency: currency)}";
    }
    return null;
  }

  /// Validate title length
  static String? validateTitle(String title) {
    if (title.length < minTitleLength) {
      return "Title must be at least $minTitleLength characters";
    }
    if (title.length > maxTitleLength) {
      return "Title must not exceed $maxTitleLength characters";
    }
    return null;
  }

  /// Validate description length
  static String? validateDescription(String description) {
    if (description.length < minDescriptionLength) {
      return "Description must be at least $minDescriptionLength characters";
    }
    if (description.length > maxDescriptionLength) {
      return "Description must not exceed $maxDescriptionLength characters";
    }
    return null;
  }

  /// Validate image count
  static String? validateImageCount(int count) {
    if (count > maxImagesPerListing) {
      return "Maximum $maxImagesPerListing images allowed";
    }
    return null;
  }

  /// Validate image size
  static String? validateImageSize(int sizeBytes) {
    if (sizeBytes > maxImageSizeBytes) {
      return "Image size must not exceed ${maxImageSizeMB}MB";
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
