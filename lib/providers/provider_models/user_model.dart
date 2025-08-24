import 'dart:ffi';

import 'package:app/providers/provider_models/location_model.dart';

class UserInfo {
  const UserInfo({
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

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['id'] ?? 0, // default to 0 if null
      username: json['username'] ?? '', // default to empty string if null
      phoneNumber:
          json['phone_number'] ?? '', // default to empty string if null
      userType: json['user_type'] ?? '', // default to empty string if null
      profileImage: ProfileImage.fromJson(json['profile_image'] ?? {}),
      location: Location.fromJson(json['location'] ?? {}),
      isActive: json['is_active'] ?? false, // default to false if null
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
      id: json['id'] ?? 0, // default to 0 if null
      region: json['region'] ?? '', // default to empty string if null
      district: json['district'] ?? '', // default to empty string if null
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
    required this.id,
    required this.image,
    required this.altText,
  });

  final int id;
  final String image;
  final String altText;

  factory ImageData.fromJson(Map<String, dynamic> json) {
    return ImageData(
      id: json['id'] ?? 0,
      image: json['image'] ?? '', // default to empty string if null
      altText: json['alt_text'] ?? '', // default to empty string if null
    );
  }
}
