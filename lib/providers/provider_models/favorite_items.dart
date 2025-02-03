import 'package:app/providers/provider_models/product_model.dart';
import 'package:app/providers/provider_models/service_model.dart';

class FavoriteItems {
  final List<Products> likedProducts;
  final List<Services> likedServices;

  FavoriteItems({required this.likedProducts, required this.likedServices});

  factory FavoriteItems.fromJson(Map<String, dynamic> json) {
    return FavoriteItems(
      likedProducts: (json['liked_products'] as List)
          .map((item) => Products.fromJson(item))
          .toList(),
      likedServices: (json['liked_services'] as List)
          .map((item) => Services.fromJson(item))
          .toList(),
    );
  }
}
