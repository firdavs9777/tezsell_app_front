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
      reviewer: _reviewUserFromJson(
        idField: json['reviewer'],
        nameField: json['reviewer_name'],
        imageField: json['reviewer_image'],
      ),
      reviewedUser: _reviewUserFromJson(
        idField: json['reviewed_user'],
        nameField: json['reviewed_user_name'],
        imageField: json['reviewed_user_image'],
      ),
      // Backend `ReviewSerializer` names this field `transaction` (an int
      // PK); tolerate a `transaction_id` key too for forward-compat.
      transactionId: json['transaction'] ?? json['transaction_id'],
      rating: json['rating'] ?? 5,
      reviewText: json['review_text'],
      tags: _tagNamesFromJson(json),
      isBuyerReview: json['is_buyer_review'] ?? true,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }

  /// Backend `ReviewSerializer` sends `reviewer`/`reviewed_user` as a flat
  /// int PK with sibling `*_name`/`*_image` fields (same convention as
  /// `Transaction.fromJson`'s `seller`/`seller_name`), not a nested user
  /// object. Also tolerate a nested map shape defensively, in case a caller
  /// (or a future backend revision) sends one.
  static ReviewUser _reviewUserFromJson({
    dynamic idField,
    dynamic nameField,
    dynamic imageField,
  }) {
    if (idField is Map<String, dynamic>) {
      return ReviewUser.fromJson(idField);
    }
    final id = idField is int
        ? idField
        : int.tryParse(idField?.toString() ?? '') ?? 0;
    return ReviewUser(
      id: id,
      username: nameField?.toString() ?? '',
      avatar: imageField?.toString(),
    );
  }

  /// The backend's `UserReviewsView` returns per-review tags as
  /// `tags_display` (a list of `{id, name, icon}` objects resolved from the
  /// tag PKs in `tags`). Prefer that for display names; fall back to `tags`
  /// only if it already contains strings (e.g. hand-built test fixtures).
  static List<String> _tagNamesFromJson(Map<String, dynamic> json) {
    final display = json['tags_display'] as List<dynamic>?;
    if (display != null) {
      return display
          .map((t) => (t is Map ? t['name']?.toString() : t?.toString()) ?? '')
          .where((name) => name.isNotEmpty)
          .toList();
    }
    final rawTags = json['tags'] as List<dynamic>?;
    if (rawTags != null && rawTags.isNotEmpty && rawTags.first is String) {
      return List<String>.from(rawTags);
    }
    return [];
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

/// Request model for submitting a review.
///
/// Mirrors the backend `CreateReviewSerializer`: `transactionId` travels in
/// the body and `tags` are ReviewTag PK integers.
class SubmitReviewRequest {
  final int transactionId;
  final int rating;
  final String? reviewText;
  final List<int> tags;

  SubmitReviewRequest({
    required this.transactionId,
    required this.rating,
    this.reviewText,
    required this.tags,
  });

  Map<String, dynamic> toJson() {
    return {
      'transaction_id': transactionId,
      'rating': rating,
      if (reviewText != null) 'review_text': reviewText,
      'tags': tags,
    };
  }
}

/// One page of a user's received (or given) reviews, matching the
/// `UserReviewsView` envelope:
/// `{success, data: {trust_score, reviews: [...], pagination: {page,
/// page_size, total, total_pages}}}`.
///
/// Deliberately separate from the old `summary`-keyed shape returned by
/// `ReviewsService.getUserReviews` -- this backend endpoint does not return
/// a `summary` key, only `pagination` + `trust_score`.
class PaginatedReviews {
  final List<Review> reviews;
  final int page;
  final int pageSize;
  final int total;
  final int totalPages;

  const PaginatedReviews({
    required this.reviews,
    required this.page,
    required this.pageSize,
    required this.total,
    required this.totalPages,
  });

  bool get hasMore => page < totalPages;

  factory PaginatedReviews.fromJson(Map<String, dynamic> json) {
    final reviewsJson = json['reviews'] as List<dynamic>? ?? const [];
    final pagination = json['pagination'] as Map<String, dynamic>? ?? const {};
    final parsedReviews = reviewsJson
        .whereType<Map<String, dynamic>>()
        .map((r) => Review.fromJson(r))
        .toList();

    return PaginatedReviews(
      reviews: parsedReviews,
      page: pagination['page'] ?? 1,
      pageSize: pagination['page_size'] ?? parsedReviews.length,
      total: pagination['total'] ?? parsedReviews.length,
      totalPages: pagination['total_pages'] ?? (parsedReviews.isEmpty ? 0 : 1),
    );
  }

  factory PaginatedReviews.empty() => const PaginatedReviews(
        reviews: [],
        page: 1,
        pageSize: 0,
        total: 0,
        totalPages: 0,
      );
}
