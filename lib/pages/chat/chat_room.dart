import 'package:app/providers/provider_models/message_model.dart';
import 'package:app/providers/provider_root/chat_provider.dart';
import 'package:app/providers/provider_root/notification_provider.dart';
import 'package:app/pages/chat/widgets/chat_app_bar.dart';
import 'package:app/pages/chat/widgets/message_list.dart';
import 'package:app/pages/chat/widgets/chat_helpers.dart';
import 'package:app/pages/chat/widgets/typing_indicator.dart';
import 'package:app/pages/chat/widgets/reply_preview.dart';
import 'package:app/pages/chat/widgets/edit_preview.dart';
import 'package:app/pages/chat/widgets/blocked_user_banner.dart';
import 'package:app/pages/chat/widgets/empty_message_state.dart';
import 'package:app/pages/chat/widgets/media_options_sheet.dart';
import 'package:app/pages/chat/widgets/message_options_sheet.dart';
import 'package:app/pages/chat/widgets/reaction_picker.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
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
  final TextEditingController _editController = TextEditingController();

  // Typing indicator debounce timer
  Timer? _typingTimer;
  bool _hasSentTypingStatus = false;
  DateTime? _recordingStartTime;

  // Scroll to bottom button state
  bool _showScrollToBottom = false;

  // Flag to track if widget is disposed
  bool _isDisposed = false;

  StreamSubscription<PlayerState>? _audioPlayerStateSubscription;

  @override
  void initState() {
    super.initState();
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
        ref.read(chatProvider.notifier).connectToChatRoom(widget.chatRoom.id);
        // Mark all chat notifications for this room as read when entering
        _markChatNotificationsAsRead(widget.chatRoom.id);
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
    // Mark as disposed FIRST to prevent any further updates
    _isDisposed = true;

    // Cancel all timers and subscriptions
    _typingTimer?.cancel();
    _audioPlayerStateSubscription?.cancel();
    _scrollController.removeListener(_onScroll);

    // Dispose controllers
    _messageController.dispose();
    _editController.dispose();
    _scrollController.dispose();
    _audioRecorder.dispose();
    _audioPlayer.dispose();

    // Mark as disconnecting
    _isDisconnecting = true;

    // Call provider methods last, but don't wait for them
    // These might trigger updates, but the widget is already disposed
    if (_hasSentTypingStatus) {
      // Use Future.microtask to avoid blocking dispose
      Future.microtask(() {
        try {
          if (!_isDisposed) {
            // Extra check
            ref.read(chatProvider.notifier).sendTypingStatus(false);
          }
        } catch (e) {
          // Ignore errors - widget is already disposed
        }
      });
    }

    // Disconnect from chat room
    Future.microtask(() {
      try {
        if (!_isDisposed) {
          // Extra check
          ref.read(chatProvider.notifier).disconnectFromChatRoom();
        }
      } catch (e) {
        // Ignore errors - widget is already disposed
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
        onDelete: () => _deleteMessage(message),
        onAddReaction: () => _showReactionPicker(message),
      ),
    );
  }

  void _showReactionPicker(ChatMessage message) {
    showModalBottomSheet(
      context: context,
      builder: (context) => ReactionPicker(
        message: message,
        onReactionSelected: (emoji) {
          ref.read(chatProvider.notifier).toggleReaction(message.id!, emoji);
        },
      ),
    );
  }

  void _startEditingMessage(ChatMessage message) {
    if (!_isDisposed) {
      setState(() {
        _editingMessageId = message.id;
        _editController.text = message.content ?? '';
      });
    }
  }

  Future<void> _saveEditedMessage() async {
    if (_editingMessageId == null || _editController.text.trim().isEmpty) {
      return;
    }

    final success = await ref
        .read(chatProvider.notifier)
        .editMessage(_editingMessageId!, _editController.text.trim());

    if (success && mounted) {
      if (!_isDisposed) {
        setState(() {
          _editingMessageId = null;
          _editController.clear();
        });
      }
    }
  }

  void _deleteMessage(ChatMessage message) {
    final l = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l?.delete_message ?? 'Delete Message'),
        content: Text(l?.delete_message_confirm ?? 'Are you sure you want to delete this message?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l?.cancel ?? 'Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              if (message.id != null) {
                await ref.read(chatProvider.notifier).deleteMessage(message.id!);
              }
            },
            child: Text(l?.delete ?? 'Delete', style: TextStyle(color: Theme.of(dialogContext).colorScheme.error)),
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

      // Instant scroll (no animation)
      _scrollController.jumpTo(targetPosition);
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
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF42A5F5), Color(0xFF1E88E5)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Colors.white,
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
                backgroundColor: Colors.red,
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
                backgroundColor: Colors.red,
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
                backgroundColor: Colors.red,
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

  Future<void> _toggleRecording() async {
    if (_isRecording) {
      final path = await _audioRecorder.stop();
      final duration = _recordingStartTime != null
          ? DateTime.now().difference(_recordingStartTime!).inSeconds
          : 0;

      if (!_isDisposed) {
        setState(() {
          _isRecording = false;
          _recordingStartTime = null;
        });
      }

      if (path != null && mounted) {
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
                Text(l.uploading_voice_message),
              ],
            ),
            duration: const Duration(seconds: 30),
          ),
        );

        final success = await ref
            .read(chatProvider.notifier)
            .sendVoiceMessage(File(path), widget.chatRoom.id, duration);

        if (mounted) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();

          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l.voice_message_sent),
                duration: const Duration(seconds: 2),
              ),
            );
            _scrollToBottom();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l.failed_to_send_voice_message),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      }
    } else {
      if (await _audioRecorder.hasPermission()) {
        final path =
            '${Directory.systemTemp.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';
        await _audioRecorder.start(const RecordConfig(), path: path);
        if (!_isDisposed) {
          setState(() {
            _isRecording = true;
            _recordingStartTime = DateTime.now();
          });
        }

        if (mounted) {
          final l = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l.recording),
              duration: const Duration(seconds: 1),
            ),
          );
        }
      } else {
        if (mounted) {
          final l = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l.microphone_permission_denied)),
          );
        }
      }
    }
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
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l?.id_label(widget.chatRoom.id) ?? 'ID: ${widget.chatRoom.id}',
                    style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l?.participants_label ?? 'Participants',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
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
                        backgroundColor: Colors.blue,
                        child: Text(
                          participant.username.isNotEmpty
                              ? participant.username[0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
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
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              participant.username.isNotEmpty
                                  ? '@${participant.username}'
                                  : '',
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
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

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop && !_isDisconnecting) {
          _isDisconnecting = true;
          ref.read(chatProvider.notifier).disconnectFromChatRoom();
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
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? Theme.of(context).colorScheme.surface
              : const Color(0xFFE5F3FF), // Telegram light blue background
          body: _buildChatBody(
            chatState: chatState,
            messages: messages,
            isLoadingMessages: isLoadingMessages,
            currentUserId: currentUserId,
            error: error,
            isBlocked: isBlocked,
            otherUser: otherUser,
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
  }) {
    return Column(
      children: [
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
              ReplyPreview(
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
                onCancel: () {
                  if (!_isDisposed) {
                    setState(() {
                      _editingMessageId = null;
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

            // Input row
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
                            hintText:
                                AppLocalizations.of(
                                  context,
                                )?.edit_message_hint ??
                                'Edit message...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.orange[50],
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                          ),
                          maxLines: 6, // Limit to 6 lines max - automatically scrollable when exceeded
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
                            hintText:
                                AppLocalizations.of(context)?.type_a_message ??
                                'Type a message...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
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
                                ref
                                    .read(chatProvider.notifier)
                                    .sendTypingStatus(false);
                              }
                              _sendMessage();
                            }
                          },
                        ),
                ),
                const SizedBox(width: 8),
                // Send button with ValueListenableBuilder for efficient updates
                if (_isRecording)
                  Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.mic, color: Colors.white),
                  )
                else if (_editingMessageId != null)
                  ValueListenableBuilder<TextEditingValue>(
                    valueListenable: _editController,
                    builder: (context, value, child) {
                      final hasText = value.text.trim().isNotEmpty;
                      return _AnimatedSendButton(
                        isEnabled: hasText,
                        color: Colors.orange,
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
                      return _AnimatedSendButton(
                        isEnabled: hasText,
                        color: Colors.blue,
                        icon: Icons.send,
                        onPressed: hasText ? _sendMessage : null,
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
          color: isEnabled ? color : Colors.grey[400],
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
