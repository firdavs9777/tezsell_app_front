import 'package:app/common_wdigets/common_button.dart';
import 'package:app/pages/products/products_list.dart';
import 'package:app/pages/tab_bar/tab_bar.dart';
import 'package:app/providers/provider_models/category_model.dart';
import 'package:app/providers/provider_root/product_provider.dart';
import 'package:app/utils/thousand_separator.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:intl/intl.dart';

class ProductNew extends ConsumerStatefulWidget {
  const ProductNew({super.key});

  @override
  ConsumerState<ProductNew> createState() => _ProductNewState();
}

class _ProductNewState extends ConsumerState<ProductNew> {
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
    _amountController.dispose();
    super.dispose();
  }

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  List<CategoryModel> availableCategories = [];

  int? selectedCategory;
  List<File> _selectedImages = [];
  final picker = ImagePicker();

  Future<void> _fetchCategories() async {
    try {
      final categories =
          await ref.read(productsServiceProvider).getCategories();
      setState(() {
        availableCategories = categories;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading categories: $e')),
      );
    }
  }

  Future<void> _pickImage({bool isMulti = false}) async {
    try {
      if (isMulti) {
        final pickedFiles = await picker.pickMultiImage();
        if (pickedFiles != null) {
          setState(() {
            _selectedImages
                .addAll(pickedFiles.map((pickedFile) => File(pickedFile.path)));
          });
        }
      } else {
        final pickedFile = await picker.pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          setState(() {
            _selectedImages.add(File(pickedFile.path));
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking images: $e')),
      );
    }
  }

  Future<void> _submitProduct() async {
    if (_titleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all the fields')),
      );
      return;
    }
    int? price = int.tryParse(_amountController.text);
    if (price == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Invalid price entered. Please enter a valid number.'),
        duration: const Duration(seconds: 3),
      ));
    } else if (selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please select a valid category.'),
        duration: const Duration(seconds: 3),
      ));
    } else {
      final product = await ref.read(productsServiceProvider).createProduct(
          title: _titleController.text,
          description: _descriptionController.text,
          price: price,
          categoryId: selectedCategory!,
          imageFiles: _selectedImages);
      if (product != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TabsScreen()),
        );
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Product successfully added'),
          duration: const Duration(seconds: 3),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(productsServiceProvider).getCategories();
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Yangi mahsulot post yaratish'),
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
                    'Yangi mahsulot post yaratish',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildSectionTitle('Mahsulot Nomi'),
                const SizedBox(height: 10),
                _buildTextField(
                  controller: _titleController,
                  labelText: 'Mahsulot Nomi',
                ),
                const SizedBox(height: 20),
                _buildSectionTitle('Mahsulot haqida batafsil'),
                const SizedBox(height: 10),
                _buildTextField(
                  controller: _descriptionController,
                  labelText: 'Mahsulot haqida yozing',
                  maxLines: 5,
                ),
                const SizedBox(height: 20),
                _buildSectionTitle('Narxi'),
                const SizedBox(height: 10),
                // _buildTextField(
                //   controller: _amountController,
                //   labelText: 'Narxi',
                //   keyboardType: TextInputType.number,
                //   inputFormatters: [
                //     ThousandsFormatter(),
                //     FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                //   ],
                // ),
                TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    ThousandsFormatter(), // Add the custom formatter
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: InputDecoration(
                    labelText: 'Narxi',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                _buildSectionTitle('Kategoriyani tanlash'),
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
                            child: Text(category.name),
                          ))
                      .toList(),
                  onChanged: (CategoryModel? value) {
                    if (value != null) {
                      setState(() {
                        selectedCategory = value.id;
                      });
                    }
                  },
                  hint: const Text('Kategoriyani tanlang'),
                ),
                const SizedBox(height: 20),
                _buildSectionTitle('Image'),
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
                if (_selectedImages.isEmpty)
                  const Center(
                    child: Text(
                      'Images will appear here. Please press the upload icon above.',
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
                          Image.file(
                            _selectedImages[index],
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            top: 2,
                            right: 2,
                            child: IconButton(
                              icon: const Icon(
                                Icons.close,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                setState(() {
                                  _selectedImages.removeAt(index);
                                });
                              },
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
            child: CommonButton(
              buttonText: 'Yuklash',
              onPressed: _submitProduct,
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
