import 'dart:convert';

import 'package:http/http.dart' as http;

class Cities {
  String cities;
  String towns;

  Cities({
    required this.cities,
    required this.towns,
  });

  factory Cities.fromJson(Map<String, dynamic> json) => Cities(
        cities: json["cities"],
        towns: json["towns"],
      );
}

Future<Cities> getCities() async {
  final response = await http.get(
    Uri.parse('http://localhost:5003/api/v1/cities'),
  );
  if (response.statusCode == 200) {
    return Cities.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load post');
  }
}
