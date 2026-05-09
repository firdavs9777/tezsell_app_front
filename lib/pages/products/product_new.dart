import 'dart:io';

import 'package:app/l10n/app_localizations.dart';
import 'package:app/pages/products/widgets/product_new_basic_info_card.dart';
import 'package:app/pages/products/widgets/product_new_category_card.dart';
import 'package:app/pages/products/widgets/product_new_image_picker.dart';
import 'package:app/pages/products/widgets/product_new_pricing_card.dart';
import 'package:app/providers/provider_models/category_model.dart';
import 'package:app/providers/provider_models/place.dart';
import 'package:app/providers/provider_root/country_provider.dart';
import 'package:app/providers/provider_root/product_provider.dart';
import 'package:app/widgets/maps/location_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:app/utils/app_logger.dart';
import 'package:app/utils/content_filter.dart';
import 'package:app/utils/currency_utils.dart';
import 'package:app/utils/error_handler.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class ProductNew extends ConsumerStatefulWidget {
  const ProductNew({super.key});

  @override
  ConsumerState<ProductNew> createState() => _ProductNewState();
}

class _ProductNewState extends ConsumerState<ProductNew> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  final _picker = ImagePicker();

  List<CategoryModel> _availableCategories = [];
  int? _selectedCategoryId;
  final List<File> _selectedImages = [];
  bool _isUploading = false;

  String _selectedCurrency = 'UZS';
  List<String> _availableCurrencies = ['UZS', 'USD', 'EUR'];
  Place? _pickedPlace;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    _loadCurrencies();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

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

  void _loadCurrencies() {
    final selectedCountry = ref.read(selectedCountryProvider);
    final countryCode = selectedCountry?.code ?? 'UZ';

    setState(() {
      _availableCurrencies = CurrencyUtils.getAllCurrencies();
      final countryCurrency = CurrencyUtils.getCurrencyForCountry(countryCode);
      _selectedCurrency = countryCurrency ?? 'UZS';
    });
  }

  Future<void> _fetchCategories() async {
    try {
      final categories =
          await ref.read(productsServiceProvider).getCategories();
      if (!mounted) return;
      setState(() {
        _availableCategories = categories;
      });
    } catch (e) {
      AppErrorHandler.logError('ProductNew._fetchCategories', e);
      if (mounted) {
        AppErrorHandler.showError(context, e);
      }
    }
  }

  String _getCategoryName(CategoryModel category) {
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
        final pickedFiles = await _picker.pickMultiImage(
          maxWidth: 2560,
          maxHeight: 2560,
          imageQuality: 95,
        );
        if (pickedFiles.isNotEmpty && mounted) {
          setState(() {
            _selectedImages.addAll(
              pickedFiles.map((pickedFile) => File(pickedFile.path)),
            );
          });
          AppLogger.debug(
              'Selected ${pickedFiles.length} images from gallery');
        }
      } else {
        final pickedFile = await _picker.pickImage(
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
      AppErrorHandler.logError('ProductNew._pickImage', e);
      if (mounted) {
        AppErrorHandler.showError(context, e);
      }
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  Future<void> _submitProduct() async {
    if (_isUploading) {
      AppLogger.debug('Product submission already in progress');
      return;
    }

    final localizations = AppLocalizations.of(context);

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final contentError = ContentFilter.validateContent(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
    );
    if (contentError != null) {
      AppErrorHandler.showWarning(context, contentError);
      return;
    }

    final price = int.tryParse(_amountController.text.replaceAll(',', ''));
    if (price == null || price <= 0) {
      AppErrorHandler.showWarning(
        context,
        localizations?.priceRequiredMessage ??
            'Invalid price entered. Please enter a valid number.',
      );
      return;
    }

    if (_selectedCategoryId == null) {
      AppErrorHandler.showWarning(
        context,
        localizations?.categoryRequiredMessage ??
            'Please select a valid category.',
      );
      return;
    }

    if (_selectedImages.isEmpty) {
      AppErrorHandler.showWarning(
        context,
        localizations?.oneImageConfirmMessage ??
            'At least one product image is required',
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      AppLogger.debug('Starting product creation...');

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
              Text(localizations?.uploading ?? 'Uploading product...'),
            ],
          ),
          duration: const Duration(seconds: 30),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );

      // NOTE: _pickedPlace not yet sent — extending createProduct signature
      // requires touching lib/providers/provider_root/product_provider.dart
      // which is currently WIP. Once that WIP merges, add place_id/lat/lng/etc.
      final product = await ref.read(productsServiceProvider).createProduct(
            title: _titleController.text.trim(),
            description: _descriptionController.text.trim(),
            price: price,
            categoryId: _selectedCategoryId!,
            imageFiles: _selectedImages,
            currency: _selectedCurrency,
          );

      if (!mounted) return;

      scaffoldMessenger.hideCurrentSnackBar();

      AppLogger.info('Product created successfully: ${product.id}');

      ref.read(productsRefreshProvider.notifier).state++;

      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(
            localizations?.productCreatedSuccess ??
                'Product successfully added!',
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );

      if (mounted) {
        Navigator.of(context).pop();
      }
        } catch (e) {
      AppErrorHandler.logError('ProductNew._submitProduct', e);
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        String errorMessage = localizations?.errorCreatingProduct ??
            'Error while creating product. Please try again.';
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
            localizations?.addNewProductBtn ?? 'Create New Product',
            style: theme.textTheme.titleLarge,
          ),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProductNewImagePicker(
                  images: _selectedImages,
                  isUploading: _isUploading,
                  onAddTap: _showImageSourceDialog,
                  onRemove: _removeImage,
                ),
                const SizedBox(height: 20),
                ProductNewBasicInfoCard(
                  titleController: _titleController,
                  descriptionController: _descriptionController,
                  isUploading: _isUploading,
                ),
                const SizedBox(height: 16),
                ProductNewPricingCard(
                  amountController: _amountController,
                  selectedCurrency: _selectedCurrency,
                  availableCurrencies: _availableCurrencies,
                  isUploading: _isUploading,
                  onCurrencyChanged: (value) {
                    setState(() => _selectedCurrency = value);
                  },
                ),
                const SizedBox(height: 16),
                ProductNewCategoryCard(
                  availableCategories: _availableCategories,
                  selectedCategoryId: _selectedCategoryId,
                  isUploading: _isUploading,
                  getCategoryName: _getCategoryName,
                  onCategoryChanged: (category) {
                    setState(() {
                      _selectedCategoryId = category.id;
                    });
                  },
                ),
                const SizedBox(height: 16),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.map_outlined),
                    title: Text(_pickedPlace?.formattedAddress ??
                        'Pick location on map'),
                    subtitle: _pickedPlace == null
                        ? const Text('Drop a pin so buyers see where the item is')
                        : Text(
                            '${_pickedPlace!.lat.toStringAsFixed(5)}, ${_pickedPlace!.lng.toStringAsFixed(5)}',
                          ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: _isUploading ? null : _openMapPicker,
                  ),
                ),
                const SizedBox(height: 24),
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
                              valueColor: AlwaysStoppedAnimation<Color>(
                                colorScheme.onPrimary,
                              ),
                            ),
                          )
                        : Text(
                            localizations?.upload ?? 'Upload Product',
                            style: theme.textTheme.labelLarge?.copyWith(
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
}
