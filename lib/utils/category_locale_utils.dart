import 'package:app/providers/provider_models/category_model.dart';
import 'package:flutter/widgets.dart';

/// Locale-aware category name lookup, shared across every surface that
/// renders a service's category label (list cards, detail header, the
/// "near you now" feed strip).
///
/// Previously copied 3x with the same `uz`/`ru`/`en` switch (Plan B Task 9
/// cleanup — see `services_list.dart`, `service_detail_content.dart`,
/// `nearby_feed_strip.dart`).
class CategoryLocaleUtils {
  const CategoryLocaleUtils._();

  /// Returns the category's name in the context's current locale, falling
  /// back to English for any locale other than `uz`/`ru`.
  static String localizedName(BuildContext context, CategoryModel category) {
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
}
