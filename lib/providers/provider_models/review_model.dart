/// Review Model for user reviews with star ratings and tags

class Review {
  final int id;
  final ReviewUser reviewer;
  final ReviewUser reviewedUser;
  final int? transactionId;
  final int rating; // 1-5 stars
  final String? reviewText;
  final List<String> tags;
  final bool isBuyerReview;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.reviewer,
    required this.reviewedUser,
    this.transactionId,
    required this.rating,
    this.reviewText,
    required this.tags,
    required this.isBuyerReview,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] ?? 0,
      reviewer: ReviewUser.fromJson(json['reviewer'] ?? {}),
      reviewedUser: ReviewUser.fromJson(json['reviewed_user'] ?? {}),
      transactionId: json['transaction_id'],
      rating: json['rating'] ?? 5,
      reviewText: json['review_text'],
      tags: List<String>.from(json['tags'] ?? []),
      isBuyerReview: json['is_buyer_review'] ?? true,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reviewer': reviewer.toJson(),
      'reviewed_user': reviewedUser.toJson(),
      'transaction_id': transactionId,
      'rating': rating,
      'review_text': reviewText,
      'tags': tags,
      'is_buyer_review': isBuyerReview,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class ReviewUser {
  final int id;
  final String username;
  final String? avatar;

  ReviewUser({
    required this.id,
    required this.username,
    this.avatar,
  });

  factory ReviewUser.fromJson(Map<String, dynamic> json) {
    return ReviewUser(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      avatar: json['avatar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'avatar': avatar,
    };
  }
}

class ReviewSummary {
  final int totalReviews;
  final double averageRating;
  final Map<int, int> ratingDistribution; // {5: 15, 4: 3, 3: 1, 2: 0, 1: 1}

  ReviewSummary({
    required this.totalReviews,
    required this.averageRating,
    required this.ratingDistribution,
  });

  factory ReviewSummary.fromJson(Map<String, dynamic> json) {
    final distribution = <int, int>{};
    final dist = json['rating_distribution'] as Map<String, dynamic>? ?? {};
    for (var i = 1; i <= 5; i++) {
      distribution[i] = dist[i.toString()] ?? 0;
    }

    return ReviewSummary(
      totalReviews: json['total_reviews'] ?? 0,
      averageRating:
          double.tryParse(json['average_rating']?.toString() ?? '0') ?? 0,
      ratingDistribution: distribution,
    );
  }

  /// Get percentage for a specific star rating
  double getPercentage(int stars) {
    if (totalReviews == 0) return 0;
    return (ratingDistribution[stars] ?? 0) / totalReviews * 100;
  }
}

class ReviewTag {
  final int id;
  final String name;
  final String? nameUz;
  final String? nameRu;
  final String tagType; // positive, negative
  final String icon;
  final bool forBuyer;
  final bool forSeller;

  const ReviewTag({
    required this.id,
    required this.name,
    this.nameUz,
    this.nameRu,
    required this.tagType,
    required this.icon,
    this.forBuyer = true,
    this.forSeller = true,
  });

  factory ReviewTag.fromJson(Map<String, dynamic> json) {
    return ReviewTag(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      nameUz: json['name_uz'],
      nameRu: json['name_ru'],
      tagType: json['tag_type'] ?? 'positive',
      icon: json['icon'] ?? '👍',
      forBuyer: json['for_buyer'] ?? true,
      forSeller: json['for_seller'] ?? true,
    );
  }

  bool get isPositive => tagType == 'positive';
  bool get isNegative => tagType == 'negative';

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
}

/// Predefined review tags
class ReviewTags {
  // Positive tags
  static const fastResponse = ReviewTag(
    id: 1,
    name: 'Fast Response',
    nameUz: 'Tez javob',
    nameRu: 'Быстрый ответ',
    tagType: 'positive',
    icon: '⚡',
  );

  static const goodCondition = ReviewTag(
    id: 2,
    name: 'Good Condition',
    nameUz: 'Yaxshi holat',
    nameRu: 'Хорошее состояние',
    tagType: 'positive',
    icon: '✨',
  );

  static const friendly = ReviewTag(
    id: 3,
    name: 'Friendly',
    nameUz: 'Do\'stona',
    nameRu: 'Дружелюбный',
    tagType: 'positive',
    icon: '🤝',
  );

  static const wellPackaged = ReviewTag(
    id: 4,
    name: 'Well Packaged',
    nameUz: 'Yaxshi qadoqlangan',
    nameRu: 'Хорошо упаковано',
    tagType: 'positive',
    icon: '📦',
  );

  static const onTime = ReviewTag(
    id: 5,
    name: 'On Time',
    nameUz: 'O\'z vaqtida',
    nameRu: 'Вовремя',
    tagType: 'positive',
    icon: '⏰',
  );

  static const fairPrice = ReviewTag(
    id: 6,
    name: 'Fair Price',
    nameUz: 'Adolatli narx',
    nameRu: 'Справедливая цена',
    tagType: 'positive',
    icon: '💰',
  );

  // Negative tags
  static const lateResponse = ReviewTag(
    id: 7,
    name: 'Late Response',
    nameUz: 'Kech javob',
    nameRu: 'Поздний ответ',
    tagType: 'negative',
    icon: '🐢',
  );

  static const notAsDescribed = ReviewTag(
    id: 8,
    name: 'Not as Described',
    nameUz: 'Tavsifga mos emas',
    nameRu: 'Не соответствует описанию',
    tagType: 'negative',
    icon: '😕',
  );

  static const noShow = ReviewTag(
    id: 9,
    name: 'No Show',
    nameUz: 'Kelmadi',
    nameRu: 'Не пришёл',
    tagType: 'negative',
    icon: '🚫',
  );

  static const rude = ReviewTag(
    id: 10,
    name: 'Rude',
    nameUz: 'Qo\'pol',
    nameRu: 'Грубый',
    tagType: 'negative',
    icon: '💢',
  );

  static List<ReviewTag> get allPositive => [
        fastResponse,
        goodCondition,
        friendly,
        wellPackaged,
        onTime,
        fairPrice,
      ];

  static List<ReviewTag> get allNegative => [
        lateResponse,
        notAsDescribed,
        noShow,
        rude,
      ];

  static List<ReviewTag> get all => [...allPositive, ...allNegative];
}

/// Request model for submitting a review
class SubmitReviewRequest {
  final int rating;
  final String? reviewText;
  final List<String> tags;

  SubmitReviewRequest({
    required this.rating,
    this.reviewText,
    required this.tags,
  });

  Map<String, dynamic> toJson() {
    return {
      'rating': rating,
      'review_text': reviewText,
      'tags': tags,
    };
  }
}
