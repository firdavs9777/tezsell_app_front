import 'package:app/providers/provider_models/favorite_items.dart';
import 'package:app/providers/provider_models/product_model.dart';
import 'package:app/providers/provider_models/service_model.dart';
import 'package:app/providers/provider_root/profile_provider.dart';

/// Own-profile secondary data (products/services/favorites) used to
/// populate the listing counts shown below the header.
///
/// Deliberately fetched separately from [ProfileService.getUserInfo]: the
/// header, trust chip, and menu only truly depend on the user record, so a
/// failure here should degrade this data's own menu rows rather than
/// blanking the whole profile page (see `_ShaxsiyPageState` in
/// `shaxsiy.dart`, which renders the header as soon as `getUserInfo`
/// resolves and layers this in underneath).
class ProfileSectionsData {
  const ProfileSectionsData({
    this.products = const [],
    this.productsError = false,
    this.services = const [],
    this.servicesError = false,
    this.favoriteItems,
    this.favoritesError = false,
  });

  final List<Products> products;
  final bool productsError;
  final List<Services> services;
  final bool servicesError;
  final FavoriteItems? favoriteItems;
  final bool favoritesError;

  int get likedProductsCount => favoriteItems?.likedProducts.length ?? 0;
  int get likedServicesCount => favoriteItems?.likedServices.length ?? 0;
}

/// Fetches products/services/favorites independently of one another so a
/// single failing call falls back to that section's default (an empty
/// list and an error flag the UI can show an inline "couldn't load"
/// affordance for) instead of throwing and taking the rest down with it.
Future<ProfileSectionsData> fetchProfileSections(ProfileService service) async {
  List<Products> products = const [];
  bool productsError = false;
  List<Services> services = const [];
  bool servicesError = false;
  FavoriteItems? favoriteItems;
  bool favoritesError = false;

  Future<void> loadProducts() async {
    try {
      // Own profile: include hidden/sold listings so the counts here match
      // what "My Products"/"My Services" show (both now include inactive).
      products = await service.getUserProducts(includeInactive: true);
    } catch (_) {
      productsError = true;
    }
  }

  Future<void> loadServices() async {
    try {
      services = await service.getUserServices(includeInactive: true);
    } catch (_) {
      servicesError = true;
    }
  }

  Future<void> loadFavorites() async {
    try {
      favoriteItems = await service.getUserFavoriteItems();
    } catch (_) {
      favoritesError = true;
    }
  }

  await Future.wait([loadProducts(), loadServices(), loadFavorites()]);

  return ProfileSectionsData(
    products: products,
    productsError: productsError,
    services: services,
    servicesError: servicesError,
    favoriteItems: favoriteItems,
    favoritesError: favoritesError,
  );
}
