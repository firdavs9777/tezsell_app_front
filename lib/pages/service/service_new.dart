import 'package:app/common_wdigets/common_button.dart';
import 'package:app/pages/products/products_list.dart';
import 'package:app/pages/tab_bar/tab_bar.dart';
import 'package:app/providers/provider_models/category_model.dart';
import 'package:app/providers/provider_root/product_provider.dart';
import 'package:app/providers/provider_root/service_provider.dart';
import 'package:app/utils/thousand_separator.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:intl/intl.dart';

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

  Future<void> _fetchCategories() async {
    try {
      final categories = await ref.read(serviceMainProvider).getCategories();
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
    if (_titleController.text.isEmpty || _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all the fields')),
      );
      return;
    }

    final service = await ref.read(serviceMainProvider).createService(
        name: _titleController.text,
        description: _descriptionController.text,
        categoryId: selectedCategory!,
        imageFiles: _selectedImages);
    if (service != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const TabsScreen(
                  initialIndex: 1,
                )),
      );
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Service successfully added'),
        duration: const Duration(seconds: 3),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(serviceMainProvider).getCategories();
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
                    'Yangi service yaratish',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildSectionTitle('Service Name'),
                const SizedBox(height: 10),
                _buildTextField(
                  controller: _titleController,
                  labelText: 'Service Name',
                ),
                const SizedBox(height: 20),
                _buildSectionTitle('Service haqida batafsil'),
                const SizedBox(height: 10),
                _buildTextField(
                  controller: _descriptionController,
                  labelText: 'Service haqida yozing',
                  maxLines: 5,
                ),
                const SizedBox(height: 20),
                _buildSectionTitle('Service Kategoriyani tanlash'),
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
                            child: Text(category.nameEn),
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
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Button color
                    foregroundColor: Colors.white, // Icon and text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Rounded corners
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                  ),
                  onPressed: () => _pickImage(isMulti: true),
                  icon: const Icon(Icons.upload_file, size: 24),
                  label: const Text("Upload", style: TextStyle(fontSize: 16)),
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
                      crossAxisSpacing: 3.0,
                      mainAxisSpacing: 3.0,
                    ),
                    itemCount: _selectedImages.length,
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          Image.file(_selectedImages[index],
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover),
                          Positioned(
                            top: 1,
                            right: 0.1,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red.withOpacity(1),
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.close,
                                    color: Colors.white, size: 18),
                                onPressed: () {
                                  setState(() {
                                    _selectedImages.removeAt(index);
                                  });
                                },
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
