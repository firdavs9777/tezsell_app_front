import 'package:app/providers/provider_models/message_model.dart';
import 'package:app/providers/provider_root/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

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
  bool _isTyping = false;
  bool _isDisconnecting = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        ref.read(chatProvider.notifier).connectToChatRoom(widget.chatRoom.id);
      }
    });
  }

  @override
  void dispose() {
    if (!_isDisconnecting) {
      _isDisconnecting = true;
      Future.microtask(() {
        ref.read(chatProvider.notifier).disconnectFromChatRoom();
      });
    }

    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final content = _messageController.text.trim();
    if (content.isNotEmpty && mounted) {
      ref.read(chatProvider.notifier).sendMessage(content);
      _messageController.clear();
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    Future.microtask(() {
      if (_scrollController.hasClients && mounted) {
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
    if (isCurrentlyTyping != _isTyping) {
      setState(() {
        _isTyping = isCurrentlyTyping;
      });
      ref.read(chatProvider.notifier).sendTypingStatus(isCurrentlyTyping);
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
              Text(widget.chatRoom.name),
              Text(
                '${widget.chatRoom.participants.length} participants',
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
          actions: [
            PopupMenuButton(
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'info',
                  child: Text('Chat Info'),
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
                }
              },
            ),
          ],
        ),
        body: Column(
          children: [
            // Error banner with dismiss button
            if (error != null)
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

            // Messages List
            Expanded(
              child: isLoadingMessages
                  ? const Center(child: CircularProgressIndicator())
                  : messages.isEmpty
                      ? _buildEmptyMessageState(error)
                      : ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(16),
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final message = messages[index];
                            final isOwnMessage =
                                message.sender.id == currentUserId;

                            bool showDateSeparator = false;
                            if (index == 0) {
                              showDateSeparator = true;
                            } else {
                              final prevMessage = messages[index - 1];
                              showDateSeparator = !_isSameDay(
                                message.timestamp,
                                prevMessage.timestamp,
                              );
                            }

                            return Column(
                              children: [
                                if (showDateSeparator)
                                  DateSeparator(date: message.timestamp),
                                MessageBubble(
                                  message: message,
                                  isOwnMessage: isOwnMessage,
                                ),
                              ],
                            );
                          },
                        ),
            ),

            // Message Input
            Container(
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
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        onChanged: _onTypingChanged,
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
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: IconButton(
                        icon: const Icon(Icons.send, color: Colors.white),
                        onPressed: _sendMessage,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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

class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isOwnMessage;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isOwnMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isOwnMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
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
            Text(
              message.content,
              style: TextStyle(
                color: isOwnMessage ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('HH:mm').format(message.timestamp),
              style: TextStyle(
                fontSize: 10,
                color: isOwnMessage ? Colors.white70 : Colors.grey[600],
              ),
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
