/// Block User Model for managing blocked users

class BlockedUser {
  final int id;
  final BlockedUserInfo blockedUser;
  final DateTime blockedAt;

  const BlockedUser({
    required this.id,
    required this.blockedUser,
    required this.blockedAt,
  });

  factory BlockedUser.fromJson(Map<String, dynamic> json) {
    return BlockedUser(
      id: json['id'] ?? 0,
      blockedUser: BlockedUserInfo.fromJson(json['blocked_user'] ?? {}),
      blockedAt: DateTime.tryParse(json['blocked_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'blocked_user': blockedUser.toJson(),
      'blocked_at': blockedAt.toIso8601String(),
    };
  }
}

class BlockedUserInfo {
  final int id;
  final String username;
  final String? avatar;

  const BlockedUserInfo({
    required this.id,
    required this.username,
    this.avatar,
  });

  factory BlockedUserInfo.fromJson(Map<String, dynamic> json) {
    return BlockedUserInfo(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      avatar: json['avatar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'avatar': avatar,
    };
  }
}

/// Response for checking if a user is blocked
class BlockCheckResponse {
  final bool isBlocked;

  const BlockCheckResponse({required this.isBlocked});

  factory BlockCheckResponse.fromJson(Map<String, dynamic> json) {
    return BlockCheckResponse(
      isBlocked: json['is_blocked'] ?? false,
    );
  }
}
