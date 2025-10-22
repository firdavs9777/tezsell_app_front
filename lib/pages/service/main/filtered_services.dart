import 'package:app/pages/service/main/service_search.dart';
import 'package:app/pages/service/main/services_list.dart';
import 'package:app/pages/tab_bar/tab_bar.dart';
import 'package:app/providers/provider_models/service_model.dart';
import 'package:app/providers/provider_root/service_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FilteredServices extends ConsumerStatefulWidget {
  final String categoryName;
  const FilteredServices({super.key, required this.categoryName});

  @override
  ConsumerState<FilteredServices> createState() => _FilteredServicesState();
}

class _FilteredServicesState extends ConsumerState<FilteredServices> {
  Future<List<Services>> getFilteredServices() async {
    // Assuming you have a method to fetch filtered products based on category
    return ref
        .read(serviceMainProvider)
        .getFilteredServices(categoryName: widget.categoryName);
  }

  Future<void> refresh() async {
    // To trigger the refresh logic when pulled down
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close), // X icon
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (ctx) => const TabsScreen()),
            ); // Close the screen or navigate back
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search), // Search icon
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => const ServiceSearch(),
                ),
              );
            },
          ),
        ],
        title: Text("Filtered Services"), // Title for the AppBar
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: refresh,
              child: FutureBuilder<List<Services>>(
                future: getFilteredServices(), // Trigger the future here
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (snapshot.hasData) {
                    final productsList = snapshot.data!;
                    if (productsList.isEmpty) {
                      return const Center(
                          child: Text('No products available.'));
                    }

                    return ListView.builder(
                      itemCount: productsList.length,
                      itemBuilder: (context, index) {
                        final service = productsList[index];
                        return ServiceList(
                          service: service,
                          refresh: () {},
                        );
                      },
                    );
                  }

                  return const Center(child: Text('No products available.'));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
