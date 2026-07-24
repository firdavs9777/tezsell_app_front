import 'package:app/l10n/app_localizations.dart';
import 'package:app/providers/provider_models/product_model.dart';
import 'package:app/utils/image_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Result of the mark-sold buyer picker: [chatId] identifies the buyer's
/// chat room to attribute the sale to -- the caller POSTs the existing
/// chat transaction endpoint for it, which flips `is_sold` AND creates the
/// completed-transaction review CTA. A null [chatId] means "Sold
/// elsewhere": a bare `is_sold` status flip with no transaction/review.
class MarkSoldSelection {
  const MarkSoldSelection({this.chatId});
  final int? chatId;
}

/// Bottom sheet for "who did you sell to?" (Plan E Task 5) -- lists
/// [buyers] (from `ProductsService.getProductChatBuyers`) plus an
/// always-present "Sold elsewhere" option. When [buyers] is empty, only
/// "Sold elsewhere" is shown. Returns null if the sheet is dismissed
/// without a selection.
Future<MarkSoldSelection?> showMarkSoldSheet(
  BuildContext context, {
  required List<ChatBuyer> buyers,
}) {
  final l = AppLocalizations.of(context);
  final colorScheme = Theme.of(context).colorScheme;

  return showModalBottomSheet<MarkSoldSelection>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (sheetContext) {
      return Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(sheetContext).size.height * 0.7,
        ),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
              child: Text(
                buyers.isEmpty
                    ? (l?.mark_as_sold ?? 'Mark as sold')
                    : (l?.who_did_you_sell_to ?? 'Who did you sell to?'),
                textAlign: TextAlign.center,
                style: Theme.of(
                  sheetContext,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            if (buyers.isNotEmpty)
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: buyers.length,
                  itemBuilder: (context, index) {
                    final buyer = buyers[index];
                    final avatarUrl = ImageUtils.buildImageUrl(
                      buyer.buyerAvatar,
                    );
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: colorScheme.primaryContainer,
                        backgroundImage: avatarUrl.isNotEmpty
                            ? CachedNetworkImageProvider(avatarUrl)
                            : null,
                        child: avatarUrl.isEmpty
                            ? Text(
                                buyer.buyerUsername.isNotEmpty
                                    ? buyer.buyerUsername[0].toUpperCase()
                                    : '?',
                                style: TextStyle(
                                  color: colorScheme.onPrimaryContainer,
                                ),
                              )
                            : null,
                      ),
                      title: Text(
                        buyer.buyerUsername,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () => Navigator.pop(
                        sheetContext,
                        MarkSoldSelection(chatId: buyer.chatId),
                      ),
                    );
                  },
                ),
              ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () =>
                      Navigator.pop(sheetContext, const MarkSoldSelection()),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(l?.sold_elsewhere ?? 'Sold elsewhere'),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      );
    },
  );
}
