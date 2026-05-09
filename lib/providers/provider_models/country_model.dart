/// Model for country data with currency and locale information
class CountryModel {
  final int id;
  final String code;
  final String name;
  final String nameEn;
  final String nameRu;
  final CurrencyInfo currency;
  final String phoneCode;
  final String flagEmoji;

  CountryModel({
    required this.id,
    required this.code,
    required this.name,
    required this.nameEn,
    required this.nameRu,
    required this.currency,
    required this.phoneCode,
    required this.flagEmoji,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      id: json['id'] ?? 0,
      code: json['code'] ?? '',
      name: json['name'] ?? json['name_en'] ?? '',
      nameEn: json['name_en'] ?? json['name'] ?? '',
      nameRu: json['name_ru'] ?? json['name'] ?? '',
      currency: json['currency'] != null
          ? CurrencyInfo.fromJson(json['currency'])
          : CurrencyInfo.defaultFor(json['code'] ?? ''),
      phoneCode: json['phone_code'] ?? '',
      flagEmoji: json['flag_emoji'] ?? _codeToEmoji(json['code'] ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'name_en': nameEn,
      'name_ru': nameRu,
      'currency': currency.toJson(),
      'phone_code': phoneCode,
      'flag_emoji': flagEmoji,
    };
  }

  /// Convert country code to flag emoji
  static String _codeToEmoji(String countryCode) {
    if (countryCode.length != 2) return '';
    return countryCode.toUpperCase().codeUnits
        .map((c) => String.fromCharCode(c + 127397))
        .join();
  }

  /// Get localized name based on locale
  String getLocalizedName(String locale) {
    switch (locale) {
      case 'ru':
        return nameRu;
      case 'en':
        return nameEn;
      default:
        return name;
    }
  }

  /// Static list of supported countries with their data
  static List<CountryModel> get supportedCountries => [
    CountryModel(
      id: 1, code: 'UZ', name: "O'zbekiston", nameEn: 'Uzbekistan', nameRu: 'Узбекистан',
      currency: const CurrencyInfo(code: 'UZS', symbol: "so'm", name: "So'm"),
      phoneCode: '+998', flagEmoji: _codeToEmoji('UZ'),
    ),
    CountryModel(
      id: 2, code: 'KZ', name: 'Qozog\'iston', nameEn: 'Kazakhstan', nameRu: 'Казахстан',
      currency: const CurrencyInfo(code: 'KZT', symbol: '\u20B8', name: 'Tenge'),
      phoneCode: '+7', flagEmoji: _codeToEmoji('KZ'),
    ),
    CountryModel(
      id: 3, code: 'KG', name: 'Qirg\'iziston', nameEn: 'Kyrgyzstan', nameRu: 'Кыргызстан',
      currency: const CurrencyInfo(code: 'KGS', symbol: '\u0441', name: 'Som'),
      phoneCode: '+996', flagEmoji: _codeToEmoji('KG'),
    ),
    CountryModel(
      id: 4, code: 'TJ', name: 'Tojikiston', nameEn: 'Tajikistan', nameRu: 'Таджикистан',
      currency: const CurrencyInfo(code: 'TJS', symbol: 'SM', name: 'Somoni'),
      phoneCode: '+992', flagEmoji: _codeToEmoji('TJ'),
    ),
    CountryModel(
      id: 5, code: 'TM', name: 'Turkmaniston', nameEn: 'Turkmenistan', nameRu: 'Туркменистан',
      currency: const CurrencyInfo(code: 'TMT', symbol: 'm', name: 'Manat'),
      phoneCode: '+993', flagEmoji: _codeToEmoji('TM'),
    ),
    CountryModel(
      id: 6, code: 'RU', name: 'Rossiya', nameEn: 'Russia', nameRu: 'Россия',
      currency: const CurrencyInfo(code: 'RUB', symbol: '\u20BD', name: 'Ruble'),
      phoneCode: '+7', flagEmoji: _codeToEmoji('RU'),
    ),
    CountryModel(
      id: 7, code: 'UA', name: 'Ukraina', nameEn: 'Ukraine', nameRu: 'Украина',
      currency: const CurrencyInfo(code: 'UAH', symbol: '\u20B4', name: 'Hryvnia'),
      phoneCode: '+380', flagEmoji: _codeToEmoji('UA'),
    ),
    CountryModel(
      id: 8, code: 'BY', name: 'Belarus', nameEn: 'Belarus', nameRu: 'Беларусь',
      currency: const CurrencyInfo(code: 'BYN', symbol: 'Br', name: 'Ruble'),
      phoneCode: '+375', flagEmoji: _codeToEmoji('BY'),
    ),
    CountryModel(
      id: 9, code: 'MD', name: 'Moldova', nameEn: 'Moldova', nameRu: 'Молдова',
      currency: const CurrencyInfo(code: 'MDL', symbol: 'L', name: 'Leu'),
      phoneCode: '+373', flagEmoji: _codeToEmoji('MD'),
    ),
    CountryModel(
      id: 10, code: 'GE', name: 'Gruziya', nameEn: 'Georgia', nameRu: 'Грузия',
      currency: const CurrencyInfo(code: 'GEL', symbol: '\u20BE', name: 'Lari'),
      phoneCode: '+995', flagEmoji: _codeToEmoji('GE'),
    ),
    CountryModel(
      id: 11, code: 'AM', name: 'Armaniston', nameEn: 'Armenia', nameRu: 'Армения',
      currency: const CurrencyInfo(code: 'AMD', symbol: '\u058F', name: 'Dram'),
      phoneCode: '+374', flagEmoji: _codeToEmoji('AM'),
    ),
    CountryModel(
      id: 12, code: 'AZ', name: 'Ozarbayjon', nameEn: 'Azerbaijan', nameRu: 'Азербайджан',
      currency: const CurrencyInfo(code: 'AZN', symbol: '\u20BC', name: 'Manat'),
      phoneCode: '+994', flagEmoji: _codeToEmoji('AZ'),
    ),
    CountryModel(
      id: 13, code: 'EE', name: 'Estoniya', nameEn: 'Estonia', nameRu: 'Эстония',
      currency: const CurrencyInfo(code: 'EUR', symbol: '\u20AC', name: 'Euro'),
      phoneCode: '+372', flagEmoji: _codeToEmoji('EE'),
    ),
    CountryModel(
      id: 14, code: 'LV', name: 'Latviya', nameEn: 'Latvia', nameRu: 'Латвия',
      currency: const CurrencyInfo(code: 'EUR', symbol: '\u20AC', name: 'Euro'),
      phoneCode: '+371', flagEmoji: _codeToEmoji('LV'),
    ),
    CountryModel(
      id: 15, code: 'LT', name: 'Litva', nameEn: 'Lithuania', nameRu: 'Литва',
      currency: const CurrencyInfo(code: 'EUR', symbol: '\u20AC', name: 'Euro'),
      phoneCode: '+370', flagEmoji: _codeToEmoji('LT'),
    ),
  ];

  /// Get country by code
  static CountryModel? getByCode(String code) {
    try {
      return supportedCountries.firstWhere((c) => c.code == code.toUpperCase());
    } catch (_) {
      return null;
    }
  }
}

/// Currency information for a country
class CurrencyInfo {
  final String code;
  final String symbol;
  final String name;

  const CurrencyInfo({
    required this.code,
    required this.symbol,
    required this.name,
  });

  factory CurrencyInfo.fromJson(Map<String, dynamic> json) {
    return CurrencyInfo(
      code: json['code'] ?? '',
      symbol: json['symbol'] ?? '',
      name: json['name'] ?? '',
    );
  }

  /// Default currency for a country code
  factory CurrencyInfo.defaultFor(String countryCode) {
    const defaults = {
      'UZ': CurrencyInfo(code: 'UZS', symbol: "so'm", name: "So'm"),
      'KZ': CurrencyInfo(code: 'KZT', symbol: '\u20B8', name: 'Tenge'),
      'KG': CurrencyInfo(code: 'KGS', symbol: '\u0441', name: 'Som'),
      'TJ': CurrencyInfo(code: 'TJS', symbol: 'SM', name: 'Somoni'),
      'TM': CurrencyInfo(code: 'TMT', symbol: 'm', name: 'Manat'),
      'RU': CurrencyInfo(code: 'RUB', symbol: '\u20BD', name: 'Ruble'),
      'UA': CurrencyInfo(code: 'UAH', symbol: '\u20B4', name: 'Hryvnia'),
      'BY': CurrencyInfo(code: 'BYN', symbol: 'Br', name: 'Ruble'),
      'MD': CurrencyInfo(code: 'MDL', symbol: 'L', name: 'Leu'),
      'GE': CurrencyInfo(code: 'GEL', symbol: '\u20BE', name: 'Lari'),
      'AM': CurrencyInfo(code: 'AMD', symbol: '\u058F', name: 'Dram'),
      'AZ': CurrencyInfo(code: 'AZN', symbol: '\u20BC', name: 'Manat'),
      'EE': CurrencyInfo(code: 'EUR', symbol: '\u20AC', name: 'Euro'),
      'LV': CurrencyInfo(code: 'EUR', symbol: '\u20AC', name: 'Euro'),
      'LT': CurrencyInfo(code: 'EUR', symbol: '\u20AC', name: 'Euro'),
    };
    return defaults[countryCode.toUpperCase()] ??
        const CurrencyInfo(code: 'USD', symbol: '\$', name: 'US Dollar');
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'symbol': symbol,
      'name': name,
    };
  }
}
