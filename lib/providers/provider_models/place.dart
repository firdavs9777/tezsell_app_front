class Place {
  final String? placeId;
  final String? formattedAddress;
  final double lat;
  final double lng;
  final String? countryCode;
  final String? region;
  final String? city;
  final String? neighborhood;

  const Place({
    this.placeId,
    this.formattedAddress,
    required this.lat,
    required this.lng,
    this.countryCode,
    this.region,
    this.city,
    this.neighborhood,
  });

  factory Place.fromNominatim(Map<String, dynamic> json) {
    final addr = (json['address'] as Map<String, dynamic>?) ?? const {};
    final cc = addr['country_code'] as String?;
    return Place(
      placeId: json['place_id']?.toString(),
      formattedAddress: json['display_name'] as String?,
      lat: double.parse(json['lat'].toString()),
      lng: double.parse(json['lon'].toString()),
      countryCode: cc?.toUpperCase(),
      region: (addr['state'] ?? addr['region'] ?? addr['province']) as String?,
      city: (addr['city'] ??
          addr['town'] ??
          addr['village'] ??
          addr['hamlet']) as String?,
      neighborhood: (addr['suburb'] ??
          addr['neighbourhood'] ??
          addr['quarter'] ??
          addr['hamlet'] ??
          addr['village'] ??
          addr['city_district']) as String?,
    );
  }

  factory Place.fromJson(Map<String, dynamic> j) => Place(
        placeId: j['place_id'] as String?,
        formattedAddress: j['formatted_address'] as String?,
        lat: (j['lat'] as num).toDouble(),
        lng: (j['lng'] as num).toDouble(),
        countryCode: j['country_code'] as String?,
        region: j['region'] as String?,
        city: j['city'] as String?,
        neighborhood: j['neighborhood'] as String?,
      );

  Map<String, dynamic> toJson() => {
        if (placeId != null) 'place_id': placeId,
        if (formattedAddress != null) 'formatted_address': formattedAddress,
        'lat': lat,
        'lng': lng,
        if (countryCode != null) 'country_code': countryCode,
        if (region != null) 'region': region,
        if (city != null) 'city': city,
        if (neighborhood != null) 'neighborhood': neighborhood,
      };
}
