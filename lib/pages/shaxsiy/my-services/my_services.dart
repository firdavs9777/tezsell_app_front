import 'package:app/pages/shaxsiy/my-services/service_edit.dart';
import 'package:app/providers/provider_models/service_model.dart';
import 'package:app/providers/provider_root/profile_provider.dart';
import 'package:app/utils/image_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/l10n/app_localizations.dart';

class MyServices extends ConsumerStatefulWidget {
  const MyServices({super.key});

  @override
  ConsumerState<MyServices> createState() => _MyServicesState();
}

class _MyServicesState extends ConsumerState<MyServices> {
  List<Services> _services = [];
  bool _isLoading = true;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _loadServices();
  }

  Future<void> _loadServices() async {
    try {
      setState(() => _isLoading = true);

      final services = await ref.read(profileServiceProvider).getUserServices();
      if (mounted) {
        setState(() {
          _services = services;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showError('Error loading services: $e');
      }
    }
  }

  Future<void> _refreshServices() async {
    await _loadServices();
  }

  void _deleteService(int serviceId) {
    final localizations = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(localizations?.delete_service ?? 'Delete Service'),
          content: Text(localizations?.delete_service_confirmation ??
              'Are you sure you want to delete this service?'),
          actions: [
            TextButton(
              child: Text(
                localizations?.cancel ?? 'Cancel',
                style: TextStyle(color: colorScheme.onSurface),
              ),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: Text(
                localizations?.delete ?? 'Delete',
                style: TextStyle(color: colorScheme.error),
              ),
              onPressed: () async {
                Navigator.of(dialogContext).pop();

                // Show loading dialog
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    Future.delayed(const Duration(seconds: 3), () {
                      if (mounted) Navigator.of(context).pop();
                    });

                    return Center(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const CircularProgressIndicator(),
                      ),
                    );
                  },
                );

                try {
                  // TODO: Implement delete API call
                  // await ref.read(profileServiceProvider).deleteService(serviceId);

                  // Remove from local list
                  setState(() {
                    _services.removeWhere((service) => service.id == serviceId);
                    _hasChanges = true;
                  });

                  if (mounted) Navigator.of(context).pop();

                  _showSuccess('Service deleted successfully');
                } catch (e) {
                  if (mounted) Navigator.of(context).pop();
                  _showError('Error deleting service: $e');
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _editService(int serviceId) {
    final service = _services.firstWhere((s) => s.id == serviceId);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ServiceEdit(service: service),
      ),
    ).then((updatedService) {
      if (updatedService != null && updatedService is Services) {
        setState(() {
          final index = _services.indexWhere((s) => s.id == updatedService.id);
          if (index != -1) {
            _services[index] = updatedService;
            _hasChanges = true;
          }
        });
        ref.invalidate(profileServiceProvider);
      }
    });

    // Temporary message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
            'Service edit functionality ready - uncomment navigation code'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showSuccess(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).colorScheme.primary,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, _hasChanges);
        return false;
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
                        Icon(
                          Icons.miscellaneous_services_outlined,
                          size: 80,
                          color: colorScheme.onSurface.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          localizations?.no_services_found ??
                              'No services found',
                          style: TextStyle(
                            fontSize: 18,
                            color: colorScheme.onSurface.withOpacity(0.7),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          localizations?.add_first_service ??
                              'Start by adding your first service',
                          style: TextStyle(
                            fontSize: 14,
                            color: colorScheme.onSurface.withOpacity(0.5),
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
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 6.0,
                            ),
                            child: Card(
                              key: ValueKey(service.id),
                              elevation: 2,
                              shadowColor: colorScheme.shadow.withOpacity(0.1),
                              color: colorScheme.surface,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                side: BorderSide(
                                  color: colorScheme.outline.withOpacity(0.1),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  children: [
                                    // Service Image
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Container(
                                        width: 80,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          color: colorScheme.surfaceVariant,
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        child: service.images.isNotEmpty
                                            ? Image.network(
                                                ImageUtils.buildImageUrl(service.images[0].image),
                                                width: 80,
                                                height: 80,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return _buildPlaceholderImage();
                                                },
                                              )
                                            : _buildPlaceholderImage(),
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
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16.0,
                                              color: colorScheme.onSurface,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4.0),
                                          Text(
                                            service.description,
                                            style: TextStyle(
                                              color: colorScheme.onSurface
                                                  .withOpacity(0.7),
                                              fontSize: 12.0,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 6.0),
                                          if (service.location != null) ...[
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.location_on,
                                                  size: 14.0,
                                                  color: colorScheme.onSurface
                                                      .withOpacity(0.6),
                                                ),
                                                const SizedBox(width: 4.0),
                                                Expanded(
                                                  child: Text(
                                                    '${service.location!.region ?? ''}, ${(service.location!.district ?? '').length > 7 ? '${service.location!.district!.substring(0, 7)}...' : service.location!.district ?? ''}',
                                                    style: TextStyle(
                                                      color: colorScheme
                                                          .onSurface
                                                          .withOpacity(0.6),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              icon: Icon(
                                                Icons.edit,
                                                color: colorScheme.primary,
                                                size: 20,
                                              ),
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
                                              icon: Icon(
                                                Icons.delete,
                                                color: colorScheme.error,
                                                size: 20,
                                              ),
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
                            ),
                          );
                        },
                      ),
                    ),
                  ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        Icons.image_outlined,
        color: colorScheme.onSurface.withOpacity(0.5),
        size: 32,
      ),
    );
  }
}
