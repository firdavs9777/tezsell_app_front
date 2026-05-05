import 'package:app/l10n/app_localizations.dart';
import 'package:app/pages/shaxsiy/customer_center/widgets/customer_center_actions.dart';
import 'package:flutter/material.dart';

class CustomerCenterSatisfactionCard extends StatelessWidget {
  const CustomerCenterSatisfactionCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(Icons.emoji_emotions, size: 48, color: theme.primaryColor),
          const SizedBox(height: 12),
          Text(
            localizations?.how_are_we_doing ?? 'How are we doing?',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            localizations?.rate_experience ??
                'Rate your customer service experience',
            style: TextStyle(
              fontSize: 14,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _RatingButton(
                icon: Icons.sentiment_very_dissatisfied,
                label: localizations?.poor ?? 'Poor',
                color: Colors.red,
              ),
              _RatingButton(
                icon: Icons.sentiment_neutral,
                label: localizations?.okay ?? 'Okay',
                color: Colors.orange,
              ),
              _RatingButton(
                icon: Icons.sentiment_satisfied,
                label: localizations?.good ?? 'Good',
                color: Colors.blue,
              ),
              _RatingButton(
                icon: Icons.sentiment_very_satisfied,
                label: localizations?.excellent ?? 'Excellent',
                color: Colors.green,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RatingButton extends StatelessWidget {
  const _RatingButton({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => CustomerCenterActions.submitRating(context, label),
      borderRadius: BorderRadius.circular(12),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
