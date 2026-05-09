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
    this.latitude,
    this.longitude,
    this.placeId,
    this.formattedAddress,
    this.countryCode,
    this.regionName,
    this.cityName,
    this.showExactPin = false,
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
  final bool isActive;
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
  /// Backend computes this per-request based on the authenticated user.
  final bool showExactPin;

  factory Services.fromJson(Map<String, dynamic> json) {
    double? toDouble(dynamic v) {
      if (v == null) return null;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString());
    }

    return Services(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      category: CategoryModel.fromJson(json['category'] ?? {}),
      location: Location.fromJson(json['location'] ?? {}),
      images: (json['images'] as List?)
              ?.map((imageJson) => ImageData.fromJson(imageJson))
              .toList() ??
          [],
      comments: (json['comments'] as List?)
              ?.map((commentJson) => Comments.fromJson(commentJson))
              .toList() ??
          [],
      likeCount: json['likeCount'] ?? 0,
      userName: UserInfo.fromJson(json['userName'] ?? {}),
      isActive: json['is_active'] ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
      latitude: toDouble(json['latitude']),
      longitude: toDouble(json['longitude']),
      placeId: json['place_id'] as String?,
      formattedAddress: json['formatted_address'] as String?,
      countryCode: json['country_code'] as String?,
      regionName: json['region_name'] as String?,
      cityName: json['city_name'] as String?,
      showExactPin: (json['show_exact_pin'] as bool?) ?? false,
    );
  }
}
