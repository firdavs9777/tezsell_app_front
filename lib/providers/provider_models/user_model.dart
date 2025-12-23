import 'dart:ffi';

import 'package:app/providers/provider_models/location_model.dart';

class UserInfo {
  const UserInfo({
    required this.id,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.userType,
    required this.profileImage,
    required this.location,
    required this.isActive,
    this.isStaff = false,
    this.isSuperuser = false,
    this.canAccessAdmin = false,
  });

  final int id;
  final String username;
  final String email;
  final String phoneNumber;
  final String userType;
  final ProfileImage profileImage;
  final Location location;
  final bool isActive;
  final bool isStaff;
  final bool isSuperuser;
  final bool canAccessAdmin;

  // Helper getter to check if user has admin access
  bool get hasAdminAccess {
    return isStaff || isSuperuser || canAccessAdmin || 
           userType.toLowerCase().contains('admin') ||
           userType.toLowerCase().contains('staff') ||
           userType.toLowerCase().contains('superuser');
  }

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    // Safely parse boolean fields, handling null values
    bool parseBool(dynamic value) {
      if (value == null) return false;
      if (value is bool) return value;
      if (value is String) {
        return value.toLowerCase() == 'true' || value == '1';
      }
      if (value is int) return value != 0;
      return false;
    }

    return UserInfo(
      id: json['id'] ?? 0, // default to 0 if null
      username: json['username'] ?? '', // default to empty string if null
      email: json['email'] ?? '', // default to empty string if null
      phoneNumber:
          json['phone_number'] ?? '', // default to empty string if null
      userType: json['user_type'] ?? '', // default to empty string if null
      profileImage: ProfileImage.fromJson(json['profile_image'] ?? {}),
      location: Location.fromJson(json['location'] ?? {}),
      isActive: parseBool(json['is_active']), // safely parse boolean
      isStaff: parseBool(json['is_staff']), // safely parse boolean
      isSuperuser: parseBool(json['is_superuser']), // safely parse boolean
      canAccessAdmin: parseBool(json['can_access_admin']), // safely parse boolean
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
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
      'alt_text': altText,
    };
  }
}
