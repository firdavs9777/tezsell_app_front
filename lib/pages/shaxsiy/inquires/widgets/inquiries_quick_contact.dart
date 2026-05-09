import 'package:app/l10n/app_localizations.dart';
import 'package:app/pages/shaxsiy/inquires/widgets/inquiries_actions.dart';
import 'package:flutter/material.dart';

class InquiriesQuickContact extends StatelessWidget {
  const InquiriesQuickContact({
    super.key,
    required this.onToggleContactForm,
  });

  final VoidCallback onToggleContactForm;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizations?.contact_us ?? 'Contact Us',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _QuickContactOption(
            icon: Icons.email_outlined,
            title: localizations?.email_support ?? 'Email Support',
            subtitle: InquiriesActions.supportEmail,
            color: const Color(0xFF2196F3),
            onTap: () => InquiriesActions.openSupportEmail(context),
          ),
          const SizedBox(height: 12),
          _QuickContactOption(
            icon: Icons.phone_outlined,
            title: localizations?.call_support ?? 'Call Support',
            subtitle: '+998996071321',
            color: const Color(0xFF4CAF50),
            onTap: () => InquiriesActions.callSupport(context),
          ),
          const SizedBox(height: 12),
          _QuickContactOption(
            icon: Icons.chat_bubble_outline,
            title: localizations?.send_message ?? 'Send Message',
            subtitle: localizations?.fill_contact_form ?? 'Fill out contact form',
            color: const Color(0xFFFF9800),
            onTap: onToggleContactForm,
          ),
        ],
      ),
    );
  }
}

class _QuickContactOption extends StatelessWidget {
  const _QuickContactOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.colorScheme.outlineVariant),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios,
                size: 16, color: theme.colorScheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}
