import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:app/l10n/app_localizations.dart';

class CustomerCenterPage extends StatefulWidget {
  const CustomerCenterPage({super.key});

  @override
  State<CustomerCenterPage> createState() => _CustomerCenterPageState();
}

class _CustomerCenterPageState extends State<CustomerCenterPage> {
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
                theme.primaryColor.withOpacity(0.8),
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
            // Welcome Header
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.primaryColor.withOpacity(0.1),
                    theme.primaryColor.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: theme.primaryColor.withOpacity(0.3),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.headset_mic,
                      size: 48,
                      color: theme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    localizations?.welcome_customer_center ??
                        'Welcome to Customer Center',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: theme.primaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    localizations?.customer_center_subtitle ??
                        'We\'re here to help you 24/7',
                    style: TextStyle(
                      fontSize: 14,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Quick Actions Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localizations?.quick_actions ?? 'Quick Actions',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
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
                      _buildQuickActionCard(
                        icon: Icons.chat_bubble_outline,
                        title: localizations?.live_chat ?? 'Live Chat',
                        subtitle: localizations?.chat_with_us ?? 'Chat with us',
                        color: const Color(0xFF2196F3),
                        onTap: _openLiveChat,
                      ),
                      _buildQuickActionCard(
                        icon: Icons.help_outline,
                        title: localizations?.help_center ?? 'Help Center',
                        subtitle: localizations?.find_answers ?? 'Find answers',
                        color: const Color(0xFF9C27B0),
                        onTap: _openHelpCenter,
                      ),
                      _buildQuickActionCard(
                        icon: Icons.description_outlined,
                        title: localizations?.my_tickets ?? 'My Tickets',
                        subtitle: localizations?.view_tickets ?? 'View tickets',
                        color: const Color(0xFFFF9800),
                        onTap: _openMyTickets,
                      ),
                      _buildQuickActionCard(
                        icon: Icons.feedback_outlined,
                        title: localizations?.feedback ?? 'Feedback',
                        subtitle:
                            localizations?.share_feedback ?? 'Share feedback',
                        color: const Color(0xFF4CAF50),
                        onTap: _openFeedback,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Contact Methods
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localizations?.contact_methods ?? 'Contact Methods',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildContactMethod(
                    icon: Icons.phone_in_talk,
                    title: localizations?.phone_support ?? 'Phone Support',
                    subtitle: '+998 99 607 13 21',
                    description:
                        localizations?.available_247 ?? 'Available 24/7',
                    color: const Color(0xFF4CAF50),
                    onTap: () => _makeCall('+998996071321'),
                  ),
                  const SizedBox(height: 12),
                  _buildContactMethod(
                    icon: Icons.email_outlined,
                    title: localizations?.email_support ?? 'Email Support',
                    subtitle: 'support@tezsell.uz',
                    description: localizations?.response_24h ??
                        'Response within 24 hours',
                    color: const Color(0xFF2196F3),
                    onTap: () => _sendEmail('support@tezsell.uz'),
                  ),
                  const SizedBox(height: 12),
                  _buildContactMethod(
                    icon: Icons.telegram,
                    title:
                        localizations?.telegram_support ?? 'Telegram Support',
                    subtitle: '@tezsell_support',
                    description:
                        localizations?.instant_replies ?? 'Instant replies',
                    color: const Color(0xFF0088CC),
                    onTap: () => _openUrl('https://t.me/tezsell_support'),
                  ),
                  const SizedBox(height: 12),
                  _buildContactMethod(
                    icon: Icons.message,
                    title:
                        localizations?.whatsapp_support ?? 'WhatsApp Support',
                    subtitle: '+998 99 607 13 21',
                    description:
                        localizations?.quick_response ?? 'Quick response',
                    color: const Color(0xFF25D366),
                    onTap: () => _openWhatsApp('+998996071321'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Support Hours
            Container(
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
                border: Border.all(
                  color: theme.primaryColor.withOpacity(0.3),
                ),
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
                        child: Icon(
                          Icons.access_time,
                          color: theme.primaryColor,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        localizations?.support_hours ?? 'Support Hours',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildSupportHourRow(
                    localizations?.live_chat ?? 'Live Chat',
                    localizations?.available_247 ?? '24/7 Available',
                    true,
                  ),
                  const Divider(height: 24),
                  _buildSupportHourRow(
                    localizations?.phone_support ?? 'Phone Support',
                    localizations?.mon_fri_9_6 ?? 'Mon-Fri: 9:00 AM - 6:00 PM',
                    false,
                  ),
                  const Divider(height: 24),
                  _buildSupportHourRow(
                    localizations?.email_support ?? 'Email Support',
                    localizations?.response_24h ?? 'Response within 24 hours',
                    false,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Satisfaction Survey
            Container(
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
                  Icon(
                    Icons.emoji_emotions,
                    size: 48,
                    color: theme.primaryColor,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    localizations?.how_are_we_doing ?? 'How are we doing?',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
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
                      _buildRatingButton(
                        icon: Icons.sentiment_very_dissatisfied,
                        label: localizations?.poor ?? 'Poor',
                        color: Colors.red,
                      ),
                      _buildRatingButton(
                        icon: Icons.sentiment_neutral,
                        label: localizations?.okay ?? 'Okay',
                        color: Colors.orange,
                      ),
                      _buildRatingButton(
                        icon: Icons.sentiment_satisfied,
                        label: localizations?.good ?? 'Good',
                        color: Colors.blue,
                      ),
                      _buildRatingButton(
                        icon: Icons.sentiment_very_satisfied,
                        label: localizations?.excellent ?? 'Excellent',
                        color: Colors.green,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
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
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactMethod({
    required IconData icon,
    required String title,
    required String subtitle,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
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
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: theme.colorScheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }

  Widget _buildTopicCard({
    required IconData icon,
    required String title,
    required List<String> topics,
    required ThemeData theme,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: theme.primaryColor, size: 24),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          iconColor: theme.primaryColor,
          collapsedIconColor: theme.colorScheme.onSurfaceVariant,
          children: topics
              .map(
                (topic) => InkWell(
                  onTap: () => _openTopicDetail(topic),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Icon(
                          Icons.arrow_right,
                          color: theme.colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            topic,
                            style: TextStyle(
                              fontSize: 14,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget _buildSupportHourRow(String service, String hours, bool isActive) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final activeColor = isDark ? theme.colorScheme.primary : const Color(0xFF43A047);
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
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
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

  Widget _buildRatingButton({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return InkWell(
      onTap: () => _submitRating(label),
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

  // Action Methods
  void _openLiveChat() {
    // Implement live chat functionality
    _showComingSoon('Live Chat');
  }

  void _openHelpCenter() {
    // Navigate to help center or open help articles
    _showComingSoon('Help Center');
  }

  void _openMyTickets() {
    // Navigate to tickets page
    _showComingSoon('My Tickets');
  }

  void _openFeedback() {
    // Open feedback form
    _showComingSoon('Feedback Form');
  }

  Future<void> _makeCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        _showError('Could not open phone app');
      }
    } catch (e) {
      _showError('Error making call: $e');
    }
  }

  Future<void> _sendEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=Customer Support Request',
    );
    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      } else {
        _showError('Could not open email app');
      }
    } catch (e) {
      _showError('Error opening email: $e');
    }
  }

  Future<void> _openWhatsApp(String phoneNumber) async {
    final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
    final Uri whatsappUri = Uri.parse('https://wa.me/$cleanNumber');
    try {
      if (await canLaunchUrl(whatsappUri)) {
        await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
      } else {
        _showError('Could not open WhatsApp');
      }
    } catch (e) {
      _showError('Error opening WhatsApp: $e');
    }
  }

  Future<void> _openUrl(String url) async {
    final Uri uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        _showError('Could not open link');
      }
    } catch (e) {
      _showError('Error opening link: $e');
    }
  }

  void _openTopicDetail(String topic) {
    // Navigate to topic detail page or show dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(topic),
        content:
            Text('Detailed information about "$topic" will be shown here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _submitRating(String rating) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text('Thank you for rating us "$rating"!'),
            ),
          ],
        ),
        backgroundColor: isDark ? theme.colorScheme.primary : const Color(0xFF43A047),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _showComingSoon(String feature) {
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

  void _showError(String message) {
    if (mounted) {
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }
}
