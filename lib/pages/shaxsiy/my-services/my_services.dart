import 'package:app/providers/provider_models/service_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyServices extends ConsumerStatefulWidget {
  final List<Services> services;

  const MyServices({super.key, required this.services});

  @override
  ConsumerState<MyServices> createState() => _MyServicesState();
}

class _MyServicesState extends ConsumerState<MyServices> {
  late List<Services> _services;

  @override
  void initState() {
    super.initState();
    _services = List.from(widget.services);
  }

  void _deleteProduct(int index) {
    setState(() {
      _services.removeAt(index);
    });
  }

  void _editProduct(int index) {
    // Navigate to the edit service screen (implement ProductEdit page)
    // Navigator.push(context, MaterialPageRoute(builder: (context) => ProductEdit(service: _services[index])));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Services'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: _services.length,
          itemBuilder: (context, index) {
            final service = _services[index];
            // final formattedPrice =
            //     NumberFormat('#,##0', 'en_US').format(int.parse(service.price));

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                key: ValueKey(service.id),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      spreadRadius: 4,
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Product Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: service.images.isNotEmpty
                          ? Image.network(
                              service.images[0].image,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              'assets/logo/logo_no_background.png',
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                    ),
                    const SizedBox(width: 12.0),
                    // Product Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            service.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            service.description,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12.0,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6.0),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                size: 14.0,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 4.0),
                              Text(
                                '${service.location.region}, ${service.location.district.substring(0, 7)}...',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12.0,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    // Price and Actions
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _editProduct(service.id),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteProduct(service.id),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
