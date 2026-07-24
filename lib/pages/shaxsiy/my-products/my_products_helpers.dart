import 'package:app/providers/provider_models/product_model.dart';

/// Splits a seller's own listings into the Active tab (everything not sold
/// -- hidden-but-unsold items stay here with a "Hidden" indicator/Unhide
/// action) and the Sold tab (`is_sold == true`), for the my-listings
/// management screen (Plan E Task 5). Pulled out as pure functions so the
/// partitioning logic is unit-testable without pumping a widget tree.
List<Products> activeListings(List<Products> products) =>
    products.where((p) => !p.isSold).toList(growable: false);

List<Products> soldListings(List<Products> products) =>
    products.where((p) => p.isSold).toList(growable: false);
