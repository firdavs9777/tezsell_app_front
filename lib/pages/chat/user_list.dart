// lib/pages/messages/user_list.dart
import 'package:app/pages/chat//chat_room.dart';
import 'package:app/providers/provider_models/message_model.dart';
import 'package:app/providers/provider_root/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

class UserListScreen extends ConsumerStatefulWidget {
  const UserListScreen({super.key});

  @override
  ConsumerState<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends ConsumerState<UserListScreen> {
  bool _isCreatingChat = false;
  bool _isLoadingUsers = false;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  Timer? _searchDebounceTimer;

  @override
  void initState() {
    super.initState();
    _loadUsers();
    // 🔥 NEW: Load blocked users on init
    ref.read(chatProvider.notifier).loadBlockedUsers();
    
    // 🔥 NEW: Listen to search input changes with debounce
    _searchController.addListener(_onSearchChanged);
  }
  
  // 🔥 NEW: Debounced search
  void _onSearchChanged() {
    _searchDebounceTimer?.cancel();
    _searchDebounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (_searchController.text.isNotEmpty) {
        _performSearch(_searchController.text);
      } else {
        setState(() {
          _searchResults = [];
          _isSearching = false;
        });
      }
    });
  }
  
  // 🔥 NEW: Perform search using new backend endpoint
  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }
    
    setState(() {
      _isSearching = true;
    });
    
    try {
      final results = await ref.read(chatProvider.notifier).searchUsers(query: query.trim());
      if (mounted) {
        setState(() {
          _searchResults = results;
          _isSearching = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSearching = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Search failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _searchDebounceTimer?.cancel();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
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
  
  // 🔥 NEW: Block/unblock user
  Future<void> _toggleBlockUser(User user, bool isBlocked) async {
    try {
      if (isBlocked) {
        await ref.read(chatProvider.notifier).unblockUser(user.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${user.username} has been unblocked'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        await ref.read(chatProvider.notifier).blockUser(user.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${user.username} has been blocked'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to ${isBlocked ? 'unblock' : 'block'} user: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // 🔥 NEW: Start chat from search result
  Future<void> _startChatFromSearch(Map<String, dynamic> searchResult) async {
    if (_isCreatingChat) return;

    // 🔥 Handle different response formats
    // Backend returns user data directly, so 'id' is at root level
    final userId = searchResult['id'] as int? ?? 
                   searchResult['user_id'] as int?;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid user data')),
      );
      return;
    }

    // 🔥 NEW: Check if chat already exists from search result
    final hasExistingChat = searchResult['has_existing_chat'] as bool? ?? 
                           searchResult['has_chat'] as bool? ?? 
                           false;
    final existingChatId = searchResult['existing_chat_id'] as int? ?? 
                          searchResult['chat_id'] as int?;

    // If chat exists, try to find it in current chat rooms first
    if (hasExistingChat && existingChatId != null) {
      final chatState = ref.read(chatProvider);
      final existingChat = chatState.chatRooms.firstWhere(
        (room) => room.id == existingChatId,
        orElse: () => ChatRoom(
          id: -1,
          name: '',
          participants: [],
          unreadCount: 0,
        ),
      );

      if (existingChat.id != -1) {
        // Chat exists locally, navigate directly
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ChatRoomScreen(chatRoom: existingChat),
            ),
          );
        }
        return;
      }
    }

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

      // 🔥 NEW: Use new start chat endpoint (it's integrated in getOrCreateDirectChat)
      // This will check for existing chat and only create if needed
      final chatRoom = await ref.read(chatProvider.notifier).getOrCreateDirectChat(userId);

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
    final chatState = ref.watch(chatProvider);
    final allUsers = ref.watch(availableUsersProvider);
    final blockedUserIds = chatState.blockedUserIds;
    
    // 🔥 NEW: Filter out blocked users and apply search
    final searchQuery = _searchController.text.toLowerCase();
    final filteredUsers = allUsers.where((user) {
      final isBlocked = blockedUserIds.contains(user.id);
      final matchesSearch = user.username.toLowerCase().contains(searchQuery) ||
          user.displayName.toLowerCase().contains(searchQuery);
      return !isBlocked && matchesSearch;
    }).toList();

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
      body: Column(
        children: [
          // 🔥 NEW: KakaoTalk-style search bar (top part)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Colors.grey[200]!, width: 0.5),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      controller: _searchController,
                      autofocus: false,
                      decoration: InputDecoration(
                        hintText: 'Search by username or phone number',
                        hintStyle: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 14,
                        ),
                        prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: Icon(Icons.clear, size: 20, color: Colors.grey[600]),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {
                                    _searchResults = [];
                                  });
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isSearching
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Searching...'),
                      ],
                    ),
                  )
                : _searchController.text.isNotEmpty && _searchResults.isNotEmpty
                    ? _buildSearchResults()
                    : _searchController.text.isNotEmpty && _searchResults.isEmpty && !_isSearching
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search_off,
                                  size: 64,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No users found',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Try a different search term',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : _isLoadingUsers
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
                            : filteredUsers.isEmpty
                                ? Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.people_outline,
                                          size: 64,
                                          color: Colors.grey[400],
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          'No users available',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey[600],
                                          ),
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
                                    child: ListView.separated(
                                      padding: EdgeInsets.zero,
                                      itemCount: filteredUsers.length,
                                      separatorBuilder: (context, index) => Divider(
                                        height: 1,
                                        thickness: 0.5,
                                        indent: 84,
                                        color: Colors.grey[200],
                                      ),
                                      itemBuilder: (context, index) {
                                        final user = filteredUsers[index];
                                        final isOnline = user.isOnline;
                                        
                                        return _buildUserTile(context, user, isOnline);
                                      },
                                    ),
                                  ),
          ),
        ],
      ),
    );
  }
  
  // 🔥 NEW: Build search results (KakaoTalk-style)
  Widget _buildSearchResults() {
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: _searchResults.length,
      separatorBuilder: (context, index) => Divider(
        height: 1,
        thickness: 0.5,
        indent: 84,
        color: Colors.grey[200],
      ),
      itemBuilder: (context, index) {
        final result = _searchResults[index];
        
        // 🔥 Handle different response formats
        // Backend returns: {"users": [{"id": 25, "username": "...", ...}]}
        // So result is already the user object, not wrapped in 'user' key
        final userData = result['user'] as Map<String, dynamic>? ?? result;
        final hasExistingChat = result['has_existing_chat'] as bool? ?? 
                               result['has_chat'] as bool? ?? 
                               false;
        final existingChatId = result['existing_chat_id'] as int? ?? 
                             result['chat_id'] as int?;
        final isOnline = userData['is_online'] as bool? ?? false;
        final profileImage = userData['profile_image'] as String?;
        
        return _buildSearchResultTile(result, userData, hasExistingChat, existingChatId, isOnline, profileImage);
      },
    );
  }
  
  // 🔥 NEW: Build search result tile (KakaoTalk-style)
  Widget _buildSearchResultTile(
    Map<String, dynamic> result,
    Map<String, dynamic> userData,
    bool hasExistingChat,
    int? existingChatId,
    bool isOnline,
    String? profileImage,
  ) {
    final username = userData['username'] as String? ?? 'Unknown';
    final displayName = userData['display_name'] as String? ?? 
                       '${userData['first_name'] ?? ''} ${userData['last_name'] ?? ''}'.trim() ??
                       username;
    final avatarLetter = username.isNotEmpty ? username[0].toUpperCase() : '?';
    
    return Container(
      color: Colors.white,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _isCreatingChat
              ? null
              : () => _startChatFromSearch(result),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                // Avatar
                Stack(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.blue[400]!, Colors.blue[600]!],
                        ),
                      ),
                      child: profileImage != null && profileImage.isNotEmpty
                          ? ClipOval(
                              child: Image.network(
                                profileImage,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Center(
                                  child: Text(
                                    avatarLetter,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Center(
                              child: Text(
                                avatarLetter,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                ),
                              ),
                            ),
                    ),
                    if (isOnline)
                      Positioned(
                        right: 2,
                        bottom: 2,
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 12),
                // User info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              displayName,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 17,
                                color: Colors.black87,
                                letterSpacing: -0.3,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (hasExistingChat) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.blue[50],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Chat exists',
                                style: TextStyle(
                                  color: Colors.blue[700],
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '@$username',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 🔥 NEW: Modern user tile (KakaoTalk-style)
  Widget _buildUserTile(BuildContext context, User user, bool isOnline) {
    return Container(
      color: Colors.white,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _isCreatingChat
              ? null
              : () => _startChatWithUser(user),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                // 🔥 NEW: Larger avatar (KakaoTalk style)
                Stack(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.blue[400]!, Colors.blue[600]!],
                        ),
                      ),
                      child: Center(
                        child: Text(
                          user.username[0].toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                      ),
                    ),
                    // Online status indicator (smaller, more subtle)
                    if (isOnline)
                      Positioned(
                        right: 2,
                        bottom: 2,
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 12),
                // User info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        user.displayName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                          color: Colors.black87,
                          letterSpacing: -0.3,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            '@${user.username}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                              letterSpacing: -0.2,
                            ),
                          ),
                          if (isOnline) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.green[50],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Online',
                                style: TextStyle(
                                  color: Colors.green[700],
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  // 🔥 NEW: Show block confirmation dialog
  void _showBlockDialog(User user) {
    final isBlocked = ref.read(chatProvider).blockedUserIds.contains(user.id);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isBlocked ? 'Unblock User' : 'Block User'),
        content: Text(
          isBlocked
              ? 'Are you sure you want to unblock ${user.username}? You will be able to receive messages from them again.'
              : 'Are you sure you want to block ${user.username}? You will not receive messages from them and they will be removed from your chat list.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _toggleBlockUser(user, isBlocked);
            },
            child: Text(
              isBlocked ? 'Unblock' : 'Block',
              style: TextStyle(
                color: isBlocked ? Colors.green : Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
