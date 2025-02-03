import 'package:app/pages/products/product_new.dart';
import 'package:app/pages/service/services_list.dart';
import 'package:app/providers/provider_root/service_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ServiceMain extends ConsumerStatefulWidget {
  const ServiceMain({Key? key}) : super(key: key);

  @override
  _ServiceMainState createState() => _ServiceMainState();
}

class _ServiceMainState extends ConsumerState<ServiceMain> {
  Future<void> refresh() async {
    ref.refresh(servicesProvider);
  }

  @override
  Widget build(BuildContext context) {
    final servicesList = ref.watch(servicesProvider);

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
                onRefresh: refresh,
                child: servicesList.when(
                  data: (item) {
                    if (item.isEmpty) {
                      return const Center(
                        child: Text('No services available'),
                      );
                    }
                    return ListView.builder(
                        itemCount: item.length,
                        itemBuilder: (context, index) {
                          final service = item[index];
                          return ServiceList(service: service);
                        });
                  },
                  error: (error, stack) =>
                      Center(child: Text('Error: $error $stack')),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                )),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (ctx) => const ProductNew(),
            ));
          },
          backgroundColor: const Color(0xFFFFA500),
          icon: const Icon(
            Icons.add,
            color: Colors.black,
            size: 24,
          ), // Black icon
          label: const Text(
            'Yuklash',
            style: TextStyle(fontSize: 18, color: Colors.black), // Black text
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
