import 'package:app/providers/provider_models/service_model.dart';
import 'package:app/providers/provider_root/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyServices extends ConsumerStatefulWidget {
  const MyServices({super.key});

  @override
  ConsumerState<MyServices> createState() => _MyServicesState();
}

class _MyServicesState extends ConsumerState<MyServices> {
  List<Services> _services = [];
  bool _isLoading = true;
  bool _hasChanges = false; // Track if any changes were made

  @override
  void initState() {
    super.initState();
    _loadServices();
  }

  Future<void> _loadServices() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final services = await ref.read(profileServiceProvider).getUserServices();

      if (mounted) {
        setState(() {
          _services = services;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading services: $e'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _refreshServices() async {
    await _loadServices();
  }

  void _deleteService(int serviceId) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        final localizations = AppLocalizations.of(dialogContext);

        return AlertDialog(
          title: Text(localizations?.delete_service ?? 'Delete Service'),
          content: Text(localizations?.delete_service_confirmation ??
              'Are you sure you want to delete this service?'),
          actions: [
            TextButton(
              child: Text(localizations?.cancel ?? 'Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: Text(localizations?.delete ?? 'Delete'),
              onPressed: () async {
                Navigator.of(dialogContext).pop(); // Close dialog first

                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    // Auto close after 3 seconds
                    Future.delayed(const Duration(seconds: 3), () {
                      if (mounted) Navigator.of(context).pop();
                    });

                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                );

                try {
                  // Call the delete API - you'll need to implement this in your service

                  // Close loading dialog
                  if (mounted) Navigator.of(context).pop();
                } catch (e) {
                  // Close loading dialog
                  if (mounted) Navigator.of(context).pop();

                  // Show error message
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error deleting service: $e'),
                        duration: const Duration(seconds: 3),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _editService(int serviceId) {
    // Find the service by ID
    final service = _services.firstWhere((s) => s.id == serviceId);

    // Navigate to the edit service screen - you'll need to create this
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => ServiceEdit(service: service),
    //   ),
    // ).then((updatedService) {
    //   // If the edit was successful and we got an updated service back
    //   if (updatedService != null && updatedService is Services) {
    //     setState(() {
    //       // Find and update the service in the local list
    //       final index = _services.indexWhere((s) => s.id == updatedService.id);
    //       if (index != -1) {
    //         _services[index] = updatedService;
    //         _hasChanges = true; // Mark that changes were made
    //       }
    //     });
    //
    //     // Also invalidate the provider for future use
    //     ref.invalidate(profileServiceProvider);
    //   }
    // });

    // For now, show a message that edit is not implemented
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Service edit functionality coming soon'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return WillPopScope(
      onWillPop: () async {
        // When user navigates back, return whether changes were made
        Navigator.pop(context, _hasChanges);
        return false; // Prevent default back navigation since we handled it
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(localizations?.my_services ?? 'My Services'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _refreshServices,
              tooltip: localizations?.refresh ?? 'Refresh',
            ),
          ],
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _services.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.miscellaneous_services_outlined,
                          size: 80,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          localizations?.no_services_found ??
                              'No services found',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          localizations?.add_first_service ??
                              'Start by adding your first service',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _refreshServices,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        itemCount: _services.length,
                        itemBuilder: (context, index) {
                          final service = _services[index];

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
                                  // Service Image
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: service.images.isNotEmpty
                                        ? Image.network(
                                            service.images[0].image,
                                            width: 80,
                                            height: 80,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Image.asset(
                                                'assets/logo/logo_no_background.png',
                                                width: 80,
                                                height: 80,
                                                fit: BoxFit.cover,
                                              );
                                            },
                                          )
                                        : Image.asset(
                                            'assets/logo/logo_no_background.png',
                                            width: 80,
                                            height: 80,
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                  const SizedBox(width: 12.0),
                                  // Service Details
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                        if (service.location != null) ...[
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.location_on,
                                                size: 14.0,
                                                color: Colors.grey,
                                              ),
                                              const SizedBox(width: 4.0),
                                              Expanded(
                                                child: Text(
                                                  '${service.location!.region ?? ''}, ${(service.location!.district ?? '').length > 7 ? '${service.location!.district!.substring(0, 7)}...' : service.location!.district ?? ''}',
                                                  style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 12.0,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8.0),
                                  // Actions
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.edit,
                                                color: Colors.blue, size: 20),
                                            onPressed: () =>
                                                _editService(service.id!),
                                            tooltip:
                                                localizations?.edit_service ??
                                                    'Edit Service',
                                            padding: const EdgeInsets.all(4),
                                            constraints: const BoxConstraints(
                                              minWidth: 32,
                                              minHeight: 32,
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete,
                                                color: Colors.red, size: 20),
                                            onPressed: () =>
                                                _deleteService(service.id!),
                                            tooltip: localizations
                                                    ?.delete_service_tooltip ??
                                                'Delete Service',
                                            padding: const EdgeInsets.all(4),
                                            constraints: const BoxConstraints(
                                              minWidth: 32,
                                              minHeight: 32,
                                            ),
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
                  ),
      ),
    );
  }
}
