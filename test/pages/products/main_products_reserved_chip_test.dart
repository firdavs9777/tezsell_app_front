import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app/l10n/app_localizations.dart';
import 'package:app/pages/products/main_products.dart';
import 'package:app/providers/provider_models/category_model.dart';
import 'package:app/providers/provider_models/location_model.dart';
import 'package:app/providers/provider_models/product_model.dart';
import 'package:app/providers/provider_models/user_model.dart';

/// D8 — the Reserved chip on `ProductMain` must show whenever a product is
/// reserved-but-not-sold, and must never show alongside the Sold overlay
/// (sold always wins; only one badge at a time).

UserInfo _dummyUser() => const UserInfo(
      id: 1,
      username: 'seller',
      email: 'seller@example.com',
      phoneNumber: '',
      userType: 'seller',
      profileImage: ProfileImage(image: '', altText: ''),
      location: Location(id: 1, country: '', region: '', district: ''),
      isActive: true,
    );

Products _buildProduct({required bool isSold, required bool isReserved}) {
  return Products(
    id: 1,
    title: 'Test product',
    description: '',
    price: '1000',
    condition: 'new',
    category: const CategoryModel(
      id: 1,
      key: 'k',
      nameUz: 'Kat',
      nameRu: 'Kat',
      nameEn: 'Category',
      icon: '',
    ),
    location: const Location(id: 1, country: 'UZ', region: 'R', district: 'D'),
    currency: 'UZS',
    inStock: true,
    isActive: true,
    isSold: isSold,
    isReserved: isReserved,
    images: const [],
    rating: 0,
    likeCount: 0,
    commentCount: 0,
    userName: _dummyUser(),
    userAddress: const UserAddress(id: 1, region: 'R', district: 'D'),
    createdAt: DateTime(2026, 1, 1),
    updatedAt: DateTime(2026, 1, 1),
  );
}

Future<void> _pump(WidgetTester tester, Products product) {
  return tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: ProductMain(product: product)),
      ),
    ),
  );
}

void main() {
  group('ProductMain reserved chip', () {
    testWidgets('shows RESERVED chip when reserved and not sold',
        (tester) async {
      await _pump(tester, _buildProduct(isSold: false, isReserved: true));
      await tester.pumpAndSettle();

      expect(find.text('RESERVED'), findsOneWidget);
      expect(find.text('SOLD'), findsNothing);
    });

    testWidgets('hides RESERVED chip when not reserved', (tester) async {
      await _pump(tester, _buildProduct(isSold: false, isReserved: false));
      await tester.pumpAndSettle();

      expect(find.text('RESERVED'), findsNothing);
      expect(find.text('SOLD'), findsNothing);
    });

    testWidgets(
        'shows only the SOLD overlay when both sold and reserved are true',
        (tester) async {
      await _pump(tester, _buildProduct(isSold: true, isReserved: true));
      await tester.pumpAndSettle();

      expect(find.text('SOLD'), findsOneWidget);
      expect(find.text('RESERVED'), findsNothing);
    });
  });
}
