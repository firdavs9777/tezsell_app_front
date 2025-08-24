import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'package:app/constants/constants.dart';
import 'package:app/providers/provider_models/category_model.dart';
import 'package:app/providers/provider_models/product_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductsService {
  // Singleton Dio instance for better performance
  static Dio? _dio;
  static SharedPreferences? _prefs;

  // Cache for frequently accessed data
  static final Map<String, List<CategoryModel>> _categoriesCache = {};
  static final Map<String, List<Products>> _productsCache = {};
  static DateTime? _categoriesCacheTime;

  // Request cache to prevent duplicate requests
  static final Map<String, Future<dynamic>> _pendingRequests = {};

  // Initialize optimized Dio client
  static Dio get dio {
    if (_dio == null) {
      _initializeDio();
    }
    return _dio!;
  }

  static void _initializeDio() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30), // Increased for mobile
      receiveTimeout: const Duration(seconds: 30), // Increased for mobile
      sendTimeout: const Duration(seconds: 60), // Increased for file uploads
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Accept-Encoding': 'gzip, deflate, br',
        'Connection': 'keep-alive',
        'User-Agent': 'FlutterApp/1.0 (${Platform.operatingSystem})',
      },
      validateStatus: (status) {
        // Accept all status codes < 500 to handle them manually
        return status != null && status < 500;
      },
    ));

    // Add performance logging and retry logic in debug mode
    if (kDebugMode) {
      _dio!.interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) {
          final start = DateTime.now().millisecondsSinceEpoch;
          options.extra['request_start'] = start;
          handler.next(options);
        },
        onResponse: (response, handler) {
          final start = response.requestOptions.extra['request_start'] as int?;
          if (start != null) {
            final duration = DateTime.now().millisecondsSinceEpoch - start;
            final emoji = duration < 1000
                ? '🟢'
                : duration < 3000
                    ? '🟡'
                    : '🔴';
          }
          handler.next(response);
        },
        onError: (error, handler) {
          final start = error.requestOptions.extra['request_start'] as int?;
          if (start != null) {
            final duration = DateTime.now().millisecondsSinceEpoch - start;
          }

          // Auto-retry on timeout or connection errors
          final shouldRetry =
              error.type == DioExceptionType.connectionTimeout ||
                  error.type == DioExceptionType.receiveTimeout ||
                  error.type == DioExceptionType.connectionError ||
                  (error.response?.statusCode != null &&
                      error.response!.statusCode! >= 500);

          if (shouldRetry) {
            final retryCount = error.requestOptions.extra['retryCount'] ?? 0;
            if (retryCount < 2) {
              error.requestOptions.extra['retryCount'] = retryCount + 1;

              // Retry with exponential backoff
              final delayMs = 500 * (retryCount + 1);
              Future.delayed(Duration(milliseconds: delayMs.toInt()), () {
                _dio!.fetch(error.requestOptions).then((response) {
                  handler.resolve(response);
                }).catchError((e) {
                  handler.next(e);
                });
              });
              return;
            }
          }

          handler.next(error);
        },
      ));
    }
  }

  // Get cached SharedPreferences
  static Future<SharedPreferences> _getPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  // Performance-optimized getProducts with caching
  Future<List<Products>> getProducts() async {
    const cacheKey = 'all_products';

    // Check cache first
    if (_productsCache.containsKey(cacheKey)) {
      return _productsCache[cacheKey]!;
    }

    // Check for pending request
    if (_pendingRequests.containsKey(cacheKey)) {
      return await _pendingRequests[cacheKey] as List<Products>;
    }

    final timer = Stopwatch()..start();

    try {
      final future = _fetchProducts();
      _pendingRequests[cacheKey] = future;

      final products = await future;

      // Cache the results for 5 minutes
      _productsCache[cacheKey] = products;
      Timer(const Duration(minutes: 5), () => _productsCache.remove(cacheKey));

      timer.stop();
      _logPerformance('Get Products', timer.elapsed.inMilliseconds);

      return products;
    } catch (e) {
      timer.stop();
      _logPerformance('FAILED - Get Products', timer.elapsed.inMilliseconds);

      // Return cached data if available, even if old
      if (_productsCache.containsKey(cacheKey)) {
        return _productsCache[cacheKey]!;
      }

      rethrow;
    } finally {
      _pendingRequests.remove(cacheKey);
    }
  }

  Future<List<Products>> _fetchProducts() async {
    try {
      final response = await dio.get(
        '/$PRODUCTS_URL/',
        options: Options(
          extra: {'retryCount': 0}, // Initialize retry count
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;

        // Validate response structure
        if (data == null) {
          throw Exception('Received null response data');
        }

        if (data is! Map<String, dynamic>) {
          throw Exception('Expected Map but got ${data.runtimeType}: $data');
        }

        if (!data.containsKey('results')) {
          throw Exception('Response missing "results" field: ${data.keys}');
        }

        final results = data['results'];
        if (results is! List) {
          throw Exception(
              'Expected List for results but got ${results.runtimeType}');
        }

        return results.map((productJson) {
          try {
            return Products.fromJson(productJson);
          } catch (e) {
            rethrow;
          }
        }).toList();
      } else {
        throw Exception(
            'HTTP ${response.statusCode}: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      // Create more specific error messages
      String errorMessage;
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
          errorMessage =
              'Connection timeout - please check your internet connection';
          break;
        case DioExceptionType.sendTimeout:
          errorMessage = 'Request timeout - please try again';
          break;
        case DioExceptionType.receiveTimeout:
          errorMessage = 'Response timeout - server is taking too long';
          break;
        case DioExceptionType.badResponse:
          errorMessage =
              'Server error (${e.response?.statusCode}): ${e.response?.statusMessage}';
          break;
        case DioExceptionType.cancel:
          errorMessage = 'Request was cancelled';
          break;
        case DioExceptionType.connectionError:
          errorMessage = 'No internet connection';
          break;
        case DioExceptionType.badCertificate:
          errorMessage = 'SSL certificate error';
          break;
        case DioExceptionType.unknown:
        default:
          errorMessage = 'Network error: ${e.message ?? 'Unknown error'}';
      }

      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }

  // Optimized filtered products with request deduplication
  Future<List<Products>> getFilteredProducts({
    int currentPage = 1,
    int pageSize = 12,
    String categoryName = "",
    String regionName = "",
    String districtName = "",
    String productTitle = "",
  }) async {
    final cacheKey =
        'filtered_${currentPage}_${pageSize}_${categoryName}_${regionName}_${districtName}_$productTitle';

    // Check for pending request
    if (_pendingRequests.containsKey(cacheKey)) {
      if (kDebugMode) {
        print('🔄 Filtered products request already in progress');
      }
      return await _pendingRequests[cacheKey] as List<Products>;
    }

    final timer = Stopwatch()..start();

    final future = _fetchFilteredProducts(
      currentPage: currentPage,
      pageSize: pageSize,
      categoryName: categoryName,
      regionName: regionName,
      districtName: districtName,
      productTitle: productTitle,
    );

    _pendingRequests[cacheKey] = future;

    try {
      final products = await future;

      timer.stop();
      _logPerformance('Get Filtered Products', timer.elapsed.inMilliseconds);

      return products;
    } finally {
      _pendingRequests.remove(cacheKey);
    }
  }

  Future<List<Products>> _fetchFilteredProducts({
    required int currentPage,
    required int pageSize,
    required String categoryName,
    required String regionName,
    required String districtName,
    required String productTitle,
  }) async {
    try {
      final queryParams = <String, String>{
        'page': currentPage.toString(),
        'page_size': pageSize.toString(),
      };

      // Only add non-empty parameters to reduce URL size
      if (categoryName.isNotEmpty) queryParams['category_name'] = categoryName;
      if (regionName.isNotEmpty) queryParams['region_name'] = regionName;
      if (districtName.isNotEmpty) queryParams['district_name'] = districtName;
      if (productTitle.isNotEmpty) queryParams['product_title'] = productTitle;

      final response = await dio.get(
        '/$PRODUCTS_URL/', // Fixed with leading slash
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final data = response.data;

        if (kDebugMode) {
          print(
              '📊 Filtered products count: ${(data['results'] as List).length}');
        }

        return (data['results'] as List)
            .map((productJson) => Products.fromJson(productJson))
            .toList();
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to load filtered products: ${response.statusCode}',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  // Optimized categories with caching and authentication
  Future<List<CategoryModel>> getCategories() async {
    const cacheKey = 'categories';

    // Check cache (categories don't change often)
    if (_categoriesCache.containsKey(cacheKey) &&
        _categoriesCacheTime != null &&
        DateTime.now().difference(_categoriesCacheTime!).inMinutes < 30) {
      if (kDebugMode) {
        print('🎯 Using cached categories');
      }
      return _categoriesCache[cacheKey]!;
    }

    // Check for pending request
    if (_pendingRequests.containsKey(cacheKey)) {
      return await _pendingRequests[cacheKey] as List<CategoryModel>;
    }

    final timer = Stopwatch()..start();

    final future = _fetchCategories();
    _pendingRequests[cacheKey] = future;

    try {
      final categories = await future;

      // Cache for 30 minutes
      _categoriesCache[cacheKey] = categories;
      _categoriesCacheTime = DateTime.now();

      timer.stop();
      _logPerformance('Get Categories', timer.elapsed.inMilliseconds);

      return categories;
    } finally {
      _pendingRequests.remove(cacheKey);
    }
  }

  Future<List<CategoryModel>> _fetchCategories() async {
    try {
      final prefs = await _getPrefs();
      final token = prefs.getString('token');

      final response = await dio.get(
        '/$CATEGORY_URL/', // Fixed with leading slash
        options: Options(
          headers: token != null ? {'Authorization': 'Token $token'} : null,
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;

        if (kDebugMode) {
          print('📊 Categories count: ${(data as List).length}');
        }

        return (data as List)
            .map((categoryJson) => CategoryModel.fromJson(categoryJson))
            .toList();
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to load categories: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('💥 Error fetching categories: $e');
      }
      rethrow;
    }
  }

  // Optimized single product with recommendations
  Future<List<Products>> getSingleProduct({required String productId}) async {
    final cacheKey = 'single_product_$productId';

    // Check for pending request
    if (_pendingRequests.containsKey(cacheKey)) {
      return await _pendingRequests[cacheKey] as List<Products>;
    }

    final timer = Stopwatch()..start();

    final future = _fetchSingleProduct(productId);
    _pendingRequests[cacheKey] = future;

    try {
      final products = await future;

      timer.stop();
      _logPerformance('Get Single Product', timer.elapsed.inMilliseconds);

      return products;
    } finally {
      _pendingRequests.remove(cacheKey);
    }
  }

  Future<List<Products>> _fetchSingleProduct(String productId) async {
    try {
      final response = await dio.get('$PRODUCTS_URL/$productId/');

      if (response.statusCode == 200) {
        final data = response.data;

        return (data['recommended_products'] as List)
            .map((productJson) => Products.fromJson(productJson))
            .toList();
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to load single product: ${response.statusCode}',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  // Optimized product creation with better error handling
  Future<Products> createProduct({
    required String title,
    required String description,
    required int price,
    required int categoryId,
    required List<File> imageFiles,
  }) async {
    final timer = Stopwatch()..start();

    try {
      final prefs = await _getPrefs();
      final token = prefs.getString('token');
      final userLocation = prefs.getString('userLocation');
      final userId = prefs.getString('userId');

      if (token == null) {
        throw Exception('User not authenticated');
      }
      final formData = FormData.fromMap({
        'title': title,
        'condition': 'new',
        'in_stock': true,
        'category_id': categoryId,
        'price': price,
        'location_id': int.tryParse(userLocation ?? '0'),
        'userAddress_id': int.tryParse(userLocation ?? '0'),
        'userName_id': int.tryParse(userId ?? '0'),
        'description': description,
      });

      // Add images efficiently
      for (int i = 0; i < imageFiles.length; i++) {
        formData.files.add(MapEntry(
          'images',
          await MultipartFile.fromFile(
            imageFiles[i].path,
            filename: 'image_$i.jpg',
          ),
        ));
      }

      final response = await dio.post(
        '/$PRODUCTS_URL/', // Fixed with leading slash
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Token $token',
            'Content-Type': 'multipart/form-data',
          },
          validateStatus: (status) => status! < 500,
        ),
      );

      timer.stop();
      _logPerformance('Create Product', timer.elapsed.inMilliseconds);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Clear products cache since we added a new product
        _productsCache.clear();
        return Products.fromJson(response.data);
      } else {
        final errorMessage = response.data is Map
            ? response.data.toString()
            : 'Failed to create product';
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: errorMessage,
        );
      }
    } catch (e) {
      timer.stop();
      _logPerformance('FAILED - Create Product', timer.elapsed.inMilliseconds);

      rethrow;
    }
  }

  Future<Products> updateProduct({
    required int productId,
    required String title,
    required String description,
    required int price,
    required int categoryId,
    String condition = 'new',
    String currency = 'Sum',
    bool inStock = true,
    List<File>? newImageFiles,
    List<int>? existingImageIds,
  }) async {
    final timer = Stopwatch()..start();

    try {
      final prefs = await _getPrefs();
      final token = prefs.getString('token');
      final userLocation = prefs.getString('userLocation');
      final userId = prefs.getString('userId');

      if (token == null) {
        throw Exception('User not authenticated');
      }

      final formData = FormData.fromMap({
        'title': title,
        'description': description,
        'condition': condition,
        'currency': currency,
        'in_stock': inStock,
        'price': price,
        'category_id': categoryId,
        'location_id': int.tryParse(userLocation ?? '0'),
        'userName_id': int.tryParse(userId ?? '0'),
        'userAddress_id': int.tryParse(userLocation ?? '0'),
      });

      // Add existing image IDs if any
      if (existingImageIds != null && existingImageIds.isNotEmpty) {
        for (int i = 0; i < existingImageIds.length; i++) {
          formData.fields
              .add(MapEntry('existing_images', existingImageIds[i].toString()));
        }
      }

      // Add new images if any
      if (newImageFiles != null && newImageFiles.isNotEmpty) {
        for (int i = 0; i < newImageFiles.length; i++) {
          formData.files.add(MapEntry(
            'images',
            await MultipartFile.fromFile(
              newImageFiles[i].path,
              filename: 'image_$i.jpg',
            ),
          ));
        }
      }

      final response = await dio.put(
        "${baseUrl}/products/api/user/products/$productId/",
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Token $token',
            'Content-Type': 'multipart/form-data',
          },
          validateStatus: (status) => status! < 500,
        ),
      );

      timer.stop();
      _logPerformance('Update Product', timer.elapsed.inMilliseconds);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Clear products cache since we updated a product
        _productsCache.clear();
        return Products.fromJson(response.data);
      } else {
        final errorMessage = response.data is Map
            ? response.data.toString()
            : 'Failed to update product';
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: errorMessage,
        );
      }
    } catch (e) {
      timer.stop();
      _logPerformance('FAILED - Update Product', timer.elapsed.inMilliseconds);

      rethrow;
    }
  }

  Future<bool> deleteProduct({
    required int productId,
  }) async {
    final timer = Stopwatch()..start();

    try {
      final prefs = await _getPrefs();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception('User not authenticated');
      }

      final response = await dio.delete(
        "${baseUrl}/products/api/user/products/$productId/",
        options: Options(
          headers: {
            'Authorization': 'Token $token',
          },
          validateStatus: (status) => status! < 500,
        ),
      );

      timer.stop();
      _logPerformance('Delete Product', timer.elapsed.inMilliseconds);

      if (response.statusCode == 200 ||
          response.statusCode == 204 ||
          response.statusCode == 201) {
        // Clear products cache since we deleted a product
        _productsCache.clear();
        return true;
      } else {
        final errorMessage = response.data is Map
            ? response.data.toString()
            : 'Failed to delete product';
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: errorMessage,
        );
      }
    } catch (e) {
      timer.stop();
      _logPerformance('FAILED - Delete Product', timer.elapsed.inMilliseconds);

      rethrow;
    }
  }

  // Performance logging helper
  void _logPerformance(String operation, int milliseconds) {
    if (!kDebugMode) return;

    String emoji;
    if (milliseconds < 200)
      emoji = '🟢';
    else if (milliseconds < 1000)
      emoji = '🟡';
    else if (milliseconds < 3000)
      emoji = '🟠';
    else
      emoji = '🔴';

    print('$emoji ⏱️ ProductsService - $operation: ${milliseconds}ms');
  }

  // Clear all caches
  void clearCache() {
    _productsCache.clear();
    _categoriesCache.clear();
    _categoriesCacheTime = null;
    _pendingRequests.clear();
  }

  // Dispose resources
  void dispose() {
    clearCache();
    _dio?.close();
    _dio = null;
    _prefs = null;
  }
}

// Optimized providers
final productsServiceProvider = Provider<ProductsService>((ref) {
  final service = ProductsService();
  ref.onDispose(() => service.dispose());
  return service;
});

final productsProvider = FutureProvider<List<Products>>((ref) async {
  final service = ref.watch(productsServiceProvider);
  return service.getProducts();
});

final categoriesProvider = FutureProvider<List<CategoryModel>>((ref) async {
  final service = ref.watch(productsServiceProvider);
  return service.getCategories();
});

// Filtered products provider with parameters
final filteredProductsProvider =
    FutureProvider.family<List<Products>, ProductFilterParams>(
        (ref, params) async {
  final service = ref.watch(productsServiceProvider);
  return service.getFilteredProducts(
    currentPage: params.currentPage,
    pageSize: params.pageSize,
    categoryName: params.categoryName,
    regionName: params.regionName,
    districtName: params.districtName,
    productTitle: params.productTitle,
  );
});

// Helper class for filter parameters
class ProductFilterParams {
  final int currentPage;
  final int pageSize;
  final String categoryName;
  final String regionName;
  final String districtName;
  final String productTitle;

  const ProductFilterParams({
    this.currentPage = 1,
    this.pageSize = 12,
    this.categoryName = "",
    this.regionName = "",
    this.districtName = "",
    this.productTitle = "",
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductFilterParams &&
          runtimeType == other.runtimeType &&
          currentPage == other.currentPage &&
          pageSize == other.pageSize &&
          categoryName == other.categoryName &&
          regionName == other.regionName &&
          districtName == other.districtName &&
          productTitle == other.productTitle;

  @override
  int get hashCode =>
      currentPage.hashCode ^
      pageSize.hashCode ^
      categoryName.hashCode ^
      regionName.hashCode ^
      districtName.hashCode ^
      productTitle.hashCode;
}
