import 'package:app/providers/provider_models/category_model.dart';
import 'package:app/providers/provider_models/location_model.dart';

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
  final UserName userName;
  final UserAddress userAddress;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory Products.fromJson(Map<String, dynamic> json) {
    return Products(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: json['price'],
      condition: json['condition'],
      category: CategoryModel.fromJson(json['category']),
      location: Location.fromJson(json['location']),
      currency: json['currency'],
      inStock: json['in_stock'],
      images: (json['images'] as List)
          .map((imageJson) => ImageData.fromJson(imageJson))
          .toList(),
      rating: double.parse(json['rating']),
      likeCount: json['likeCount'],
      commentCount: json['commentCount'],
      userName: UserName.fromJson(json['userName']),
      userAddress: UserAddress.fromJson(json['userAddress']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

class ProfileImage {
  const ProfileImage({required this.image, required this.altText});
  final String image;
  final String altText;
  factory ProfileImage.fromJson(Map<String, dynamic> json) {
    return ProfileImage(
        image: json['image'] ?? '', altText: json['alt_text'] ?? '');
  }
}

class ImageData {
  const ImageData({
    required this.image,
    required this.altText,
  });

  final String image;
  final String altText;

  factory ImageData.fromJson(Map<String, dynamic> json) {
    return ImageData(
      image: json['image'] ??
          '', // Provide an empty string as the default value for null
      altText: json['alt_text'] ??
          '', // Provide an empty string as the default value for null
    );
  }
}

class UserName {
  const UserName({
    required this.id,
    required this.username,
    required this.phoneNumber,
    required this.userType,
    required this.profileImage,
    required this.location,
    required this.isActive,
  });

  final int id;
  final String username;
  final String phoneNumber;
  final String userType;
  final ProfileImage profileImage;
  final Location location;
  final bool isActive;

  factory UserName.fromJson(Map<String, dynamic> json) {
    return UserName(
      id: json['id'],
      username: json['username'],
      phoneNumber: json['phone_number'],
      userType: json['user_type'],
      profileImage: ProfileImage.fromJson(json['profile_image']),
      location: Location.fromJson(json['location']),
      isActive: json['is_active'],
    );
  }
}

class UserAddress {
  const UserAddress({
    required this.id,
    required this.region,
    required this.district,
  });

  final int id;
  final String region;
  final String district;

  factory UserAddress.fromJson(Map<String, dynamic> json) {
    return UserAddress(
      id: json['id'],
      region: json['region'],
      district: json['district'],
    );
  }
}
