class Location {
  const Location({
    required this.id,
    required this.country,
    required this.region,
    required this.district,
    this.fullAddress,
  });

  final int id;
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
      country: json["country"] ?? '',
      region: json['region'] ?? '',
      district: json['district'] ?? '',
      fullAddress: json['full_address'],
    );
  }
}

class Regions {
  const Regions({required this.region});

  final String region;

  factory Regions.fromJson(Map<String, dynamic> json) {
    return Regions(region: json['region'] ?? '');
  }
}

class Districts {
  const Districts({required this.id, required this.district});
  final int id;
  final String district;
  factory Districts.fromJson(Map<String, dynamic> json) {
    return Districts(id: json['id'] ?? 0, district: json['district'] ?? '');
  }
}
