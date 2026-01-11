import 'package:app/providers/provider_models/category_model.dart';
import 'package:app/providers/provider_models/comments_model.dart';
import 'package:app/providers/provider_models/location_model.dart';
import 'package:app/providers/provider_models/user_model.dart';

class Services {
  const Services({
    required this.id,
    required this.name,
    required this.likeCount,
    required this.description,
    required this.category,
    required this.location,
    required this.images,
    required this.comments,
    required this.userName,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final int likeCount;
  final String name;
  final String description;
  final CategoryModel category;
  final Location location;
  final List<Comments> comments;
  final List<ImageData> images;
  final UserInfo userName;
  final bool isActive;  // NEW: Whether service is visible
  final DateTime createdAt;
  final DateTime updatedAt;

  factory Services.fromJson(Map<String, dynamic> json) {
    return Services(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      category: CategoryModel.fromJson(json['category'] ?? {}),
      location: Location.fromJson(json['location'] ?? {}),
      images: (json['images'] as List?)
          ?.map((imageJson) => ImageData.fromJson(imageJson))
          .toList() ?? [],
      comments: (json['comments'] as List?)
          ?.map((commentJson) => Comments.fromJson(commentJson))
          .toList() ?? [],
      likeCount: json['likeCount'] ?? 0,
      userName: UserInfo.fromJson(json['userName'] ?? {}),
      isActive: json['is_active'] ?? true,  // NEW
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
    );
  }
}
