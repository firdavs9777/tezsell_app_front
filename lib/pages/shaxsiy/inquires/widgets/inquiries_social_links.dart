import 'package:app/l10n/app_localizations.dart';
import 'package:app/pages/shaxsiy/inquires/widgets/inquiries_actions.dart';
import 'package:flutter/material.dart';

class InquiriesSocialLinks extends StatelessWidget {
  const InquiriesSocialLinks({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizations?.follow_us ?? 'Follow Us',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _SocialButton(
                icon: Icons.facebook,
                label: 'Facebook',
                color: const Color(0xFF1877F2),
                onTap: () => InquiriesActions.openUrl(
                    context, 'https://facebook.com/tezsell'),
              ),
              _SocialButton(
                icon: Icons.telegram,
                label: 'Telegram',
                color: const Color(0xFF0088CC),
                onTap: () => InquiriesActions.openUrl(
                    context, 'https://t.me/tezsell'),
              ),
              _SocialButton(
                icon: Icons.language,
                label: 'Instagram',
                color: const Color(0xFFE4405F),
                onTap: () => InquiriesActions.openUrl(
                    context, 'https://instagram.com/tezsell'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
