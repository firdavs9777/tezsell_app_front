import 'package:app/providers/provider_models/category_model.dart';
import 'package:app/providers/provider_models/location_model.dart';
import 'package:app/providers/provider_models/user_model.dart';

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
  final bool isActive;  // NEW: Whether product is visible
  final bool isSold;    // NEW: Whether product is sold
  final List<ImageData> images;
  final double rating;
  final int likeCount;
  final int commentCount;
  final UserInfo userName;
  final UserAddress userAddress;
  final DateTime createdAt;
  final DateTime updatedAt;

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
    );
  }
}
