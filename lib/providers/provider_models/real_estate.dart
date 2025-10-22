class RealEstate {
  const RealEstate({
    required this.id,
    required this.title,
    required this.propertyType,
    required this.propertyTypeDisplay,
    required this.listingType,
    required this.listingTypeDisplay,
    required this.price,
    required this.pricePerSqm,
    required this.currency,
    required this.squareMeters,
    required this.bedrooms,
    required this.bathrooms,
    required this.district,
    required this.city,
    required this.region,
    required this.userLocation,
    required this.owner,
    this.agent,
    required this.mainImage,
    required this.isFeatured,
    required this.viewsCount,
    required this.createdAt,
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  final String id;
  final String title;
  final String propertyType;
  final String propertyTypeDisplay;
  final String listingType;
  final String listingTypeDisplay;
  final String price;
  final String pricePerSqm;
  final String currency;
  final int squareMeters;
  final int bedrooms;
  final int bathrooms;
  final String district;
  final String city;
  final String region;
  final UserLocation userLocation;
  final Owner owner;
  final Agent? agent;
  final String mainImage;
  final bool isFeatured;
  final int viewsCount;
  final DateTime createdAt;
  final String latitude;
  final String longitude;
  final String address;

  factory RealEstate.fromJson(Map<String, dynamic> json) {
    return RealEstate(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      propertyType: json['property_type'] ?? '',
      propertyTypeDisplay: json['property_type_display'] ?? '',
      listingType: json['listing_type'] ?? '',
      listingTypeDisplay: json['listing_type_display'] ?? '',
      price: json['price'] ?? '0.00',
      pricePerSqm: json['price_per_sqm'] ?? '0.00',
      currency: json['currency'] ?? 'UZS',
      squareMeters: json['square_meters'] ?? 0,
      bedrooms: json['bedrooms'] ?? 0,
      bathrooms: json['bathrooms'] ?? 0,
      district: json['district'] ?? '',
      city: json['city'] ?? '',
      region: json['region'] ?? '',
      userLocation: UserLocation.fromJson(json['user_location'] ?? {}),
      owner: Owner.fromJson(json['owner'] ?? {}),
      agent: json['agent'] != null ? Agent.fromJson(json['agent']) : null,
      mainImage: json['main_image'] ?? '',
      isFeatured: json['is_featured'] ?? false,
      viewsCount: json['views_count'] ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      latitude: json['latitude'] ?? '0.0',
      longitude: json['longitude'] ?? '0.0',
      address: json['address'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'property_type': propertyType,
      'property_type_display': propertyTypeDisplay,
      'listing_type': listingType,
      'listing_type_display': listingTypeDisplay,
      'price': price,
      'price_per_sqm': pricePerSqm,
      'currency': currency,
      'square_meters': squareMeters,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'district': district,
      'city': city,
      'region': region,
      'user_location': userLocation.toJson(),
      'owner': owner.toJson(),
      'agent': agent?.toJson(),
      'main_image': mainImage,
      'is_featured': isFeatured,
      'views_count': viewsCount,
      'created_at': createdAt.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
    };
  }
}

class UserLocation {
  const UserLocation({
    required this.id,
    required this.country,
    required this.region,
    required this.district,
    required this.displayName,
  });

  final int id;
  final String country;
  final String region;
  final String district;
  final String displayName;

  factory UserLocation.fromJson(Map<String, dynamic> json) {
    return UserLocation(
      id: json['id'] ?? 0,
      country: json['country'] ?? '',
      region: json['region'] ?? '',
      district: json['district'] ?? '',
      displayName: json['display_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'country': country,
      'region': region,
      'district': district,
      'display_name': displayName,
    };
  }
}

class Owner {
  const Owner({
    required this.id,
    required this.username,
    required this.phoneNumber,
    required this.userType,
  });

  final int id;
  final String username;
  final String phoneNumber;
  final String userType;

  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      userType: json['user_type'] ?? 'regular',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'phone_number': phoneNumber,
      'user_type': userType,
    };
  }
}

class Agent {
  const Agent({
    required this.id,
    required this.username,
    required this.phoneNumber,
    required this.userType,
  });

  final int id;
  final String username;
  final String phoneNumber;
  final String userType;

  factory Agent.fromJson(Map<String, dynamic> json) {
    return Agent(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      userType: json['user_type'] ?? 'agent',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'phone_number': phoneNumber,
      'user_type': userType,
    };
  }
}

class Permission {
  final int? id;
  final String? username;
  final String? phoneNumber;
  final String? userType;
  final bool isAgent;
  final bool isVerifiedAgent;
  final bool isStaff;
  final bool isSuperuser;
  final bool canCreateProperties;
  final bool canManageInquiries;
  final bool canAccessAdmin;
  final bool canVerifyAgents;
  final bool canManageUsers;
  final String userRole;
  final DateTime? lastUpdated;

  const Permission({
    this.id,
    this.username,
    this.phoneNumber,
    this.userType,
    required this.isAgent,
    required this.isVerifiedAgent,
    required this.isStaff,
    required this.isSuperuser,
    required this.canCreateProperties,
    required this.canManageInquiries,
    required this.canAccessAdmin,
    required this.canVerifyAgents,
    required this.canManageUsers,
    required this.userRole,
    this.lastUpdated,
  });

  factory Permission.fromJson(Map<String, dynamic> json) {
    return Permission(
      id: json['id'],
      username: json['username'],
      phoneNumber: json['phone_number'],
      userType: json['user_type'],
      isAgent: json['is_agent'] ?? false,
      isVerifiedAgent: json['is_verified_agent'] ?? false,
      isStaff: json['is_staff'] ?? false,
      isSuperuser: json['is_superuser'] ?? false,
      canCreateProperties: json['can_create_properties'] ?? false,
      canManageInquiries: json['can_manage_inquiries'] ?? false,
      canAccessAdmin: json['can_access_admin'] ?? false,
      canVerifyAgents: json['can_verify_agents'] ?? false,
      canManageUsers: json['can_manage_users'] ?? false,
      userRole: json['user_role'] ?? 'user',
      lastUpdated: json['last_updated'] != null
          ? DateTime.tryParse(json['last_updated'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'phone_number': phoneNumber,
      'user_type': userType,
      'is_agent': isAgent,
      'is_verified_agent': isVerifiedAgent,
      'is_staff': isStaff,
      'is_superuser': isSuperuser,
      'can_create_properties': canCreateProperties,
      'can_manage_inquiries': canManageInquiries,
      'can_access_admin': canAccessAdmin,
      'can_verify_agents': canVerifyAgents,
      'can_manage_users': canManageUsers,
      'user_role': userRole,
      'last_updated': lastUpdated?.toIso8601String(),
    };
  }

  // Convenience getters for easier permission checking
  bool get hasAgentAccess => isAgent || isVerifiedAgent || canCreateProperties;
  bool get hasAdminAccess => isStaff || isSuperuser || canAccessAdmin;
  bool get canManageAgents => canVerifyAgents || isSuperuser;
  bool get hasFullAdminRights => isSuperuser;

  // Role-based getters
  bool get isRegularUser => !isAgent && !isStaff && !isSuperuser;
  bool get isSuperAdmin => userRole == 'super_admin' || isSuperuser;
  bool get isVerifiedAgentUser => isVerifiedAgent && isAgent;

  // Copy with method for state updates
  Permission copyWith({
    int? id,
    String? username,
    String? phoneNumber,
    String? userType,
    bool? isAgent,
    bool? isVerifiedAgent,
    bool? isStaff,
    bool? isSuperuser,
    bool? canCreateProperties,
    bool? canManageInquiries,
    bool? canAccessAdmin,
    bool? canVerifyAgents,
    bool? canManageUsers,
    String? userRole,
    DateTime? lastUpdated,
  }) {
    return Permission(
      id: id ?? this.id,
      username: username ?? this.username,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      userType: userType ?? this.userType,
      isAgent: isAgent ?? this.isAgent,
      isVerifiedAgent: isVerifiedAgent ?? this.isVerifiedAgent,
      isStaff: isStaff ?? this.isStaff,
      isSuperuser: isSuperuser ?? this.isSuperuser,
      canCreateProperties: canCreateProperties ?? this.canCreateProperties,
      canManageInquiries: canManageInquiries ?? this.canManageInquiries,
      canAccessAdmin: canAccessAdmin ?? this.canAccessAdmin,
      canVerifyAgents: canVerifyAgents ?? this.canVerifyAgents,
      canManageUsers: canManageUsers ?? this.canManageUsers,
      userRole: userRole ?? this.userRole,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  String toString() {
    return 'Permission(id: $id, username: $username, userRole: $userRole, '
        'isAgent: $isAgent, isStaff: $isStaff, isSuperuser: $isSuperuser)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Permission &&
        other.id == id &&
        other.username == username &&
        other.phoneNumber == phoneNumber &&
        other.userType == userType &&
        other.isAgent == isAgent &&
        other.isVerifiedAgent == isVerifiedAgent &&
        other.isStaff == isStaff &&
        other.isSuperuser == isSuperuser &&
        other.canCreateProperties == canCreateProperties &&
        other.canManageInquiries == canManageInquiries &&
        other.canAccessAdmin == canAccessAdmin &&
        other.canVerifyAgents == canVerifyAgents &&
        other.canManageUsers == canManageUsers &&
        other.userRole == userRole;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      username,
      phoneNumber,
      userType,
      isAgent,
      isVerifiedAgent,
      isStaff,
      isSuperuser,
      canCreateProperties,
      canManageInquiries,
      canAccessAdmin,
      canVerifyAgents,
      canManageUsers,
      userRole,
    );
  }
}

// // Extension for navigation logic
// extension PermissionNavigation on Permission {
//   List<String> get availableRoutes {
//     List<String> routes = [
//       '/',
//       '/products',
//       '/service',
//       '/properties',
//       '/agents',
//     ];
//
//     if (hasAgentAccess) {
//       routes.addAll([
//         '/agent/dashboard',
//         '/agent/properties',
//         '/agent/inquiries',
//         '/agent/profile',
//       ]);
//
//       if (canCreateProperties) {
//         routes.add('/agent/create-property');
//       }
//     }
//
//     if (hasAdminAccess) {
//       routes.addAll([
//         '/admin/dashboard',
//         '/admin/users',
//       ]);
//
//       if (canVerifyAgents) {
//         routes.addAll([
//           '/admin/pending-agents',
//           '/admin/verified-agents',
//         ]);
//       }
//     }
//
//     return routes;
//   }
//
//   bool canAccessRoute(String route) {
//     return availableRoutes.contains(route);
//   }
// }

class SavedProperty {
  final int id;
  final RealEstate property;
  final DateTime savedAt;

  const SavedProperty({
    required this.id,
    required this.property,
    required this.savedAt,
  });

  factory SavedProperty.fromJson(Map<String, dynamic> json) {
    return SavedProperty(
      id: json['id'] ?? 0,
      property: RealEstate.fromJson(json['property'] ?? {}),
      savedAt: json['saved_at'] != null
          ? DateTime.parse(json['saved_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'property': property.toJson(),
      'saved_at': savedAt.toIso8601String(),
    };
  }
}

class SavedPropertiesResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<SavedProperty> results;

  const SavedPropertiesResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory SavedPropertiesResponse.fromJson(Map<String, dynamic> json) {
    final resultsData = json['results'] as List? ?? [];
    final results = resultsData.map((item) {
      if (item['property'] != null) {
        return SavedProperty.fromJson(item);
      } else {
        return SavedProperty(
          id: DateTime.now().millisecondsSinceEpoch,
          property: RealEstate.fromJson(item),
          savedAt: DateTime.now(),
        );
      }
    }).toList();

    return SavedPropertiesResponse(
      count: json['count'] ?? 0,
      next: json['next'],
      previous: json['previous'],
      results: results,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'next': next,
      'previous': previous,
      'results': results.map((e) => e.toJson()).toList(),
    };
  }
}
