import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.alerts_phone_copied),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizations?.contact_title ?? 'Contact Information',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          if (property.agent != null) ...[
            Row(
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
                          style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () =>
                      _copyPhoneNumber(context, property.agent!.phoneNumber),
                  icon: Icon(Icons.phone, color: Colors.green),
                ),
              ],
            ),
          ] else ...[
            Row(
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
                          style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () =>
                      _copyPhoneNumber(context, property.owner.phoneNumber),
                  icon: Icon(Icons.phone, color: Colors.green),
                ),
              ],
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
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
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

