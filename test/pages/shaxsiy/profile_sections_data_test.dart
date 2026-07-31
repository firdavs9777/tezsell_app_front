import 'package:app/pages/shaxsiy/profile_sections_data.dart';
import 'package:app/providers/provider_models/favorite_items.dart';
import 'package:app/providers/provider_models/product_model.dart';
import 'package:app/providers/provider_models/service_model.dart';
import 'package:app/providers/provider_root/profile_provider.dart';
import 'package:flutter_test/flutter_test.dart';

/// Stands in for the real HTTP-backed [ProfileService]. Only products
/// fails here -- exercising fix #3's requirement that a single failing
/// call degrades just that section instead of throwing and taking the
/// whole profile page down with it.
class _PartiallyFailingProfileService extends ProfileService {
  @override
  Future<List<Products>> getUserProducts({bool includeInactive = false}) {
    throw Exception('products endpoint down');
  }

  @override
  Future<List<Services>> getUserServices({bool includeInactive = false}) async {
    return const [];
  }

  @override
  Future<FavoriteItems> getUserFavoriteItems() async {
    return FavoriteItems(likedProducts: const [], likedServices: const []);
  }
}

class _AllFailingProfileService extends ProfileService {
  @override
  Future<List<Products>> getUserProducts({bool includeInactive = false}) {
    throw Exception('down');
  }

  @override
  Future<List<Services>> getUserServices({bool includeInactive = false}) {
    throw Exception('down');
  }

  @override
  Future<FavoriteItems> getUserFavoriteItems() {
    throw Exception('down');
  }
}

void main() {
  test('a single failing section is flagged and defaults to empty, without '
      'affecting the sections that succeeded', () async {
    final data = await fetchProfileSections(_PartiallyFailingProfileService());

    expect(data.productsError, true);
    expect(data.products, isEmpty);

    expect(data.servicesError, false);
    expect(data.services, isEmpty);

    expect(data.favoritesError, false);
    expect(data.likedProductsCount, 0);
    expect(data.likedServicesCount, 0);
  });

  test('fetchProfileSections never throws, even if every call fails', () async {
    final data = await fetchProfileSections(_AllFailingProfileService());
    expect(data.productsError, true);
    expect(data.servicesError, true);
    expect(data.favoritesError, true);
  });
}
