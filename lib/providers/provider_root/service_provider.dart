import 'dart:convert';

import 'package:app/constants/constants.dart';
import 'package:app/providers/provider_models/service_model.dart';

import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ServiceProvider {
  Future<List<Services>> getServices() async {
    print("Fetching services from API..."); // Debugging

    final response = await http.get(Uri.parse('$baseUrl$SERVICES_URL'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data);
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
  print("Fetching services from API..."); // Debugging

  final service = ServiceProvider();
  return service.getServices();
});

final serviceMainProvider = Provider((ref) => ServiceProvider());
