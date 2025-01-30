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
  final List<ImageData> images;
  final double rating;
  final int likeCount;
  final int commentCount;
  final UserInfo userName;
  final UserAddress userAddress;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory Products.fromJson(Map<String, dynamic> json) {
    return Products(
      id: json['id'] ?? 0, // default to 0 if null
      title: json['title'] ?? '', // default to empty string if null
      description: json['description'] ?? '', // default to empty string if null
      price: json['price'] ?? '', // default to empty string if null
      condition: json['condition'] ?? '', // default to empty string if null
      category: CategoryModel.fromJson(json['category'] ?? {}),
      location: Location.fromJson(json['location'] ?? {}),
      currency: json['currency'] ?? '', // default to empty string if null
      inStock: json['in_stock'] ?? false, // default to false if null
      images: (json['images'] as List<dynamic>?)
              ?.map((imageJson) => ImageData.fromJson(imageJson))
              .toList() ??
          [],
      rating: (json['rating'] is String
              ? double.tryParse(json['rating'] ?? '')
              : json['rating']) ??
          0.0,

      likeCount: json['likeCount'] ?? 0, // default to 0 if null
      commentCount: json['commentCount'] ?? 0, // default to 0 if null
      userName: UserInfo.fromJson(json['userName'] ?? {}),
      userAddress: UserAddress.fromJson(json['userAddress'] ?? {}),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(), // default to now if null
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(), // default to now if null
    );
  }
}
