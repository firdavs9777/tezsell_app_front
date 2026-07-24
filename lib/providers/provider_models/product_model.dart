import 'package:app/providers/provider_models/category_model.dart';
import 'package:app/providers/provider_models/location_model.dart';
import 'package:app/providers/provider_models/user_model.dart';

/// Seller trust summary embedded in the product DETAIL payload (Plan D
/// Task 2/6). Sourced from `UserTrustScore` on the backend; null-safe
/// because the block is only present on the detail endpoint — list/browse
/// payloads (and `recommended_products` inside a detail response) omit it
/// to avoid N+1 queries, so [Products.seller] is null there.
class ProductSeller {
  const ProductSeller({
    required this.id,
    required this.username,
    this.avatarUrl,
    this.trustTemperature = 36.5,
    this.ratingAvg,
    this.reviewCount = 0,
    this.responseLabel,
  });

  final int id;
  final String username;
  final String? avatarUrl;

  /// Manner-temperature style trust score. Defaults to 36.5 (the backend's
  /// "new user" baseline) when absent.
  final double trustTemperature;

  /// Aggregate rating (1dp). Null when the seller has zero visible reviews.
  final double? ratingAvg;

  /// Count of visible reviews backing [ratingAvg]. 0 when [ratingAvg] is null.
  final int reviewCount;

  /// Optional server-formatted label (e.g. "Responds quickly"). Null when
  /// there isn't enough data to compute one.
  final String? responseLabel;

  factory ProductSeller.fromJson(Map<String, dynamic> json) {
    return ProductSeller(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      avatarUrl: json['avatar'] as String?,
      trustTemperature: _toDouble(json['trust_temperature']) ?? 36.5,
      ratingAvg: _toDouble(json['rating_avg']),
      reviewCount: json['review_count'] is int
          ? json['review_count'] as int
          : int.tryParse(json['review_count']?.toString() ?? '') ?? 0,
      responseLabel: json['response_label'] as String?,
    );
  }
}

class Products {
  const Products({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.condition,
    required this.category,
    required this.location,
    required this.currency,
    required this.inStock,
    required this.isActive,
    required this.isSold,
    required this.images,
    required this.rating,
    required this.likeCount,
    required this.commentCount,
    required this.userName,
    required this.userAddress,
    required this.createdAt,
    required this.updatedAt,
    this.latitude,
    this.longitude,
    this.placeId,
    this.formattedAddress,
    this.countryCode,
    this.regionName,
    this.cityName,
    this.showExactPin = false,
    this.distanceKm,
    this.acceptsOffers = true,
    this.minimumOfferPercent = 70,
    this.seller,
  });

  final int id;
  final String title;
  final String description;
  final String price;
  final String condition;
  final CategoryModel category;
  final Location location;
  final String currency;
  final bool inStock;
  final bool isActive;
  final bool isSold;
  final List<ImageData> images;
  final double rating;
  final int likeCount;
  final int commentCount;
  final UserInfo userName;
  final UserAddress userAddress;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Phase-1 OSM/Carrot location metadata.
  final double? latitude;
  final double? longitude;
  final String? placeId;
  final String? formattedAddress;
  final String? countryCode;
  final String? regionName;
  final String? cityName;

  /// Privacy-pin reveal flag — true once buyer-seller chat initiated.
  final bool showExactPin;

  /// Distance from the active geo center (km, 1dp), when the request was
  /// made with center_lat/center_lng. Null otherwise.
  final double? distanceKm;

  /// Whether the seller allows buyers to make price offers. Defaults to
  /// true (matches the backend `Product.accepts_offers` default).
  final bool acceptsOffers;

  /// Minimum offer as a percentage of the asking price (e.g. 70 = reject
  /// offers below 70%). Defaults to 70 (matches the backend
  /// `Product.minimum_offer_percent` default).
  final int minimumOfferPercent;

  /// Seller trust block (Plan D Task 2/6), present only on the product
  /// DETAIL payload. Null on list/browse payloads and on
  /// `recommended_products` entries.
  final ProductSeller? seller;

  /// Returns localized condition label
  String get conditionLabel {
    switch (condition) {
      case 'new':
        return 'Yangi';
      case 'like_new':
        return 'Deyarli yangi';
      case 'used':
        return 'Ishlatilgan';
      case 'refurbished':
        return 'Tiklangan';
      default:
        return condition;
    }
  }

  /// Returns formatted price with proper currency symbol
  String get formattedPrice {
    final priceNum = double.tryParse(price) ?? 0;
    if (currency == 'UZS') {
      // Format UZS with space as thousands separator
      final formatted = priceNum.toInt().toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]} ',
      );
      return "$formatted so'm";
    } else {
      // Format USD with comma separator
      return '\$${priceNum.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]},',
      )}';
    }
  }

  factory Products.fromJson(Map<String, dynamic> json) {
    return Products(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: json['price']?.toString() ?? '',
      condition: json['condition'] ?? '',
      category: CategoryModel.fromJson(json['category'] ?? {}),
      location: Location.fromJson(json['location'] ?? {}),
      currency: json['currency'] ?? 'UZS',
      inStock: json['in_stock'] ?? false,
      isActive: json['is_active'] ?? true,  // NEW
      isSold: json['is_sold'] ?? false,      // NEW
      images: (json['images'] as List<dynamic>?)
              ?.map((imageJson) => ImageData.fromJson(imageJson))
              .toList() ??
          [],
      rating: (json['rating'] is String
              ? double.tryParse(json['rating'] ?? '')
              : json['rating']) ??
          0.0,
      likeCount: json['likeCount'] ?? 0,
      commentCount: json['commentCount'] ?? 0,
      userName: UserInfo.fromJson(json['userName'] ?? {}),
      userAddress: UserAddress.fromJson(json['userAddress'] ?? {}),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
      latitude: _toDouble(json['latitude']),
      longitude: _toDouble(json['longitude']),
      placeId: json['place_id'] as String?,
      formattedAddress: json['formatted_address'] as String?,
      countryCode: json['country_code'] as String?,
      regionName: json['region_name'] as String?,
      cityName: json['city_name'] as String?,
      showExactPin: (json['show_exact_pin'] as bool?) ?? false,
      distanceKm: _toDouble(json['distance_km']),
      acceptsOffers: (json['accepts_offers'] as bool?) ?? true,
      minimumOfferPercent: (json['minimum_offer_percent'] is num)
          ? (json['minimum_offer_percent'] as num).toInt()
          : 70,
      seller: json['seller'] is Map<String, dynamic>
          ? ProductSeller.fromJson(json['seller'] as Map<String, dynamic>)
          : null,
    );
  }
}

double? _toDouble(dynamic v) {
  if (v == null) return null;
  if (v is num) return v.toDouble();
  return double.tryParse(v.toString());
}
