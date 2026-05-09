class Location {
  const Location({
    required this.id,
    this.countryCode,
    required this.country,
    required this.region,
    required this.district,
    this.fullAddress,
  });

  final int id;
  final String? countryCode; // ISO country code (UZ, KZ, etc.)
  final String country;
  final String region;
  final String district;
  final String? fullAddress;

  /// Returns the full address if available, otherwise constructs it from parts
  String get displayAddress {
    if (fullAddress != null && fullAddress!.isNotEmpty) {
      return fullAddress!;
    }
    final parts = [district, region, country].where((p) => p.isNotEmpty).toList();
    return parts.join(', ');
  }

  /// Returns a short display (region, district only)
  String get shortAddress {
    final parts = [district, region].where((p) => p.isNotEmpty).toList();
    return parts.join(', ');
  }

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'] != null ? int.tryParse(json['id'].toString()) ?? 0 : 0,
      countryCode: json['country_code'],
      country: json['country'] ?? '',
      region: json['region'] ?? '',
      district: json['district'] ?? '',
      fullAddress: json['full_address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'country_code': countryCode,
      'country': country,
      'region': region,
      'district': district,
      'full_address': fullAddress,
    };
  }

  Location copyWith({
    int? id,
    String? countryCode,
    String? country,
    String? region,
    String? district,
    String? fullAddress,
  }) {
    return Location(
      id: id ?? this.id,
      countryCode: countryCode ?? this.countryCode,
      country: country ?? this.country,
      region: region ?? this.region,
      district: district ?? this.district,
      fullAddress: fullAddress ?? this.fullAddress,
    );
  }
}

class Regions {
  const Regions({
    required this.id,
    required this.region,
    this.countryCode,
  });

  final int id;
  final String region;
  final String? countryCode;

  factory Regions.fromJson(Map<String, dynamic> json) {
    return Regions(
      id: json['id'] ?? 0,
      region: json['region'] ?? json['name'] ?? '',
      countryCode: json['country_code'] ?? json['country'],
    );
  }
}

class Districts {
  const Districts({
    required this.id,
    required this.district,
    this.regionId,
  });

  final int id;
  final String district;
  final int? regionId;

  factory Districts.fromJson(Map<String, dynamic> json) {
    return Districts(
      id: json['id'] ?? 0,
      district: json['district'] ?? json['name'] ?? '',
      regionId: json['region_id'] ?? json['region'],
    );
  }
}
