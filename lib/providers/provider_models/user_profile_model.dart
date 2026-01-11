import 'package:app/providers/provider_models/location_model.dart';
import 'package:app/providers/provider_models/product_model.dart';
import 'package:app/providers/provider_models/service_model.dart';
import 'package:app/providers/provider_models/user_model.dart';

/// Public user profile model for viewing other users' profiles
class UserProfile {
  const UserProfile({
    required this.id,
    required this.username,
    required this.profileImage,
    required this.location,
    required this.memberSince,
    required this.isActive,
    required this.totalListings,
    required this.activeListings,
    required this.followersCount,
    required this.followingCount,
    required this.isFollowing,
    this.recentProducts = const [],
    this.recentServices = const [],
  });

  final int id;
  final String username;
  final ProfileImage profileImage;
  final Location location;
  final DateTime memberSince;
  final bool isActive;
  final int totalListings;
  final int activeListings;
  final int followersCount;
  final int followingCount;
  final bool isFollowing;
  final List<Products> recentProducts;
  final List<Services> recentServices;

  /// Get user initials for avatar fallback
  String get initials {
    if (username.isEmpty) return '?';
    final parts = username.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return username[0].toUpperCase();
  }

  /// Get formatted member since date
  String get memberSinceFormatted {
    final months = [
      'Yanvar', 'Fevral', 'Mart', 'Aprel', 'May', 'Iyun',
      'Iyul', 'Avgust', 'Sentyabr', 'Oktyabr', 'Noyabr', 'Dekabr'
    ];
    return "${months[memberSince.month - 1]} ${memberSince.year}";
  }

  /// Check if this is the current user (should not show follow button)
  bool isCurrentUser(int currentUserId) => id == currentUserId;

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    // Parse member_since date - backend uses 'created_at'
    DateTime memberSince;
    try {
      memberSince = DateTime.parse(
        json['created_at'] ?? json['member_since'] ?? json['date_joined'] ?? ''
      );
    } catch (_) {
      memberSince = DateTime.now();
    }

    // Parse recent products
    List<Products> recentProducts = [];
    if (json['recent_products'] != null && json['recent_products'] is List) {
      recentProducts = (json['recent_products'] as List)
          .map((p) => Products.fromJson(p))
          .toList();
    }

    // Parse recent services
    List<Services> recentServices = [];
    if (json['recent_services'] != null && json['recent_services'] is List) {
      recentServices = (json['recent_services'] as List)
          .map((s) => Services.fromJson(s))
          .toList();
    }

    // Parse profile image - can be null, a string URL, or an object
    ProfileImage profileImage;
    final profileImageData = json['profile_image'];
    if (profileImageData == null) {
      profileImage = ProfileImage.fromJson({});
    } else if (profileImageData is String) {
      profileImage = ProfileImage.fromJson({'image': profileImageData});
    } else if (profileImageData is Map<String, dynamic>) {
      profileImage = ProfileImage.fromJson(profileImageData);
    } else {
      profileImage = ProfileImage.fromJson({});
    }

    // Calculate total listings from individual counts
    final productsCount = json['products_count'] ?? 0;
    final servicesCount = json['services_count'] ?? 0;
    final propertiesCount = json['properties_count'] ?? 0;
    final totalListings = json['total_listings'] ?? (productsCount + servicesCount + propertiesCount);
    final activeListings = json['active_listings'] ?? totalListings;

    return UserProfile(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      profileImage: profileImage,
      location: Location.fromJson(json['location'] ?? {}),
      memberSince: memberSince,
      isActive: json['is_active'] ?? true,
      totalListings: totalListings,
      activeListings: activeListings,
      followersCount: json['followers_count'] ?? 0,
      followingCount: json['following_count'] ?? 0,
      isFollowing: json['is_following'] ?? false,
      recentProducts: recentProducts,
      recentServices: recentServices,
    );
  }

  /// Create a copy with updated follow status
  UserProfile copyWithFollowStatus({required bool isFollowing, int? followersCount}) {
    return UserProfile(
      id: id,
      username: username,
      profileImage: profileImage,
      location: location,
      memberSince: memberSince,
      isActive: isActive,
      totalListings: totalListings,
      activeListings: activeListings,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount,
      isFollowing: isFollowing,
      recentProducts: recentProducts,
      recentServices: recentServices,
    );
  }
}

/// Follow/Following list item
class FollowUser {
  const FollowUser({
    required this.id,
    required this.username,
    required this.profileImage,
    required this.isFollowing,
  });

  final int id;
  final String username;
  final ProfileImage profileImage;
  final bool isFollowing;

  String get initials {
    if (username.isEmpty) return '?';
    return username[0].toUpperCase();
  }

  factory FollowUser.fromJson(Map<String, dynamic> json) {
    // Parse profile image - can be null, a string URL, or an object
    ProfileImage profileImage;
    final profileImageData = json['profile_image'];
    if (profileImageData == null) {
      profileImage = ProfileImage.fromJson({});
    } else if (profileImageData is String) {
      profileImage = ProfileImage.fromJson({'image': profileImageData});
    } else if (profileImageData is Map<String, dynamic>) {
      profileImage = ProfileImage.fromJson(profileImageData);
    } else {
      profileImage = ProfileImage.fromJson({});
    }

    return FollowUser(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      profileImage: profileImage,
      isFollowing: json['is_following'] ?? false,
    );
  }

  FollowUser copyWithFollowStatus(bool isFollowing) {
    return FollowUser(
      id: id,
      username: username,
      profileImage: profileImage,
      isFollowing: isFollowing,
    );
  }
}

/// Paginated follow list response
class FollowListResponse {
  const FollowListResponse({
    required this.count,
    required this.results,
    this.next,
    this.previous,
  });

  final int count;
  final List<FollowUser> results;
  final String? next;
  final String? previous;

  bool get hasMore => next != null;

  /// Factory that handles different API response formats:
  /// - Paginated: {count, results, next, previous}
  /// - Simple list: [...]
  /// - Wrapped: {data: [...]} or {data: {results: [...]}}
  factory FollowListResponse.fromJson(dynamic json) {
    // Handle if response is a List directly
    if (json is List) {
      final results = json.map((u) => FollowUser.fromJson(u as Map<String, dynamic>)).toList();
      return FollowListResponse(
        count: results.length,
        results: results,
      );
    }

    // Handle Map response
    if (json is Map<String, dynamic>) {
      // Check for wrapped data
      if (json['data'] != null) {
        return FollowListResponse.fromJson(json['data']);
      }

      // Check for results array (paginated format)
      if (json['results'] != null && json['results'] is List) {
        return FollowListResponse(
          count: json['count'] ?? (json['results'] as List).length,
          results: (json['results'] as List)
              .map((u) => FollowUser.fromJson(u as Map<String, dynamic>))
              .toList(),
          next: json['next'],
          previous: json['previous'],
        );
      }

      // Check for followers/following array directly
      if (json['followers'] != null && json['followers'] is List) {
        final results = (json['followers'] as List)
            .map((u) => FollowUser.fromJson(u as Map<String, dynamic>))
            .toList();
        return FollowListResponse(count: results.length, results: results);
      }
      if (json['following'] != null && json['following'] is List) {
        final results = (json['following'] as List)
            .map((u) => FollowUser.fromJson(u as Map<String, dynamic>))
            .toList();
        return FollowListResponse(count: results.length, results: results);
      }
    }

    // Fallback: empty response
    return const FollowListResponse(count: 0, results: []);
  }
}
