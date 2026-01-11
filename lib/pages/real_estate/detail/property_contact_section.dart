import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:app/providers/provider_models/real_estate.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/pages/real_estate/property_inquiry_dialog.dart';

class PropertyContactSection extends StatelessWidget {
  final RealEstate property;
  final VoidCallback onInquiry;
  final AppLocalizations? localizations;

  const PropertyContactSection({
    Key? key,
    required this.property,
    required this.onInquiry,
    this.localizations,
  }) : super(key: key);

  void _copyPhoneNumber(BuildContext context, String phoneNumber) {
    Clipboard.setData(ClipboardData(text: phoneNumber));
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.alerts_phone_copied),
        backgroundColor: isDark
            ? Theme.of(context).colorScheme.primary
            : const Color(0xFF43A047),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizations?.contact_title ?? 'Contact Information',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
          ),
          SizedBox(height: 16),
          if (property.agent != null) ...[
            InkWell(
              onTap: () => context.push('/user/${property.agent!.id}'),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.blue[100],
                      child: Icon(Icons.person, color: Colors.blue[600]),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            localizations?.contact_modal_agent ?? 'Agent',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          Text(property.agent!.username,
                              style: TextStyle(color: colorScheme.onSurfaceVariant)),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    IconButton(
                      onPressed: () =>
                          _copyPhoneNumber(context, property.agent!.phoneNumber),
                      icon: Icon(Icons.phone, color: isDark ? colorScheme.primary : const Color(0xFF43A047)),
                    ),
                  ],
                ),
              ),
            ),
          ] else ...[
            InkWell(
              onTap: () => context.push('/user/${property.owner.id}'),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.green[100],
                      child: Icon(Icons.home, color: Colors.green[600]),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            localizations?.contact_property_owner ??
                                'Property Owner',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          Text(property.owner.username,
                              style: TextStyle(color: colorScheme.onSurfaceVariant)),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    IconButton(
                      onPressed: () =>
                          _copyPhoneNumber(context, property.owner.phoneNumber),
                      icon: Icon(Icons.phone, color: isDark ? colorScheme.primary : const Color(0xFF43A047)),
                    ),
                  ],
                ),
              ),
            ),
          ],
          SizedBox(height: 16),
          // Inquiry Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onInquiry,
              icon: Icon(Icons.message),
              label: Text(
                localizations?.contact_send_inquiry ?? 'Send Inquiry',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

