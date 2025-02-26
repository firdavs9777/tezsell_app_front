import 'package:app/pages/products/main_products.dart';
import 'package:app/pages/service/services_list.dart';
import 'package:app/providers/provider_models/service_model.dart';
import 'package:app/providers/provider_root/product_provider.dart';
import 'package:app/providers/provider_root/service_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/providers/provider_models/product_model.dart';

class ServiceSearch extends ConsumerStatefulWidget {
  const ServiceSearch({super.key});

  @override
  ConsumerState<ServiceSearch> createState() => _ServiceSearchState();
}

class _ServiceSearchState extends ConsumerState<ServiceSearch> {
  final TextEditingController _searchController = TextEditingController();
  Future<List<Services>>? _searchResults;

  void _searchServices(String _) {
    setState(() {
      _searchResults = ref
          .read(serviceMainProvider)
          .getFilteredServices(serviceName: _searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: "Search for services...",
            hintStyle: TextStyle(color: Colors.white60),
            border: InputBorder.none,
          ),
          textInputAction: TextInputAction.search,
          style: TextStyle(color: Colors.white),
          onSubmitted: (_) => _searchServices(_),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () => _searchServices,
          ),
        ],
      ),
      body: _searchResults == null
          ? const Center(child: Text("Enter a search term to find products"))
          : FutureBuilder<List<Services>>(
              future: _searchResults,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No products found"));
                }
                final filteredServices = snapshot.data!;
                return ListView.builder(
                  itemCount: filteredServices.length,
                  itemBuilder: (context, index) {
                    final service = filteredServices[index];
                    return ServiceList(
                      service: service,
                      refresh: () {},
                    );
                  },
                );
              },
            ),
    );
  }
}
