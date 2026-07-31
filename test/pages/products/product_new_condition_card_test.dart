import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app/l10n/app_localizations.dart';
import 'package:app/pages/products/widgets/product_new_condition_card.dart';

/// Second-hand marketplace fix: the product-create form used to hardcode
/// `condition: 'new'` on every listing with no way for the seller to say
/// otherwise. This covers the replacement selector — all 4 backend values
/// are offered, the caller's default ('used') renders selected, and picking
/// another chip reports the chosen value back up.
Future<void> _pump(
  WidgetTester tester, {
  required String selectedCondition,
  required ValueChanged<String> onConditionChanged,
}) {
  return tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: ProductNewConditionCard(
          selectedCondition: selectedCondition,
          isUploading: false,
          onConditionChanged: onConditionChanged,
        ),
      ),
    ),
  );
}

void main() {
  group('ProductNewConditionCard', () {
    testWidgets('offers all 4 backend condition values', (tester) async {
      await _pump(
        tester,
        selectedCondition: 'used',
        onConditionChanged: (_) {},
      );
      await tester.pumpAndSettle();

      expect(find.text('New'), findsOneWidget);
      expect(find.text('Like New'), findsOneWidget);
      expect(find.text('Used'), findsOneWidget);
      expect(find.text('Refurbished'), findsOneWidget);
    });

    testWidgets('defaults to Used selected', (tester) async {
      await _pump(
        tester,
        selectedCondition: 'used',
        onConditionChanged: (_) {},
      );
      await tester.pumpAndSettle();

      final chip = tester.widget<ChoiceChip>(
        find.ancestor(of: find.text('Used'), matching: find.byType(ChoiceChip)),
      );
      expect(chip.selected, isTrue);
    });

    testWidgets('tapping a different condition reports it back', (
      tester,
    ) async {
      String? picked;
      await _pump(
        tester,
        selectedCondition: 'used',
        onConditionChanged: (value) => picked = value,
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Like New'));
      await tester.pumpAndSettle();

      expect(picked, 'like_new');
    });

    testWidgets('disables selection while uploading', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: ProductNewConditionCard(
              selectedCondition: 'used',
              isUploading: true,
              onConditionChanged: (_) {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final chip = tester.widget<ChoiceChip>(
        find.ancestor(of: find.text('New'), matching: find.byType(ChoiceChip)),
      );
      expect(chip.onSelected, isNull);
    });
  });
}
