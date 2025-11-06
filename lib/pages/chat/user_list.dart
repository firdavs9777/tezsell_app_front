// lib/pages/messages/user_list.dart
import 'package:app/pages/chat//chat_room.dart';
import 'package:app/providers/provider_models/message_model.dart';
import 'package:app/providers/provider_root/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserListScreen extends ConsumerStatefulWidget {
  const UserListScreen({super.key});

  @override
  ConsumerState<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends ConsumerState<UserListScreen> {
  bool _isCreatingChat = false;
  bool _isLoadingUsers = false;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    if (_isLoadingUsers) return;

    setState(() {
      _isLoadingUsers = true;
    });

    try {
      await ref.read(chatProvider.notifier).loadUsers();
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingUsers = false;
        });
      }
    }
  }

  Future<void> _startChatWithUser(User user) async {
    if (_isCreatingChat) return;

    setState(() {
      _isCreatingChat = true;
    });

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => WillPopScope(
          onWillPop: () async => false,
          child: const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text(
                  'Starting chat...',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      );

      final chatRoom =
          await ref.read(chatProvider.notifier).getOrCreateDirectChat(user.id);

      if (mounted) Navigator.of(context).pop();

      if (chatRoom != null && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ChatRoomScreen(chatRoom: chatRoom),
          ),
        );
      } else {
        throw Exception('Failed to create or get chat room');
      }
    } catch (e) {
      if (mounted && Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to start chat: ${e.toString()}'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCreatingChat = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableUsers = ref.watch(availableUsersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Start a Conversation'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoadingUsers ? null : _loadUsers,
            tooltip: 'Refresh users',
          ),
        ],
      ),
      body: _isLoadingUsers
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading users...'),
                ],
              ),
            )
          : availableUsers.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.people_outline,
                          size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      const Text(
                        'No users available',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: _loadUsers,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadUsers,
                  child: ListView.builder(
                    itemCount: availableUsers.length,
                    itemBuilder: (context, index) {
                      final user = availableUsers[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Text(
                            user.username[0].toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          user.displayName,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text('@${user.username}'),
                        trailing: const Icon(Icons.chat_bubble_outline),
                        onTap: _isCreatingChat
                            ? null
                            : () => _startChatWithUser(user),
                      );
                    },
                  ),
                ),
    );
  }
}
