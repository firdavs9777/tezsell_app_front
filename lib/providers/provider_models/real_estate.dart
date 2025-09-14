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
