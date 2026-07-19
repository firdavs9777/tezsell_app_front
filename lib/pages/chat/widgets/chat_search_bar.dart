import 'dart:async';

import 'package:app/l10n/app_localizations.dart';
import 'package:app/providers/provider_root/chat_provider.dart';
import 'package:app/service/chat_api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 🔥 NEW: Task 18 — in-room search. Replaces [ChatAppBar] when active: a
/// text field debounced 400ms against `GET /chats/<id>/search/?q=`, a
/// server-reported total-match count, and up/down arrows that step through
/// only the matches whose message is currently loaded in this room's
/// message list (older, not-yet-paginated-in matches are counted in the
/// total but simply aren't navigable — no attempt to force-load them).
class ChatSearchBar extends ConsumerStatefulWidget
    implements PreferredSizeWidget {
  final int chatId;
  final VoidCallback onClose;

  /// Scrolls to + flash-highlights the message (reuses
  /// `ChatRoomScreen._scrollToMessage`, the same navigation quoted replies
  /// already use).
  final void Function(int messageId) onNavigateToMessage;

  const ChatSearchBar({
    super.key,
    required this.chatId,
    required this.onClose,
    required this.onNavigateToMessage,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  ConsumerState<ChatSearchBar> createState() => _ChatSearchBarState();
}

class _ChatSearchBarState extends ConsumerState<ChatSearchBar> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ChatApiService _apiService = ChatApiService();
  Timer? _debounce;

  bool _isLoading = false;
  bool _searched = false;
  int _totalCount = 0;
  List<int> _matchIds = const [];
  int _currentIndex = -1;

  /// 🔥 FIX: monotonically increasing token guarding against out-of-order
  /// responses — a slow earlier request landing after a faster later one
  /// (or after clear/close) must not clobber the current results. Bumped on
  /// every new query and on clear/close; the in-flight request's captured
  /// value is compared against this after the await, before applying.
  int _searchGeneration = 0;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  /// Matches from the server whose message is actually present in the
  /// currently-loaded message list — only these can be scrolled to.
  List<int> get _navigableIds {
    final loadedIds = ref
        .read(chatProvider)
        .messages
        .map((m) => m.id)
        .whereType<int>()
        .toSet();
    return _matchIds.where(loadedIds.contains).toList();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    final query = value.trim();

    if (query.length < 2) {
      _searchGeneration++;
      setState(() {
        _searched = false;
        _matchIds = const [];
        _totalCount = 0;
        _currentIndex = -1;
        _isLoading = false;
      });
      return;
    }

    setState(() => _isLoading = true);
    _debounce = Timer(const Duration(milliseconds: 400), () {
      _performSearch(query);
    });
  }

  Future<void> _performSearch(String query) async {
    final gen = ++_searchGeneration;
    try {
      final data = await _apiService.searchMessagesInChat(widget.chatId, query);
      if (!mounted || gen != _searchGeneration) return;

      final rawResults = data['results'] as List? ?? const [];
      final ids = rawResults
          .map((r) => (r as Map)['id'])
          .whereType<int>()
          .toList();
      final total = data['total_count'] as int? ?? ids.length;

      setState(() {
        _matchIds = ids;
        _totalCount = total;
        _searched = true;
        _isLoading = false;
        _currentIndex = _navigableIds.isNotEmpty ? 0 : -1;
      });

      final nav = _navigableIds;
      if (nav.isNotEmpty) {
        widget.onNavigateToMessage(nav.first);
      }
    } catch (e) {
      if (!mounted || gen != _searchGeneration) return;
      setState(() {
        _isLoading = false;
        _searched = true;
        _matchIds = const [];
        _totalCount = 0;
        _currentIndex = -1;
      });
    }
  }

  void _step(int delta) {
    final nav = _navigableIds;
    if (nav.isEmpty) return;
    var next = _currentIndex + delta;
    if (next < 0) next = nav.length - 1;
    if (next >= nav.length) next = 0;
    setState(() => _currentIndex = next);
    widget.onNavigateToMessage(nav[next]);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final nav = _navigableIds;
    final hasNoResults = _searched && !_isLoading && _totalCount == 0;

    return AppBar(
      titleSpacing: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: widget.onClose,
      ),
      title: TextField(
        controller: _controller,
        focusNode: _focusNode,
        autofocus: true,
        onChanged: _onChanged,
        decoration: InputDecoration(
          hintText: l.chatSearchInChat,
          border: InputBorder.none,
        ),
        textInputAction: TextInputAction.search,
      ),
      actions: [
        if (_isLoading)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          )
        else if (hasNoResults)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Center(
              child: Text(
                l.chatNoResults,
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
            ),
          )
        else if (_searched && _totalCount > 0) ...[
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                nav.isEmpty
                    ? '$_totalCount'
                    : '${_currentIndex + 1}/$_totalCount',
                style: theme.textTheme.bodySmall,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.keyboard_arrow_up),
            onPressed: nav.isEmpty ? null : () => _step(-1),
          ),
          IconButton(
            icon: const Icon(Icons.keyboard_arrow_down),
            onPressed: nav.isEmpty ? null : () => _step(1),
          ),
        ],
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            _debounce?.cancel();
            _searchGeneration++;
            _controller.clear();
            widget.onClose();
          },
        ),
      ],
    );
  }
}
