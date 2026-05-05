import 'package:app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class InquiriesFaq extends StatelessWidget {
  const InquiriesFaq({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);

    final items = <_FaqEntry>[
      _FaqEntry(
        question:
            l?.faq_how_to_sell ?? 'How do I sell items on Tezsell?',
        answer: l?.faq_how_to_sell_answer ??
            'To sell items: 1) Create an account, 2) Tap the "+" button, 3) Choose category (Products/Services/Real Estate), 4) Add photos and description, 5) Set your price, 6) Publish! Your listing will be visible to buyers in your area.',
      ),
      _FaqEntry(
        question: l?.faq_is_free ?? 'Is Tezsell free to use?',
        answer: l?.faq_is_free_answer ??
            'Yes! Tezsell is currently 100% free. No listing fees, no commission on sales, no subscription charges. We may introduce premium features in the future, but will notify users 30 days in advance.',
      ),
      _FaqEntry(
        question: l?.faq_safety ??
            'How can I stay safe when buying/selling?',
        answer: l?.faq_safety_answer ??
            'Safety tips: 1) Meet in public places, 2) Inspect items before paying, 3) Never send money to strangers, 4) Trust your instincts, 5) Report suspicious users, 6) Don\'t share personal information too early, 7) Bring a friend for high-value transactions.',
      ),
      _FaqEntry(
        question: l?.faq_payment ?? 'How do payments work?',
        answer: l?.faq_payment_answer ??
            'Tezsell does not process payments. Buyers and sellers arrange payment directly (cash, bank transfer, etc.). We are just a platform to connect people - you handle the transaction yourselves.',
      ),
      _FaqEntry(
        question: l?.faq_prohibited ?? 'What items are prohibited?',
        answer: l?.faq_prohibited_answer ??
            'Prohibited items include: weapons, drugs, stolen goods, counterfeit items, adult content, live animals (without permits), government IDs, and hazardous materials. See our Terms & Conditions for the complete list.',
      ),
      _FaqEntry(
        question:
            l?.faq_account_delete ?? 'How do I delete my account?',
        answer: l?.faq_account_delete_answer ??
            'Go to Profile → Settings → Account Settings → Delete Account. Note: This is permanent and cannot be undone. All your listings will be removed.',
      ),
      _FaqEntry(
        question:
            l?.faq_report_user ?? 'How do I report a user or listing?',
        answer: l?.faq_report_user_answer ??
            'Tap the three dots (•••) on any listing or user profile, then select "Report". Choose the reason and submit. We review all reports within 24-48 hours.',
      ),
      _FaqEntry(
        question:
            l?.faq_change_location ?? 'How do I change my location?',
        answer: l?.faq_change_location_answer ??
            'Tap the location button in the top-left corner of the home screen. You can select your region and district to see listings in your area.',
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.help_outline, color: theme.primaryColor),
              const SizedBox(width: 8),
              Text(
                l?.faq ?? 'Frequently Asked Questions',
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...items.map((entry) => _FaqItem(entry: entry)),
        ],
      ),
    );
  }
}

class _FaqEntry {
  const _FaqEntry({required this.question, required this.answer});
  final String question;
  final String answer;
}

class _FaqItem extends StatelessWidget {
  const _FaqItem({required this.entry});
  final _FaqEntry entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Theme(
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          title: Text(
            entry.question,
            style:
                const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          iconColor: theme.primaryColor,
          collapsedIconColor: theme.colorScheme.onSurfaceVariant,
          children: [
            Text(
              entry.answer,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
