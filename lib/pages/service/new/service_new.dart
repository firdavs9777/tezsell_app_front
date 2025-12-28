import 'package:app/common_widgets/common_button.dart';
import 'package:app/pages/tab_bar/tab_bar.dart';
import 'package:app/providers/provider_models/category_model.dart';
import 'package:app/providers/provider_root/service_provider.dart';
import 'package:app/utils/error_handler.dart';
import 'package:app/utils/app_logger.dart';
import 'package:app/utils/content_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:app/l10n/app_localizations.dart';

class ServiceNew extends ConsumerStatefulWidget {
  const ServiceNew({super.key});

  @override
  ConsumerState<ServiceNew> createState() => _ServiceNewState();
}

class _ServiceNewState extends ConsumerState<ServiceNew> {
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
  List<File> _selectedImages = [];
  final picker = ImagePicker();
  bool _isUploading = false; // Track upload state

  // Function to get the appropriate category name based on current locale
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

  /// Shows a bottom sheet to choose between camera and gallery
  Future<void> _showImageSourceDialog({bool isMulti = false}) async {
    if (!mounted) return;

    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final localizations = AppLocalizations.of(context);
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  localizations?.selectImageSource ?? 'Select Image Source',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.blue),
                title: Text(localizations?.camera ?? 'Camera'),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.purple),
                title: Text(localizations?.gallery ?? 'Gallery'),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );

    if (source != null) {
      await _pickImage(source: source, isMulti: isMulti);
    }
  }

  /// Picks image(s) from the specified source
  Future<void> _pickImage({
    required ImageSource source,
    bool isMulti = false,
  }) async {
    try {
      if (isMulti && source == ImageSource.gallery) {
        // Multi-image picker only works with gallery
        final pickedFiles = await picker.pickMultiImage(
          maxWidth: 1920,
          maxHeight: 1920,
          imageQuality: 85,
        );
        if (pickedFiles != null && mounted) {
          setState(() {
            _selectedImages.addAll(
              pickedFiles.map((pickedFile) => File(pickedFile.path)),
            );
          });
          AppLogger.debug('Selected ${pickedFiles.length} images from gallery');
        }
      } else {
        // Single image from camera or gallery
        final pickedFile = await picker.pickImage(
          source: source,
          maxWidth: 1920,
          maxHeight: 1920,
          imageQuality: 85,
        );
        if (pickedFile != null && mounted) {
          final imageFile = File(pickedFile.path);

          // Check file size (max 10MB)
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
    // Prevent multiple submissions
    if (_isUploading) {
      AppLogger.debug('Service submission already in progress');
      return;
    }

    final localizations = AppLocalizations.of(context);

    // Validation
    if (_titleController.text.trim().isEmpty ||
        _descriptionController.text.trim().isEmpty) {
      AppErrorHandler.showWarning(
        context,
        localizations?.pleaseFillAllRequired ?? 'Please fill all the fields',
      );
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

    // Set uploading state
    setState(() {
      _isUploading = true;
    });

    try {
      AppLogger.debug('Starting service creation...');

      // Show loading indicator
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              const SizedBox(width: 16),
              const Text('Uploading service...'),
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

      // Hide loading indicator
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (service != null) {
        AppLogger.info('Service created successfully: ${service.id}');

        // Show success message BEFORE navigation
        AppErrorHandler.showSuccess(
          context,
          'Service successfully added!',
        );

        // Wait a bit for user to see the success message
        await Future.delayed(const Duration(milliseconds: 500));

        if (!mounted) return;

        // Navigate to home
        await Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const TabsScreen(initialIndex: 1),
          ),
        );
      } else {
        AppLogger.error('Service creation returned null');
        AppErrorHandler.showError(
          context,
          'Error while creating service. Please try again.',
        );
      }
    } catch (e) {
      AppErrorHandler.logError('ServiceNew._submitProduct', e);
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        AppErrorHandler.showError(
          context,
          'Error while creating service. Please try again.',
        );
      }
    } finally {
      // Reset uploading state
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(localizations?.addNewServiceBtn ?? 'Create New Service'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    localizations?.addNewServiceBtn ?? 'Create New Service',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildSectionTitle(
                    localizations?.serviceName ?? 'Service Name'),
                const SizedBox(height: 10),
                _buildTextField(
                    controller: _titleController,
                    labelText: localizations?.serviceName ?? 'Service Name'),
                const SizedBox(height: 20),
                _buildSectionTitle(
                    localizations?.serviceDescription ?? 'Service Description'),
                const SizedBox(height: 10),
                _buildTextField(
                  controller: _descriptionController,
                  labelText: localizations?.serviceDescription ??
                      'Service Description',
                  maxLines: 5,
                ),
                const SizedBox(height: 20),
                _buildSectionTitle(
                    localizations?.serviceCategory ?? 'Select Category'),
                const SizedBox(height: 10),
                DropdownButton<CategoryModel>(
                  isExpanded: true,
                  value: selectedCategory != null
                      ? availableCategories.firstWhere(
                          (cat) => cat.id == selectedCategory,
                          orElse: () => availableCategories[0],
                        )
                      : null,
                  items: availableCategories
                      .map((category) => DropdownMenuItem(
                            value: category,
                            child: Text(getCategoryName(category)),
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
                  hint:
                      Text(localizations?.serviceCategory ?? 'Select Category'),
                ),
                const SizedBox(height: 20),
                _buildSectionTitle(localizations?.serviceImages ??
                    localizations?.newProductImages ??
                    'Images'),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildImageSourceButton(
                      icon: Icons.camera_alt,
                      label: localizations?.camera ?? 'Camera',
                      color: Colors.blue,
                      onPressed: () => _showImageSourceDialog(isMulti: false),
                    ),
                    _buildImageSourceButton(
                      icon: Icons.photo_library,
                      label: localizations?.gallery ?? 'Gallery',
                      color: Colors.purple,
                      onPressed: () => _showImageSourceDialog(isMulti: true),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                if (_selectedImages.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        localizations?.imageUploadHelper ??
                            'Images will appear here. Please select images using the buttons above.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.6),
                        ),
                      ),
                    ),
                  )
                else
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                    ),
                    itemCount: _selectedImages.length,
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              _selectedImages[index],
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 2,
                            right: 2,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _selectedImages.removeAt(index);
                                  });
                                },
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(
                                  minWidth: 24,
                                  minHeight: 24,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.transparent,
          child: Container(
            color: Colors.orange,
            height: 60,
            child: AbsorbPointer(
              absorbing: _isUploading,
              child: Opacity(
                opacity: _isUploading ? 0.6 : 1.0,
                child: CommonButton(
                  buttonText: _isUploading
                      ? localizations?.uploading ?? 'Uploading...'
                      : (localizations?.upload ?? 'Upload'),
                  onPressed: _submitProduct,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.onBackground,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      enabled: !_isUploading, // Disable fields during upload
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  /// Builds a button for selecting image source (camera or gallery)
  Widget _buildImageSourceButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ElevatedButton.icon(
          onPressed: _isUploading ? null : onPressed,
          icon: Icon(icon, color: Colors.white),
          label: Text(label),
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }
}
