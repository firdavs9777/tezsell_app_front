import 'package:app/l10n/app_localizations.dart';
import 'package:app/pages/shaxsiy/inquires/widgets/inquiries_contact_form.dart';
import 'package:app/pages/shaxsiy/inquires/widgets/inquiries_faq.dart';
import 'package:app/pages/shaxsiy/inquires/widgets/inquiries_header.dart';
import 'package:app/pages/shaxsiy/inquires/widgets/inquiries_quick_contact.dart';
import 'package:app/pages/shaxsiy/inquires/widgets/inquiries_social_links.dart';
import 'package:flutter/material.dart';

class InquiriesPage extends StatefulWidget {
  const InquiriesPage({super.key});

  @override
  State<InquiriesPage> createState() => _InquiriesPageState();
}

class _InquiriesPageState extends State<InquiriesPage> {
  bool _showContactForm = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.primaryColor,
                theme.primaryColor.withValues(alpha: 0.8),
              ],
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.onPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          localizations?.inquiries ?? 'Help & Support',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: theme.colorScheme.onPrimary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const InquiriesHeader(),
            InquiriesQuickContact(
              onToggleContactForm: () {
                setState(() {
                  _showContactForm = !_showContactForm;
                });
              },
            ),
            if (_showContactForm) ...[
              const SizedBox(height: 24),
              InquiriesContactForm(
                onSubmitted: () {
                  setState(() => _showContactForm = false);
                },
              ),
            ],
            const SizedBox(height: 32),
            const InquiriesFaq(),
            const SizedBox(height: 32),
            const InquiriesSocialLinks(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
