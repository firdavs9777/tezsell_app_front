import 'package:app/providers/provider_models/message_model.dart';
import 'package:app/providers/provider_root/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:record/record.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:io';
import 'dart:async';

class ChatRoomScreen extends ConsumerStatefulWidget {
  final ChatRoom chatRoom;

  const ChatRoomScreen({
    super.key,
    required this.chatRoom,
  });

  @override
  ConsumerState<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends ConsumerState<ChatRoomScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _imagePicker = ImagePicker();
  final AudioRecorder _audioRecorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();

  bool _isTyping = false;
  bool _isDisconnecting = false;
  bool _isRecording = false;
  bool _showMediaOptions = false;
  bool _showEmojiPicker = false;
  int? _currentlyPlayingMessageId;
  PlayerState _audioPlayerState = PlayerState.stopped;
  
  // 🔥 NEW: Enhanced features state
  int? _replyingToMessageId;
  ChatMessage? _replyingToMessage;
  int? _editingMessageId;
  final TextEditingController _editController = TextEditingController();
  
  // 🔥 NEW: Typing indicator debounce timer
  Timer? _typingTimer;
  bool _hasSentTypingStatus = false;

  @override
  void initState() {
    super.initState();
    // Listen to audio player state changes
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _audioPlayerState = state;
          if (state == PlayerState.stopped || state == PlayerState.completed) {
            _currentlyPlayingMessageId = null;
          }
        });
      }
    });
    
    // 🔥 NEW: Listen to scroll position for pagination
    _scrollController.addListener(_onScroll);
    
    Future.microtask(() {
      if (mounted) {
        ref.read(chatProvider.notifier).connectToChatRoom(widget.chatRoom.id);
      }
    });
  }
  
  // 🔥 NEW: Handle scroll to top for pagination
  void _onScroll() {
    if (!_scrollController.hasClients) return;
    
    final chatState = ref.read(chatProvider);
    
    // Load older messages when scrolled to top
    if (_scrollController.position.pixels <= 100 && 
        chatState.hasMoreMessages && 
        !chatState.isLoadingOlderMessages) {
      _loadOlderMessages();
    }
  }
  
  // 🔥 NEW: Load older messages with scroll position preservation
  Future<void> _loadOlderMessages() async {
    final chatState = ref.read(chatProvider);
    if (!chatState.hasMoreMessages || chatState.isLoadingOlderMessages) {
      return;
    }
    
    if (!_scrollController.hasClients) return;
    
    // Save current scroll position and first visible item
    final currentScrollPosition = _scrollController.position.pixels;
    final messagesBefore = chatState.messages.length;
    
    // Load older messages
    await ref.read(chatProvider.notifier).loadOlderMessages();
    
    // Restore scroll position after loading
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients && mounted) {
        final messagesAfter = ref.read(chatProvider).messages.length;
        final messagesAdded = messagesAfter - messagesBefore;
        
        if (messagesAdded > 0) {
          // Estimate height per message (approximate)
          const estimatedMessageHeight = 80.0;
          final heightAdded = messagesAdded * estimatedMessageHeight;
          
          // Adjust scroll position to maintain visual position
          final newPosition = currentScrollPosition + heightAdded;
          _scrollController.jumpTo(newPosition.clamp(
            0.0,
            _scrollController.position.maxScrollExtent,
          ));
        }
      }
    });
  }

  @override
  void dispose() {
    // 🔥 NEW: Stop typing indicator and cancel timer
    _typingTimer?.cancel();
    if (_hasSentTypingStatus) {
      ref.read(chatProvider.notifier).sendTypingStatus(false);
    }
    
    if (!_isDisconnecting) {
      _isDisconnecting = true;
      Future.microtask(() {
        ref.read(chatProvider.notifier).disconnectFromChatRoom();
      });
    }

    _messageController.dispose();
    _editController.dispose();
    _scrollController.dispose();
    _audioRecorder.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  // 🔥 NEW: Play/pause audio message
  Future<void> _toggleAudioPlayback(ChatMessage message) async {
    if (message.fileUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Audio file not available')),
      );
      return;
    }

    try {
      // If this message is already playing, pause it
      if (_currentlyPlayingMessageId == message.id && 
          _audioPlayerState == PlayerState.playing) {
        await _audioPlayer.pause();
        setState(() {
          _currentlyPlayingMessageId = null;
        });
        return;
      }

      // If another message is playing, stop it first
      if (_currentlyPlayingMessageId != null && 
          _currentlyPlayingMessageId != message.id) {
        await _audioPlayer.stop();
      }

      // Play the selected audio
      setState(() {
        _currentlyPlayingMessageId = message.id;
      });

      await _audioPlayer.play(UrlSource(message.fileUrl!));
    } catch (e) {

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to play audio: $e')),
        );
      }
      setState(() {
        _currentlyPlayingMessageId = null;
      });
    }
  }

  void _sendMessage() {
    final content = _messageController.text.trim();
    if (content.isNotEmpty && mounted) {
      // 🔥 NEW: Send with reply if replying
      if (_replyingToMessageId != null) {
        ref.read(chatProvider.notifier).sendMessageWithReply(
          content,
          _replyingToMessageId,
        );
        setState(() {
          _replyingToMessageId = null;
          _replyingToMessage = null;
        });
      } else {
        ref.read(chatProvider.notifier).sendMessage(content);
      }
      _messageController.clear();
      _scrollToBottom();
    }
  }
  
  // 🔥 NEW: Show message options (edit, delete, reply, react)
  void _showMessageOptions(ChatMessage message, int currentUserId) {
    final isOwnMessage = message.sender.id == currentUserId;
    
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!isOwnMessage) ...[
              ListTile(
                leading: const Icon(Icons.reply),
                title: const Text('Reply'),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _replyingToMessageId = message.id;
                    _replyingToMessage = message;
                  });
                },
              ),
              ListTile(
                leading: const Icon(Icons.add_reaction),
                title: const Text('Add Reaction'),
                onTap: () {
                  Navigator.pop(context);
                  _showReactionPicker(message);
                },
              ),
            ],
            if (isOwnMessage && !message.isDeleted) ...[
              if (message.messageType == MessageType.text)
                ListTile(
                  leading: const Icon(Icons.edit),
                  title: const Text('Edit'),
                  onTap: () {
                    Navigator.pop(context);
                    _startEditingMessage(message);
                  },
                ),
              ListTile(
                leading: const Icon(Icons.reply),
                title: const Text('Reply'),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _replyingToMessageId = message.id;
                    _replyingToMessage = message;
                  });
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: const Text('Delete', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  _deleteMessage(message);
                },
              ),
            ],
            if (isOwnMessage)
              ListTile(
                leading: const Icon(Icons.add_reaction),
                title: const Text('Add Reaction'),
                onTap: () {
                  Navigator.pop(context);
                  _showReactionPicker(message);
                },
              ),
          ],
        ),
      ),
    );
  }
  
  // 🔥 NEW: Show reaction picker
  void _showReactionPicker(ChatMessage message) {
    final commonReactions = ['👍', '❤️', '😂', '😮', '😢', '🙏'];
    
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Add Reaction', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: commonReactions.map((emoji) {
                final hasReaction = message.reactions.containsKey(emoji) &&
                    message.reactions[emoji]!.contains(ref.read(chatProvider).currentUserId);
                return GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    ref.read(chatProvider.notifier).toggleReaction(
                      message.id!,
                      emoji,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: hasReaction ? Colors.blue[100] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(emoji, style: const TextStyle(fontSize: 32)),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
  
  // 🔥 NEW: Start editing message
  void _startEditingMessage(ChatMessage message) {
    setState(() {
      _editingMessageId = message.id;
      _editController.text = message.content ?? '';
    });
  }
  
  // 🔥 NEW: Save edited message
  void _saveEditedMessage() async {
    if (_editingMessageId == null || _editController.text.trim().isEmpty) {
      return;
    }
    
    final success = await ref.read(chatProvider.notifier).editMessage(
      _editingMessageId!,
      _editController.text.trim(),
    );
    
    if (success && mounted) {
      setState(() {
        _editingMessageId = null;
        _editController.clear();
      });
    }
  }
  
  // 🔥 NEW: Delete message
  void _deleteMessage(ChatMessage message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Message'),
        content: const Text('Are you sure you want to delete this message?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(chatProvider.notifier).deleteMessage(message.id!);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
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
      }
    });
  }

  void _onTypingChanged(String text) {
    if (!mounted) return;

    final isCurrentlyTyping = text.trim().isNotEmpty;
    
    // Cancel existing timer
    _typingTimer?.cancel();
    
    if (isCurrentlyTyping) {
      // User is typing - send typing status if not already sent
      if (!_hasSentTypingStatus) {
        _isTyping = true;
        _hasSentTypingStatus = true;
        ref.read(chatProvider.notifier).sendTypingStatus(true);

      }
      
      // Set timer to stop typing after 3 seconds of inactivity
      _typingTimer = Timer(const Duration(seconds: 3), () {
        if (mounted && _hasSentTypingStatus) {
          _isTyping = false;
          _hasSentTypingStatus = false;
          ref.read(chatProvider.notifier).sendTypingStatus(false);
        }
      });
    } else {
      // User stopped typing - send stop typing status immediately
      if (_hasSentTypingStatus) {
        _isTyping = false;
        _hasSentTypingStatus = false;
        ref.read(chatProvider.notifier).sendTypingStatus(false);
      }
    }
  }

  // 🔥 UPDATED: Pick and send image with validation
  Future<void> _pickAndSendImage(ImageSource source) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (image != null && mounted) {

        // 🔥 VALIDATE IMAGE: Check file size and format
        final imageFile = File(image.path);
        final fileSize = await imageFile.length();
        const maxSize = 10 * 1024 * 1024; // 10MB

        if (fileSize > maxSize) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('❌ Image is too large. Maximum size is 10MB'),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 3),
              ),
            );
          }
          return;
        }

        // Check if file exists and is readable
        if (!await imageFile.exists()) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('❌ Image file not found'),
                backgroundColor: Colors.red,
              ),
            );
          }
          return;
        }

        // Show uploading indicator
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white),
                ),
                SizedBox(width: 16),
                Text('Uploading image...'),
              ],
            ),
            duration: Duration(seconds: 30),
          ),
        );

        // Upload image
        final success = await ref.read(chatProvider.notifier).sendImageMessage(
              imageFile,
              widget.chatRoom.id,
            );

        if (mounted) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();

          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('✅ Image sent!'),
                duration: Duration(seconds: 2),
              ),
            );
            _scrollToBottom();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('❌ Failed to send image'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      }
    } catch (e) {

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to pick image: $e')),
        );
      }
    }
  }

// 🔥 UPDATED: Start/Stop voice recording with duration tracking
  DateTime? _recordingStartTime;

  Future<void> _toggleRecording() async {
    if (_isRecording) {
      // Stop recording
      final path = await _audioRecorder.stop();

      // Calculate duration
      final duration = _recordingStartTime != null
          ? DateTime.now().difference(_recordingStartTime!).inSeconds
          : 0;

      setState(() {
        _isRecording = false;
        _recordingStartTime = null;
      });

      if (path != null && mounted) {

        // Show uploading indicator
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white),
                ),
                SizedBox(width: 16),
                Text('Uploading voice message...'),
              ],
            ),
            duration: Duration(seconds: 30),
          ),
        );

        // Upload voice message
        final success = await ref.read(chatProvider.notifier).sendVoiceMessage(
              File(path),
              widget.chatRoom.id,
              duration,
            );

        if (mounted) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();

          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('✅ Voice message sent!'),
                duration: Duration(seconds: 2),
              ),
            );
            _scrollToBottom();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('❌ Failed to send voice message'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      }
    } else {
      // Start recording
      if (await _audioRecorder.hasPermission()) {
        final path =
            '${Directory.systemTemp.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';
        await _audioRecorder.start(const RecordConfig(), path: path);
        setState(() {
          _isRecording = true;
          _recordingStartTime = DateTime.now();
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('🎙️ Recording...'),
              duration: Duration(seconds: 1),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Microphone permission denied')),
          );
        }
      }
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
      if (mounted && previous?.messages.length != next.messages.length) {
        _scrollToBottom();
      }

      if (mounted &&
          previous?.isLoadingMessages == true &&
          next.isLoadingMessages == false) {
        _scrollToBottom();
      }
    });

    return WillPopScope(
      onWillPop: () async {
        if (!_isDisconnecting) {
          _isDisconnecting = true;
          ref.read(chatProvider.notifier).disconnectFromChatRoom();
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(widget.chatRoom.name),
                  const SizedBox(width: 8),
                  // 🔥 NEW: Online status indicator
                  if (widget.chatRoom.participants.isNotEmpty)
                    Builder(
                      builder: (context) {
                        final otherUser = widget.chatRoom.participants.firstWhere(
                          (p) => p.id != chatState.currentUserId,
                          orElse: () => widget.chatRoom.participants.first,
                        );
                        final onlineUser = chatState.onlineUsers[otherUser.id];
                        final isOnline = onlineUser?.isOnline ?? otherUser.isOnline;
                        return Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: isOnline ? Colors.green : Colors.grey,
                            shape: BoxShape.circle,
                          ),
                        );
                      },
                    ),
                ],
              ),
              Text(
                widget.chatRoom.isGroup
                    ? '${widget.chatRoom.participants.length} participants'
                    : chatState.typingUsers.entries
                            .where((e) => e.key != chatState.currentUserId && e.value)
                            .isNotEmpty
                        ? 'typing...'
                        : 'online',
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
          actions: [
            // 🔥 NEW: Voice call button
            IconButton(
              icon: const Icon(Icons.phone),
              onPressed: () {
                ref.read(chatProvider.notifier).initiateCall('voice');
              },
            ),
            // 🔥 NEW: Video call button
            IconButton(
              icon: const Icon(Icons.videocam),
              onPressed: () {
                ref.read(chatProvider.notifier).initiateCall('video');
              },
            ),
            PopupMenuButton(
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'info',
                  child: Text('Chat Info'),
                ),
                // 🔥 NEW: Block user option (for direct chats)
                if (!widget.chatRoom.isGroup && widget.chatRoom.participants.isNotEmpty)
                  PopupMenuItem(
                    value: 'block',
                    child: Text(
                      chatState.blockedUserIds.contains(
                        widget.chatRoom.participants
                            .firstWhere((p) => p.id != chatState.currentUserId,
                                orElse: () => widget.chatRoom.participants.first)
                            .id,
                      )
                          ? 'Unblock User'
                          : 'Block User',
                    ),
                  ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Text('Delete Chat'),
                ),
              ],
              onSelected: (value) {
                if (value == 'delete') {
                  _showDeleteConfirmation();
                } else if (value == 'info') {
                  _showChatInfo();
                } else if (value == 'block') {
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
              },
            ),
          ],
        ),
        body: Column(
          children: [
            // 🔥 NEW: Show message if you're blocked by this user
            if (!widget.chatRoom.isGroup && widget.chatRoom.participants.isNotEmpty)
              Builder(
                builder: (context) {
                  final otherUser = widget.chatRoom.participants.firstWhere(
                    (p) => p.id != chatState.currentUserId,
                    orElse: () => widget.chatRoom.participants.first,
                  );
                  
                  // Check if error indicates you're blocked
                  final isBlocked = error != null && 
                      (error.toString().contains('blocked') || 
                       error.toString().contains('PermissionDenied') ||
                       error.toString().contains('Access denied'));
                  
                  if (isBlocked) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      color: Colors.orange[50],
                      child: Row(
                        children: [
                          Icon(Icons.block, color: Colors.orange[700]),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'You are blocked',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange[900],
                                  ),
                                ),
                                Text(
                                  '${otherUser.username} has blocked you. You cannot send messages.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.orange[800],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            if (error != null && !error.toString().contains('blocked'))
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                color: Colors.red[100],
                child: Row(
                  children: [
                    const Icon(Icons.error_outline,
                        color: Colors.red, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Error: $error',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                    IconButton(
                      icon:
                          const Icon(Icons.close, color: Colors.red, size: 20),
                      onPressed: () {
                        ref.read(chatProvider.notifier).refresh();
                      },
                    ),
                  ],
                ),
              ),
            Expanded(
              child: isLoadingMessages
                  ? const Center(child: CircularProgressIndicator())
                  : messages.isEmpty
                      ? _buildEmptyMessageState(error)
                      : Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                controller: _scrollController,
                                reverse: false, // Normal order (oldest at top)
                                padding: const EdgeInsets.all(16),
                                itemCount: messages.length + (chatState.isLoadingOlderMessages ? 1 : 0),
                                itemBuilder: (context, index) {
                                  // 🔥 NEW: Show loading indicator at top when loading older messages
                                  if (index == 0 && chatState.isLoadingOlderMessages) {
                                    return const Padding(
                                      padding: EdgeInsets.all(16),
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    );
                                  }
                                  
                                  final messageIndex = chatState.isLoadingOlderMessages ? index - 1 : index;
                                  final sortedMessages = List.from(messages)
                                    ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

                                  final message = sortedMessages[messageIndex];
                                  final isOwnMessage =
                                      message.sender.id == currentUserId;

                                  bool showDateSeparator = false;
                                  if (messageIndex == 0) {
                                    showDateSeparator = true;
                                  } else {
                                    final prevMessage = sortedMessages[messageIndex - 1];
                                    showDateSeparator = !_isSameDay(
                                      message.timestamp,
                                      prevMessage.timestamp,
                                    );
                                  }

                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      if (showDateSeparator)
                                        DateSeparator(date: message.timestamp),
                                      GestureDetector(
                                        onLongPress: () => _showMessageOptions(message, currentUserId!),
                                        child: MessageBubble(
                                          message: message,
                                          isOwnMessage: isOwnMessage,
                                          currentlyPlayingMessageId: _currentlyPlayingMessageId,
                                          audioPlayerState: _audioPlayerState,
                                          onAudioTap: message.messageType == MessageType.voice
                                              ? () => _toggleAudioPlayback(message)
                                              : null,
                                          currentUserId: currentUserId,
                                          onReactionTap: (emoji) {
                                            ref.read(chatProvider.notifier).toggleReaction(
                                              message.id!,
                                              emoji,
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                            // 🔥 NEW: Typing indicators
                            if (chatState.typingUsers.entries
                                .any((e) => e.key != currentUserId && e.value))
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                child: Row(
                                  children: [
                                    ...chatState.typingUsers.entries
                                        .where((e) => e.key != currentUserId && e.value)
                                        .map((e) {
                                      final user = widget.chatRoom.participants
                                          .firstWhere((p) => p.id == e.key, orElse: () => User(id: e.key, username: 'User'));
                                      return Padding(
                                        padding: const EdgeInsets.only(right: 8),
                                        child: Text(
                                          '${user.username} is typing...',
                                          style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            color: Colors.grey[600],
                                            fontSize: 12,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ],
                                ),
                              ),
                          ],
                        ),
            ),
            _buildMessageInput(),
            // Emoji Picker
            if (_showEmojiPicker)
              SizedBox(
                height: 250,
                child: EmojiPicker(
                  onEmojiSelected: (category, emoji) {
                    _messageController.text += emoji.emoji;
                    setState(() {});
                  },
                  config: Config(
                    checkPlatformCompatibility: true,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // 🔥 NEW: Enhanced message input with media buttons
  Widget _buildMessageInput() {
    final chatState = ref.watch(chatProvider);
    final error = chatState.error;
    
    // 🔥 NEW: Check if user is blocked
    final isBlocked = error != null && 
        (error.toString().contains('blocked') || 
         error.toString().contains('PermissionDenied') ||
         error.toString().contains('Access denied'));
    
    // 🔥 NEW: Disable input if blocked
    if (isBlocked) {
      return Container(
        padding: const EdgeInsets.all(16),
        color: Colors.grey[200],
        child: Row(
          children: [
            Icon(Icons.block, color: Colors.grey[600]),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'You cannot send messages. You have been blocked.',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 🔥 NEW: Reply preview
            if (_replyingToMessage != null)
              Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 3,
                      height: 40,
                      color: Colors.blue,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Replying to ${_replyingToMessage!.sender.username}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[900],
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _replyingToMessage!.content ?? 
                            (_replyingToMessage!.messageType == MessageType.image 
                                ? '📷 Photo' 
                                : _replyingToMessage!.messageType == MessageType.voice 
                                    ? '🎤 Voice message'
                                    : ''),
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.blue[700],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () {
                        setState(() {
                          _replyingToMessageId = null;
                          _replyingToMessage = null;
                        });
                      },
                    ),
                  ],
                ),
              ),
            // 🔥 NEW: Edit mode
            if (_editingMessageId != null)
              Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.edit, size: 16, color: Colors.orange),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Editing message',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () {
                        setState(() {
                          _editingMessageId = null;
                          _editController.clear();
                        });
                      },
                    ),
                  ],
                ),
              ),
            // Media options row
            if (_showMediaOptions)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildMediaOption(
                      icon: Icons.photo_library,
                      label: 'Gallery',
                      color: Colors.purple,
                      onTap: () => _pickAndSendImage(ImageSource.gallery),
                    ),
                    _buildMediaOption(
                      icon: Icons.camera_alt,
                      label: 'Camera',
                      color: Colors.blue,
                      onTap: () => _pickAndSendImage(ImageSource.camera),
                    ),
                    _buildMediaOption(
                      icon: Icons.mic,
                      label: 'Voice',
                      color: Colors.red,
                      onTap: _toggleRecording,
                    ),
                    _buildMediaOption(
                      icon: Icons.emoji_emotions,
                      label: 'Emoji',
                      color: Colors.orange,
                      onTap: () {
                        setState(() {
                          _showEmojiPicker = !_showEmojiPicker;
                          _showMediaOptions = false;
                        });
                      },
                    ),
                  ],
                ),
              ),

            // Input row
            Row(
              children: [
                // Media toggle button
                IconButton(
                  icon: Icon(
                    _showMediaOptions ? Icons.close : Icons.add_circle,
                    color: _showMediaOptions ? Colors.red : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _showMediaOptions = !_showMediaOptions;
                    });
                  },
                ),

                // Emoji button
                IconButton(
                  icon: Icon(
                    _showEmojiPicker ? Icons.keyboard : Icons.emoji_emotions,
                    color: _showEmojiPicker ? Colors.blue : Colors.grey[600],
                  ),
                  onPressed: () {
                    setState(() {
                      _showEmojiPicker = !_showEmojiPicker;
                      _showMediaOptions = false;
                    });
                  },
                ),

                // Text input (normal or edit mode)
                Expanded(
                  child: _editingMessageId != null
                      ? TextField(
                          controller: _editController,
                          decoration: InputDecoration(
                            hintText: 'Edit message...',
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
                          maxLines: null,
                          textInputAction: TextInputAction.send,
                          onSubmitted: (_) {
                            if (_editController.text.trim().isNotEmpty) {
                              _saveEditedMessage();
                            }
                          },
                        )
                      : TextField(
                          controller: _messageController,
                          onChanged: (text) {
                            _onTypingChanged(text);
                            setState(() {}); // Rebuild to update send button state
                          },
                          decoration: InputDecoration(
                            hintText: 'Type a message...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.grey[200],
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                          ),
                          maxLines: null,
                          textInputAction: TextInputAction.send,
                          onSubmitted: (_) {
                            if (_messageController.text.trim().isNotEmpty) {
                              // 🔥 NEW: Stop typing indicator when sending message
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

                // Send button or recording indicator or save edit button
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
                  CircleAvatar(
                    backgroundColor: _editController.text.trim().isEmpty
                        ? Colors.grey[400]
                        : Colors.orange,
                    child: IconButton(
                      icon: const Icon(Icons.check, color: Colors.white),
                      onPressed: _editController.text.trim().isEmpty
                          ? null
                          : _saveEditedMessage,
                    ),
                  )
                else
                  CircleAvatar(
                    backgroundColor: _messageController.text.trim().isEmpty
                        ? Colors.grey[400]
                        : Colors.blue,
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: _messageController.text.trim().isEmpty
                          ? null
                          : _sendMessage,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 🔥 NEW: Media option button
  Widget _buildMediaOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyMessageState(String? error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'No messages yet',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
          const SizedBox(height: 8),
          const Text(
            'Say hi! 👋',
            style: TextStyle(fontSize: 24, color: Colors.grey),
          ),
          if (error != null) ...[
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                ref
                    .read(chatProvider.notifier)
                    .loadChatMessages(widget.chatRoom.id);
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ],
      ),
    );
  }

  void _showChatInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Chat Info'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Chat Room: ${widget.chatRoom.name}',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Text(
                'ID: ${widget.chatRoom.id}',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              const SizedBox(height: 16),
              const Text(
                'Participants:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
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
                          participant.username[0].toUpperCase(),
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
                              participant.displayName,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '@${participant.username}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
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
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Chat'),
        content: const Text('Are you sure you want to delete this chat?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              if (mounted) {
                final success = await ref
                    .read(chatProvider.notifier)
                    .deleteChatRoom(widget.chatRoom.id);
                if (success && mounted) {
                  Navigator.pop(context);
                }
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

// Keep your existing MessageBubble, DateSeparator classes...
class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isOwnMessage;
  final int? currentlyPlayingMessageId;
  final PlayerState audioPlayerState;
  final VoidCallback? onAudioTap;
  final int? currentUserId;
  final Function(String)? onReactionTap;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isOwnMessage,
    this.currentlyPlayingMessageId,
    this.audioPlayerState = PlayerState.stopped,
    this.onAudioTap,
    this.currentUserId,
    this.onReactionTap,
  });

  @override
  Widget build(BuildContext context) {
    // 🔥 NEW: Show deleted message differently
    if (message.isDeleted) {
      return Align(
        alignment: isOwnMessage ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.delete_outline, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 8),
              Text(
                'This message was deleted',
                style: TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Align(
      alignment: isOwnMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        child: Column(
          crossAxisAlignment: isOwnMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            // 🔥 NEW: Reply preview
            if (message.replyTo != null)
              Container(
                margin: const EdgeInsets.only(bottom: 4),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isOwnMessage 
                      ? Colors.blue.withOpacity(0.2)
                      : Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                  border: Border(
                    left: BorderSide(
                      color: isOwnMessage ? Colors.blue : Colors.grey[400]!,
                      width: 3,
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message.replyTo!.sender.username,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isOwnMessage ? Colors.blue[900] : Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      message.replyTo!.content ?? 
                      (message.replyTo!.messageType == MessageType.image 
                          ? '📷 Photo' 
                          : message.replyTo!.messageType == MessageType.voice 
                              ? '🎤 Voice message'
                              : ''),
                      style: TextStyle(
                        fontSize: 12,
                        color: isOwnMessage ? Colors.blue[800] : Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isOwnMessage ? Colors.blue : Colors.grey[300],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isOwnMessage)
                    Text(
                      message.sender.username,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                  _buildMessageContent(context),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        DateFormat('HH:mm').format(message.timestamp),
                        style: TextStyle(
                          fontSize: 10,
                          color: isOwnMessage ? Colors.white70 : Colors.grey[600],
                        ),
                      ),
                      if (message.isEdited) ...[
                        const SizedBox(width: 4),
                        Text(
                          'edited',
                          style: TextStyle(
                            fontSize: 9,
                            fontStyle: FontStyle.italic,
                            color: isOwnMessage ? Colors.white60 : Colors.grey[500],
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            // 🔥 NEW: Reactions
            if (message.reactions.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Wrap(
                  spacing: 4,
                  children: message.reactions.entries.map((entry) {
                    final emoji = entry.key;
                    final userIds = entry.value;
                    final hasMyReaction = currentUserId != null && userIds.contains(currentUserId);
                    return GestureDetector(
                      onTap: () => onReactionTap?.call(emoji),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: hasMyReaction 
                              ? Colors.blue[100] 
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                          border: hasMyReaction
                              ? Border.all(color: Colors.blue, width: 1)
                              : null,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(emoji, style: const TextStyle(fontSize: 14)),
                            if (userIds.length > 1) ...[
                              const SizedBox(width: 4),
                              Text(
                                '${userIds.length}',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: hasMyReaction ? Colors.blue[900] : Colors.grey[700],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageContent(BuildContext context) {
    switch (message.messageType) {
      case MessageType.text:
        return Text(
          message.content!,
          style: TextStyle(
            color: isOwnMessage ? Colors.white : Colors.black87,
            fontSize: 16,
          ),
        );

      case MessageType.image:
        return _buildImageMessage(context);

      case MessageType.voice:
        return _buildVoiceMessage(context, onAudioTap);
    }
  }

  Widget _buildImageMessage(BuildContext context) {
    // Use fileUrl first, fallback to file
    final imageUrl = message.fileUrl ?? message.file;
    
    if (imageUrl == null || imageUrl.isEmpty) {
      return Container(
        width: 200,
        height: 200,
        color: Colors.grey[300],
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
            SizedBox(height: 8),
            Text('Image unavailable', style: TextStyle(fontSize: 12)),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => Scaffold(
              backgroundColor: Colors.black,
              appBar: AppBar(
                backgroundColor: Colors.black,
                iconTheme: const IconThemeData(color: Colors.white),
              ),
              body: Center(
                child: InteractiveViewer(
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.broken_image, size: 64, color: Colors.white),
                            SizedBox(height: 16),
                            Text(
                              'Failed to load image',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          imageUrl,
          width: 200,
          height: 200,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              width: 200,
              height: 200,
              color: Colors.grey[300],
              child: Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: 200,
              height: 200,
              color: Colors.grey[300],
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.broken_image, size: 50, color: Colors.grey),
                  SizedBox(height: 8),
                  Text('Failed to load', style: TextStyle(fontSize: 12)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // 🔥 MODERNIZED: Voice message bubble with waveform design and playback
  Widget _buildVoiceMessage(BuildContext context, VoidCallback? onTap) {
    final duration = message.duration ?? 0;
    final minutes = duration ~/ 60;
    final seconds = duration % 60;
    final isPlaying = currentlyPlayingMessageId == message.id && 
                      audioPlayerState == PlayerState.playing;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Play/Pause button with modern design
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isOwnMessage 
                    ? Colors.white.withOpacity(0.3)
                    : Colors.blue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isPlaying ? Icons.pause : Icons.play_arrow,
                color: isOwnMessage ? Colors.white : Colors.blue,
                size: 28,
              ),
            ),
          const SizedBox(width: 12),
          
          // Waveform visualization (simplified)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Waveform bars
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(20, (index) {
                    final height = (index % 3 + 1) * 3.0;
                    return Container(
                      width: 2.5,
                      height: height,
                      margin: const EdgeInsets.symmetric(horizontal: 1),
                      decoration: BoxDecoration(
                        color: isOwnMessage 
                            ? Colors.white.withOpacity(0.7)
                            : Colors.blue.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(1),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 6),
                // Duration
                Text(
                  '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    color: isOwnMessage ? Colors.white70 : Colors.grey[700],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(width: 8),
          
          // Voice icon indicator
          Icon(
            Icons.mic,
            color: isOwnMessage ? Colors.white70 : Colors.grey[600],
            size: 18,
          ),
        ],
      ),
      ),
    );
  }
}

class DateSeparator extends StatelessWidget {
  final DateTime date;

  const DateSeparator({super.key, required this.date});

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else {
      return DateFormat('MMMM d, y').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            _formatDate(date),
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
            ),
          ),
        ),
      ),
    );
  }
}
