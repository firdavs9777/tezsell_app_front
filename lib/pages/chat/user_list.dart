// lib/pages/messages/user_list.dart
import 'package:app/pages/chat//chat_room.dart';
import 'package:app/providers/provider_models/message_model.dart';
import 'package:app/providers/provider_root/chat_provider.dart';
import 'package:app/widgets/image_viewer.dart';
import 'package:app/l10n/app_localizations.dart';
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
        final l = AppLocalizations.of(context);
        final errorMessage = l?.search_failed(e.toString()) ?? 'Search failed: $e';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Theme.of(context).colorScheme.error,
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
    // Get localization before async operation
    final l = AppLocalizations.of(context);

    try {
      if (isBlocked) {
        await ref.read(chatProvider.notifier).unblockUser(user.id);
        if (mounted) {
          final message = l?.user_unblocked(user.username) ?? 'User ${user.username} unblocked';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? Theme.of(context).colorScheme.primary
                  : const Color(0xFF43A047),
            ),
          );
        }
      } else {
        await ref.read(chatProvider.notifier).blockUser(user.id);
        if (mounted) {
          final message = l?.user_blocked(user.username) ?? 'User ${user.username} blocked';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: Theme.of(context).colorScheme.tertiary,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        final errorMessage = isBlocked
            ? (l?.failed_to_unblock ?? 'Failed to unblock user')
            : (l?.failed_to_block ?? 'Failed to block user');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Theme.of(context).colorScheme.error,
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
      final l = AppLocalizations.of(context);
      final errorMessage = l?.invalid_user_data ?? 'Invalid user data';
      ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
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

    // Get localization before showing dialog (to avoid null context issues)
    final localizations = AppLocalizations.of(context);
    final startingChatText = localizations?.starting_chat ?? 'Starting chat...';

    try {
      print('🔍 [UserList] Starting chat with userId: $userId');

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => PopScope(
          canPop: false,
          child: Center(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(
                      startingChatText,
                      style: TextStyle(color: Theme.of(dialogContext).colorScheme.onSurface),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      print('🔍 [UserList] Dialog shown, calling getOrCreateDirectChat...');

      // Use new start chat endpoint (it's integrated in getOrCreateDirectChat)
      // This will check for existing chat and only create if needed
      final chatRoom = await ref.read(chatProvider.notifier).getOrCreateDirectChat(userId);

      print('🔍 [UserList] getOrCreateDirectChat returned: ${chatRoom?.id}');

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
        final errorText = localizations?.failed_to_start_chat(e.toString()) ?? 'Failed to start chat: $e';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorText),
            backgroundColor: Theme.of(context).colorScheme.error,
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

    // Get localization before showing dialog (to avoid null context issues)
    final localizations = AppLocalizations.of(context);
    final startingChatText = localizations?.starting_chat ?? 'Starting chat...';

    try {
      print('🔍 [UserList] _startChatWithUser called for user: ${user.id} (${user.username})');

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => PopScope(
          canPop: false,
          child: Center(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(
                      startingChatText,
                      style: TextStyle(color: Theme.of(dialogContext).colorScheme.onSurface),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      print('🔍 [UserList] Dialog shown, calling getOrCreateDirectChat for user.id: ${user.id}');

      final chatRoom =
          await ref.read(chatProvider.notifier).getOrCreateDirectChat(user.id);

      print('🔍 [UserList] getOrCreateDirectChat returned: ${chatRoom?.id}');

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
        final errorText = localizations?.failed_to_start_chat(e.toString()) ?? 'Failed to start chat: $e';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorText),
            backgroundColor: Theme.of(context).colorScheme.error,
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
        title: Builder(
          builder: (context) {
            final l = AppLocalizations.of(context)!;
                return Text(l.start_conversation);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoadingUsers ? null : _loadUsers,
            tooltip: AppLocalizations.of(context)?.refresh_users ?? 'Refresh users',
          ),
        ],
      ),
      body: Column(
        children: [
          // 🔥 NEW: KakaoTalk-style search bar (top part)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border(
                bottom: BorderSide(color: Theme.of(context).colorScheme.outlineVariant, width: 0.5),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      controller: _searchController,
                      autofocus: false,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)?.search_by_username_or_phone ?? 'Search by username or phone number',
                        hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.onSurfaceVariant),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: Icon(Icons.clear, size: 20, color: Theme.of(context).colorScheme.onSurfaceVariant),
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
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 16),
                        Builder(
                          builder: (context) {
                            final l = AppLocalizations.of(context)!;
                            return Text(l.searching);
                          },
                        ),
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
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                                const SizedBox(height: 16),
                                Builder(
                                  builder: (context) {
                                    final l = AppLocalizations.of(context)!;
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          l.no_users_found,
                                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          l.try_different_search_term,
                                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            ),
                          )
                        : _isLoadingUsers
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const CircularProgressIndicator(),
                                    const SizedBox(height: 16),
                                    Builder(
                                      builder: (context) {
                                        final l = AppLocalizations.of(context)!;
                                        return Text(l.loading_users);
                                      },
                                    ),
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
                                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                                        ),
                                        const SizedBox(height: 16),
                                        Builder(
                                          builder: (context) {
                                            final l = AppLocalizations.of(context)!;
                                            return Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  l.no_users_available,
                                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                                  ),
                                                ),
                                                const SizedBox(height: 24),
                                                ElevatedButton.icon(
                                                  onPressed: _loadUsers,
                                                  icon: const Icon(Icons.refresh),
                                                  label: Text(l.retry),
                                                ),
                                              ],
                                            );
                                          },
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
                                        color: Theme.of(context).colorScheme.outlineVariant,
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
        color: Theme.of(context).colorScheme.outlineVariant,
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
    final l = AppLocalizations.of(context);
    final username = userData['username'] as String? ?? l?.unknown ?? 'Unknown';
    final fullName = '${userData['first_name'] ?? ''} ${userData['last_name'] ?? ''}'.trim();
    final displayName = userData['display_name'] as String? ??
                       (fullName.isNotEmpty ? fullName : username);
    final avatarLetter = username.isNotEmpty ? username[0].toUpperCase() : '?';

    return Container(
      color: Theme.of(context).colorScheme.surface,
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
                profileImage != null && profileImage.isNotEmpty
                    ? GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ImageViewer(
                                imageUrl: profileImage,
                                title: username,
                              ),
                            ),
                          );
                        },
                        child: Stack(
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
                        child: ClipOval(
                          child: Image.network(
                            profileImage,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Center(
                              child: Text(
                                avatarLetter,
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
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
                )
                    : Stack(
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
                                avatarLetter,
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
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
                                  color: Theme.of(context).brightness == Brightness.dark
                                      ? Theme.of(context).colorScheme.primary
                                      : const Color(0xFF43A047),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Theme.of(context).colorScheme.surface, width: 2),
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
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
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
                              child: Builder(
                                builder: (context) {
                                  final l = AppLocalizations.of(context)!;
                                  return Text(
                                    l.chat_exists,
                                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                      color: Colors.blue[700],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '@$username',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
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
      color: Theme.of(context).colorScheme.surface,
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
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
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
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Theme.of(context).colorScheme.primary
                                : const Color(0xFF43A047),
                            shape: BoxShape.circle,
                            border: Border.all(color: Theme.of(context).colorScheme.surface, width: 2),
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
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
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
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
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
                              child: Builder(
                                builder: (context) {
                                  final l = AppLocalizations.of(context)!;
                                  return Text(
                                    l.online,
                                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                      color: Colors.green[700],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  );
                                },
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
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
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

    // Get localization before showing dialog (to avoid null context issues)
    final l = AppLocalizations.of(context);
    final titleText = isBlocked
        ? (l?.unblock_user ?? 'Unblock User')
        : (l?.block_user ?? 'Block User');
    final contentText = isBlocked
        ? (l?.unblock_user_confirm(user.username) ?? 'Unblock ${user.username}?')
        : (l?.block_user_confirm(user.username) ?? 'Block ${user.username}?');
    final cancelText = l?.cancel ?? 'Cancel';
    final actionText = titleText;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(titleText),
          content: Text(contentText),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(cancelText),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(dialogContext);
                await _toggleBlockUser(user, isBlocked);
              },
              child: Text(
                actionText,
                style: TextStyle(
                  color: isBlocked
                      ? (Theme.of(dialogContext).brightness == Brightness.dark
                          ? Theme.of(dialogContext).colorScheme.primary
                          : const Color(0xFF43A047))
                      : Theme.of(dialogContext).colorScheme.error,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
