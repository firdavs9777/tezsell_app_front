// replies_model.dart

class RepliesResponse {
  final bool success;
  final int count;
  final List<Reply> data;

  RepliesResponse({
    required this.success,
    required this.count,
    required this.data,
  });

  factory RepliesResponse.fromJson(Map<String, dynamic> json) {
    return RepliesResponse(
      success: json['success'] ?? false,
      count: json['count'] ?? 0,
      data: json['data'] != null
          ? (json['data'] as List)
              .map((replyJson) => Reply.fromJson(replyJson))
              .toList()
          : [],
    );
  }
}

class Reply {
  final int id;
  final ReplyUser user;
  final String text;
  final String createdAt;

  Reply({
    required this.id,
    required this.user,
    required this.text,
    required this.createdAt,
  });

  factory Reply.fromJson(Map<String, dynamic> json) {
    return Reply(
      id: json['id'] ?? 0,
      user: ReplyUser.fromJson(json['user'] ?? {}),
      text: json['text'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user.toJson(),
      'text': text,
      'created_at': createdAt,
    };
  }
}

class ReplyUser {
  final int id;
  final String username;
  final String phoneNumber;
  final String userType;
  final ReplyProfileImage? profileImage;
  final ReplyLocation location;
  final bool isActive;

  ReplyUser({
    required this.id,
    required this.username,
    required this.phoneNumber,
    required this.userType,
    this.profileImage,
    required this.location,
    required this.isActive,
  });

  factory ReplyUser.fromJson(Map<String, dynamic> json) {
    return ReplyUser(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      userType: json['user_type'] ?? '',
      profileImage: json['profile_image'] != null
          ? ReplyProfileImage.fromJson(json['profile_image'])
          : null,
      location: ReplyLocation.fromJson(json['location'] ?? {}),
      isActive: json['is_active'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'phone_number': phoneNumber,
      'user_type': userType,
      'profile_image': profileImage?.toJson(),
      'location': location.toJson(),
      'is_active': isActive,
    };
  }
}

class ReplyProfileImage {
  final String image;

  ReplyProfileImage({
    required this.image,
  });

  factory ReplyProfileImage.fromJson(Map<String, dynamic> json) {
    return ReplyProfileImage(
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image': image,
    };
  }
}

class ReplyLocation {
  final int id;
  final String country;
  final String region;
  final String district;

  ReplyLocation({
    required this.id,
    required this.country,
    required this.region,
    required this.district,
  });

  factory ReplyLocation.fromJson(Map<String, dynamic> json) {
    return ReplyLocation(
      id: json['id'] ?? 0,
      country: json['country'] ?? '',
      region: json['region'] ?? '',
      district: json['district'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'country': country,
      'region': region,
      'district': district,
    };
  }
}
