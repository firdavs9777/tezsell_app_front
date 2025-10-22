import 'package:app/pages/service/main/services_list.dart';
import 'package:app/providers/provider_models/service_model.dart';
import 'package:flutter/material.dart';

class RecommendedServicesSection extends StatelessWidget {
  const RecommendedServicesSection(
      {super.key, required this.recommendedServices});

  final Future<List<Services>> recommendedServices;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Recommended Services',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          FutureBuilder<List<Services>>(
            future: recommendedServices,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return const Center(child: Text('Error loading products'));
              }
              if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return ServiceList(
                      service: snapshot.data![index],
                      refresh: () {},
                    );
                  },
                );
              }
              return const Center(
                  child: Text('No recommended products found.'));
            },
          ),
        ],
      ),
    );
  }
}
