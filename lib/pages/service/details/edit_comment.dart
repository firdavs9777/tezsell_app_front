import 'package:flutter/material.dart';
import 'package:app/l10n/app_localizations.dart';

class EditCommentWidget extends StatefulWidget {
  final String commentText;
  final Function(String) onTextChanged;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const EditCommentWidget({
    Key? key,
    required this.commentText,
    required this.onTextChanged,
    required this.onSave,
    required this.onCancel,
  }) : super(key: key);

  @override
  _EditCommentWidgetState createState() => _EditCommentWidgetState();
}

class _EditCommentWidgetState extends State<EditCommentWidget> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.commentText);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(Icons.edit, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  l10n.editComment,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: colorScheme.onSurface,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: widget.onCancel,
                  child: Text(l10n.cancel),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _controller,
              onChanged: widget.onTextChanged,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: l10n.editYourComment,
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: widget.onSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(l10n.saveChanges),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
