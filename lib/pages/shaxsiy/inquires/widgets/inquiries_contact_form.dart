import 'package:app/l10n/app_localizations.dart';
import 'package:app/pages/shaxsiy/inquires/widgets/inquiries_actions.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class InquiriesContactForm extends StatefulWidget {
  const InquiriesContactForm({super.key, required this.onSubmitted});

  final VoidCallback onSubmitted;

  @override
  State<InquiriesContactForm> createState() => _InquiriesContactFormState();
}

class _InquiriesContactFormState extends State<InquiriesContactForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final emailUri = Uri(
        scheme: 'mailto',
        path: InquiriesActions.supportEmail,
        query: 'subject=${Uri.encodeComponent(_subjectController.text)}'
            '&body=${Uri.encodeComponent(
          'Name: ${_nameController.text}\n'
          'Email: ${_emailController.text}\n\n'
          'Message:\n${_messageController.text}',
        )}',
      );

      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
        if (!mounted) return;

        InquiriesActions.showSuccessSnackbar(
          context,
          'Email app opened! Please send your message.',
        );
        _nameController.clear();
        _emailController.clear();
        _subjectController.clear();
        _messageController.clear();
        widget.onSubmitted();
      } else if (mounted) {
        InquiriesActions.showErrorSnackbar(
            context, 'Could not open email app');
      }
    } catch (e) {
      if (mounted) {
        InquiriesActions.showErrorSnackbar(context, 'Error: $e');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

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
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _formField(
              controller: _nameController,
              label: localizations?.name ?? 'Your Name',
              icon: Icons.person_outline,
              validator: (value) => (value == null || value.isEmpty)
                  ? (localizations?.name_required ?? 'Please enter your name')
                  : null,
            ),
            const SizedBox(height: 16),
            _formField(
              controller: _emailController,
              label: localizations?.email ?? 'Email Address',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
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
            _formField(
              controller: _subjectController,
              label: localizations?.subject ?? 'Subject',
              icon: Icons.subject,
              validator: (value) => (value == null || value.isEmpty)
                  ? (localizations?.subject_required ?? 'Please enter a subject')
                  : null,
            ),
            const SizedBox(height: 16),
            _formField(
              controller: _messageController,
              label: localizations?.message ?? 'Your Message',
              icon: Icons.message_outlined,
              maxLines: 5,
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
                onPressed: _isLoading ? null : _submit,
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
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _formField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String? Function(String?) validator,
    TextInputType? keyboardType,
    int? maxLines,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines ?? 1,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        alignLabelWithHint: maxLines != null && maxLines > 1,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      validator: validator,
    );
  }
}
