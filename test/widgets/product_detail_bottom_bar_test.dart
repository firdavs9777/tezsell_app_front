import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app/l10n/app_localizations.dart';
import 'package:app/widgets/offer_widgets.dart';

/// D5 review fix — regression guard for the PDP bottom action-bar overflow.
///
/// `product_detail.dart`'s `_buildCarrotBottomBar` is a private method on a
/// `ConsumerStatefulWidget` that reaches into several riverpod providers
/// (chat/offers/product/profile) with real network-backed dependencies in
/// `initState`/`build`, so pumping the actual `ProductDetail` screen would
/// require extensive provider mocking disproportionate to this fix. Instead,
/// this test reproduces the exact Row structure used by
/// `_buildCarrotBottomBar` (heart button, divider, Flexible price, Expanded
/// Make-Offer + Expanded Chat buttons) using the real `MakeOfferButton`
/// widget class, at the same ~360dp width as a common phone, with both
/// buttons visible (the non-owner/unsold case that previously overflowed).
///
/// Structurally, wrapping both action buttons in `Expanded` (rather than
/// letting them size to their fixed intrinsic content width as
/// unconstrained Row siblings) makes overflow impossible regardless of
/// label length/locale: the row can only ever ask the two buttons to share
/// whatever space remains after the fixed heart/divider and the Flexible
/// price column, and each button's label is additionally wrapped in
/// Flexible+FittedBox so long localized text scales down instead of
/// overflowing within its own bounds.
Widget _bottomBarReplica({required bool showMakeOffer, required bool showChat}) {
  return Container(
    color: Colors.white,
    padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
    child: Row(
      children: [
        // Heart button
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(border: Border.all()),
          child: const Icon(Icons.favorite_border),
        ),
        const SizedBox(width: 12),
        // Divider
        Container(width: 1, height: 36, color: Colors.grey),
        const SizedBox(width: 12),
        // Price
        const Flexible(
          flex: 2,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '12,345,678 UZS',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
        if (showMakeOffer) ...[
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: MakeOfferButton(
              currentPrice: 12345678,
              onPressed: () {},
            ),
          ),
        ],
        if (showChat) ...[
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: SizedBox(
              height: 48,
              child: FilledButton(
                onPressed: () {},
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
                child: const FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '\u{1F4AC} Chat with seller',
                    maxLines: 1,
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    ),
  );
}

void main() {
  group('PDP bottom action bar (overflow fix)', () {
    testWidgets(
        'lays out with no overflow at 360dp width when both Make Offer '
        'and Chat with seller buttons are visible (non-owner, unsold — '
        'the primary case)', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: 360,
                child: _bottomBarReplica(showMakeOffer: true, showChat: true),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(MakeOfferButton), findsOneWidget);
      expect(find.textContaining('Chat with seller'), findsOneWidget);
    });

    testWidgets(
        'still lays out with no overflow at an even narrower 320dp width',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: 320,
                child: _bottomBarReplica(showMakeOffer: true, showChat: true),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });
  });
}
