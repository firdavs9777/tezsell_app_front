/// Seller Analytics Model for tracking performance metrics

class SellerAnalytics {
  final ProductAnalytics products;
  final ServiceAnalytics services;
  final FavoritesAnalytics favorites;
  final OffersAnalytics offers;
  final TransactionsAnalytics transactions;
  final TrustScoreAnalytics trustScore;

  const SellerAnalytics({
    required this.products,
    required this.services,
    required this.favorites,
    required this.offers,
    required this.transactions,
    required this.trustScore,
  });

  factory SellerAnalytics.fromJson(Map<String, dynamic> json) {
    return SellerAnalytics(
      products: ProductAnalytics.fromJson(json['products'] ?? {}),
      services: ServiceAnalytics.fromJson(json['services'] ?? {}),
      favorites: FavoritesAnalytics.fromJson(json['favorites'] ?? {}),
      offers: OffersAnalytics.fromJson(json['offers'] ?? {}),
      transactions: TransactionsAnalytics.fromJson(json['transactions'] ?? {}),
      trustScore: TrustScoreAnalytics.fromJson(json['trust_score'] ?? {}),
    );
  }

  /// Get total views across all listings
  int get totalViews => products.totalViews + services.totalViews;

  /// Get total likes across all listings
  int get totalLikes => products.totalLikes + services.totalLikes;

  /// Get total listings count
  int get totalListings => products.total + services.total;
}

class ProductAnalytics {
  final int total;
  final int totalViews;
  final int totalLikes;
  final int active;
  final int sold;

  const ProductAnalytics({
    required this.total,
    required this.totalViews,
    required this.totalLikes,
    required this.active,
    required this.sold,
  });

  factory ProductAnalytics.fromJson(Map<String, dynamic> json) {
    return ProductAnalytics(
      total: json['total'] ?? 0,
      totalViews: json['total_views'] ?? 0,
      totalLikes: json['total_likes'] ?? 0,
      active: json['active'] ?? 0,
      sold: json['sold'] ?? 0,
    );
  }
}

class ServiceAnalytics {
  final int total;
  final int totalViews;
  final int totalLikes;

  const ServiceAnalytics({
    required this.total,
    required this.totalViews,
    required this.totalLikes,
  });

  factory ServiceAnalytics.fromJson(Map<String, dynamic> json) {
    return ServiceAnalytics(
      total: json['total'] ?? 0,
      totalViews: json['total_views'] ?? 0,
      totalLikes: json['total_likes'] ?? 0,
    );
  }
}

class FavoritesAnalytics {
  final int onProducts;
  final int onServices;
  final int total;

  const FavoritesAnalytics({
    required this.onProducts,
    required this.onServices,
    required this.total,
  });

  factory FavoritesAnalytics.fromJson(Map<String, dynamic> json) {
    return FavoritesAnalytics(
      onProducts: json['on_products'] ?? 0,
      onServices: json['on_services'] ?? 0,
      total: json['total'] ?? 0,
    );
  }
}

class OffersAnalytics {
  final int totalReceived;
  final int pending;
  final int accepted;
  final int declined;

  const OffersAnalytics({
    required this.totalReceived,
    required this.pending,
    required this.accepted,
    required this.declined,
  });

  factory OffersAnalytics.fromJson(Map<String, dynamic> json) {
    return OffersAnalytics(
      totalReceived: json['total_received'] ?? 0,
      pending: json['pending'] ?? 0,
      accepted: json['accepted'] ?? 0,
      declined: json['declined'] ?? 0,
    );
  }

  /// Acceptance rate percentage
  double get acceptanceRate {
    final responded = accepted + declined;
    if (responded == 0) return 0;
    return (accepted / responded) * 100;
  }
}

class TransactionsAnalytics {
  final int total;
  final int completed;
  final int active;

  const TransactionsAnalytics({
    required this.total,
    required this.completed,
    required this.active,
  });

  factory TransactionsAnalytics.fromJson(Map<String, dynamic> json) {
    return TransactionsAnalytics(
      total: json['total'] ?? 0,
      completed: json['completed'] ?? 0,
      active: json['active'] ?? 0,
    );
  }

  /// Completion rate percentage
  double get completionRate {
    if (total == 0) return 0;
    return (completed / total) * 100;
  }
}

class TrustScoreAnalytics {
  final double temperature;
  final String level;
  final int reviewsReceived;
  final double averageRating;

  const TrustScoreAnalytics({
    required this.temperature,
    required this.level,
    required this.reviewsReceived,
    required this.averageRating,
  });

  factory TrustScoreAnalytics.fromJson(Map<String, dynamic> json) {
    return TrustScoreAnalytics(
      temperature: double.tryParse(json['temperature']?.toString() ?? '36.5') ?? 36.5,
      level: json['level'] ?? 'normal',
      reviewsReceived: json['reviews_received'] ?? 0,
      averageRating: double.tryParse(json['average_rating']?.toString() ?? '0') ?? 0,
    );
  }
}

/// Analytics for a specific listing
class ListingAnalytics {
  final int itemId;
  final String itemType;
  final String title;
  final int views;
  final int likes;
  final int favorites;
  final ListingOffersAnalytics offers;
  final ListingTransactionsAnalytics transactions;
  final DateTime createdAt;

  const ListingAnalytics({
    required this.itemId,
    required this.itemType,
    required this.title,
    required this.views,
    required this.likes,
    required this.favorites,
    required this.offers,
    required this.transactions,
    required this.createdAt,
  });

  factory ListingAnalytics.fromJson(Map<String, dynamic> json) {
    return ListingAnalytics(
      itemId: json['item_id'] ?? 0,
      itemType: json['item_type'] ?? 'product',
      title: json['title'] ?? '',
      views: json['views'] ?? 0,
      likes: json['likes'] ?? 0,
      favorites: json['favorites'] ?? 0,
      offers: ListingOffersAnalytics.fromJson(json['offers'] ?? {}),
      transactions: ListingTransactionsAnalytics.fromJson(json['transactions'] ?? {}),
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }

  /// Views per day since listing created
  double get viewsPerDay {
    final daysSinceCreated = DateTime.now().difference(createdAt).inDays;
    if (daysSinceCreated == 0) return views.toDouble();
    return views / daysSinceCreated;
  }

  /// Engagement rate (likes + favorites / views)
  double get engagementRate {
    if (views == 0) return 0;
    return ((likes + favorites) / views) * 100;
  }
}

class ListingOffersAnalytics {
  final int total;
  final int pending;
  final int accepted;

  const ListingOffersAnalytics({
    required this.total,
    required this.pending,
    required this.accepted,
  });

  factory ListingOffersAnalytics.fromJson(Map<String, dynamic> json) {
    return ListingOffersAnalytics(
      total: json['total'] ?? 0,
      pending: json['pending'] ?? 0,
      accepted: json['accepted'] ?? 0,
    );
  }
}

class ListingTransactionsAnalytics {
  final int total;
  final int completed;

  const ListingTransactionsAnalytics({
    required this.total,
    required this.completed,
  });

  factory ListingTransactionsAnalytics.fromJson(Map<String, dynamic> json) {
    return ListingTransactionsAnalytics(
      total: json['total'] ?? 0,
      completed: json['completed'] ?? 0,
    );
  }
}
