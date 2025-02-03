import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';

import 'package:app/constants/constants.dart';
import 'package:app/providers/provider_models/category_model.dart';

import 'package:app/providers/provider_models/product_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shared_preferences/shared_preferences.dart';

class ProductsService {
  Future<List<Products>> getProducts() async {
    final response = await http.get(Uri.parse('$baseUrl$PRODUCTS_URL'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      return (data['results'] as List)
          .map((postJson) => Products.fromJson(postJson))
          .toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Future<List<Products>> getFilteredProducts({
    int currentPage = 1,
    int pageSize = 12,
    String categoryName = "",
    String regionName = "",
    String districtName = "",
    String productTitle = "",
  }) async {
    final response = await http.get(
      Uri.parse('$baseUrl$PRODUCTS_URL').replace(
        queryParameters: {
          'page': currentPage.toString(),
          'page_size': pageSize.toString(),
          'category_name': categoryName,
          'region_name': regionName,
          'district_name': districtName,
          'product_title': productTitle,
        },
      ),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data['results']);
      return (data['results'] as List)
          .map((postJson) => Products.fromJson(postJson))
          .toList();
    } else {
      throw Exception('Failed to load filtered products');
    }
  }

  Future<List<CategoryModel>> getCategories() async {
    final response = await http.get(Uri.parse('$baseUrl$CATEGORY_URL'));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data as List)
          .map((postJson) => CategoryModel.fromJson(postJson))
          .toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Future<List<Products>> getSingleProduct({required String productId}) async {
    final response =
        await http.get(Uri.parse('$baseUrl$PRODUCTS_URL/$productId'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      return (data['recommended_products'] as List)
          .map((postJson) => Products.fromJson(postJson))
          .toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Future<Products> createProduct({
    required String title,
    required String description,
    required int price,
    required int categoryId,
    required List<File> imageFiles,
  }) async {
    const url = '$baseUrl$PRODUCTS_URL/';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? userLocation = prefs.getString('userLocation');
    String? userId = prefs.getString('userId');
    Dio dio = Dio();

    FormData formData = FormData.fromMap({
      'title': title,
      'condition': 'new',
      'in_stock': true,
      'category_id': categoryId,
      'price': price,
      'location_id':
          int.tryParse(userLocation.toString()), // Ensure it's an integer
      'userAddress_id':
          int.tryParse(userLocation.toString()), // Ensure it's an integer
      'userName_id': int.tryParse(userId.toString()),
      'description': description,
      'images': imageFiles
          .map((file) => MultipartFile.fromFileSync(file.path))
          .toList(),

      // Attach image
    });
    final response = await dio.post(url,
        data: formData,
        options: Options(headers: {
          'Authorization': 'Token $token',
          'Content-Type': 'application/json'
        }));
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Products.fromJson(response.data);
// Assuming 'data' is a map representing the new moment
    } else {
      throw Exception('Failed to create moment');
    }
  }

  // Future<Moments> getSingleMoment({required id}) async {
  //   final response = await http
  //       .get(Uri.parse('${Endpoints.baseURL}${Endpoints.momentsURL}/${id}'));
  //   if (response.statusCode == 200) {
  //     final data = json.decode(response.body);
  //
  //     return Moments.fromJson(
  //         data['data']); // Assuming 'data' is a map representing the new moment
  //   } else {
  //     throw Exception('Failed to create moment');
  //   }
  // }

  // Future<void> uploadMomentPhotos(
  //     String momentId, List<File> imageFiles) async {

  //   final url = Uri.parse(
  //       '${Endpoints.baseURL}${Endpoints.momentsURL}/$momentId/photo');
  //   final request = http.MultipartRequest('PUT', url);
  //
  //   for (var imageFile in imageFiles) {
  //     request.files.add(
  //       await http.MultipartFile.fromPath(
  //         'file',
  //         imageFile.path,
  //         contentType: MediaType('image', 'jpeg'),
  //       ),
  //     );
  //   }
  //
  //   try {
  //     final response = await request.send();

  //     if (response.statusCode == 200) {

  //     } else {
  //       response.stream.transform(utf8.decoder).listen((value) {
  //         print(value);
  //       });
  //     }
  //   } catch (e) {
  //     print("Error uploading file: $e");
  //   }
  // }

  // Future<void> likeMoment(String momentId, String userId) async {
  //   final url = Uri.parse(
  //       '${Endpoints.baseURL}${Endpoints.momentsURL}/${momentId}/like');
  //
  //   final response = await http.post(
  //     url,
  //     headers: {
  //       'Content-Type': 'application/json',
  //       // 'Authorization': 'Bearer $accessToken',
  //     },
  //     body: json.encode({
  //       'userId': userId,
  //     }),
  //   );
  //
  //   if (response.statusCode == 200) {
  //     final responseData = json.decode(response.body);
  //     print('Moment liked successfully: $responseData');
  //   } else {
  //     final errorData = json.decode(response.body);
  //     print('Error liking moment: $errorData');
  //   }
  // }

  // Future<void> dislikeMoment(String momentId, String userId) async {
  //   final url = Uri.parse(
  //       '${Endpoints.baseURL}${Endpoints.momentsURL}/${momentId}/dislike');
  //
  //   final response = await http.post(
  //     url,
  //     headers: {
  //       'Content-Type': 'application/json',
  //       // 'Authorization': 'Bearer $accessToken',
  //     },
  //     body: json.encode({
  //       'userId': userId,
  //     }),
  //   );
  //
  //   if (response.statusCode == 200) {
  //     final responseData = json.decode(response.body);
  //     print('Moment liked successfully: $responseData');
  //   } else {
  //     final errorData = json.decode(response.body);
  //     print('Error liking moment: $errorData');
  //   }
  // }
}

final productsProvider = FutureProvider<List<Products>>((ref) async {
  final service = ProductsService();
  return service.getProducts();
});

final productsServiceProvider = Provider((ref) => ProductsService());
