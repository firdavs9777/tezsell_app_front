import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerCenterActions {
  CustomerCenterActions._();

  static Future<void> makeCall(BuildContext context, String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else if (context.mounted) {
        _showError(context, 'Could not open phone app');
      }
    } catch (e) {
      if (context.mounted) {
        _showError(context, 'Error making call: $e');
      }
    }
  }

  static Future<void> sendEmail(BuildContext context, String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=Customer Support Request',
    );
    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      } else if (context.mounted) {
        _showError(context, 'Could not open email app');
      }
    } catch (e) {
      if (context.mounted) {
        _showError(context, 'Error opening email: $e');
      }
    }
  }

  static Future<void> openWhatsApp(
      BuildContext context, String phoneNumber) async {
    final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
    final Uri whatsappUri = Uri.parse('https://wa.me/$cleanNumber');
    try {
      if (await canLaunchUrl(whatsappUri)) {
        await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
      } else if (context.mounted) {
        _showError(context, 'Could not open WhatsApp');
      }
    } catch (e) {
      if (context.mounted) {
        _showError(context, 'Error opening WhatsApp: $e');
      }
    }
  }

  static Future<void> openUrl(BuildContext context, String url) async {
    final Uri uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else if (context.mounted) {
        _showError(context, 'Could not open link');
      }
    } catch (e) {
      if (context.mounted) {
        _showError(context, 'Error opening link: $e');
      }
    }
  }

  static void showComingSoon(BuildContext context, String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.info_outline, color: Theme.of(context).primaryColor),
            const SizedBox(width: 8),
            const Text('Coming Soon'),
          ],
        ),
        content: Text('$feature feature will be available soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  static void submitRating(BuildContext context, String rating) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text('Thank you for rating us "$rating"!')),
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

  static void _showError(BuildContext context, String message) {
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
}
