import 'package:app/providers/provider_models/message_model.dart';
import 'package:app/providers/provider_root/chat_provider.dart';
import 'package:app/providers/provider_root/notification_provider.dart';
import 'package:app/pages/chat/widgets/chat_app_bar.dart';
import 'package:app/pages/chat/widgets/message_list.dart';
import 'package:app/pages/chat/widgets/chat_helpers.dart';
import 'package:app/pages/chat/widgets/typing_indicator.dart';
// Aliased: `message_model.dart` also exports a `ReplyPreview` class (the
// lightweight `{id, content, sender, message_type}` payload shape) — the
// name collides with this widget, so an unprefixed import is ambiguous.
import 'package:app/pages/chat/widgets/reply_preview.dart' as reply_bar;
import 'package:app/pages/chat/widgets/edit_preview.dart';
import 'package:app/pages/chat/widgets/blocked_user_banner.dart';
import 'package:app/pages/chat/widgets/empty_message_state.dart';
import 'package:app/pages/chat/widgets/media_options_sheet.dart';
import 'package:app/pages/chat/widgets/message_options_sheet.dart';
import 'package:app/pages/chat/widgets/forward_picker_sheet.dart';
import 'package:app/pages/chat/widgets/pinned_messages_bar.dart';
import 'package:app/pages/chat/widgets/listing_card.dart';
import 'package:app/pages/chat/widgets/quick_chips.dart';
import 'package:app/pages/chat/widgets/voice_recorder_bar.dart';
import 'package:app/pages/chat/widgets/chat_search_bar.dart';
import 'package:app/pages/chat/widgets/media_gallery_screen.dart';
import 'package:app/pages/chat/widgets/quick_replies_panel.dart';
import 'package:app/service/draft_store.dart';
import 'package:app/widgets/connection_banner.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:record/record.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:io';
import 'dart:async';

class ChatRoomScreen extends ConsumerStatefulWidget {
  final ChatRoom chatRoom;

  const ChatRoomScreen({super.key, required this.chatRoom});

  @override
  ConsumerState<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends ConsumerState<ChatRoomScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _imagePicker = ImagePicker();
  final AudioRecorder _audioRecorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();

  bool _isDisconnecting = false;
  bool _isRecording = false;
  bool _showMediaOptions = false;
  bool _showEmojiPicker = false;
  int? _currentlyPlayingMessageId;
  PlayerState _audioPlayerState = PlayerState.stopped;

  /// 🔥 NEW: Task 17 — current playback position of the single shared
  /// `_audioPlayer`, forwarded down to `MessageList`/`MessageBubble`/
  /// `VoiceBubble` so the currently-playing voice bubble can render a
  /// played-progress fill on its waveform.
  Duration _playbackPosition = Duration.zero;

  // Enhanced features state
  int? _replyingToMessageId;
  ChatMessage? _replyingToMessage;
  int? _editingMessageId;
  // 🔥 NEW: Task 15 — the full message being edited (not just its id), so
  // the edit banner can show a snippet of the original content.
  ChatMessage? _editingMessage;
  final TextEditingController _editController = TextEditingController();

  // Typing indicator debounce timer
  Timer? _typingTimer;
  bool _hasSentTypingStatus = false;
  DateTime? _recordingStartTime;

  // Scroll to bottom button state
  bool _showScrollToBottom = false;

  /// 🔥 NEW: Task 20 — distance-from-bottom threshold (px) past which the
  /// scroll-to-bottom FAB appears.
  static const double _scrollUpFabThreshold = 300;

  /// 🔥 NEW: Task 20 — count of messages that have arrived while the user
  /// is scrolled up (shown as a badge on the FAB); reset on tap-to-bottom or
  /// once the list naturally scrolls back near the bottom.
  int _unseenNewMessagesCount = 0;

  /// 🔥 NEW: Task 20 — id of the first unread message at the moment this
  /// room's messages finished their initial load. Computed once (guarded by
  /// [_unreadDividerComputed]) so the divider row doesn't shift as messages
  /// get marked read while the user is sitting in the room.
  int? _unreadDividerMessageId;
  bool _unreadDividerComputed = false;

  // 🔥 NEW: Task 14 — id of the message briefly flashed after tapping a
  // quoted-reply block scrolls the list to it.
  int? _highlightedMessageId;
  Timer? _highlightTimer;

  // 🔥 NEW: Task 18 — true while the inline in-room search bar replaces the
  // normal app bar.
  bool _isSearching = false;

  // Flag to track if widget is disposed
  bool _isDisposed = false;

  // Captured in initState so dispose() can call it without touching ref
  // (Riverpod marks ref invalid before state.dispose() is called in 2.x).
  late final ChatNotifier _chatNotifier;

  StreamSubscription<PlayerState>? _audioPlayerStateSubscription;
  StreamSubscription<Duration>? _audioPositionSubscription;

  // 🔥 NEW: Timer for periodic read status refresh (fallback)
  Timer? _readStatusRefreshTimer;

  // 🔥 NEW: Task 19 — debounced per-room draft save (SharedPreferences via
  // DraftStore), restored into the composer on open and cleared on send.
  Timer? _draftSaveTimer;

  final GlobalKey<VoiceMicButtonState> _voiceMicKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _chatNotifier = ref.read(chatProvider.notifier);
    _audioPlayerStateSubscription = _audioPlayer.onPlayerStateChanged.listen((
      state,
    ) {
      if (mounted && !_isDisposed) {
        if (!_isDisposed) {
          setState(() {
            _audioPlayerState = state;
            if (state == PlayerState.stopped ||
                state == PlayerState.completed) {
              _currentlyPlayingMessageId = null;
            }
          });
        }
      }
    });

    // 🔥 NEW: Task 17 — track playback position for the voice bubble's
    // played-progress waveform fill.
    _audioPositionSubscription = _audioPlayer.onPositionChanged.listen((
      position,
    ) {
      if (mounted && !_isDisposed) {
        setState(() => _playbackPosition = position);
      }
    });

    _scrollController.addListener(_onScroll);

    Future.microtask(() {
      if (mounted) {
        print('🔵 [ChatRoom] initState → connectToChatRoom(${widget.chatRoom.id})');
        // 🔥 FIX: Task 19 (review round 1) — rooms just created from a
        // listing detail page (product/service/real-estate) via
        // `ChatApiService.startFromListing()` never went through the
        // provider, so they're missing from `chatRooms`/`archivedChatRooms`.
        // Insert the full object we already have before anything on this
        // screen (mute/archive/pin) needs it.
        _chatNotifier.ensureRoomInList(widget.chatRoom);
        _chatNotifier.connectToChatRoom(widget.chatRoom.id);
        _markChatNotificationsAsRead(widget.chatRoom.id);
      }
    });

    // 🔥 NEW: Task 19 — restore any saved draft into the composer.
    _restoreDraft();

    // 🔥 NEW: Start periodic read status refresh (fallback for WebSocket)
    _startReadStatusRefresh();
  }

  /// 🔥 NEW: Task 19 — loads the draft cache (no-op if already loaded) and,
  /// if this room has a saved draft, puts it in the composer.
  Future<void> _restoreDraft() async {
    await DraftStore.instance.ensureLoaded();
    if (!mounted) return;
    final draft = DraftStore.instance.get(widget.chatRoom.id);
    if (draft != null && draft.isNotEmpty) {
      _messageController.text = draft;
    }
  }

  /// 🔥 NEW: Periodic refresh of read status (every 10 seconds as fallback)
  void _startReadStatusRefresh() {
    _readStatusRefreshTimer?.cancel();
    _readStatusRefreshTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (mounted && !_isDisposed) {
        // Only refresh if there are own messages that might need read status update
        final chatState = ref.read(chatProvider);
        final hasUnreadOwnMessages = chatState.messages.any((m) =>
          m.sender.id == chatState.currentUserId && !m.isRead
        );
        if (hasUnreadOwnMessages) {
          ref.read(chatProvider.notifier).refreshMessageReadStatus();
        }
      } else {
        timer.cancel();
      }
    });
  }

  /// Mark all chat notifications for a specific room as read
  void _markChatNotificationsAsRead(int roomId) {
    try {
      final chatNotificationNotifier = ref.read(chatNotificationProvider.notifier);
      final state = ref.read(chatNotificationProvider);
      
      // Find all unread chat notifications for this room
      final roomNotifications = state.notifications.where((n) =>
        n.type == 'chat' &&
        !n.isRead &&
        n.objectId == roomId
      ).toList();
      
      if (roomNotifications.isNotEmpty) {
        print('📬 Marking ${roomNotifications.length} chat notifications as read for room $roomId');
        // Mark each notification as read
        for (final notification in roomNotifications) {
          chatNotificationNotifier.markAsRead(notification.id);
        }
      }
    } catch (e) {
      print('⚠️ Error marking chat notifications as read: $e');
    }
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    // Show/hide scroll to bottom button — appears once scrolled up more
    // than ~300px from the bottom (Task 20 polish; was 200px).
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    final isScrolledUp = (maxScroll - currentScroll) > _scrollUpFabThreshold;

    if (mounted && !_isDisposed) {
      final nowShown = isScrolledUp && maxScroll > 0;
      if (_showScrollToBottom && !nowShown) {
        // Back near the bottom — the unseen badge no longer applies.
        setState(() {
          _showScrollToBottom = false;
          _unseenNewMessagesCount = 0;
        });
      } else if (_showScrollToBottom != nowShown) {
        setState(() => _showScrollToBottom = nowShown);
      }
    }

    final chatState = ref.read(chatProvider);

    if (_scrollController.position.pixels <= 100 &&
        chatState.hasMoreMessages &&
        !chatState.isLoadingOlderMessages) {
      _loadOlderMessages();
    }
  }

  Future<void> _loadOlderMessages() async {
    final chatState = ref.read(chatProvider);
    if (!chatState.hasMoreMessages || chatState.isLoadingOlderMessages) {
      return;
    }

    if (!_scrollController.hasClients) return;

    final currentScrollPosition = _scrollController.position.pixels;
    final messagesBefore = chatState.messages.length;

    await ref.read(chatProvider.notifier).loadOlderMessages();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients && mounted) {
        final messagesAfter = ref.read(chatProvider).messages.length;
        final messagesAdded = messagesAfter - messagesBefore;

        if (messagesAdded > 0) {
          const estimatedMessageHeight = 80.0;
          final heightAdded = messagesAdded * estimatedMessageHeight;
          final newPosition = currentScrollPosition + heightAdded;
          _scrollController.jumpTo(
            newPosition.clamp(0.0, _scrollController.position.maxScrollExtent),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _isDisposed = true;
    _isDisconnecting = true;

    // Cancel all timers and subscriptions
    _typingTimer?.cancel();
    _readStatusRefreshTimer?.cancel();
    _highlightTimer?.cancel();
    _draftSaveTimer?.cancel();
    _audioPlayerStateSubscription?.cancel();
    _audioPositionSubscription?.cancel();
    _scrollController.removeListener(_onScroll);

    // Dispose controllers
    _messageController.dispose();
    _editController.dispose();
    _scrollController.dispose();
    _audioRecorder.dispose();
    _audioPlayer.dispose();

    // Riverpod forbids state changes during lifecycle methods (dispose included).
    // Defer via Future(() {}) so it runs after the current frame when the tree
    // is stable. _chatNotifier was captured in initState so ref is not needed.
    final notifier = _chatNotifier;
    final hadTyping = _hasSentTypingStatus;
    Future(() {
      try {
        if (hadTyping) notifier.sendTypingStatus(false);
        print('🔵 [ChatRoom] dispose deferred → disconnectFromChatRoom()');
        notifier.disconnectFromChatRoom();
      } catch (e) {
        print('🔴 [ChatRoom] dispose deferred error: $e');
      }
    });

    super.dispose();
  }

  Future<void> _toggleAudioPlayback(ChatMessage message) async {
    if (message.fileUrl == null) {
      final l = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l.audio_file_not_available)));
      return;
    }

    try {
      final isSameMessage = _currentlyPlayingMessageId == message.id;

      if (isSameMessage && _audioPlayerState == PlayerState.playing) {
        // 🔥 FIX: keep _currentlyPlayingMessageId set while paused so the
        // bubble keeps receiving its playbackPosition (and freezes the
        // waveform fill) instead of snapping to 0. The onPlayerStateChanged
        // listener only clears the id on stopped/completed, not paused.
        await _audioPlayer.pause();
        return;
      }

      if (isSameMessage && _audioPlayerState == PlayerState.paused) {
        // Resume from the exact paused position — play() with the same
        // source would restart from 0, resume() continues from where the
        // player was paused.
        await _audioPlayer.resume();
        return;
      }

      if (_currentlyPlayingMessageId != null &&
          _currentlyPlayingMessageId != message.id) {
        await _audioPlayer.stop();
      }

      if (!_isDisposed) {
        setState(() {
          _currentlyPlayingMessageId = message.id;
          // 🔥 NEW: Task 17 — reset the shared progress tracker so the new
          // (or resumed-from-scratch) bubble doesn't briefly show the
          // previous message's played-fill for a frame.
          _playbackPosition = Duration.zero;
        });
      }
      await _audioPlayer.play(UrlSource(message.fileUrl!));
    } catch (e) {
      if (mounted) {
        final l = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.failed_to_play_audio(e.toString()))),
        );
      }
      if (!_isDisposed) {
        setState(() => _currentlyPlayingMessageId = null);
      }
    }
  }

  void _sendMessage() {
    print('📤 _sendMessage() called in chat_room.dart');
    final content = _messageController.text.trim();
    print('📤 Content: "$content", mounted: $mounted');
    if (content.isNotEmpty && mounted) {
      if (_replyingToMessageId != null) {
        print('📤 Sending reply to message $_replyingToMessageId');
        ref
            .read(chatProvider.notifier)
            .sendMessageWithReply(content, _replyingToMessageId);
        if (!_isDisposed) {
          setState(() {
            _replyingToMessageId = null;
            _replyingToMessage = null;
          });
        }
      } else {
        print('📤 Calling chatProvider.sendMessage');
        ref.read(chatProvider.notifier).sendMessage(content);
      }
      // 🔥 NEW: Task 19 — clear the persisted draft once handed off to send.
      _draftSaveTimer?.cancel();
      DraftStore.instance.clear(widget.chatRoom.id);
      _messageController.clear();
      _scrollToBottom();
    } else {
      print('❌ Message not sent: content empty or not mounted');
    }
  }

  /// 🔥 NEW: Quick chips only make sense on listing-anchored rooms, for the
  /// buyer (not the seller), and only before the conversation has really
  /// gotten going (fewer than 2 messages sent by the current user so far).
  bool _shouldShowQuickChips(int? currentUserId, List<ChatMessage> messages) {
    final listing = widget.chatRoom.listing;
    if (listing == null || currentUserId == null) return false;
    if (listing.sellerId != null && currentUserId == listing.sellerId) {
      return false;
    }
    final ownMessageCount =
        messages.where((m) => m.sender.id == currentUserId).length;
    return ownMessageCount < 2;
  }

  /// 🔥 NEW: Sends a quick-reply chip's text via the normal send path (same
  /// as typing it and hitting send) — reuses `_sendMessage` so reply/edit
  /// state, scrolling, etc. all behave identically.
  void _sendQuickReply(String text) {
    _messageController.text = text;
    _sendMessage();
  }

  void _showMessageOptions(ChatMessage message, int currentUserId) {
    final isOwnMessage = message.sender.id == currentUserId;

    showModalBottomSheet(
      context: context,
      builder: (context) => MessageOptionsSheet(
        message: message,
        isOwnMessage: isOwnMessage,
        onReply: () {
          if (mounted) {
            if (!_isDisposed) {
              setState(() {
                _replyingToMessageId = message.id;
                _replyingToMessage = message;
              });
            }
            // Scroll to bottom to show reply preview
            Future.delayed(const Duration(milliseconds: 200), () {
              if (mounted) {
                _scrollToBottom();
              }
            });
          }
        },
        onEdit: () => _startEditingMessage(message),
        onDelete: () => _deleteMessage(message, isOwnMessage),
        onReact: (emoji) {
          if (message.id != null) {
            ref.read(chatProvider.notifier).toggleReaction(message.id!, emoji);
          }
        },
        // 🔥 FIX: never offer copy for deleted-for-everyone content — the
        // in-memory `content` still holds the original text (rendering
        // keys off `isDeleted`), so gating on `content != null` alone would
        // let a deleted message's text still be copied.
        onCopy: message.content != null && !message.isDeleted
            ? () => _copyMessage(message.content!)
            : null,
        // 🔥 NEW: Task 16 — Pin/Unpin + Forward. Both need a server id and
        // never apply to deleted-for-everyone messages (the sheet hides the
        // rows whenever the callback is null).
        onPin: message.id != null && !message.isDeleted
            ? () {
                ref
                    .read(chatProvider.notifier)
                    .togglePinMessage(message.id!);
              }
            : null,
        onForward: message.id != null && !message.isDeleted
            ? () => _showForwardPicker(message)
            : null,
        // 🔥 NEW: Task 18 — Translate/Show original. Never offered for own
        // messages (gated in the sheet itself) or messages without a server
        // id / text content.
        onTranslate: message.id != null &&
                !message.isDeleted &&
                message.messageType == MessageType.text
            ? () => _translateMessage(message)
            : null,
      ),
    );
  }

  /// 🔥 NEW: Task 18 — fetches (or reverts) a translation for [message] via
  /// the actions sheet's Translate / Show original row. Target language is
  /// the app's current locale; the 503 "not configured" / 502 provider /
  /// 400 cases from the backend all surface the same generic
  /// `chatTranslationFailed` snackbar per the task contract.
  Future<void> _translateMessage(ChatMessage message) async {
    if (message.id == null) return;
    final id = message.id!;

    // 🔥 FIX: Task 18 review — a cached translation is never destroyed; the
    // sheet's "Show original" row (relabeled by message_options_sheet.dart
    // once `message.translation != null`) just flips whether this message id
    // is currently showing its original text, with no network round-trip.
    if (message.translation != null) {
      ref.read(showingOriginalTranslationsProvider.notifier).update((ids) {
        final next = {...ids};
        if (!next.remove(id)) next.add(id);
        return next;
      });
      return;
    }

    final target = Localizations.localeOf(context).languageCode;
    final success = await ref
        .read(chatProvider.notifier)
        .translateMessage(message.id!, target);

    if (!success && mounted) {
      final l = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l.chatTranslationFailed),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  /// 🔥 NEW: Task 16 — opens the forward destination picker for [message].
  /// The picker itself performs the forward API call, closes, and shows the
  /// `chatForwarded` snackbar confirmation (no navigation to the target room).
  void _showForwardPicker(ChatMessage message) {
    if (message.id == null) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ForwardPickerSheet(
        messageId: message.id!,
        currentRoomId: widget.chatRoom.id,
      ),
    );
  }

  /// 🔥 NEW: Task 14 — Copy wiring for the message actions sheet.
  void _copyMessage(String content) {
    Clipboard.setData(ClipboardData(text: content));
    if (mounted) {
      final l = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.chatCopied), duration: const Duration(seconds: 2)),
      );
    }
  }

  void _startEditingMessage(ChatMessage message) {
    if (!_isDisposed) {
      setState(() {
        _editingMessageId = message.id;
        _editingMessage = message;
        _editController.text = message.content ?? '';
      });
    }
  }

  Future<void> _saveEditedMessage() async {
    if (_editingMessageId == null || _editController.text.trim().isEmpty) {
      return;
    }

    final notifier = ref.read(chatProvider.notifier);
    final success = await notifier.editMessage(
      _editingMessageId!,
      _editController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      if (!_isDisposed) {
        setState(() {
          _editingMessageId = null;
          _editingMessage = null;
          _editController.clear();
        });
      }
    } else {
      // 🔥 NEW: Task 15 — surface the 15-minute-window 403 (or any other
      // edit failure) via a snackbar with the backend's detail message,
      // falling back to a generic message. Clear the transient provider
      // error afterward so it doesn't also linger as the persistent
      // top-of-screen error banner.
      final l = AppLocalizations.of(context)!;
      final rawError = ref.read(chatProvider).error;
      final detail = (rawError != null && rawError.isNotEmpty)
          ? rawError.replaceFirst(RegExp(r'^Exception:\s*'), '')
          : l.unknown_error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(detail),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      notifier.clearError();
    }
  }

  /// 🔥 NEW: Task 15 — offers "Delete for me" (always) and, for the
  /// sender's own messages, "Delete for everyone". `for_me` only removes
  /// the message from this client/account; `for_everyone` blanks it for
  /// all participants (backend + `message_deleted` WS relay).
  void _deleteMessage(ChatMessage message, bool isOwnMessage) {
    final l = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l.chatDelete),
        content: Text(l.delete_message_confirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l.cancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              if (message.id != null) {
                await ref
                    .read(chatProvider.notifier)
                    .deleteMessage(message.id!, mode: 'for_me');
              }
            },
            child: Text(l.chatDeleteForMe),
          ),
          if (isOwnMessage)
            TextButton(
              onPressed: () async {
                Navigator.pop(dialogContext);
                if (message.id != null) {
                  await ref
                      .read(chatProvider.notifier)
                      .deleteMessage(message.id!, mode: 'for_everyone');
                }
              },
              child: Text(
                l.chatDeleteForEveryone,
                style: TextStyle(color: Theme.of(dialogContext).colorScheme.error),
              ),
            ),
        ],
      ),
    );
  }

  /// 🔥 NEW: Task 20 — the latest (max) timestamp in [messages], or null if
  /// empty. Used to tell a genuinely new tail message apart from an older
  /// page of history merged in at the front of the list.
  DateTime? _latestTimestamp(List<ChatMessage> messages) {
    if (messages.isEmpty) return null;
    return messages
        .map((m) => m.timestamp)
        .reduce((a, b) => a.isAfter(b) ? a : b);
  }

  /// 🔥 NEW: Task 20 — snapshots the first message (from the other
  /// participant) this user hasn't read yet, exactly once per room open, so
  /// the [UnreadDivider] row stays put even after those messages get marked
  /// read while the user is sitting in the room (read receipts round-trip
  /// asynchronously over the WS, well after this runs).
  void _computeUnreadDividerOnce() {
    if (_unreadDividerComputed) return;
    _unreadDividerComputed = true;

    final chatState = ref.read(chatProvider);
    final currentUserId = chatState.currentUserId;
    if (currentUserId == null) return;

    final sorted = ref.read(sortedMessagesProvider);
    ChatMessage? firstUnread;
    for (final m in sorted) {
      if (m.id != null &&
          m.sender.id != currentUserId &&
          !m.isRead &&
          !m.readBy.contains(currentUserId)) {
        firstUnread = m;
        break;
      }
    }

    if (firstUnread != null && mounted && !_isDisposed) {
      setState(() => _unreadDividerMessageId = firstUnread!.id);
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
        // Hide button after scrolling and clear the unseen-messages badge.
        if (mounted && !_isDisposed) {
          setState(() {
            _showScrollToBottom = false;
            _unseenNewMessagesCount = 0;
          });
        }
      }
    });
  }

  // Scroll to a specific message by ID
  void _scrollToMessage(int messageId) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) {
        return;
      }

      final chatState = ref.read(chatProvider);
      final messages = chatState.messages;

      // Find the message index
      final sortedMessages = List<ChatMessage>.from(messages)
        ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

      final messageIndex = sortedMessages.indexWhere((m) => m.id == messageId);

      if (messageIndex == -1) {
        // Message might be in older messages, try to load them
        if (chatState.hasMoreMessages && !chatState.isLoadingOlderMessages) {
          _loadOlderMessages().then((_) {
            // Retry scrolling after loading
            Future.delayed(const Duration(milliseconds: 500), () {
              _scrollToMessage(messageId);
            });
          });
        }
        return;
      }

      // Estimate message height (adjust based on your actual message height)
      const estimatedMessageHeight = 100.0; // Increased for better accuracy
      const dateSeparatorHeight = 50.0;
      const padding = 16.0; // ListView padding

      // Calculate approximate scroll position
      // We need to account for date separators and padding
      double targetPosition = padding;

      for (int i = 0; i < messageIndex; i++) {
        // Check if we need to add date separator
        if (i == 0 ||
            !ChatHelpers.isSameDay(
              sortedMessages[i].timestamp,
              sortedMessages[i - 1].timestamp,
            )) {
          targetPosition += dateSeparatorHeight;
        }
        targetPosition += estimatedMessageHeight;
      }

      // Add some padding to show the message clearly (scroll a bit above the message)
      targetPosition = (targetPosition - 150).clamp(
        0.0,
        _scrollController.position.maxScrollExtent,
      );

      // 🔥 NEW: Task 14 — animate to the target instead of an instant jump,
      // then flash-highlight the message so it's easy to spot once in view.
      _scrollController
          .animateTo(
            targetPosition,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          )
          .then((_) => _flashHighlightMessage(messageId));
    });
  }

  /// 🔥 NEW: Task 14 — briefly highlights [messageId]'s bubble (see
  /// [MessageBubble.isHighlighted]), then clears it after a short delay.
  void _flashHighlightMessage(int messageId) {
    if (!mounted || _isDisposed) return;
    _highlightTimer?.cancel();
    setState(() => _highlightedMessageId = messageId);
    _highlightTimer = Timer(const Duration(milliseconds: 1200), () {
      if (mounted && !_isDisposed) {
        setState(() => _highlightedMessageId = null);
      }
    });
  }

  Widget _buildScrollToBottomButton() {
    return Positioned(
      bottom: 80,
      right: 16,
      child: AnimatedScale(
        scale: _showScrollToBottom ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutBack,
        child: AnimatedOpacity(
          opacity: _showScrollToBottom ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 150),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Material(
                elevation: 4,
                shadowColor: Theme.of(context).shadowColor.withOpacity(0.3),
                shape: const CircleBorder(),
                child: InkWell(
                  onTap: _scrollToBottom,
                  customBorder: const CircleBorder(),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.primary,
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Theme.of(context).colorScheme.onPrimary,
                      size: 28,
                    ),
                  ),
                ),
              ),
              // 🔥 NEW: Task 20 — badge showing how many new messages
              // arrived while the user was scrolled up.
              if (_unseenNewMessagesCount > 0)
                Positioned(
                  top: -4,
                  right: -4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                    constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.error,
                      borderRadius: BorderRadius.circular(9),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.surface,
                        width: 1.5,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        _unseenNewMessagesCount > 99
                            ? '99+'
                            : '$_unseenNewMessagesCount',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onError,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          height: 1.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Debounced typing indicator - prevents excessive WebSocket messages
  void _onTypingChanged(String text) {
    if (!mounted || _isDisposed) return;

    // 🔥 NEW: Task 19 — debounced (500ms) draft save, independent of the
    // typing-indicator debounce below.
    _draftSaveTimer?.cancel();
    _draftSaveTimer = Timer(const Duration(milliseconds: 500), () {
      DraftStore.instance.set(widget.chatRoom.id, text);
    });

    final isCurrentlyTyping = text.trim().isNotEmpty;

    // Cancel any pending stop-typing timer
    _typingTimer?.cancel();

    if (isCurrentlyTyping) {
      // Only send "typing" status if we haven't already
      if (!_hasSentTypingStatus) {
        _hasSentTypingStatus = true;
        ref.read(chatProvider.notifier).sendTypingStatus(true);
      }

      // Auto-stop typing after 3 seconds of inactivity
      _typingTimer = Timer(const Duration(seconds: 3), () {
        if (mounted && !_isDisposed && _hasSentTypingStatus) {
          _hasSentTypingStatus = false;
          ref.read(chatProvider.notifier).sendTypingStatus(false);
        }
      });
    } else {
      // User cleared the input - stop typing immediately
      if (_hasSentTypingStatus) {
        _hasSentTypingStatus = false;
        ref.read(chatProvider.notifier).sendTypingStatus(false);
      }
    }
  }

  Future<void> _pickAndSendImage(ImageSource source) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (image != null && mounted) {
        final imageFile = File(image.path);
        final fileSize = await imageFile.length();
        const maxSize = 10 * 1024 * 1024;

        if (fileSize > maxSize) {
          if (mounted) {
            final l = AppLocalizations.of(context)!;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l.image_too_large),
                backgroundColor: Theme.of(context).colorScheme.error,
                duration: const Duration(seconds: 3),
              ),
            );
          }
          return;
        }

        if (!await imageFile.exists()) {
          if (mounted) {
            final l = AppLocalizations.of(context)!;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l.image_file_not_found),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
          return;
        }

        final l = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 16),
                Text(l.uploading_image),
              ],
            ),
            duration: const Duration(seconds: 30),
          ),
        );

        final success = await ref
            .read(chatProvider.notifier)
            .sendImageMessage(imageFile, widget.chatRoom.id);

        if (mounted) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();

          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l.image_sent),
                duration: const Duration(seconds: 2),
              ),
            );
            _scrollToBottom();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l.failed_to_send_image),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        final l = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l.failed_to_send_image)));
      }
    }
  }

  // 🔥 NEW: Telegram-style voice recording handlers
  void _handleVoiceRecordingStarted() {
    if (!_isDisposed) {
      setState(() {
        _isRecording = true;
        _showMediaOptions = false;
        _showEmojiPicker = false;
      });
    }
  }

  void _handleVoiceRecordingCancelled() {
    if (!_isDisposed) {
      setState(() {
        _isRecording = false;
      });
    }
  }

  Future<void> _handleVoiceRecordingComplete(
    File audioFile,
    int duration,
    List<int> waveform,
  ) async {
    if (!_isDisposed) {
      setState(() {
        _isRecording = false;
      });
    }

    if (!mounted) return;

    final l = AppLocalizations.of(context);

    // Show uploading indicator
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 16),
            Text(l?.uploading_voice_message ?? 'Sending voice message...'),
          ],
        ),
        duration: const Duration(seconds: 30),
      ),
    );

    final success = await ref
        .read(chatProvider.notifier)
        .sendVoiceMessage(
          audioFile,
          widget.chatRoom.id,
          duration,
          waveform: waveform,
        );

    if (mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l?.voice_message_sent ?? 'Voice message sent'),
            duration: const Duration(seconds: 2),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
        _scrollToBottom();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l?.failed_to_send_voice_message ?? 'Failed to send voice message'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  // Legacy toggle recording (kept for media sheet)
  Future<void> _toggleRecording() async {
    if (_isRecording) {
      // This will be handled by the new voice recorder
      return;
    }
    // Start recording via media sheet tap
    _handleVoiceRecordingStarted();
  }

  /// 🔥 FIX: Task 18 review — stops this room's shared voice player and
  /// clears the "currently playing" id, without the error-snackbar/retry
  /// plumbing `_toggleAudioPlayback` needs for a user-initiated tap. Used
  /// whenever another audio surface (the media gallery's own player) is
  /// about to become active, so the two never play over each other.
  Future<void> _stopAudioPlayback() async {
    if (_currentlyPlayingMessageId == null) return;
    try {
      await _audioPlayer.stop();
    } catch (_) {
      // Best-effort — falls through to clearing local state regardless.
    }
    if (!_isDisposed) {
      setState(() => _currentlyPlayingMessageId = null);
    }
  }

  /// 🔥 NEW: Task 18 — opens the shared media gallery (Images/Voice tabs)
  /// for this room, built from whatever messages are already loaded.
  void _openMediaGallery() async {
    // 🔥 FIX: Task 18 review — the gallery has its own AudioPlayer for voice
    // messages; without pausing the room's player first, both could play
    // simultaneously.
    await _stopAudioPlayback();
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const MediaGalleryScreen()),
    );
  }

  void _showChatInfo() {
    final l = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l?.chat_info ?? 'Chat Info'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l?.chat_room_label(widget.chatRoom.name) ?? 'Chat: ${widget.chatRoom.name}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l?.id_label(widget.chatRoom.id) ?? 'ID: ${widget.chatRoom.id}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l?.participants_label ?? 'Participants',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ...widget.chatRoom.participants.map(
                (participant) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                        child: Text(
                          participant.username.isNotEmpty
                              ? participant.username[0].toUpperCase()
                              : '?',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              participant.displayName.isNotEmpty
                                  ? participant.displayName
                                  : 'Unknown',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              participant.username.isNotEmpty
                                  ? '@${participant.username}'
                                  : '',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l?.cancel ?? 'Cancel'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation() {
    final l = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l?.delete_chat ?? 'Delete Chat'),
        content: Text(l?.delete_chat_confirm(widget.chatRoom.name) ?? 'Are you sure you want to delete this chat?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l?.cancel ?? 'Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              if (mounted) {
                final success = await ref
                    .read(chatProvider.notifier)
                    .deleteChatRoom(widget.chatRoom.id);
                if (success && mounted) {
                  Navigator.pop(context);
                }
              }
            },
            child: Text(l?.delete ?? 'Delete', style: TextStyle(color: Theme.of(dialogContext).colorScheme.error)),
          ),
        ],
      ),
    );
  }

  void _handleBlockUser() {
    final chatState = ref.read(chatProvider);
    final otherUser = widget.chatRoom.participants.firstWhere(
      (p) => p.id != chatState.currentUserId,
      orElse: () => widget.chatRoom.participants.first,
    );
    if (chatState.blockedUserIds.contains(otherUser.id)) {
      ref.read(chatProvider.notifier).unblockUser(otherUser.id);
    } else {
      ref.read(chatProvider.notifier).blockUser(otherUser.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatProvider);
    final messages = chatState.messages;
    final isLoadingMessages = chatState.isLoadingMessages;
    final currentUserId = chatState.currentUserId;
    final error = chatState.error;

    ref.listen(chatProvider, (previous, next) {
      if (!mounted || _isDisposed)
        return; // Guard against updates after disposal

      final justFinishedLoading = previous?.isLoadingMessages == true &&
          next.isLoadingMessages == false;

      if (justFinishedLoading) {
        _scrollToBottom();
        // 🔥 NEW: Task 20 — snapshot the first-unread message id exactly
        // once, right as the room's messages first land.
        _computeUnreadDividerOnce();
      } else if (previous != null &&
          next.messages.length > previous.messages.length) {
        // 🔥 FIX: Task 20 — `loadOlderMessages()` (pagination while
        // scrolled up to read history) also grows `messages.length`; only
        // treat this as a "new message arrived" event if the newest
        // message actually got newer (appended at the tail), not when
        // older history was merely prepended.
        final prevLatest = _latestTimestamp(previous.messages);
        final nextLatest = _latestTimestamp(next.messages);
        final isNewAtTail =
            prevLatest == null || (nextLatest != null && nextLatest.isAfter(prevLatest));

        if (isNewAtTail) {
          if (_showScrollToBottom) {
            // User is scrolled up reading history — don't yank them down;
            // surface the arrival via the FAB's unseen-count badge instead.
            final delta = next.messages.length - previous.messages.length;
            if (!_isDisposed) {
              setState(() => _unseenNewMessagesCount += delta);
            }
          } else {
            _scrollToBottom();
          }
        }
      }
    });

    // Check if user is blocked
    final isBlocked =
        error != null &&
        (error.toString().contains('blocked') ||
            error.toString().contains('PermissionDenied') ||
            error.toString().contains('Access denied'));

    final otherUser =
        !widget.chatRoom.isGroup && widget.chatRoom.participants.isNotEmpty
        ? widget.chatRoom.participants.firstWhere(
            (p) => p.id != currentUserId,
            orElse: () => widget.chatRoom.participants.first,
          )
        : null;

    // 🔥 NEW: Task 13 — apply any local listing-status override (from the
    // transaction API response / `transaction_updated` WS event) on top of
    // the listing summary `widget.chatRoom` was constructed with, so the
    // pinned card's status chip re-renders without a full room refetch.
    final baseListing = widget.chatRoom.listing;
    final listingStatusOverride =
        chatState.listingStatusOverrides[widget.chatRoom.id];
    final effectiveListing = baseListing != null && listingStatusOverride != null
        ? baseListing.copyWith(status: listingStatusOverride)
        : baseListing;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop && !_isDisconnecting) {
          _isDisconnecting = true;
          print('🔵 [ChatRoom] onPopInvoked → disconnectFromChatRoom()');
          _chatNotifier.disconnectFromChatRoom();
        }
      },
      child: GestureDetector(
        onHorizontalDragEnd: (details) {
          // Right swipe to navigate back (positive velocity means right swipe)
          if (details.primaryVelocity != null &&
              details.primaryVelocity! > 500) {
            Navigator.pop(context);
          }
        },
        child: Scaffold(
          appBar: _isSearching
              ? ChatSearchBar(
                  chatId: widget.chatRoom.id,
                  onClose: () {
                    if (!_isDisposed) setState(() => _isSearching = false);
                  },
                  onNavigateToMessage: _scrollToMessage,
                )
              : ChatAppBar(
                  chatRoom: widget.chatRoom,
                  onInfoTap: _showChatInfo,
                  onBlockTap: _handleBlockUser,
                  onDeleteTap: _showDeleteConfirmation,
                  onSearchTap: () {
                    if (!_isDisposed) setState(() => _isSearching = true);
                  },
                  onMediaGalleryTap: _openMediaGallery,
                ),
          backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
          body: _buildChatBody(
            chatState: chatState,
            messages: messages,
            isLoadingMessages: isLoadingMessages,
            currentUserId: currentUserId,
            error: error,
            isBlocked: isBlocked,
            otherUser: otherUser,
            effectiveListing: effectiveListing,
          ),
        ),
      ),
    );
  }

  Widget _buildChatBody({
    required dynamic chatState,
    required List<ChatMessage> messages,
    required bool isLoadingMessages,
    required int? currentUserId,
    required String? error,
    required bool isBlocked,
    required dynamic otherUser,
    required ChatListing? effectiveListing,
  }) {
    return Column(
      children: [
        // 🔥 NEW: Reconnect banner (shown after 3s continuous non-connected)
        const ConnectionBanner(),

        // 🔥 NEW: Pinned listing summary card (only when the room is
        // anchored to a product/service/property listing)
        if (effectiveListing != null) ListingCard(listing: effectiveListing),

        // 🔥 NEW: Task 16 — pinned messages bar (renders nothing when no
        // message in the loaded list is pinned). Tap cycles through pinned
        // messages, scrolling to + flash-highlighting each; long-press
        // offers to unpin the currently shown one.
        PinnedMessagesBar(onTapMessage: _scrollToMessage),

        // Blocked user banner
        if (isBlocked && otherUser != null)
          BlockedUserBanner(
            username: otherUser.username,
            isBlockedByUser: true,
          ),

        // Error banner (non-blocking errors)
        if (error != null && !isBlocked)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            color: Theme.of(context).colorScheme.errorContainer,
            child: Row(
              children: [
                Icon(Icons.error_outline, color: Theme.of(context).colorScheme.error, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Builder(
                    builder: (context) {
                      final l = AppLocalizations.of(context)!;
                      return Text(
                        l.error_label(error.toString()),
                        style: TextStyle(color: Theme.of(context).colorScheme.error),
                      );
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Theme.of(context).colorScheme.error, size: 20),
                  onPressed: () {
                    ref.read(chatProvider.notifier).refresh();
                  },
                ),
              ],
            ),
          ),

        // Message list - use Expanded to take remaining space
        Expanded(
          child: isLoadingMessages
              ? const Center(child: CircularProgressIndicator())
              : messages.isEmpty
              ? EmptyMessageState(error: error, chatRoomId: widget.chatRoom.id)
              : Stack(
                  children: [
                    Column(
                      children: [
                        Expanded(
                          child: MessageList(
                            scrollController: _scrollController,
                            currentlyPlayingMessageId:
                                _currentlyPlayingMessageId,
                            audioPlayerState: _audioPlayerState,
                            playbackPosition: _playbackPosition,
                            onAudioTap: _toggleAudioPlayback,
                            onMessageLongPress: _showMessageOptions,
                            onReplyTap: _scrollToMessage,
                            listingSellerId: effectiveListing?.sellerId,
                            highlightedMessageId: _highlightedMessageId,
                            unreadDividerMessageId: _unreadDividerMessageId,
                            onMessageSwipeReply: (message) {
                              if (mounted && !_isDisposed) {
                                setState(() {
                                  _replyingToMessageId = message.id;
                                  _replyingToMessage = message;
                                });
                                // Scroll to bottom to show reply preview
                                Future.delayed(
                                  const Duration(milliseconds: 200),
                                  () {
                                    if (mounted) {
                                      _scrollToBottom();
                                    }
                                  },
                                );
                              }
                            },
                          ),
                        ),
                        // Typing indicators
                        TypingIndicator(
                          typingUsers: chatState.typingUsers,
                          participants: widget.chatRoom.participants,
                          currentUserId: currentUserId!,
                        ),
                      ],
                    ),
                    // Scroll to bottom button
                    _buildScrollToBottomButton(),
                  ],
                ),
        ),

        // 🔥 NEW: Quick-reply chips — listing rooms only, hidden for the
        // seller themselves and once the buyer has already sent 2+ messages
        if (!isBlocked && _shouldShowQuickChips(currentUserId, messages))
          Container(
            color: Theme.of(context).colorScheme.surface,
            child: QuickChips(onChipTap: _sendQuickReply),
          ),

        // Message input
        _buildMessageInput(),

        // Emoji Picker
        if (_showEmojiPicker)
          SizedBox(
            height: 250,
            child: EmojiPicker(
              onEmojiSelected: (category, emoji) {
                _messageController.text += emoji.emoji;
                if (!_isDisposed) {
                  setState(() {});
                }
              },
              config: Config(checkPlatformCompatibility: true),
            ),
          ),
      ],
    );
  }

  Widget _buildMessageInput() {
    final chatState = ref.watch(chatProvider);
    final error = chatState.error;

    final isBlocked =
        error != null &&
        (error.toString().contains('blocked') ||
            error.toString().contains('PermissionDenied') ||
            error.toString().contains('Access denied'));

    if (isBlocked) {
      return Container(
        padding: const EdgeInsets.all(16),
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: Row(
          children: [
            Icon(Icons.block, color: Theme.of(context).colorScheme.onSurfaceVariant),
            const SizedBox(width: 12),
            Expanded(
              child: Builder(
                builder: (context) {
                  final l = AppLocalizations.of(context)!;
                  return Text(
                    l.cannot_send_messages_blocked,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontStyle: FontStyle.italic,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Reply preview
            if (_replyingToMessage != null)
              reply_bar.ReplyPreview(
                replyToMessage: _replyingToMessage!,
                onCancel: () {
                  if (!_isDisposed) {
                    setState(() {
                      _replyingToMessageId = null;
                      _replyingToMessage = null;
                    });
                  }
                },
              ),

            // Edit preview
            if (_editingMessageId != null)
              EditPreview(
                snippet: _editingMessage?.content,
                onCancel: () {
                  if (!_isDisposed) {
                    setState(() {
                      _editingMessageId = null;
                      _editingMessage = null;
                      _editController.clear();
                    });
                  }
                },
              ),

            // Media options
            if (_showMediaOptions)
              MediaOptionsSheet(
                onGalleryTap: () => _pickAndSendImage(ImageSource.gallery),
                onCameraTap: () => _pickAndSendImage(ImageSource.camera),
                onVoiceTap: _toggleRecording,
                onEmojiTap: () {
                  if (!_isDisposed) {
                    setState(() {
                      _showEmojiPicker = !_showEmojiPicker;
                      _showMediaOptions = false;
                    });
                  }
                },
                // 🔥 NEW: Task 19 — quick-replies panel; inserts the tapped
                // template's text into the composer without sending.
                onQuickRepliesTap: () {
                  if (!_isDisposed) {
                    setState(() => _showMediaOptions = false);
                  }
                  showQuickRepliesPanel(
                    context,
                    onSelect: (text) {
                      _messageController.text = text;
                      _messageController.selection = TextSelection.collapsed(
                        offset: text.length,
                      );
                    },
                  );
                },
              ),

            // Input row — full-width recording bar when recording, normal row otherwise
            if (_isRecording)
              SizedBox(
                height: 56,
                child: VoiceMicButton(
                  key: _voiceMicKey,
                  onRecordingComplete: _handleVoiceRecordingComplete,
                  onRecordingStarted: _handleVoiceRecordingStarted,
                  onRecordingCancelled: _handleVoiceRecordingCancelled,
                ),
              )
            else
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      _showMediaOptions ? Icons.close : Icons.add_circle,
                      color: _showMediaOptions ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    onPressed: () {
                      setState(() => _showMediaOptions = !_showMediaOptions);
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      _showEmojiPicker ? Icons.keyboard : Icons.emoji_emotions,
                      color: _showEmojiPicker ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    onPressed: () {
                      if (!_isDisposed) {
                        setState(() {
                          _showEmojiPicker = !_showEmojiPicker;
                          _showMediaOptions = false;
                        });
                      }
                    },
                  ),
                  Expanded(
                    child: _editingMessageId != null
                        ? TextField(
                            controller: _editController,
                            decoration: InputDecoration(
                              hintText: AppLocalizations.of(context)?.edit_message_hint ?? 'Edit message...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            ),
                            maxLines: 6,
                            minLines: 1,
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.send,
                            onSubmitted: (_) {
                              if (_editController.text.trim().isNotEmpty) {
                                _saveEditedMessage();
                              }
                            },
                          )
                        : TextField(
                            controller: _messageController,
                            onChanged: _onTypingChanged,
                            decoration: InputDecoration(
                              hintText: AppLocalizations.of(context)?.type_a_message ?? 'Type a message...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            ),
                            maxLines: 6,
                            minLines: 1,
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.send,
                            onSubmitted: (_) {
                              if (_messageController.text.trim().isNotEmpty) {
                                _typingTimer?.cancel();
                                if (_hasSentTypingStatus) {
                                  _hasSentTypingStatus = false;
                                  ref.read(chatProvider.notifier).sendTypingStatus(false);
                                }
                                _sendMessage();
                              }
                            },
                          ),
                  ),
                  const SizedBox(width: 8),
                  if (_editingMessageId != null)
                    ValueListenableBuilder<TextEditingValue>(
                      valueListenable: _editController,
                      builder: (context, value, child) {
                        final hasText = value.text.trim().isNotEmpty;
                        return _AnimatedSendButton(
                          isEnabled: hasText,
                          color: Theme.of(context).colorScheme.primary,
                          icon: Icons.check,
                          onPressed: hasText ? _saveEditedMessage : null,
                        );
                      },
                    )
                  else
                    ValueListenableBuilder<TextEditingValue>(
                      valueListenable: _messageController,
                      builder: (context, value, child) {
                        final hasText = value.text.trim().isNotEmpty;
                        // 🔥 NEW: Task 17 — cross-fade between the mic and
                        // send buttons instead of an instant swap. The mic
                        // button keeps `_voiceMicKey` so its recorder/timer
                        // state survives being reparented into the
                        // full-width recording bar above once a hold starts
                        // (see the `_isRecording` branch) — mutually
                        // exclusive with this branch, so the key is never
                        // duplicated in the tree at the same time.
                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          switchInCurve: Curves.easeOut,
                          switchOutCurve: Curves.easeIn,
                          transitionBuilder: (child, animation) =>
                              FadeTransition(
                                opacity: animation,
                                child: ScaleTransition(
                                  scale: animation,
                                  child: child,
                                ),
                              ),
                          child: hasText
                              ? _AnimatedSendButton(
                                  key: const ValueKey('send-button'),
                                  isEnabled: true,
                                  color: Theme.of(context).colorScheme.primary,
                                  icon: Icons.send,
                                  onPressed: _sendMessage,
                                )
                              : VoiceMicButton(
                                  key: _voiceMicKey,
                                  onRecordingComplete:
                                      _handleVoiceRecordingComplete,
                                  onRecordingStarted:
                                      _handleVoiceRecordingStarted,
                                  onRecordingCancelled:
                                      _handleVoiceRecordingCancelled,
                                ),
                        );
                      },
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

/// Animated send button with scale and color transition
class _AnimatedSendButton extends StatelessWidget {
  final bool isEnabled;
  final Color color;
  final IconData icon;
  final VoidCallback? onPressed;

  const _AnimatedSendButton({
    super.key,
    required this.isEnabled,
    required this.color,
    required this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: isEnabled ? 1.0 : 0.9,
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOutCubic,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isEnabled ? color : color.withOpacity(0.4),
          boxShadow: isEnabled
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            customBorder: const CircleBorder(),
            child: Center(
              child: Icon(
                icon,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

