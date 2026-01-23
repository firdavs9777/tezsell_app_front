/// Trust Score Model - Manner Temperature System (like Karrot/당근마켓)
/// Temperature ranges from 0°C to 99.9°C
/// Starts at 36.5°C (normal body temperature)

class TrustScore {
  final int userId;
  final String username;
  final double temperature;
  final String temperatureLevel;
  final String temperatureEmoji;
  final int totalTransactions;
  final int completedTransactions;
  final int cancelledTransactions;
  final int reviewsReceived;
  final double averageRating;
  final int positiveReviews;
  final int negativeReviews;
  final double responseRate;
  final int avgResponseTimeMinutes;
  final List<UserBadge> badges;

  TrustScore({
    required this.userId,
    required this.username,
    required this.temperature,
    required this.temperatureLevel,
    required this.temperatureEmoji,
    required this.totalTransactions,
    required this.completedTransactions,
    required this.cancelledTransactions,
    required this.reviewsReceived,
    required this.averageRating,
    required this.positiveReviews,
    required this.negativeReviews,
    required this.responseRate,
    required this.avgResponseTimeMinutes,
    required this.badges,
  });

  factory TrustScore.fromJson(Map<String, dynamic> json) {
    return TrustScore(
      userId: json['user_id'] ?? 0,
      username: json['username'] ?? '',
      temperature: double.tryParse(json['temperature']?.toString() ?? '36.5') ?? 36.5,
      temperatureLevel: json['temperature_level'] ?? 'normal',
      temperatureEmoji: json['temperature_emoji'] ?? '🙂',
      totalTransactions: json['total_transactions'] ?? 0,
      completedTransactions: json['completed_transactions'] ?? 0,
      cancelledTransactions: json['cancelled_transactions'] ?? 0,
      reviewsReceived: json['reviews_received'] ?? 0,
      averageRating: double.tryParse(json['average_rating']?.toString() ?? '0') ?? 0,
      positiveReviews: json['positive_reviews'] ?? 0,
      negativeReviews: json['negative_reviews'] ?? 0,
      responseRate: double.tryParse(json['response_rate']?.toString() ?? '0') ?? 0,
      avgResponseTimeMinutes: json['avg_response_time_minutes'] ?? 0,
      badges: (json['badges'] as List<dynamic>?)
              ?.map((b) => UserBadge.fromJson(b))
              .toList() ??
          [],
    );
  }

  /// Get temperature color based on level
  static int getTemperatureColor(String level) {
    switch (level) {
      case 'cold':
        return 0xFF2196F3; // Blue
      case 'cool':
        return 0xFF90CAF9; // Light Blue
      case 'normal':
        return 0xFFFFC107; // Amber
      case 'warm':
        return 0xFFFF9800; // Orange
      case 'hot':
        return 0xFFFF5722; // Deep Orange
      case 'fire':
        return 0xFFF44336; // Red
      default:
        return 0xFFFFC107; // Amber
    }
  }

  /// Get emoji for temperature level
  static String getEmoji(double temp) {
    if (temp < 20) return '🥶';
    if (temp < 30) return '😐';
    if (temp < 36.5) return '🙂';
    if (temp < 45) return '😊';
    if (temp < 60) return '😄';
    return '🔥';
  }

  /// Get level name for temperature
  static String getLevel(double temp) {
    if (temp < 20) return 'cold';
    if (temp < 30) return 'cool';
    if (temp < 36.5) return 'normal';
    if (temp < 45) return 'warm';
    if (temp < 60) return 'hot';
    return 'fire';
  }

  /// Default trust score for new users
  factory TrustScore.defaultScore(int userId, String username) {
    return TrustScore(
      userId: userId,
      username: username,
      temperature: 36.5,
      temperatureLevel: 'normal',
      temperatureEmoji: '🙂',
      totalTransactions: 0,
      completedTransactions: 0,
      cancelledTransactions: 0,
      reviewsReceived: 0,
      averageRating: 0,
      positiveReviews: 0,
      negativeReviews: 0,
      responseRate: 0,
      avgResponseTimeMinutes: 0,
      badges: [],
    );
  }
}

class UserBadge {
  final String code;
  final String name;
  final String? nameUz;
  final String? nameRu;
  final String icon;
  final String color;
  final String? description;

  const UserBadge({
    required this.code,
    required this.name,
    this.nameUz,
    this.nameRu,
    required this.icon,
    required this.color,
    this.description,
  });

  factory UserBadge.fromJson(Map<String, dynamic> json) {
    return UserBadge(
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      nameUz: json['name_uz'],
      nameRu: json['name_ru'],
      icon: json['icon'] ?? '🏆',
      color: json['color'] ?? '#4CAF50',
      description: json['description'],
    );
  }

  /// Get localized name based on locale
  String getLocalizedName(String locale) {
    switch (locale) {
      case 'uz':
        return nameUz ?? name;
      case 'ru':
        return nameRu ?? name;
      default:
        return name;
    }
  }

  /// Parse color string to int
  int get colorValue {
    try {
      return int.parse(color.replaceFirst('#', '0xFF'));
    } catch (e) {
      return 0xFF4CAF50; // Default green
    }
  }
}

/// Predefined badges
class BadgeTypes {
  static const fastResponder = UserBadge(
    code: 'fast_responder',
    name: 'Fast Responder',
    nameUz: 'Tez javob beruvchi',
    nameRu: 'Быстрый ответчик',
    icon: '⚡',
    color: '#FFD700',
    description: 'Responds within 30 minutes on average',
  );

  static const trustedSeller = UserBadge(
    code: 'trusted_seller',
    name: 'Trusted Seller',
    nameUz: 'Ishonchli sotuvchi',
    nameRu: 'Надежный продавец',
    icon: '🏆',
    color: '#4CAF50',
    description: '10+ completed sales with 4.5+ rating',
  );

  static const verifiedBuyer = UserBadge(
    code: 'verified_buyer',
    name: 'Verified Buyer',
    nameUz: 'Tasdiqlangan xaridor',
    nameRu: 'Проверенный покупатель',
    icon: '✅',
    color: '#2196F3',
    description: '5+ completed purchases',
  );

  static const topRated = UserBadge(
    code: 'top_rated',
    name: 'Top Rated',
    nameUz: 'Eng yuqori baho',
    nameRu: 'Лучший рейтинг',
    icon: '⭐',
    color: '#FF9800',
    description: 'Average rating 4.8+ with 20+ reviews',
  );

  static const premiumMember = UserBadge(
    code: 'premium_member',
    name: 'Premium Member',
    nameUz: 'Premium foydalanuvchi',
    nameRu: 'Премиум пользователь',
    icon: '💎',
    color: '#9C27B0',
    description: 'Subscribed to premium features',
  );
}
