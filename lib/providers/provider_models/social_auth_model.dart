/// Social Authentication Models for Google and Apple Sign-In

class SocialAuthResponse {
  final bool success;
  final String message;
  final bool isNewUser;
  final AuthTokens? tokens;
  final SocialUserInfo? userInfo;
  final String? error;

  SocialAuthResponse({
    required this.success,
    required this.message,
    this.isNewUser = false,
    this.tokens,
    this.userInfo,
    this.error,
  });

  factory SocialAuthResponse.fromJson(Map<String, dynamic> json) {
    // Handle tokens - can be nested in 'tokens' object or at root level
    AuthTokens? tokens;
    if (json['tokens'] != null) {
      tokens = AuthTokens.fromJson(json['tokens']);
    } else if (json['token'] != null || json['access_token'] != null) {
      // Backend returns token/access_token/refresh_token at root level
      tokens = AuthTokens(
        access: json['access_token'] ?? json['token'] ?? '',
        refresh: json['refresh_token'] ?? '',
      );
    }

    // Handle user info - can be nested in 'user_info' or 'user' or at root level
    SocialUserInfo? userInfo;
    if (json['user_info'] != null) {
      userInfo = SocialUserInfo.fromJson(json['user_info']);
    } else if (json['user'] != null) {
      userInfo = SocialUserInfo.fromJson(json['user']);
    } else if (json['user_id'] != null || json['id'] != null) {
      // User data at root level
      userInfo = SocialUserInfo(
        id: json['user_id'] ?? json['id'] ?? 0,
        email: json['email'] ?? '',
        username: json['username'] ?? '',
        avatar: json['avatar'],
        isVerified: json['is_verified'] ?? false,
        location: json['location'] != null
            ? SocialUserLocation.fromJson(json['location'])
            : null,
      );
    }

    return SocialAuthResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      isNewUser: json['is_new_user'] ?? false,
      tokens: tokens,
      userInfo: userInfo,
      error: json['error'],
    );
  }

  factory SocialAuthResponse.error(String message) {
    return SocialAuthResponse(
      success: false,
      message: message,
      error: message,
    );
  }
}

class AuthTokens {
  final String access;
  final String refresh;

  AuthTokens({
    required this.access,
    required this.refresh,
  });

  factory AuthTokens.fromJson(Map<String, dynamic> json) {
    return AuthTokens(
      access: json['access'] ?? '',
      refresh: json['refresh'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access': access,
      'refresh': refresh,
    };
  }
}

class SocialUserLocation {
  final String? region;
  final String? district;

  SocialUserLocation({
    this.region,
    this.district,
  });

  factory SocialUserLocation.fromJson(Map<String, dynamic> json) {
    return SocialUserLocation(
      region: json['region'],
      district: json['district'],
    );
  }

  bool get isComplete => region != null && region!.isNotEmpty;
}

class SocialUserInfo {
  final int id;
  final String email;
  final String username;
  final String? avatar;
  final bool isVerified;
  final SocialUserLocation? location;

  SocialUserInfo({
    required this.id,
    required this.email,
    required this.username,
    this.avatar,
    required this.isVerified,
    this.location,
  });

  factory SocialUserInfo.fromJson(Map<String, dynamic> json) {
    return SocialUserInfo(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      avatar: json['avatar'],
      isVerified: json['is_verified'] ?? false,
      location: json['location'] != null
          ? SocialUserLocation.fromJson(json['location'])
          : null,
    );
  }

  /// Check if user needs to set up location
  bool get needsLocationSetup => location == null || !location!.isComplete;
}

class SocialAccount {
  final int id;
  final String provider; // google, apple
  final String email;
  final String? name;
  final DateTime createdAt;

  SocialAccount({
    required this.id,
    required this.provider,
    required this.email,
    this.name,
    required this.createdAt,
  });

  factory SocialAccount.fromJson(Map<String, dynamic> json) {
    return SocialAccount(
      id: json['id'] ?? 0,
      provider: json['provider'] ?? '',
      email: json['email'] ?? '',
      name: json['name'],
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }

  String get providerDisplayName {
    switch (provider) {
      case 'google':
        return 'Google';
      case 'apple':
        return 'Apple';
      default:
        return provider;
    }
  }

  String get providerIcon {
    switch (provider) {
      case 'google':
        return 'assets/icons/google.png';
      case 'apple':
        return 'assets/icons/apple.png';
      default:
        return '';
    }
  }
}

/// Google Sign-In Request
class GoogleSignInRequest {
  final String idToken;

  GoogleSignInRequest({
    required this.idToken,
  });

  Map<String, dynamic> toJson() {
    return {
      'id_token': idToken,
    };
  }
}

/// Apple Sign-In Request
class AppleSignInRequest {
  final String idToken;
  final String? userEmail;
  final String? userName;

  AppleSignInRequest({
    required this.idToken,
    this.userEmail,
    this.userName,
  });

  Map<String, dynamic> toJson() {
    return {
      'id_token': idToken,
      if (userEmail != null) 'user_email': userEmail,
      if (userName != null) 'user_name': userName,
    };
  }
}

/// Unlink Social Account Request
class UnlinkSocialAccountRequest {
  final String provider;

  UnlinkSocialAccountRequest({
    required this.provider,
  });

  Map<String, dynamic> toJson() {
    return {
      'provider': provider,
    };
  }
}

/// Login History Entry
class LoginHistoryEntry {
  final int id;
  final String ipAddress;
  final String device;
  final String userAgent;
  final String loginMethod; // password, google, apple
  final bool success;
  final bool isNewDevice;
  final DateTime createdAt;

  LoginHistoryEntry({
    required this.id,
    required this.ipAddress,
    required this.device,
    required this.userAgent,
    required this.loginMethod,
    required this.success,
    required this.isNewDevice,
    required this.createdAt,
  });

  factory LoginHistoryEntry.fromJson(Map<String, dynamic> json) {
    return LoginHistoryEntry(
      id: json['id'] ?? 0,
      ipAddress: json['ip_address'] ?? '',
      device: json['device'] ?? 'unknown',
      userAgent: json['user_agent'] ?? '',
      loginMethod: json['login_method'] ?? 'password',
      success: json['success'] ?? true,
      isNewDevice: json['is_new_device'] ?? false,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }

  String get deviceIcon {
    switch (device.toLowerCase()) {
      case 'mobile':
        return '📱';
      case 'tablet':
        return '📱';
      case 'desktop':
        return '💻';
      default:
        return '🖥️';
    }
  }

  String get loginMethodDisplay {
    switch (loginMethod) {
      case 'google':
        return 'Google';
      case 'apple':
        return 'Apple';
      case 'password':
        return 'Password';
      default:
        return loginMethod;
    }
  }
}

/// Account Lockout Response
class AccountLockoutResponse {
  final bool success;
  final String error;
  final DateTime? lockedUntil;
  final int minutesRemaining;

  AccountLockoutResponse({
    required this.success,
    required this.error,
    this.lockedUntil,
    required this.minutesRemaining,
  });

  factory AccountLockoutResponse.fromJson(Map<String, dynamic> json) {
    return AccountLockoutResponse(
      success: json['success'] ?? false,
      error: json['error'] ?? '',
      lockedUntil: json['locked_until'] != null
          ? DateTime.tryParse(json['locked_until'])
          : null,
      minutesRemaining: json['minutes_remaining'] ?? 0,
    );
  }
}

/// Social Auth Provider enum
enum SocialAuthProvider {
  google,
  apple,
}

extension SocialAuthProviderExtension on SocialAuthProvider {
  String get value {
    switch (this) {
      case SocialAuthProvider.google:
        return 'google';
      case SocialAuthProvider.apple:
        return 'apple';
    }
  }

  String get displayName {
    switch (this) {
      case SocialAuthProvider.google:
        return 'Google';
      case SocialAuthProvider.apple:
        return 'Apple';
    }
  }
}
