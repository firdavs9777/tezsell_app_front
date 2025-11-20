import 'package:app/providers/provider_models/message_model.dart';
import 'package:app/providers/provider_root/chat_provider.dart';
import 'package:app/pages/chat/widgets/chat_app_bar.dart';
import 'package:app/pages/chat/widgets/message_list.dart';
import 'package:app/pages/chat/widgets/typing_indicator.dart';
import 'package:app/pages/chat/widgets/reply_preview.dart';
import 'package:app/pages/chat/widgets/edit_preview.dart';
import 'package:app/pages/chat/widgets/blocked_user_banner.dart';
import 'package:app/pages/chat/widgets/empty_message_state.dart';
import 'package:app/pages/chat/widgets/media_options_sheet.dart';
import 'package:app/pages/chat/widgets/message_options_sheet.dart';
import 'package:app/pages/chat/widgets/reaction_picker.dart';
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

  @override
  void initState() {
    super.initState();
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
    
    _scrollController.addListener(_onScroll);
    
    Future.microtask(() {
      if (mounted) {
        ref.read(chatProvider.notifier).connectToChatRoom(widget.chatRoom.id);
      }
    });
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    
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

  Future<void> _toggleAudioPlayback(ChatMessage message) async {
    if (message.fileUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Audio file not available')),
      );
      return;
    }

    try {
      if (_currentlyPlayingMessageId == message.id && 
          _audioPlayerState == PlayerState.playing) {
        await _audioPlayer.pause();
        setState(() => _currentlyPlayingMessageId = null);
        return;
      }

      if (_currentlyPlayingMessageId != null && 
          _currentlyPlayingMessageId != message.id) {
        await _audioPlayer.stop();
      }

      setState(() => _currentlyPlayingMessageId = message.id);
      await _audioPlayer.play(UrlSource(message.fileUrl!));
    } catch (e) {

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to play audio: $e')),
        );
      }
      setState(() => _currentlyPlayingMessageId = null);
    }
  }

  void _sendMessage() {
    final content = _messageController.text.trim();
    if (content.isNotEmpty && mounted) {
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

  void _showMessageOptions(ChatMessage message, int currentUserId) {
    final isOwnMessage = message.sender.id == currentUserId;
    
    showModalBottomSheet(
      context: context,
      builder: (context) => MessageOptionsSheet(
        message: message,
        isOwnMessage: isOwnMessage,
        onReply: () {
          setState(() {
            _replyingToMessageId = message.id;
            _replyingToMessage = message;
          });
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
    setState(() {
      _editingMessageId = message.id;
      _editController.text = message.content ?? '';
    });
  }

  Future<void> _saveEditedMessage() async {
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
    _typingTimer?.cancel();
    
    if (isCurrentlyTyping) {
      if (!_hasSentTypingStatus) {
        _hasSentTypingStatus = true;
        ref.read(chatProvider.notifier).sendTypingStatus(true);
      }
      
      _typingTimer = Timer(const Duration(seconds: 3), () {
        if (mounted && _hasSentTypingStatus) {
          _hasSentTypingStatus = false;
          ref.read(chatProvider.notifier).sendTypingStatus(false);
        }
      });
    } else {
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

  Future<void> _toggleRecording() async {
    if (_isRecording) {
      final path = await _audioRecorder.stop();
      final duration = _recordingStartTime != null
          ? DateTime.now().difference(_recordingStartTime!).inSeconds
          : 0;

      setState(() {
        _isRecording = false;
        _recordingStartTime = null;
      });

      if (path != null && mounted) {
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
      if (mounted && previous?.messages.length != next.messages.length) {
        _scrollToBottom();
      }

      if (mounted &&
          previous?.isLoadingMessages == true &&
          next.isLoadingMessages == false) {
        _scrollToBottom();
      }
    });

    // Check if user is blocked
    final isBlocked = error != null && 
        (error.toString().contains('blocked') || 
         error.toString().contains('PermissionDenied') ||
         error.toString().contains('Access denied'));

    final otherUser = !widget.chatRoom.isGroup && widget.chatRoom.participants.isNotEmpty
        ? widget.chatRoom.participants.firstWhere(
            (p) => p.id != currentUserId,
            orElse: () => widget.chatRoom.participants.first,
          )
        : null;

    return WillPopScope(
      onWillPop: () async {
        if (!_isDisconnecting) {
          _isDisconnecting = true;
          ref.read(chatProvider.notifier).disconnectFromChatRoom();
        }
        return true;
      },
      child: Scaffold(
        appBar: ChatAppBar(
          chatRoom: widget.chatRoom,
          onInfoTap: _showChatInfo,
          onBlockTap: _handleBlockUser,
          onDeleteTap: _showDeleteConfirmation,
        ),
        body: Column(
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
                color: Colors.red[100],
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Error: $error',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.red, size: 20),
                      onPressed: () {
                        ref.read(chatProvider.notifier).refresh();
                      },
                    ),
                  ],
                ),
              ),
            
            // Message list
            Expanded(
              child: isLoadingMessages
                  ? const Center(child: CircularProgressIndicator())
                  : messages.isEmpty
                      ? EmptyMessageState(
                          error: error,
                          chatRoomId: widget.chatRoom.id,
                        )
                      : Column(
                          children: [
                            Expanded(
                              child: MessageList(
                                scrollController: _scrollController,
                                currentlyPlayingMessageId: _currentlyPlayingMessageId,
                                audioPlayerState: _audioPlayerState,
                                onAudioTap: _toggleAudioPlayback,
                                onMessageLongPress: _showMessageOptions,
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

  Widget _buildMessageInput() {
    final chatState = ref.watch(chatProvider);
    final error = chatState.error;
    
    final isBlocked = error != null && 
        (error.toString().contains('blocked') || 
         error.toString().contains('PermissionDenied') ||
         error.toString().contains('Access denied'));
    
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
            // Reply preview
            if (_replyingToMessage != null)
              ReplyPreview(
                replyToMessage: _replyingToMessage!,
                onCancel: () {
                  setState(() {
                    _replyingToMessageId = null;
                    _replyingToMessage = null;
                  });
                },
              ),
            
            // Edit preview
            if (_editingMessageId != null)
              EditPreview(
                onCancel: () {
                  setState(() {
                    _editingMessageId = null;
                    _editController.clear();
                  });
                },
              ),
            
            // Media options
            if (_showMediaOptions)
              MediaOptionsSheet(
                onGalleryTap: () => _pickAndSendImage(ImageSource.gallery),
                onCameraTap: () => _pickAndSendImage(ImageSource.camera),
                onVoiceTap: _toggleRecording,
                onEmojiTap: () {
                  setState(() {
                    _showEmojiPicker = !_showEmojiPicker;
                    _showMediaOptions = false;
                  });
                },
              ),

            // Input row
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    _showMediaOptions ? Icons.close : Icons.add_circle,
                    color: _showMediaOptions ? Colors.red : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() => _showMediaOptions = !_showMediaOptions);
                  },
                ),
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
                            setState(() {});
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
}

