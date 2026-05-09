import 'package:app/pages/service/new/widgets/service_new_image_picker.dart';
import 'package:app/providers/provider_models/category_model.dart';
import 'package:app/providers/provider_models/place.dart';
import 'package:app/providers/provider_root/service_provider.dart';
import 'package:app/utils/error_handler.dart';
import 'package:app/utils/app_logger.dart';
import 'package:app/utils/content_filter.dart';
import 'package:app/widgets/maps/location_picker.dart';
import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:app/l10n/app_localizations.dart';

class ServiceNew extends ConsumerStatefulWidget {
  const ServiceNew({super.key});

  @override
  ConsumerState<ServiceNew> createState() => _ServiceNewState();
}

class _ServiceNewState extends ConsumerState<ServiceNew> {
  final _formKey = GlobalKey<FormState>();
  final _formatter = NumberFormat('#,##0', 'en_US');

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  List<CategoryModel> availableCategories = [];
  int? selectedCategory;
  final List<File> _selectedImages = [];
  final picker = ImagePicker();
  bool _isUploading = false;
  Place? _pickedPlace;

  Future<void> _openMapPicker() async {
    final initial = _pickedPlace != null
        ? LatLng(_pickedPlace!.lat, _pickedPlace!.lng)
        : const LatLng(41.3, 69.24);
    final picked = await Navigator.of(context).push<Place>(
      MaterialPageRoute(
        builder: (_) => LocationPicker(
          initialCenter: initial,
          onConfirmed: (p) => Navigator.of(context).pop(p),
        ),
      ),
    );
    if (picked != null && mounted) {
      setState(() => _pickedPlace = picked);
    }
  }

  String getCategoryName(CategoryModel category) {
    final locale = Localizations.localeOf(context).languageCode;
    switch (locale) {
      case 'uz':
        return category.nameUz;
      case 'ru':
        return category.nameRu;
      case 'en':
      default:
        return category.nameEn;
    }
  }

  Future<void> _fetchCategories() async {
    try {
      final categories = await ref.read(serviceMainProvider).getCategories();
      setState(() {
        availableCategories = categories;
      });
    } catch (e) {
      AppErrorHandler.logError('ServiceNew._fetchCategories', e);
      AppErrorHandler.showError(context, e);
    }
  }

  Future<void> _showImageSourceDialog() async {
    if (!mounted) return;

    final colorScheme = Theme.of(context).colorScheme;
    final localizations = AppLocalizations.of(context);

    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: colorScheme.surface,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                localizations?.selectImageSource ?? 'Select Image Source',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.camera_alt, color: colorScheme.primary),
              title: Text(
                localizations?.camera ?? 'Camera',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: Icon(Icons.photo_library, color: colorScheme.secondary),
              title: Text(
                localizations?.gallery ?? 'Gallery',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );

    if (source != null) {
      await _pickImage(source: source);
    }
  }

  Future<void> _pickImage({required ImageSource source}) async {
    try {
      if (source == ImageSource.gallery) {
        final pickedFiles = await picker.pickMultiImage(
          maxWidth: 2560,
          maxHeight: 2560,
          imageQuality: 95,
        );
        if (mounted) {
          setState(() {
            _selectedImages.addAll(
              pickedFiles.map((pickedFile) => File(pickedFile.path)),
            );
          });
          AppLogger.debug('Selected ${pickedFiles.length} images from gallery');
        }
      } else {
        final pickedFile = await picker.pickImage(
          source: source,
          maxWidth: 2560,
          maxHeight: 2560,
          imageQuality: 95,
        );
        if (pickedFile != null && mounted) {
          final imageFile = File(pickedFile.path);

          final fileSize = await imageFile.length();
          const maxSize = 10 * 1024 * 1024; // 10MB

          if (fileSize > maxSize) {
            if (mounted) {
              AppErrorHandler.showWarning(
                context,
                'Image is too large. Maximum size is 10MB',
              );
            }
            return;
          }

          setState(() {
            _selectedImages.add(imageFile);
          });
          AppLogger.debug('Selected image from ${source.name}');
        }
      }
    } catch (e) {
      AppErrorHandler.logError('ServiceNew._pickImage', e);
      AppErrorHandler.showError(context, e);
    }
  }

  Future<void> _submitProduct() async {
    if (_isUploading) {
      AppLogger.debug('Service submission already in progress');
      return;
    }

    final localizations = AppLocalizations.of(context);

    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Content filtering
    final contentError = ContentFilter.validateContent(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
    );
    if (contentError != null) {
      AppErrorHandler.showWarning(context, contentError);
      return;
    }

    if (selectedCategory == null) {
      AppErrorHandler.showWarning(
        context,
        'Please select a valid category.',
      );
      return;
    }

    if (_selectedImages.isEmpty) {
      AppErrorHandler.showWarning(
        context,
        'At least one service image is required',
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    // Store router reference BEFORE async operation
    final router = GoRouter.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      AppLogger.debug('Starting service creation...');

      if (!mounted) return;
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Text(localizations?.uploading ?? 'Uploading service...'),
            ],
          ),
          duration: const Duration(seconds: 30),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );

      final service = await ref.read(serviceMainProvider).createService(
            name: _titleController.text.trim(),
            description: _descriptionController.text.trim(),
            categoryId: selectedCategory!,
            imageFiles: _selectedImages,
          );

      if (!mounted) return;

      scaffoldMessenger.hideCurrentSnackBar();

      AppLogger.info('Service created successfully: ${service.id}');

      // Trigger refresh in services list
      ref.read(servicesRefreshProvider.notifier).state++;

      // Show success message
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Service successfully added!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      // Pop this page to go back to services list (was opened with Navigator.push)
      if (mounted) {
        Navigator.of(context).pop();
      }
        } catch (e) {
      AppErrorHandler.logError('ServiceNew._submitProduct', e);
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        // Extract actual error message from DioException
        String errorMessage = 'Error while creating service. Please try again.';
        if (e is DioException && e.message != null && e.message!.isNotEmpty) {
          errorMessage = e.message!;
        }
        AppErrorHandler.showError(context, errorMessage);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final localizations = AppLocalizations.of(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppBar(
          elevation: 0,
          title: Text(
            localizations?.addNewServiceBtn ?? 'Create New Service',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Images Section
                ServiceNewImagePicker(
                  images: _selectedImages,
                  isUploading: _isUploading,
                  onAddTap: _showImageSourceDialog,
                  onRemove: (index) {
                    setState(() {
                      _selectedImages.removeAt(index);
                    });
                  },
                ),
                const SizedBox(height: 20),

                // Basic Information Card
                _buildCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader(
                        localizations?.serviceName ?? 'Service Information',
                        Icons.info_outline,
                        theme,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _titleController,
                        enabled: !_isUploading,
                        decoration: InputDecoration(
                          labelText: '${localizations?.serviceName ?? 'Service Name'} *',
                          hintText: localizations?.serviceName ?? 'Enter service name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.work),
                          filled: true,
                          fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return localizations?.pleaseFillAllRequired ?? 'Please enter service name';
                          }
                          if (value.trim().length < 3) {
                            return localizations?.service_name_min_length ?? 'Service name must be at least 3 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _descriptionController,
                        enabled: !_isUploading,
                        maxLines: 5,
                        decoration: InputDecoration(
                          labelText: '${localizations?.serviceDescription ?? 'Description'} *',
                          hintText: localizations?.serviceDescription ?? 'Describe your service in detail...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.description),
                          filled: true,
                          fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return localizations?.pleaseFillAllRequired ?? 'Please enter description';
                          }
                          if (value.trim().length < 10) {
                            return localizations?.service_description_min_length ?? 'Description must be at least 10 characters';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Category Card
                _buildCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader(
                        localizations?.serviceCategory ?? 'Category',
                        Icons.category,
                        theme,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<CategoryModel>(
                        initialValue: selectedCategory != null
                            ? availableCategories.firstWhere(
                                (cat) => cat.id == selectedCategory,
                                orElse: () => availableCategories.first,
                              )
                            : null,
                        isExpanded: true,
                        decoration: InputDecoration(
                          labelText: '${localizations?.serviceCategory ?? 'Select Category'} *',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.category),
                          filled: true,
                          fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                        ),
                        hint: Text(
                          localizations?.serviceCategory ?? 'Select a category',
                          overflow: TextOverflow.ellipsis,
                        ),
                        items: availableCategories
                            .map((category) => DropdownMenuItem(
                                  value: category,
                                  child: Text(
                                    getCategoryName(category),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ))
                            .toList(),
                        onChanged: _isUploading
                            ? null
                            : (CategoryModel? value) {
                                if (value != null) {
                                  setState(() {
                                    selectedCategory = value.id;
                                  });
                                }
                              },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a category';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.map_outlined),
                    title: Text(_pickedPlace?.formattedAddress ??
                        'Pick service location'),
                    subtitle: _pickedPlace == null
                        ? const Text('Help nearby customers find your service')
                        : Text(
                            '${_pickedPlace!.lat.toStringAsFixed(5)}, ${_pickedPlace!.lng.toStringAsFixed(5)}',
                          ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: _isUploading ? null : _openMapPicker,
                  ),
                ),
                const SizedBox(height: 24),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isUploading ? null : _submitProduct,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: _isUploading
                        ? SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation<Color>(colorScheme.onPrimary),
                            ),
                          )
                        : Text(
                            localizations?.upload ?? 'Upload Service',
                            style: theme.textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, ThemeData theme) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: theme.colorScheme.primary),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
