import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/providers/provider_models/property_inquiry.dart';
import 'package:app/providers/provider_root/real_estate_provider.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/utils/error_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PropertyInquiryDialog extends ConsumerStatefulWidget {
  final String propertyId;
  final String propertyTitle;

  const PropertyInquiryDialog({
    super.key,
    required this.propertyId,
    required this.propertyTitle,
  });

  @override
  ConsumerState<PropertyInquiryDialog> createState() =>
      _PropertyInquiryDialogState();
}

class _PropertyInquiryDialogState extends ConsumerState<PropertyInquiryDialog> {
  final _formKey = GlobalKey<FormState>();
  final _messageController = TextEditingController();
  final _preferredTimeController = TextEditingController();
  final _offeredPriceController = TextEditingController();

  InquiryType _selectedInquiryType = InquiryType.viewing;
  bool _isSubmitting = false;
  String? _userToken;

  @override
  void initState() {
    super.initState();
    _loadUserToken();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _preferredTimeController.dispose();
    _offeredPriceController.dispose();
    super.dispose();
  }

  Future<void> _loadUserToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (mounted) {
        setState(() {
          _userToken = prefs.getString('token');
        });
      }
    } catch (e) {
      // Handle error
    }
  }

  Future<void> _submitInquiry() async {
    if (_userToken == null) {
      final l10n = AppLocalizations.of(context);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n?.authLoginRequired ?? 'Please login to continue'),
            backgroundColor: Colors.orange,
            action: SnackBarAction(
              label: l10n?.authLogin ?? 'Login',
              textColor: Colors.white,
              onPressed: () {
                Navigator.of(context).pushNamed('/login');
              },
            ),
          ),
        );
      }
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await ref.read(realEstateServiceProvider).createInquiry(
            propertyId: widget.propertyId,
            inquiryType: _selectedInquiryType.value,
            message: _messageController.text.trim().isEmpty
                ? null
                : _messageController.text.trim(),
            preferredContactTime: _preferredTimeController.text.trim().isEmpty
                ? null
                : _preferredTimeController.text.trim(),
            offeredPrice: _offeredPriceController.text.trim().isEmpty
                ? null
                : _offeredPriceController.text.trim(),
            token: _userToken!,
          );

      if (mounted) {
        HapticFeedback.mediumImpact();
        Navigator.of(context).pop(true); // Return true to indicate success

        final l10n = AppLocalizations.of(context);
        final isDark = Theme.of(context).brightness == Brightness.dark;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                  l10n?.inquiry_inquiry_sent_success ?? 'Inquiry submitted successfully!',
            ),
            backgroundColor: isDark
                ? Theme.of(context).colorScheme.primary
                : const Color(0xFF43A047),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        AppErrorHandler.showError(context, error);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.primaryColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.message, color: colorScheme.onPrimary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n?.inquiry_title ?? 'Contact Property Owner',
                          style: TextStyle(
                            color: colorScheme.onPrimary,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.propertyTitle,
                          style: TextStyle(
                            color: colorScheme.onPrimary.withOpacity(0.9),
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: colorScheme.onPrimary),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // Form Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Inquiry Type Selection
                      Text(
                            l10n?.inquiry_inquiry_type ?? 'Inquiry Type',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...InquiryType.values.map((type) {
                        return RadioListTile<InquiryType>(
                          title: Text(_getInquiryTypeLabel(type, l10n)),
                          subtitle: Text(_getInquiryTypeDescription(type, l10n)),
                          value: type,
                          groupValue: _selectedInquiryType,
                          onChanged: (value) {
                            setState(() {
                              _selectedInquiryType = value!;
                            });
                            HapticFeedback.selectionClick();
                          },
                          contentPadding: EdgeInsets.zero,
                        );
                      }),

                      const SizedBox(height: 24),

                      // Message Field
                      TextFormField(
                        controller: _messageController,
                        decoration: InputDecoration(
                              labelText: l10n?.inquiry_message ?? 'Message (Optional)',
                              hintText: l10n?.inquiry_message_placeholder ??
                                  'Add any additional details...',
                          prefixIcon: const Icon(Icons.message_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: colorScheme.surfaceContainerHighest.withOpacity(0.5),
                        ),
                        maxLines: 4,
                        textInputAction: TextInputAction.newline,
                      ),

                      const SizedBox(height: 16),

                      // Preferred Contact Time (for viewing/callback)
                      if (_selectedInquiryType == InquiryType.viewing ||
                          _selectedInquiryType == InquiryType.callback)
                        TextFormField(
                          controller: _preferredTimeController,
                          decoration: InputDecoration(
                                labelText: l10n?.inquiry_preferred_contact_time ??
                                    'Preferred Contact Time',
                                hintText: l10n?.inquiry_contact_time_placeholder ??
                                    'e.g., Weekdays 2-5 PM',
                            prefixIcon: const Icon(Icons.access_time),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: colorScheme.surfaceContainerHighest.withOpacity(0.5),
                          ),
                        ),

                      // Offered Price (for offer type)
                      if (_selectedInquiryType == InquiryType.offer) ...[
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _offeredPriceController,
                          decoration: InputDecoration(
                                labelText: l10n?.inquiry_offered_price ?? 'Offered Price',
                                hintText: l10n?.inquiry_enter_offer ?? 'Enter your offer',
                            prefixIcon: const Icon(Icons.attach_money),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: colorScheme.surfaceContainerHighest.withOpacity(0.5),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),

            // Submit Button
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(20),
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitInquiry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isSubmitting
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(colorScheme.onPrimary),
                          ),
                        )
                      : Text(
                              l10n?.inquiry_send_inquiry ?? 'Submit Inquiry',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getInquiryTypeLabel(InquiryType type, AppLocalizations? l10n) {
    switch (type) {
      case InquiryType.viewing:
        return l10n?.inquiry_schedule_viewing ?? 'Schedule Viewing';
      case InquiryType.info:
        return l10n?.inquiry_request_info ?? 'Request Information';
      case InquiryType.offer:
        return l10n?.inquiry_make_offer ?? 'Make Offer';
      case InquiryType.callback:
        return l10n?.inquiry_request_callback ?? 'Request Callback';
    }
  }

  String _getInquiryTypeDescription(InquiryType type, AppLocalizations? l10n) {
    switch (type) {
      case InquiryType.viewing:
        return 'Schedule a time to visit the property';
      case InquiryType.info:
        return 'Ask questions about the property';
      case InquiryType.offer:
        return 'Submit a price offer for the property';
      case InquiryType.callback:
        return 'Request a phone call from the owner/agent';
    }
  }
}

