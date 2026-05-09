class Neighborhood {
  final String id;
  final String name;
  final String displayName;
  final String countryCode;
  final String region;
  final String city;
  final double centroidLat;
  final double centroidLng;

  const Neighborhood({
    required this.id,
    required this.name,
    required this.displayName,
    required this.countryCode,
    required this.region,
    required this.city,
    required this.centroidLat,
    required this.centroidLng,
  });

  factory Neighborhood.fromJson(Map<String, dynamic> j) => Neighborhood(
        id: j['id'] as String,
        name: j['name'] as String,
        displayName: j['display_name'] as String,
        countryCode: j['country_code'] as String,
        region: j['region'] as String,
        city: j['city'] as String,
        centroidLat: (j['centroid_lat'] as num).toDouble(),
        centroidLng: (j['centroid_lng'] as num).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'display_name': displayName,
        'country_code': countryCode,
        'region': region,
        'city': city,
        'centroid_lat': centroidLat,
        'centroid_lng': centroidLng,
      };
}

class VerifiedNeighborhood {
  static const Duration validityDuration = Duration(days: 60);

  final Neighborhood neighborhood;
  final DateTime verifiedAt;
  final double gpsAccuracyM;
  final bool lowConfidence;

  const VerifiedNeighborhood({
    required this.neighborhood,
    required this.verifiedAt,
    required this.gpsAccuracyM,
    this.lowConfidence = false,
  });

  DateTime get expiresAt => verifiedAt.add(validityDuration);
  bool get isExpired => DateTime.now().isAfter(expiresAt);

  factory VerifiedNeighborhood.fromJson(Map<String, dynamic> j) =>
      VerifiedNeighborhood(
        neighborhood:
            Neighborhood.fromJson(j['neighborhood'] as Map<String, dynamic>),
        verifiedAt: DateTime.parse(j['verified_at'] as String),
        gpsAccuracyM: (j['gps_accuracy_m'] as num).toDouble(),
        lowConfidence: (j['low_confidence'] as bool?) ?? false,
      );

  Map<String, dynamic> toJson() => {
        'neighborhood': neighborhood.toJson(),
        'verified_at': verifiedAt.toIso8601String(),
        'gps_accuracy_m': gpsAccuracyM,
        'low_confidence': lowConfidence,
      };
}
