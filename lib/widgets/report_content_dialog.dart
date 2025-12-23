import 'package:flutter/material.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/service/content_report_service.dart';
import 'package:app/utils/app_logger.dart';
import 'package:app/utils/error_handler.dart';

/// Dialog for reporting objectionable content.
/// 
/// Supports reporting products, services, messages, users, and properties.
class ReportContentDialog extends StatefulWidget {
  final String contentType; // 'product', 'service', 'message', 'user', 'property'
  final dynamic contentId; // int for products/services/messages/users, String for properties
  final String? contentTitle; // Optional title for display

  const ReportContentDialog({
    super.key,
    required this.contentType,
    required this.contentId,
    this.contentTitle,
  });

  @override
  State<ReportContentDialog> createState() => _ReportContentDialogState();
}

class _ReportContentDialogState extends State<ReportContentDialog> {
  final _reportService = ContentReportService();
  final _descriptionController = TextEditingController();
  String? _selectedReason;
  bool _isSubmitting = false;

  final List<Map<String, String>> _reportReasons = [
    {'value': 'spam', 'label': 'Spam'},
    {'value': 'inappropriate', 'label': 'Inappropriate Content'},
    {'value': 'fraud', 'label': 'Fraud or Scam'},
    {'value': 'harassment', 'label': 'Harassment'},
    {'value': 'illegal', 'label': 'Illegal Activity'},
    {'value': 'other', 'label': 'Other'},
  ];

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitReport() async {
    final localizations = AppLocalizations.of(context);
    
    if (_selectedReason == null) {
      AppErrorHandler.showWarning(
        context,
        'Please select a reason for reporting',
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      ReportResult? result;
      
      switch (widget.contentType) {
        case 'product':
          result = await _reportService.reportProduct(
            productId: widget.contentId as int,
            reason: _selectedReason!,
            description: _descriptionController.text.trim(),
          );
          break;
        case 'service':
          result = await _reportService.reportService(
            serviceId: widget.contentId as int,
            reason: _selectedReason!,
            description: _descriptionController.text.trim(),
          );
          break;
        case 'message':
          result = await _reportService.reportMessage(
            messageId: widget.contentId as int,
            reason: _selectedReason!,
            description: _descriptionController.text.trim(),
          );
          break;
        case 'user':
          result = await _reportService.reportUser(
            userId: widget.contentId as int,
            reason: _selectedReason!,
            description: _descriptionController.text.trim(),
          );
          break;
        case 'property':
          result = await _reportService.reportProperty(
            propertyId: widget.contentId as String,
            reason: _selectedReason!,
            description: _descriptionController.text.trim(),
          );
          break;
      }

      if (!mounted || result == null) return;

      if (result.success) {
        // Close dialog and return success
        Navigator.of(context).pop(true);
        // Success message will be shown by the calling code
      } else {
        // Handle specific error cases
        String errorMessage;
        
        if (result.errorCode == 'already_reported') {
          errorMessage = localizations?.reportAlreadySubmitted ??
              'You have already reported this content. We are reviewing your previous report.';
        } else if (result.errorCode == 'network_error') {
          errorMessage = localizations?.reportFailedNetwork ??
              'Network error occurred. Please check your connection and try again.';
        } else {
          // Generic error or unknown error
          errorMessage = result.errorMessage ??
              localizations?.reportFailedGeneric ??
              'Failed to submit report. Please try again.';
        }
        
        // Get parent context before closing dialog
        final navigator = Navigator.of(context, rootNavigator: false);
        final parentContext = navigator.context;
        
        // Close dialog first
        navigator.pop(false);
        
        // Show error message on parent page after dialog closes
        await Future.delayed(const Duration(milliseconds: 200));
        
        if (parentContext.mounted) {
          AppErrorHandler.showError(parentContext, errorMessage);
        }
      }
    } catch (e) {
      AppLogger.error('Error submitting report: $e');
      if (mounted) {
        // Get parent context before closing dialog
        final navigator = Navigator.of(context, rootNavigator: false);
        final parentContext = navigator.context;
        
        // Close dialog first
        navigator.pop(false);
        
        // Show error message on parent page after dialog closes
        await Future.delayed(const Duration(milliseconds: 200));
        
        if (parentContext.mounted) {
          AppErrorHandler.showError(
            parentContext,
            'An error occurred. Please try again.',
          );
        }
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
    final localizations = AppLocalizations.of(context);

    return AlertDialog(
      title: Text(
        localizations?.reportContent ?? 'Report Content',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.error,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.contentTitle != null) ...[
              Text(
                'Reporting: ${widget.contentTitle}',
                style: TextStyle(
                  fontSize: 14,
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 16),
            ],
            Text(
              localizations?.selectReportReason ??
                  'Please select a reason for reporting:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 12),
            ..._reportReasons.map((reason) {
              return RadioListTile<String>(
                title: Text(reason['label']!),
                value: reason['value']!,
                groupValue: _selectedReason,
                onChanged: _isSubmitting
                    ? null
                    : (value) {
                        setState(() {
                          _selectedReason = value;
                        });
                      },
                dense: true,
              );
            }),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              enabled: !_isSubmitting,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: localizations?.additionalDetails ??
                    'Additional details (optional)',
                hintText: localizations?.reportDetailsHint ??
                    'Provide any additional information...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting
              ? null
              : () => Navigator.of(context).pop(false),
          child: Text(localizations?.cancel ?? 'Cancel'),
        ),
        ElevatedButton(
          onPressed: _isSubmitting || _selectedReason == null
              ? null
              : _submitReport,
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.error,
            foregroundColor: Colors.white,
          ),
          child: _isSubmitting
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(localizations?.submit ?? 'Submit'),
        ),
      ],
    );
  }
}

