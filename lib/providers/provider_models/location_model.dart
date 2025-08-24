class Location {
  const Location({
    required this.id,
    required this.country,
    required this.region,
    required this.district,
  });

  final int id;
  final String country;
  final String region;
  final String district;

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'] != null ? int.tryParse(json['id'].toString()) ?? 0 : 0,
      country: json["country"] ?? '',
      region: json['region'] ?? '',
      district: json['district'] ?? '',
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
