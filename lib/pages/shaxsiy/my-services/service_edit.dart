import 'dart:io';
import 'package:app/providers/provider_models/service_model.dart';
import 'package:app/providers/provider_models/category_model.dart';
import 'package:app/providers/provider_models/location_model.dart';
import 'package:app/providers/provider_root/profile_provider.dart';
import 'package:app/providers/provider_root/service_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';

class ServiceEdit extends ConsumerStatefulWidget {
  final Services service;

  const ServiceEdit({
    super.key,
    required this.service,
  });

  @override
  ConsumerState<ServiceEdit> createState() => _ServiceEditState();
}

class _ServiceEditState extends ConsumerState<ServiceEdit> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  List<CategoryModel> _categories = [];
  List<Location> _locations = [];
  List<File> _newImages = [];
  List<Map<String, dynamic>> _existingImages = [];
  List<int> _imagesToDelete = [];

  CategoryModel? _selectedCategory;
  Location? _selectedLocation;
  bool _isLoading = false;
  bool _isLoadingCategories = true;
  bool _isLoadingLocations = true;

  @override
  void initState() {
    super.initState();
    _initializeForm();
    _loadCategories();
    _loadLocations();
  }

  void _initializeForm() {
    _nameController.text = widget.service.name;
    _descriptionController.text = widget.service.description;
    _selectedCategory = widget.service.category;
    _selectedLocation = widget.service.location;
    _existingImages = widget.service.images
        .map((img) => {
              'id': img.id,
              'url': img.image,
            })
        .toList();
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await ref.read(serviceMainProvider).getCategories();
      setState(() {
        _categories = categories;
        _isLoadingCategories = false;
      });
    } catch (e) {
      setState(() => _isLoadingCategories = false);
      _showError('Error loading categories: $e');
    }
  }

  Future<void> _loadLocations() async {
    try {
      // final locations = await ref.read(serviceMainProvider).getLocations();
      setState(() {
        // _locations = locations;
        _isLoadingLocations = false;
      });
    } catch (e) {
      setState(() => _isLoadingLocations = false);
      _showError('Error loading locations: $e');
    }
  }

  String getCategoryName(CategoryModel category) {
    final locale = Localizations.localeOf(context);
    switch (locale.languageCode) {
      case 'ru':
        return category.nameRu;
      case 'uz':
        return category.nameUz;
      case 'en':
      default:
        return category.nameEn;
    }
  }

  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();

    try {
      final List<XFile> images = await picker.pickMultiImage(
        imageQuality: 80,
        maxWidth: 1920,
        maxHeight: 1080,
      );

      if (images.isNotEmpty) {
        setState(() {
          _newImages.addAll(images.map((xFile) => File(xFile.path)));
        });
      }
    } catch (e) {
      _showError('Error picking images: $e');
    }
  }

  void _removeExistingImage(Map<String, dynamic> imageData) {
    setState(() {
      _existingImages.remove(imageData);
      _imagesToDelete.add(imageData['id']);
    });
  }

  void _removeNewImage(File image) {
    setState(() {
      _newImages.remove(image);
    });
  }

  Future<void> _saveService() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedCategory == null) {
      _showError('Please select a category');
      return;
    }

    if (_selectedLocation == null) {
      _showError('Please select a location');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final existingImageIds = _existingImages
          .where((img) => !_imagesToDelete.contains(img['id']))
          .map<int>((img) => img['id'])
          .toList();

      final updatedService = await ref.read(serviceMainProvider).updateService(
            serviceId: widget.service.id,
            name: _nameController.text.trim(),
            description: _descriptionController.text.trim(),
            categoryId: _selectedCategory!.id,
            locationId: _selectedLocation!.id,
            newImageFiles: _newImages.isNotEmpty ? _newImages : null,
            existingImageIds:
                existingImageIds.isNotEmpty ? existingImageIds : null,
          );

      if (mounted) {
        Navigator.of(context).pop(updatedService);
      }
    } catch (e) {
      _showError('Error updating service: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
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

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations?.edit_service ?? 'Edit Service'),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveService,
            child: _isLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    localizations?.save ?? 'Save',
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Service Name
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: localizations?.service_name ?? 'Service Name',
                  hintText:
                      localizations?.enter_service_name ?? 'Enter service name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.business),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return localizations?.service_name_required ??
                        'Service name is required';
                  }
                  if (value.trim().length < 3) {
                    return localizations?.service_name_min_length ??
                        'Service name must be at least 3 characters';
                  }
                  return null;
                },
                textCapitalization: TextCapitalization.words,
              ),

              const SizedBox(height: 16),

              // Service Description
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: localizations?.service_description ??
                      'Service Description',
                  hintText: localizations?.enter_service_description ??
                      'Enter service description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.description),
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return localizations?.service_description_required ??
                        'Service description is required';
                  }
                  if (value.trim().length < 10) {
                    return localizations?.service_description_min_length ??
                        'Description must be at least 10 characters';
                  }
                  return null;
                },
                textCapitalization: TextCapitalization.sentences,
              ),

              const SizedBox(height: 16),

              // Category Selection
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localizations?.category ?? 'Category',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (_isLoadingCategories)
                        const Center(child: CircularProgressIndicator())
                      else if (_categories.isEmpty)
                        Text(
                          localizations?.no_categories_available ??
                              'No categories available',
                          style: TextStyle(
                              color: colorScheme.onSurface.withOpacity(0.6)),
                        )
                      else
                        DropdownButtonFormField<CategoryModel>(
                          value: _selectedCategory,
                          decoration: InputDecoration(
                            hintText: localizations?.select_category ??
                                'Select category',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            prefixIcon: const Icon(Icons.category),
                          ),
                          items: _categories.map((category) {
                            return DropdownMenuItem<CategoryModel>(
                              value: category,
                              child: Text(getCategoryName(category)),
                            );
                          }).toList(),
                          onChanged: (CategoryModel? value) {
                            setState(() {
                              _selectedCategory = value;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return localizations?.category_required ??
                                  'Please select a category';
                            }
                            return null;
                          },
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Location Selection
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localizations?.location ?? 'Location',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (_isLoadingLocations)
                        const Center(child: CircularProgressIndicator())
                      else if (_locations.isEmpty)
                        Text(
                          localizations?.no_locations_available ??
                              'No locations available',
                          style: TextStyle(
                              color: colorScheme.onSurface.withOpacity(0.6)),
                        )
                      else
                        DropdownButtonFormField<Location>(
                          value: _selectedLocation,
                          decoration: InputDecoration(
                            hintText: localizations?.select_location ??
                                'Select location',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            prefixIcon: const Icon(Icons.location_on),
                          ),
                          items: _locations.map((location) {
                            return DropdownMenuItem<Location>(
                              value: location,
                              child: Text(
                                  '${location.region ?? ''}, ${location.district ?? ''}'),
                            );
                          }).toList(),
                          onChanged: (Location? value) {
                            setState(() {
                              _selectedLocation = value;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return localizations?.location_required ??
                                  'Please select a location';
                            }
                            return null;
                          },
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Images Section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            localizations?.images ?? 'Images',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: _pickImages,
                            icon: const Icon(Icons.add_photo_alternate),
                            label:
                                Text(localizations?.add_images ?? 'Add Images'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorScheme.primary,
                              foregroundColor: colorScheme.onPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Existing Images
                      if (_existingImages.isNotEmpty) ...[
                        Text(
                          localizations?.current_images ?? 'Current Images',
                          style: theme.textTheme.titleSmall,
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _existingImages.length,
                            itemBuilder: (context, index) {
                              final imageData = _existingImages[index];
                              return Container(
                                margin: const EdgeInsets.only(right: 8),
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        imageData['url'],
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Container(
                                            width: 100,
                                            height: 100,
                                            color: colorScheme.surfaceVariant,
                                            child: const Icon(Icons.error),
                                          );
                                        },
                                      ),
                                    ),
                                    Positioned(
                                      top: 4,
                                      right: 4,
                                      child: GestureDetector(
                                        onTap: () =>
                                            _removeExistingImage(imageData),
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            color: colorScheme.error,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.close,
                                            color: colorScheme.onError,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // New Images
                      if (_newImages.isNotEmpty) ...[
                        Text(
                          localizations?.new_images ?? 'New Images',
                          style: theme.textTheme.titleSmall,
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _newImages.length,
                            itemBuilder: (context, index) {
                              final image = _newImages[index];
                              return Container(
                                margin: const EdgeInsets.only(right: 8),
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.file(
                                        image,
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      top: 4,
                                      right: 4,
                                      child: GestureDetector(
                                        onTap: () => _removeNewImage(image),
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            color: colorScheme.error,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.close,
                                            color: colorScheme.onError,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],

                      if (_existingImages.isEmpty && _newImages.isEmpty)
                        Container(
                          height: 100,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceVariant,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: colorScheme.outline.withOpacity(0.3),
                              style: BorderStyle.solid,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.image_outlined,
                                color: colorScheme.onSurface.withOpacity(0.5),
                                size: 32,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                localizations?.no_images_selected ??
                                    'No images selected',
                                style: TextStyle(
                                  color: colorScheme.onSurface.withOpacity(0.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveService,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          localizations?.save_changes ?? 'Save Changes',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
