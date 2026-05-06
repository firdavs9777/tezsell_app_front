import 'package:app/l10n/app_localizations.dart';
import 'package:app/providers/provider_models/user_profile_model.dart';
import 'package:app/widgets/report_content_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

void showUserProfileMoreOptions(
  BuildContext context,
  UserProfile profile,
) {
  final colorScheme = Theme.of(context).colorScheme;
  final localizations = AppLocalizations.of(context);
  final profileUrl = 'https://webtezsell.com/user/${profile.id}';

  showModalBottomSheet(
    context: context,
    backgroundColor: colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (sheetContext) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.share_outlined),
            title: Text(localizations?.profile_share ?? 'Share'),
            onTap: () {
              Navigator.pop(sheetContext);
              _shareProfile(context, profile, profileUrl);
            },
          ),
          ListTile(
            leading: const Icon(Icons.link),
            title: Text(localizations?.profile_copy_link ?? 'Copy link'),
            onTap: () {
              Navigator.pop(sheetContext);
              _copyProfileLink(context, profileUrl);
            },
          ),
          ListTile(
            leading: Icon(Icons.flag_outlined, color: colorScheme.error),
            title: Text(
              localizations?.profile_report ?? 'Report',
              style: TextStyle(color: colorScheme.error),
            ),
            onTap: () {
              Navigator.pop(sheetContext);
              _reportUser(context, profile);
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    ),
  );
}

void _shareProfile(
  BuildContext context,
  UserProfile profile,
  String profileUrl,
) {
  final localizations = AppLocalizations.of(context);
  final shareText = '${localizations?.checkOutProfile ?? "Check out"} '
      '${profile.username} '
      '${localizations?.onTezsell ?? "on TezSell"}: $profileUrl';
  final box = context.findRenderObject() as RenderBox?;
  Share.share(
    shareText,
    subject: profile.username,
    sharePositionOrigin: box != null
        ? box.localToGlobal(Offset.zero) & box.size
        : const Rect.fromLTWH(0, 0, 100, 100),
  );
}

void _copyProfileLink(BuildContext context, String profileUrl) {
  final localizations = AppLocalizations.of(context);
  Clipboard.setData(ClipboardData(text: profileUrl));
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(localizations?.linkCopied ?? 'Link copied to clipboard'),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      duration: const Duration(seconds: 2),
    ),
  );
}

Future<void> _reportUser(
  BuildContext context,
  UserProfile profile,
) async {
  final localizations = AppLocalizations.of(context);
  final scaffoldMessenger = ScaffoldMessenger.of(context);
  final colorScheme = Theme.of(context).colorScheme;

  final result = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => ReportContentDialog(
      contentType: 'user',
      contentId: profile.id,
      contentTitle: profile.username,
    ),
  );

  if (result == true && context.mounted) {
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(
          localizations?.reportSubmitted ?? 'Report submitted successfully',
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        backgroundColor: colorScheme.primary,
      ),
    );
  }
}
