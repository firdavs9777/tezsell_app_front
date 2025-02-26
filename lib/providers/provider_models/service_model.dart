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
  final DateTime createdAt;
  final DateTime updatedAt;

  factory Services.fromJson(Map<String, dynamic> json) {
    return Services(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      category: CategoryModel.fromJson(json['category']),
      location: Location.fromJson(json['location']),
      images: (json['images'] as List)
          .map((imageJson) => ImageData.fromJson(imageJson))
          .toList(),
      comments: (json['comments'] as List)
          .map((commentJson) => Comments.fromJson(commentJson))
          .toList(),
      likeCount: json['likeCount'],
      userName: UserInfo.fromJson(json['userName']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
