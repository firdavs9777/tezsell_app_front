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

  // 🔥 NEW: Task 14 — id of the message briefly flashed after tapping a
  // quoted-reply block scrolls the list to it.
  int? _highlightedMessageId;
  Timer? _highlightTimer;

  // Flag to track if widget is disposed
  bool _isDisposed = false;

  // Captured in initState so dispose() can call it without touching ref
  // (Riverpod marks ref invalid before state.dispose() is called in 2.x).
  late final ChatNotifier _chatNotifier;

  StreamSubscription<PlayerState>? _audioPlayerStateSubscription;

  // 🔥 NEW: Timer for periodic read status refresh (fallback)
  Timer? _readStatusRefreshTimer;

  final GlobalKey<_VoiceMicButtonState> _voiceMicKey = GlobalKey();

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

    _scrollController.addListener(_onScroll);

    Future.microtask(() {
      if (mounted) {
        print('🔵 [ChatRoom] initState → connectToChatRoom(${widget.chatRoom.id})');
        _chatNotifier.connectToChatRoom(widget.chatRoom.id);
        _markChatNotificationsAsRead(widget.chatRoom.id);
      }
    });

    // 🔥 NEW: Start periodic read status refresh (fallback for WebSocket)
    _startReadStatusRefresh();
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

    // Show/hide scroll to bottom button
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    final isNearBottom = (maxScroll - currentScroll) < 200; // 200px threshold

    if (mounted && !_isDisposed) {
      setState(() {
        _showScrollToBottom = !isNearBottom && maxScroll > 0;
      });
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
    _audioPlayerStateSubscription?.cancel();
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
      if (_currentlyPlayingMessageId == message.id &&
          _audioPlayerState == PlayerState.playing) {
        await _audioPlayer.pause();
        if (!_isDisposed) {
          setState(() => _currentlyPlayingMessageId = null);
        }
        return;
      }

      if (_currentlyPlayingMessageId != null &&
          _currentlyPlayingMessageId != message.id) {
        await _audioPlayer.stop();
      }

      if (!_isDisposed) {
        setState(() => _currentlyPlayingMessageId = message.id);
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
        // rows whenever the callback is null). onTranslate stays omitted —
        // Task 18 wires Translate.
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
      ),
    );
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

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
        // Hide button after scrolling
        if (mounted && !_isDisposed) {
          setState(() {
            _showScrollToBottom = false;
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
          child: Material(
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
        ),
      ),
    );
  }

  // Debounced typing indicator - prevents excessive WebSocket messages
  void _onTypingChanged(String text) {
    if (!mounted || _isDisposed) return;

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

  Future<void> _handleVoiceRecordingComplete(File audioFile, int duration) async {
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
        .sendVoiceMessage(audioFile, widget.chatRoom.id, duration);

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

      if (previous?.messages.length != next.messages.length) {
        _scrollToBottom();
      }

      if (previous?.isLoadingMessages == true &&
          next.isLoadingMessages == false) {
        _scrollToBottom();
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
          appBar: ChatAppBar(
            chatRoom: widget.chatRoom,
            onInfoTap: _showChatInfo,
            onBlockTap: _handleBlockUser,
            onDeleteTap: _showDeleteConfirmation,
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
                            onAudioTap: _toggleAudioPlayback,
                            onMessageLongPress: _showMessageOptions,
                            onReplyTap: _scrollToMessage,
                            listingSellerId: effectiveListing?.sellerId,
                            highlightedMessageId: _highlightedMessageId,
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
              ),

            // Input row — full-width recording bar when recording, normal row otherwise
            if (_isRecording)
              SizedBox(
                height: 56,
                child: _VoiceMicButton(
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
                        if (hasText) {
                          return _AnimatedSendButton(
                            isEnabled: true,
                            color: Theme.of(context).colorScheme.primary,
                            icon: Icons.send,
                            onPressed: _sendMessage,
                          );
                        } else {
                          return _VoiceMicButton(
                            key: _voiceMicKey,
                            onRecordingComplete: _handleVoiceRecordingComplete,
                            onRecordingStarted: _handleVoiceRecordingStarted,
                            onRecordingCancelled: _handleVoiceRecordingCancelled,
                          );
                        }
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

/// Telegram-style voice mic button with hold-to-record
class _VoiceMicButton extends StatefulWidget {
  final Function(File audioFile, int duration) onRecordingComplete;
  final VoidCallback? onRecordingStarted;
  final VoidCallback? onRecordingCancelled;

  const _VoiceMicButton({
    super.key,
    required this.onRecordingComplete,
    this.onRecordingStarted,
    this.onRecordingCancelled,
  });

  @override
  State<_VoiceMicButton> createState() => _VoiceMicButtonState();
}

class _VoiceMicButtonState extends State<_VoiceMicButton>
    with TickerProviderStateMixin {
  final AudioRecorder _audioRecorder = AudioRecorder();

  bool _isRecording = false;
  bool _isLocked = false;
  DateTime? _recordingStartTime;
  String? _recordingPath;
  Timer? _durationTimer;
  int _recordingDuration = 0;

  // Gesture tracking
  double _dragOffsetX = 0;
  double _dragOffsetY = 0;
  static const double _cancelThreshold = -80;
  static const double _lockThreshold = -60;

  // Animation
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _durationTimer?.cancel();
    _pulseController.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  Future<void> _startRecording() async {
    if (_isRecording) return;

    final hasPerm = await _audioRecorder.hasPermission();
    print('🎙️ [Voice] hasPermission: $hasPerm');
    if (!hasPerm) {
      HapticFeedback.heavyImpact();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Microphone permission denied')),
        );
      }
      return;
    }

    HapticFeedback.mediumImpact();

    _recordingPath = '${Directory.systemTemp.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';
    print('🎙️ [Voice] starting recording → $_recordingPath');
    try {
      await _audioRecorder.start(const RecordConfig(), path: _recordingPath!);
      print('🎙️ [Voice] recording started OK');
    } catch (e) {
      print('🔴 [Voice] start error: $e');
      rethrow;
    }

    setState(() {
      _isRecording = true;
      _isLocked = false;
      _recordingStartTime = DateTime.now();
      _recordingDuration = 0;
      _dragOffsetX = 0;
      _dragOffsetY = 0;
    });

    widget.onRecordingStarted?.call();
    _pulseController.repeat(reverse: true);

    _durationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted && _isRecording) {
        setState(() => _recordingDuration++);
      }
    });
  }

  Future<void> _stopRecording({bool send = true}) async {
    if (!_isRecording) return;

    _durationTimer?.cancel();
    _pulseController.stop();
    _pulseController.reset();

    final path = await _audioRecorder.stop();
    final duration = _recordingDuration;
    print('🎙️ [Voice] stopped — path: $path, duration: ${duration}s, send: $send');

    final wasCancelled = !send || duration < 1;
    if (wasCancelled) print('🎙️ [Voice] cancelled (send=$send, duration=$duration)');

    setState(() {
      _isRecording = false;
      _isLocked = false;
      _recordingStartTime = null;
      _dragOffsetX = 0;
      _dragOffsetY = 0;
    });

    if (!wasCancelled && path != null) {
      final fileSize = await File(path).length().catchError((_) => 0);
      print('🎙️ [Voice] sending file — size: ${fileSize}B');
      HapticFeedback.lightImpact();
      widget.onRecordingComplete(File(path), duration);
    } else {
      if (path != null) {
        try { await File(path).delete(); } catch (_) {}
      }
      widget.onRecordingCancelled?.call();
    }
  }

  void _cancelRecording() {
    HapticFeedback.heavyImpact();
    _stopRecording(send: false);
  }

  void _lockRecording() {
    HapticFeedback.mediumImpact();
    setState(() {
      _isLocked = true;
      _dragOffsetY = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isRecording) {
      return _buildMicButton();
    } else if (_isLocked) {
      return _buildLockedUI();
    } else {
      return _buildRecordingUI();
    }
  }

  Widget _buildMicButton() {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () async {
        await _startRecording();
        if (mounted && _isRecording) _lockRecording();
      },
      onLongPressStart: (_) => _startRecording(),
      onLongPressEnd: (_) {
        if (!_isLocked && _isRecording) {
          _stopRecording(send: true);
        }
      },
      onLongPressMoveUpdate: (details) {
        if (!_isRecording) return;

        setState(() {
          _dragOffsetX = details.offsetFromOrigin.dx;
          _dragOffsetY = details.offsetFromOrigin.dy;
        });

        if (_dragOffsetX < _cancelThreshold) {
          _cancelRecording();
        } else if (_dragOffsetY < _lockThreshold && !_isLocked) {
          _lockRecording();
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colorScheme.surfaceContainerHighest,
        ),
        child: Icon(
          Icons.mic,
          color: colorScheme.onSurfaceVariant,
          size: 22,
        ),
      ),
    );
  }

  Widget _buildRecordingUI() {
    return SizedBox(
      height: 48,
      child: Row(
        children: [
          const SizedBox(width: 4),
          // Pulsing red dot
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red,
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
          // Timer
          Text(
            _formatDuration(_recordingDuration),
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
          const Spacer(),
          // Slide to cancel — moves left with drag
          Transform.translate(
            offset: Offset(_dragOffsetX.clamp(-50.0, 0.0) * 0.5, 0),
            child: Opacity(
              opacity: _dragOffsetX < -20
                  ? (1.0 - ((-_dragOffsetX - 20) / 60)).clamp(0.2, 1.0)
                  : 1.0,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.chevron_left, color: Theme.of(context).colorScheme.onSurfaceVariant, size: 18),
                  Text(
                    'Slide to cancel',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Lock indicator (appears when dragging up)
          if (_dragOffsetY < -20)
            Icon(
              Icons.lock_outline,
              color: _dragOffsetY < _lockThreshold
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey,
              size: 18,
            ),
          const SizedBox(width: 4),
          // Animated mic button (moves with finger)
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(
                  _dragOffsetX.clamp(-40, 0),
                  _dragOffsetY.clamp(-40, 0),
                ),
                child: Transform.scale(
                  scale: _pulseAnimation.value,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.primary,
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Icon(Icons.mic, color: Theme.of(context).colorScheme.onPrimary, size: 22),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLockedUI() {
    return SizedBox(
      height: 48,
      child: Row(
        children: [
          // Cancel button
          IconButton(
            onPressed: _cancelRecording,
            icon: const Icon(Icons.delete_outline, color: Colors.red, size: 22),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
          ),
          // Recording indicator
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red,
            ),
          ),
          const SizedBox(width: 6),
          // Timer
          Text(
            _formatDuration(_recordingDuration),
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const Spacer(),
          // Waveform animation
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(12, (i) {
              final h = ((_recordingDuration + i) % 4 + 1) * 3.5;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 2.5,
                height: h,
                margin: const EdgeInsets.symmetric(horizontal: 1),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(1),
                ),
              );
            }),
          ),
          const SizedBox(width: 12),
          // Send button
          GestureDetector(
            onTap: () => _stopRecording(send: true),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Icon(Icons.send, color: Theme.of(context).colorScheme.onPrimary, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
