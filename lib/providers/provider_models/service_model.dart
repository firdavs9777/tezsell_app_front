import 'package:app/providers/provider_models/category_model.dart';
import 'package:app/providers/provider_models/product_model.dart';
import 'package:app/providers/provider_models/location_model.dart';

class Services {
  const Services({
    required this.id,
    required this.name,
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
  final String name;
  final String description;

  final CategoryModel category;
  final Location location;
  final List<Comment> comments;
  final List<ImageData> images;
  final UserName userName;
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
          .map((commentJson) => Comment.fromJson(commentJson))
          .toList(),
      userName: UserName.fromJson(json['userName']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

class Comment {
  const Comment({
    required this.id,
    required this.user,
    required this.text,
    required this.createdAt,
  });

  final int id;
  final UserName user;
  final String text;
  final DateTime createdAt;

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      user: UserName.fromJson(json['user']),
      text: json['text'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
