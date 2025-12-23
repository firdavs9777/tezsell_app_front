import 'package:app/common_widgets/common_button.dart';
import 'package:app/providers/provider_models/category_model.dart';
import 'package:app/providers/provider_models/product_model.dart';
import 'package:app/providers/provider_root/product_provider.dart';
import 'package:app/utils/thousand_separator.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:app/l10n/app_localizations.dart';

class ProductEdit extends ConsumerStatefulWidget {
  final Products product; // Pass the existing product to edit

  const ProductEdit({super.key, required this.product});

  @override
  ConsumerState<ProductEdit> createState() => _ProductEditState();
}

class _ProductEditState extends ConsumerState<ProductEdit> {
  final _formatter = NumberFormat('#,##0', 'en_US');

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    _initializeFields();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  List<CategoryModel> availableCategories = [];

  int? selectedCategory;
  String selectedCondition = 'new';
  String selectedCurrency = 'Sum';
  bool inStock = true;

  List<File> _newImages = [];
  // Changed: Track existing images with their deletion status
  List<ExistingImageData> _existingImages = [];
  final picker = ImagePicker();

  void _initializeFields() {
    _titleController.text = widget.product.title ?? '';
    _descriptionController.text = widget.product.description ?? '';

    // Handle price conversion safely - price is a String
    int price = int.tryParse(widget.product.price?.toString() ?? '0') ?? 0;
    _amountController.text = _formatter.format(price);

    selectedCategory = widget.product.category?.id;
    selectedCondition = widget.product.condition ?? 'new';

    // Handle currency mapping - convert "So'm" to "Sum" if needed
    String productCurrency = widget.product.currency ?? 'Sum';
    if (productCurrency == "So'm" || productCurrency == "So`m") {
      productCurrency = 'Sum';
    }
    selectedCurrency = productCurrency;

    inStock = widget.product.inStock ?? true;

    // Initialize existing images with better tracking
    if (widget.product.images != null) {
      _existingImages = widget.product.images!
          .map((img) => ExistingImageData(
                id: img.id ?? 0,
                imageUrl: img.image ?? '',
                isDeleted: false,
              ))
          .toList();
    }
  }

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
      final categories =
          await ref.read(productsServiceProvider).getCategories();
      setState(() {
        availableCategories = categories;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading categories: $e'),
        ),
      );
    }
  }

  Future<void> _pickImage({bool isMulti = false}) async {
    try {
      if (isMulti) {
        final pickedFiles = await picker.pickMultiImage();
        if (pickedFiles != null) {
          // Check total image count limit
          final currentImageCount =
              _getActiveExistingImagesCount() + _newImages.length;
          final maxNewImages = 10 - currentImageCount;

          if (pickedFiles.length > maxNewImages) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    'You can only add ${maxNewImages} more image(s). Maximum 10 images allowed.'),
                duration: Duration(seconds: 3),
              ),
            );
            return;
          }

          setState(() {
            _newImages
                .addAll(pickedFiles.map((pickedFile) => File(pickedFile.path)));
          });
        }
      } else {
        final pickedFile = await picker.pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          final currentImageCount =
              _getActiveExistingImagesCount() + _newImages.length;

          if (currentImageCount >= 10) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Maximum 10 images allowed.'),
                duration: Duration(seconds: 3),
              ),
            );
            return;
          }

          setState(() {
            _newImages.add(File(pickedFile.path));
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking images: $e'),
        ),
      );
    }
  }

  // Helper method to count active existing images
  int _getActiveExistingImagesCount() {
    return _existingImages.where((img) => !img.isDeleted).length;
  }

  // Helper method to get active existing image IDs
  List<int> _getActiveExistingImageIds() {
    return _existingImages
        .where((img) => !img.isDeleted)
        .map((img) => img.id)
        .toList();
  }

  // Helper method to get active existing image URLs
  List<String> _getActiveExistingImageUrls() {
    return _existingImages
        .where((img) => !img.isDeleted)
        .map((img) => img.imageUrl)
        .toList();
  }

  void _removeExistingImage(int index) {
    final activeImages =
        _existingImages.where((img) => !img.isDeleted).toList();
    if (index < activeImages.length) {
      // Find the actual index in the full list
      final imageToRemove = activeImages[index];
      final actualIndex = _existingImages.indexOf(imageToRemove);

      setState(() {
        _existingImages[actualIndex].isDeleted = true;
      });
    }
  }

  void _removeNewImage(int index) {
    setState(() {
      _newImages.removeAt(index);
    });
  }

  Future<void> _updateProduct() async {
    if (_titleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all the fields'),
        ),
      );
      return;
    }

    int? price = int.tryParse(_amountController.text.replaceAll(',', ''));
    if (price == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Invalid price entered. Please enter a valid number.'),
        duration: Duration(seconds: 3),
      ));
      return;
    }

    if (selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please select a valid category.'),
        duration: Duration(seconds: 3),
      ));
      return;
    }

    // Check if at least one image exists (either existing non-deleted or new)
    if (_getActiveExistingImagesCount() == 0 && _newImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('At least one product image is required'),
        duration: Duration(seconds: 3),
      ));
      return;
    }

    try {
      final activeExistingImageIds = _getActiveExistingImageIds();

      final updatedProduct =
          await ref.read(productsServiceProvider).updateProduct(
                productId: widget.product.id!,
                title: _titleController.text,
                description: _descriptionController.text,
                price: price,
                categoryId: selectedCategory!,
                condition: selectedCondition,
                currency: selectedCurrency,
                inStock: inStock,
                newImageFiles: _newImages.isNotEmpty ? _newImages : null,
                existingImageIds: activeExistingImageIds.isNotEmpty
                    ? activeExistingImageIds
                    : null,
              );

      if (updatedProduct != null) {
        // Pop back to parent screen with success result
        Navigator.pop(context, updatedProduct);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Product successfully updated'),
          duration: Duration(seconds: 3),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error while updating product: $e'),
        duration: const Duration(seconds: 3),
      ));
    }
  }

  String _getLocalizedCondition(
      String condition, AppLocalizations? localizations) {
    switch (condition.toLowerCase()) {
      case 'new':
        return localizations?.condition_new ?? 'New';
      case 'used':
        return localizations?.condition_used ?? 'Used';
      default:
        return condition.capitalize();
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final activeExistingImageUrls = _getActiveExistingImageUrls();
    final totalImageCount = activeExistingImageUrls.length + _newImages.length;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(localizations?.edit_product_title ?? 'Edit Product'),
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
                    localizations?.edit_product_title ?? 'Edit Product',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildSectionTitle(
                    localizations?.product_name ?? 'Product Name'),
                const SizedBox(height: 10),
                _buildTextField(
                  controller: _titleController,
                  labelText: localizations?.product_name ?? 'Product Name',
                ),
                const SizedBox(height: 20),
                _buildSectionTitle(localizations?.product_description ??
                    'Product Description'),
                const SizedBox(height: 10),
                _buildTextField(
                  controller: _descriptionController,
                  labelText: localizations?.product_description ??
                      'Product Description',
                  maxLines: 5,
                ),
                const SizedBox(height: 20),
                _buildSectionTitle(localizations?.price ?? 'Price'),
                const SizedBox(height: 10),
                TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    ThousandsFormatter(),
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: InputDecoration(
                    labelText: localizations?.price ?? 'Price',
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                _buildSectionTitle(localizations?.condition ?? 'Condition'),
                const SizedBox(height: 10),
                DropdownButton<String>(
                  isExpanded: true,
                  value: selectedCondition,
                  items: ['new', 'used']
                      .map((condition) => DropdownMenuItem(
                            value: condition,
                            child: Text(_getLocalizedCondition(
                                condition, localizations)),
                          ))
                      .toList(),
                  onChanged: (String? value) {
                    if (value != null) {
                      setState(() {
                        selectedCondition = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 20),
                _buildSectionTitle(localizations?.currency ?? 'Currency'),
                const SizedBox(height: 10),
                DropdownButton<String>(
                  isExpanded: true,
                  value: ['Sum', 'USD', 'EUR'].contains(selectedCurrency)
                      ? selectedCurrency
                      : 'Sum',
                  items: ['Sum', 'USD', 'EUR']
                      .map((currency) => DropdownMenuItem(
                            value: currency,
                            child: Text(currency),
                          ))
                      .toList(),
                  onChanged: (String? value) {
                    if (value != null) {
                      setState(() {
                        selectedCurrency = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    _buildSectionTitle(localizations?.in_stock ?? 'In Stock'),
                    const SizedBox(width: 10),
                    Switch(
                      value: inStock,
                      onChanged: (bool value) {
                        setState(() {
                          inStock = value;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildSectionTitle(
                    localizations?.category ?? 'Select Category'),
                const SizedBox(height: 10),
                DropdownButton<CategoryModel>(
                  isExpanded: true,
                  value:
                      selectedCategory != null && availableCategories.isNotEmpty
                          ? availableCategories.firstWhere(
                              (cat) => cat.id == selectedCategory,
                            )
                          : null,
                  items: availableCategories
                      .map((category) => DropdownMenuItem(
                            value: category,
                            child: Text(getCategoryName(category)),
                          ))
                      .toList(),
                  onChanged: (CategoryModel? value) {
                    if (value != null) {
                      setState(() {
                        selectedCategory = value.id;
                      });
                    }
                  },
                  hint:
                      Text(localizations?.select_category ?? 'Select Category'),
                ),
                const SizedBox(height: 20),

                // Images Section with counter
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSectionTitle(localizations?.images ?? 'Images'),
                    Text(
                      '$totalImageCount/10',
                      style: TextStyle(
                        color: totalImageCount >= 10 ? Colors.red : Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Upload button with conditional state
                IconButton(
                  color: totalImageCount >= 10 ? Colors.grey : Colors.red,
                  icon: const Icon(
                    Icons.upload_file,
                    size: 30,
                  ),
                  onPressed: totalImageCount >= 10
                      ? null
                      : () => _pickImage(isMulti: true),
                ),
                const SizedBox(height: 10),

                // Existing Images Section
                if (activeExistingImageUrls.isNotEmpty) ...[
                  _buildSectionTitle(
                      localizations?.existing_images ?? 'Existing Images'),
                  const SizedBox(height: 10),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                    ),
                    itemCount: activeExistingImageUrls.length,
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              activeExistingImageUrls[index],
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.error),
                                );
                              },
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
                                onPressed: () => _removeExistingImage(index),
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
                  const SizedBox(height: 20),
                ],

                // New Images Section
                if (_newImages.isNotEmpty) ...[
                  _buildSectionTitle(localizations?.new_images ?? 'New Images'),
                  const SizedBox(height: 10),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                    ),
                    itemCount: _newImages.length,
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              _newImages[index],
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
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
                                onPressed: () => _removeNewImage(index),
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

                if (totalImageCount == 0)
                  Center(
                    child: Text(
                      localizations?.image_instructions ??
                          'Images will appear here. Please press the upload icon above.',
                    ),
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
            child: CommonButton(
              buttonText: localizations?.update_button ?? 'Update',
              onPressed: _updateProduct,
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
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

// Helper class to track existing images
class ExistingImageData {
  final int id;
  final String imageUrl;
  bool isDeleted;

  ExistingImageData({
    required this.id,
    required this.imageUrl,
    this.isDeleted = false,
  });
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
