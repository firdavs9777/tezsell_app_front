import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class InquiriesActions {
  InquiriesActions._();

  static const String supportEmail = 'support@tezsell.uz';
  static const String supportPhone = '+998XXXXXXXXX';

  static Future<void> openSupportEmail(BuildContext context) async {
    final Uri uri = Uri(
      scheme: 'mailto',
      path: supportEmail,
      query: 'subject=Support Request from Tezsell App',
    );
    await _launchOrError(context, uri, 'Could not open email app');
  }

  static Future<void> callSupport(BuildContext context) async {
    final Uri uri = Uri(scheme: 'tel', path: supportPhone);
    await _launchOrError(context, uri, 'Could not open phone app');
  }

  static Future<void> openUrl(BuildContext context, String url) async {
    final Uri uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else if (context.mounted) {
        showErrorSnackbar(context, 'Could not open link');
      }
    } catch (e) {
      if (context.mounted) {
        showErrorSnackbar(context, 'Error opening link: $e');
      }
    }
  }

  static Future<void> _launchOrError(
    BuildContext context,
    Uri uri,
    String errorMessage,
  ) async {
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else if (context.mounted) {
        showErrorSnackbar(context, errorMessage);
      }
    } catch (e) {
      if (context.mounted) {
        showErrorSnackbar(context, '$errorMessage: $e');
      }
    }
  }

  static void showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  static void showSuccessSnackbar(BuildContext context, String message) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor:
            isDark ? theme.colorScheme.primary : const Color(0xFF43A047),
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
