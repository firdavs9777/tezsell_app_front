class Location {
  const Location({
    required this.id,
    required this.region,
    required this.district,
  });

  final int id;
  final String region;
  final String district;

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'],
      region: json['region'],
      district: json['district'],
    );
  }
}
