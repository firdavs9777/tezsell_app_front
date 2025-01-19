import 'dart:convert';

import 'package:app/constants/constants.dart';
import 'package:app/providers/provider_models/service_model.dart';

import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'dart:io';
// import 'package:http_parser/http_parser.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class ServiceProvider {
  Future<List<Services>> getServices() async {
    final response = await http.get(Uri.parse('$baseUrl$SERVICES_URL'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['results'] as List)
          .map((postJson) => Services.fromJson(postJson))
          .toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Future<List<Services>> getSingleService({required String serviceId}) async {
    final response =
        await http.get(Uri.parse('$baseUrl$SERVICES_URL/$serviceId'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      return (data['recommended_services'] as List)
          .map((postJson) => Services.fromJson(postJson))
          .toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }
}

final servicesProvider = FutureProvider<List<Services>>((ref) async {
  final service = ServiceProvider();
  return service.getServices();
});

final serviceMainProvider = Provider((ref) => ServiceProvider());
