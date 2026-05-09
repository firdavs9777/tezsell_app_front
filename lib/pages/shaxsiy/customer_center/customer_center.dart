import 'package:app/l10n/app_localizations.dart';
import 'package:app/pages/shaxsiy/customer_center/widgets/customer_center_actions.dart';
import 'package:app/pages/shaxsiy/customer_center/widgets/customer_center_cards.dart';
import 'package:app/pages/shaxsiy/customer_center/widgets/customer_center_satisfaction_card.dart';
import 'package:app/pages/shaxsiy/customer_center/widgets/customer_center_support_hours.dart';
import 'package:app/pages/shaxsiy/customer_center/widgets/customer_center_welcome_header.dart';
import 'package:flutter/material.dart';

class CustomerCenterPage extends StatelessWidget {
  const CustomerCenterPage({super.key});

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
          localizations?.customer_center ?? 'Customer Center',
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
            const CustomerCenterWelcomeHeader(),
            _buildQuickActionsGrid(context, localizations),
            const SizedBox(height: 24),
            _buildContactMethodsSection(context, localizations),
            const SizedBox(height: 24),
            const CustomerCenterSupportHours(),
            const SizedBox(height: 24),
            const CustomerCenterSatisfactionCard(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionsGrid(
      BuildContext context, AppLocalizations? localizations) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizations?.quick_actions ?? 'Quick Actions',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.9,
            children: [
              QuickActionCard(
                icon: Icons.chat_bubble_outline,
                title: localizations?.live_chat ?? 'Live Chat',
                subtitle: localizations?.chat_with_us ?? 'Chat with us',
                color: const Color(0xFF2196F3),
                onTap: () =>
                    CustomerCenterActions.showComingSoon(context, 'Live Chat'),
              ),
              QuickActionCard(
                icon: Icons.help_outline,
                title: localizations?.help_center ?? 'Help Center',
                subtitle: localizations?.find_answers ?? 'Find answers',
                color: const Color(0xFF9C27B0),
                onTap: () => CustomerCenterActions.showComingSoon(
                    context, 'Help Center'),
              ),
              QuickActionCard(
                icon: Icons.description_outlined,
                title: localizations?.my_tickets ?? 'My Tickets',
                subtitle: localizations?.view_tickets ?? 'View tickets',
                color: const Color(0xFFFF9800),
                onTap: () => CustomerCenterActions.showComingSoon(
                    context, 'My Tickets'),
              ),
              QuickActionCard(
                icon: Icons.feedback_outlined,
                title: localizations?.feedback ?? 'Feedback',
                subtitle: localizations?.share_feedback ?? 'Share feedback',
                color: const Color(0xFF4CAF50),
                onTap: () => CustomerCenterActions.showComingSoon(
                    context, 'Feedback Form'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactMethodsSection(
      BuildContext context, AppLocalizations? localizations) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizations?.contact_methods ?? 'Contact Methods',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ContactMethodTile(
            icon: Icons.phone_in_talk,
            title: localizations?.phone_support ?? 'Phone Support',
            subtitle: '+998 99 607 13 21',
            description: localizations?.available_247 ?? 'Available 24/7',
            color: const Color(0xFF4CAF50),
            onTap: () =>
                CustomerCenterActions.makeCall(context, '+998996071321'),
          ),
          const SizedBox(height: 12),
          ContactMethodTile(
            icon: Icons.email_outlined,
            title: localizations?.email_support ?? 'Email Support',
            subtitle: 'support@tezsell.uz',
            description:
                localizations?.response_24h ?? 'Response within 24 hours',
            color: const Color(0xFF2196F3),
            onTap: () =>
                CustomerCenterActions.sendEmail(context, 'support@tezsell.uz'),
          ),
          const SizedBox(height: 12),
          ContactMethodTile(
            icon: Icons.telegram,
            title: localizations?.telegram_support ?? 'Telegram Support',
            subtitle: '@tezsell_support',
            description: localizations?.instant_replies ?? 'Instant replies',
            color: const Color(0xFF0088CC),
            onTap: () => CustomerCenterActions.openUrl(
                context, 'https://t.me/tezsell_support'),
          ),
          const SizedBox(height: 12),
          ContactMethodTile(
            icon: Icons.message,
            title: localizations?.whatsapp_support ?? 'WhatsApp Support',
            subtitle: '+998 99 607 13 21',
            description: localizations?.quick_response ?? 'Quick response',
            color: const Color(0xFF25D366),
            onTap: () =>
                CustomerCenterActions.openWhatsApp(context, '+998996071321'),
          ),
        ],
      ),
    );
  }
}
