import 'package:app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class CustomerCenterSupportHours extends StatelessWidget {
  const CustomerCenterSupportHours({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.primaryColor.withOpacity(0.1),
            theme.primaryColor.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.primaryColor.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.access_time,
                    color: theme.primaryColor, size: 24),
              ),
              const SizedBox(width: 12),
              Text(
                localizations?.support_hours ?? 'Support Hours',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _SupportHourRow(
            service: localizations?.live_chat ?? 'Live Chat',
            hours: localizations?.available_247 ?? '24/7 Available',
            isActive: true,
          ),
          const Divider(height: 24),
          _SupportHourRow(
            service: localizations?.phone_support ?? 'Phone Support',
            hours: localizations?.mon_fri_9_6 ??
                'Mon-Fri: 9:00 AM - 6:00 PM',
            isActive: false,
          ),
          const Divider(height: 24),
          _SupportHourRow(
            service: localizations?.email_support ?? 'Email Support',
            hours: localizations?.response_24h ?? 'Response within 24 hours',
            isActive: false,
          ),
        ],
      ),
    );
  }
}

class _SupportHourRow extends StatelessWidget {
  const _SupportHourRow({
    required this.service,
    required this.hours,
    required this.isActive,
  });

  final String service;
  final String hours;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final activeColor =
        isDark ? theme.colorScheme.primary : const Color(0xFF43A047);

    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? activeColor : theme.colorScheme.onSurfaceVariant,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                service,
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 2),
              Text(
                hours,
                style: TextStyle(
                  fontSize: 13,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        if (isActive)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: activeColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Online',
              style: TextStyle(
                fontSize: 11,
                color: activeColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}
