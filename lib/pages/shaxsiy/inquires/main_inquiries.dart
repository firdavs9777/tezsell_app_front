import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:app/l10n/app_localizations.dart';

class InquiriesPage extends StatefulWidget {
  const InquiriesPage({super.key});

  @override
  State<InquiriesPage> createState() => _InquiriesPageState();
}

class _InquiriesPageState extends State<InquiriesPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isLoading = false;
  bool _showContactForm = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

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
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          localizations?.inquiries ?? 'Help & Support',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Card
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
                  Icon(
                    Icons.support_agent,
                    size: 64,
                    color: theme.primaryColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    localizations?.help_center ?? 'How can we help you?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: theme.primaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    localizations?.help_subtitle ??
                        'We\'re here to assist you with any questions',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Quick Contact Options
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localizations?.contact_us ?? 'Contact Us',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildQuickContactOption(
                    icon: Icons.email_outlined,
                    title: localizations?.email_support ?? 'Email Support',
                    subtitle: 'support@tezsell.uz',
                    color: const Color(0xFF2196F3),
                    onTap: _openEmail,
                  ),
                  const SizedBox(height: 12),
                  _buildQuickContactOption(
                    icon: Icons.phone_outlined,
                    title: localizations?.call_support ?? 'Call Support',
                    subtitle: '+998996071321',
                    color: const Color(0xFF4CAF50),
                    onTap: _callSupport,
                  ),
                  const SizedBox(height: 12),
                  _buildQuickContactOption(
                    icon: Icons.chat_bubble_outline,
                    title: localizations?.send_message ?? 'Send Message',
                    subtitle: localizations?.fill_contact_form ??
                        'Fill out contact form',
                    color: const Color(0xFFFF9800),
                    onTap: () {
                      setState(() {
                        _showContactForm = !_showContactForm;
                      });
                    },
                  ),
                ],
              ),
            ),

            // Contact Form (Expandable)
            if (_showContactForm) ...[
              const SizedBox(height: 24),
              _buildContactForm(theme, localizations),
            ],

            const SizedBox(height: 32),

            // FAQ Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.help_outline, color: theme.primaryColor),
                      const SizedBox(width: 8),
                      Text(
                        localizations?.faq ?? 'Frequently Asked Questions',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildFAQItem(
                    question: localizations?.faq_how_to_sell ??
                        'How do I sell items on Tezsell?',
                    answer: localizations?.faq_how_to_sell_answer ??
                        'To sell items: 1) Create an account, 2) Tap the "+" button, 3) Choose category (Products/Services/Real Estate), 4) Add photos and description, 5) Set your price, 6) Publish! Your listing will be visible to buyers in your area.',
                    theme: theme,
                  ),
                  _buildFAQItem(
                    question:
                        localizations?.faq_is_free ?? 'Is Tezsell free to use?',
                    answer: localizations?.faq_is_free_answer ??
                        'Yes! Tezsell is currently 100% free. No listing fees, no commission on sales, no subscription charges. We may introduce premium features in the future, but will notify users 30 days in advance.',
                    theme: theme,
                  ),
                  _buildFAQItem(
                    question: localizations?.faq_safety ??
                        'How can I stay safe when buying/selling?',
                    answer: localizations?.faq_safety_answer ??
                        'Safety tips: 1) Meet in public places, 2) Inspect items before paying, 3) Never send money to strangers, 4) Trust your instincts, 5) Report suspicious users, 6) Don\'t share personal information too early, 7) Bring a friend for high-value transactions.',
                    theme: theme,
                  ),
                  _buildFAQItem(
                    question:
                        localizations?.faq_payment ?? 'How do payments work?',
                    answer: localizations?.faq_payment_answer ??
                        'Tezsell does not process payments. Buyers and sellers arrange payment directly (cash, bank transfer, etc.). We are just a platform to connect people - you handle the transaction yourselves.',
                    theme: theme,
                  ),
                  _buildFAQItem(
                    question: localizations?.faq_prohibited ??
                        'What items are prohibited?',
                    answer: localizations?.faq_prohibited_answer ??
                        'Prohibited items include: weapons, drugs, stolen goods, counterfeit items, adult content, live animals (without permits), government IDs, and hazardous materials. See our Terms & Conditions for the complete list.',
                    theme: theme,
                  ),
                  _buildFAQItem(
                    question: localizations?.faq_account_delete ??
                        'How do I delete my account?',
                    answer: localizations?.faq_account_delete_answer ??
                        'Go to Profile → Settings → Account Settings → Delete Account. Note: This is permanent and cannot be undone. All your listings will be removed.',
                    theme: theme,
                  ),
                  _buildFAQItem(
                    question: localizations?.faq_report_user ??
                        'How do I report a user or listing?',
                    answer: localizations?.faq_report_user_answer ??
                        'Tap the three dots (•••) on any listing or user profile, then select "Report". Choose the reason and submit. We review all reports within 24-48 hours.',
                    theme: theme,
                  ),
                  _buildFAQItem(
                    question: localizations?.faq_change_location ??
                        'How do I change my location?',
                    answer: localizations?.faq_change_location_answer ??
                        'Tap the location button in the top-left corner of the home screen. You can select your region and district to see listings in your area.',
                    theme: theme,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Social Media & Links
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localizations?.follow_us ?? 'Follow Us',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildSocialButton(
                        icon: Icons.facebook,
                        label: 'Facebook',
                        color: const Color(0xFF1877F2),
                        onTap: () => _openUrl('https://facebook.com/tezsell'),
                      ),
                      _buildSocialButton(
                        icon: Icons.telegram,
                        label: 'Telegram',
                        color: const Color(0xFF0088CC),
                        onTap: () => _openUrl('https://t.me/tezsell'),
                      ),
                      _buildSocialButton(
                        icon: Icons.language,
                        label: 'Instagram',
                        color: const Color(0xFFE4405F),
                        onTap: () => _openUrl('https://instagram.com/tezsell'),
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

  Widget _buildQuickContactOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!),
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
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
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
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  Widget _buildContactForm(ThemeData theme, AppLocalizations? localizations) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.message, color: theme.primaryColor),
                const SizedBox(width: 8),
                Text(
                  localizations?.contact_form ?? 'Contact Form',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: localizations?.name ?? 'Your Name',
                prefixIcon: const Icon(Icons.person_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return localizations?.name_required ??
                      'Please enter your name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: localizations?.email ?? 'Email Address',
                prefixIcon: const Icon(Icons.email_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return localizations?.email_required ??
                      'Please enter your email';
                }
                if (!value.contains('@')) {
                  return localizations?.email_invalid ??
                      'Please enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _subjectController,
              decoration: InputDecoration(
                labelText: localizations?.subject ?? 'Subject',
                prefixIcon: const Icon(Icons.subject),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return localizations?.subject_required ??
                      'Please enter a subject';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _messageController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: localizations?.message ?? 'Your Message',
                prefixIcon: const Icon(Icons.message_outlined),
                alignLabelWithHint: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return localizations?.message_required ??
                      'Please enter your message';
                }
                if (value.length < 10) {
                  return localizations?.message_too_short ??
                      'Message must be at least 10 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitContactForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        localizations?.send_message ?? 'Send Message',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem({
    required String question,
    required String answer,
    required ThemeData theme,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          title: Text(
            question,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          iconColor: theme.primaryColor,
          collapsedIconColor: Colors.grey[600],
          children: [
            Text(
              answer,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
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

  Future<void> _openEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'support@tezsell.uz',
      query: 'subject=Support Request from Tezsell App',
    );

    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      } else {
        _showErrorSnackbar('Could not open email app');
      }
    } catch (e) {
      _showErrorSnackbar('Error opening email: $e');
    }
  }

  Future<void> _callSupport() async {
    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: '+998XXXXXXXXX', // Replace with actual number
    );

    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        _showErrorSnackbar('Could not open phone app');
      }
    } catch (e) {
      _showErrorSnackbar('Error making call: $e');
    }
  }

  Future<void> _submitContactForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        // Create email with form data
        final Uri emailUri = Uri(
          scheme: 'mailto',
          path: 'support@tezsell.uz',
          query:
              'subject=${Uri.encodeComponent(_subjectController.text)}&body=${Uri.encodeComponent('Name: ${_nameController.text}\nEmail: ${_emailController.text}\n\nMessage:\n${_messageController.text}')}',
        );

        if (await canLaunchUrl(emailUri)) {
          await launchUrl(emailUri);

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.white),
                    SizedBox(width: 12),
                    Expanded(
                      child:
                          Text('Email app opened! Please send your message.'),
                    ),
                  ],
                ),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );

            // Clear form
            _nameController.clear();
            _emailController.clear();
            _subjectController.clear();
            _messageController.clear();
            setState(() => _showContactForm = false);
          }
        } else {
          _showErrorSnackbar('Could not open email app');
        }
      } catch (e) {
        _showErrorSnackbar('Error: $e');
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  Future<void> _openUrl(String url) async {
    final Uri uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        _showErrorSnackbar('Could not open link');
      }
    } catch (e) {
      _showErrorSnackbar('Error opening link: $e');
    }
  }

  void _showErrorSnackbar(String message) {
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
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }
}
