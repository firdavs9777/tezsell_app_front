// lib/pages/chat/widgets/quick_replies_panel.dart
//
// 🔥 NEW: Task 19 — bottom-sheet panel for a room's quick-reply templates
// (`GET/POST/DELETE /chats/quick-replies/`). Tapping a template inserts its
// text into the composer (does not auto-send); an inline field adds a new
// template (respecting the backend's 20-template cap, surfaced via
// snackbar), and each row can be deleted.
import 'package:app/l10n/app_localizations.dart';
import 'package:app/providers/provider_root/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Opens the quick replies panel as a modal bottom sheet. [onSelect] is
/// called with the tapped template's text when the user picks one (the
/// sheet closes itself right after).
Future<void> showQuickRepliesPanel(
  BuildContext context, {
  required ValueChanged<String> onSelect,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => QuickRepliesPanel(onSelect: onSelect),
  );
}

class QuickRepliesPanel extends ConsumerStatefulWidget {
  final ValueChanged<String> onSelect;

  const QuickRepliesPanel({super.key, required this.onSelect});

  @override
  ConsumerState<QuickRepliesPanel> createState() => _QuickRepliesPanelState();
}

class _QuickRepliesPanelState extends ConsumerState<QuickRepliesPanel> {
  final TextEditingController _addController = TextEditingController();
  bool _isAdding = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) ref.read(chatProvider.notifier).loadQuickReplies();
    });
  }

  @override
  void dispose() {
    _addController.dispose();
    super.dispose();
  }

  Future<void> _submitAdd() async {
    final text = _addController.text.trim();
    if (text.isEmpty || _isAdding) return;

    setState(() => _isAdding = true);
    final error = await ref.read(chatProvider.notifier).addQuickReply(text);
    if (!mounted) return;
    setState(() => _isAdding = false);

    if (error == null) {
      _addController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final chatState = ref.watch(chatProvider);
    final quickReplies = chatState.quickReplies;
    final isLoading = chatState.isLoadingQuickReplies;

    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.85,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        l.chatQuickReplies,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: isLoading && quickReplies.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : quickReplies.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 32),
                              child: Text(
                                l.chatAddQuickReply,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: colorScheme.onSurfaceVariant),
                              ),
                            ),
                          )
                        : ListView.separated(
                            controller: scrollController,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            itemCount: quickReplies.length,
                            separatorBuilder: (_, __) => Divider(
                              height: 1,
                              color: colorScheme.outlineVariant.withOpacity(0.4),
                            ),
                            itemBuilder: (context, index) {
                              final reply = quickReplies[index];
                              return ListTile(
                                title: Text(reply.text),
                                onTap: () {
                                  widget.onSelect(reply.text);
                                  Navigator.pop(context);
                                },
                                trailing: IconButton(
                                  icon: Icon(
                                    Icons.delete_outline,
                                    color: colorScheme.error,
                                    size: 20,
                                  ),
                                  onPressed: () => ref
                                      .read(chatProvider.notifier)
                                      .deleteQuickReply(reply.id),
                                ),
                              );
                            },
                          ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _addController,
                          decoration: InputDecoration(
                            hintText: l.chatAddQuickReply,
                            isDense: true,
                            filled: true,
                            fillColor: colorScheme.surfaceContainerHighest,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) => _submitAdd(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: _isAdding
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Icon(Icons.add_circle,
                                color: colorScheme.primary, size: 32),
                        onPressed: _isAdding ? null : _submitAdd,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
