import 'package:flutter/material.dart';
import 'package:app/providers/provider_models/report_model.dart';

/// Dialog for reporting content
class ReportDialog extends StatefulWidget {
  final ReportContentType contentType;
  final int contentId;
  final String? contentTitle;
  final Function(SubmitReportRequest request) onSubmit;

  const ReportDialog({
    super.key,
    required this.contentType,
    required this.contentId,
    this.contentTitle,
    required this.onSubmit,
  });

  @override
  State<ReportDialog> createState() => _ReportDialogState();
}

class _ReportDialogState extends State<ReportDialog> {
  ReportReason? _selectedReason;
  final _descriptionController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.flag_rounded, color: colorScheme.error),
          const SizedBox(width: 8),
          const Text('Report'),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.contentTitle != null) ...[
              Text(
                'Report: ${widget.contentTitle}',
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16),
            ],
            Text(
              'Why are you reporting this ${widget.contentType.displayName.toLowerCase()}?',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            // Reason selection
            ...ReportReason.values.map((reason) => _buildReasonTile(reason)),
            const SizedBox(height: 16),
            // Description field
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Additional details (optional)',
                hintText: 'Provide more context about this issue',
                border: const OutlineInputBorder(),
                alignLabelWithHint: true,
                helperText: _selectedReason == ReportReason.other
                    ? 'Please describe the issue'
                    : null,
              ),
              maxLines: 3,
              maxLength: 500,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton.icon(
          onPressed: _selectedReason == null || _isSubmitting
              ? null
              : _handleSubmit,
          icon: _isSubmitting
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.send, size: 18),
          label: Text(_isSubmitting ? 'Submitting...' : 'Submit Report'),
        ),
      ],
    );
  }

  Widget _buildReasonTile(ReportReason reason) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSelected = _selectedReason == reason;

    return InkWell(
      onTap: () => setState(() => _selectedReason = reason),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? colorScheme.primary : colorScheme.outline.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isSelected ? colorScheme.primaryContainer.withValues(alpha: 0.3) : null,
        ),
        child: Row(
          children: [
            Text(reason.icon, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reason.displayName,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: isSelected ? colorScheme.primary : colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    reason.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: colorScheme.primary, size: 20),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (_selectedReason == null) return;

    setState(() => _isSubmitting = true);

    final request = SubmitReportRequest(
      contentType: widget.contentType,
      contentId: widget.contentId,
      reason: _selectedReason!,
      description: _descriptionController.text.isNotEmpty
          ? _descriptionController.text
          : null,
    );

    try {
      await widget.onSubmit(request);
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Report submitted successfully'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit report: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}

/// Report button to be placed in app bars or menus
class ReportButton extends StatelessWidget {
  final ReportContentType contentType;
  final int contentId;
  final String? contentTitle;
  final Function(SubmitReportRequest request) onReport;
  final bool showLabel;

  const ReportButton({
    super.key,
    required this.contentType,
    required this.contentId,
    this.contentTitle,
    required this.onReport,
    this.showLabel = false,
  });

  @override
  Widget build(BuildContext context) {
    if (showLabel) {
      return TextButton.icon(
        onPressed: () => _showReportDialog(context),
        icon: const Icon(Icons.flag_outlined, size: 18),
        label: const Text('Report'),
        style: TextButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }

    return IconButton(
      onPressed: () => _showReportDialog(context),
      icon: const Icon(Icons.flag_outlined),
      tooltip: 'Report',
    );
  }

  void _showReportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ReportDialog(
        contentType: contentType,
        contentId: contentId,
        contentTitle: contentTitle,
        onSubmit: onReport,
      ),
    );
  }
}

/// Menu item for reporting (use in popup menus)
class ReportMenuItem extends StatelessWidget {
  final ReportContentType contentType;
  final int contentId;
  final String? contentTitle;
  final Function(SubmitReportRequest request) onReport;

  const ReportMenuItem({
    super.key,
    required this.contentType,
    required this.contentId,
    this.contentTitle,
    required this.onReport,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuItem(
      onTap: () {
        // Use Future.delayed to show dialog after popup closes
        Future.delayed(Duration.zero, () {
          if (context.mounted) {
            showDialog(
              context: context,
              builder: (ctx) => ReportDialog(
                contentType: contentType,
                contentId: contentId,
                contentTitle: contentTitle,
                onSubmit: onReport,
              ),
            );
          }
        });
      },
      child: Row(
        children: [
          Icon(
            Icons.flag_outlined,
            size: 20,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(width: 12),
          Text(
            'Report',
            style: TextStyle(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ],
      ),
    );
  }
}
