import 'package:app/common_widgets/common_button.dart';
import 'package:app/pages/tab_bar/tab_bar.dart';
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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  List<int> _existingImageIds = [];
  List<String> _existingImageUrls = [];
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

    // Initialize existing images
    if (widget.product.images != null) {
      _existingImageUrls =
          widget.product.images!.map((img) => img.image ?? '').toList();
      _existingImageIds =
          widget.product.images!.map((img) => img.id ?? 0).toList();
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
      final localizations = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              '${localizations?.loadingCategoryError ?? "Error loading categories:"} $e'),
        ),
      );
    }
  }

  Future<void> _pickImage({bool isMulti = false}) async {
    try {
      if (isMulti) {
        final pickedFiles = await picker.pickMultiImage();
        if (pickedFiles != null) {
          setState(() {
            _newImages
                .addAll(pickedFiles.map((pickedFile) => File(pickedFile.path)));
          });
        }
      } else {
        final pickedFile = await picker.pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          setState(() {
            _newImages.add(File(pickedFile.path));
          });
        }
      }
    } catch (e) {
      final localizations = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              '${localizations?.errorMessage ?? "Error picking images:"} $e'),
        ),
      );
    }
  }

  void _removeExistingImage(int index) {
    setState(() {
      _existingImageUrls.removeAt(index);
      _existingImageIds.removeAt(index);
    });
  }

  void _removeNewImage(int index) {
    setState(() {
      _newImages.removeAt(index);
    });
  }

  Future<void> _updateProduct() async {
    final localizations = AppLocalizations.of(context);

    if (_titleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localizations?.pleaseFillAllRequired ??
              'Please fill all the fields'),
        ),
      );
      return;
    }

    int? price = int.tryParse(_amountController.text.replaceAll(',', ''));
    if (price == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(localizations?.priceRequiredMessage ??
            'Invalid price entered. Please enter a valid number.'),
        duration: const Duration(seconds: 3),
      ));
      return;
    }

    if (selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(localizations?.categoryRequiredMessage ??
            'Please select a valid category.'),
        duration: const Duration(seconds: 3),
      ));
      return;
    }

    if (_existingImageUrls.isEmpty && _newImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(localizations?.oneImageConfirmMessage ??
            'At least one product image is required'),
        duration: const Duration(seconds: 3),
      ));
      return;
    }

    try {
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
                existingImageIds:
                    _existingImageIds.isNotEmpty ? _existingImageIds : null,
              );

      if (updatedProduct != null) {
        // Pop back to parent screen with success result
        Navigator.pop(context, updatedProduct);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(localizations?.productUpdatedSuccess ??
              'Product successfully updated'),
          duration: Duration(seconds: 3),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            '${localizations?.errorUpdatingProduct ?? "Error while updating product:"} $e'),
        duration: Duration(seconds: 3),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(localizations?.editProductTitle ?? 'Edit Product'),
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
                    localizations?.editProductTitle ?? 'Edit Product',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildSectionTitle(
                    localizations?.newProductTitle ?? 'Product Name'),
                const SizedBox(height: 10),
                _buildTextField(
                  controller: _titleController,
                  labelText: localizations?.newProductTitle ?? 'Product Name',
                ),
                const SizedBox(height: 20),
                _buildSectionTitle(localizations?.newProductDescription ??
                    'Product Description'),
                const SizedBox(height: 10),
                _buildTextField(
                  controller: _descriptionController,
                  labelText: localizations?.newProductDescription ??
                      'Product Description',
                  maxLines: 5,
                ),
                const SizedBox(height: 20),
                _buildSectionTitle(localizations?.newProductPrice ?? 'Price'),
                const SizedBox(height: 10),
                TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    ThousandsFormatter(),
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: InputDecoration(
                    labelText: localizations?.newProductPrice ?? 'Price',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                _buildSectionTitle('Condition'),
                const SizedBox(height: 10),
                DropdownButton<String>(
                  isExpanded: true,
                  value: selectedCondition,
                  items: ['new', 'used', 'refurbished']
                      .map((condition) => DropdownMenuItem(
                            value: condition,
                            child: Text(condition.capitalize()),
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
                _buildSectionTitle('Currency'),
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
                    _buildSectionTitle('In Stock'),
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
                    localizations?.newProductCategory ?? 'Select Category'),
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
                      Text(localizations?.selectCategory ?? 'Select Category'),
                ),
                const SizedBox(height: 20),
                _buildSectionTitle(localizations?.newProductImages ?? 'Images'),
                const SizedBox(height: 10),
                IconButton(
                  color: Colors.red,
                  icon: const Icon(
                    Icons.upload_file,
                    size: 30,
                  ),
                  onPressed: () => _pickImage(isMulti: true),
                ),
                const SizedBox(height: 10),

                // Existing Images Section
                if (_existingImageUrls.isNotEmpty) ...[
                  _buildSectionTitle('Existing Images'),
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
                    itemCount: _existingImageUrls.length,
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              _existingImageUrls[index],
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[300],
                                  child: Icon(Icons.error),
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
                                constraints: BoxConstraints(
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
                  _buildSectionTitle('New Images'),
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
                                constraints: BoxConstraints(
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

                if (_existingImageUrls.isEmpty && _newImages.isEmpty)
                  Center(
                    child: Text(
                      localizations?.imageInstructions ??
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
              buttonText: localizations?.uploadBtnLabel ?? 'Update',
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

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
