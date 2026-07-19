import 'dart:async';
import 'dart:math';
import 'package:app/providers/provider_models/message_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/service/chat_api_service.dart';
import 'package:app/service/websocket_service.dart';
import 'package:app/service/connection_state_controller.dart';
import 'package:app/service/message_outbox_service.dart';
import 'dart:io';

// Chat State
class ChatState {
  final List<ChatRoom> chatRooms;
  final List<ChatMessage> messages;
  final List<User> users;
  final bool isLoading;
  final bool isLoadingMessages;
  final bool isAuthenticated;
  final String? token;
  final int? currentUserId;
  final String? currentUsername;
  final int? currentChatRoomId;
  final String? error;
  
  // 🔥 NEW: Enhanced features state
  final Map<int, bool> typingUsers; // userId -> isTyping
  final Map<int, User> onlineUsers; // userId -> User with online status
  final List<int> blockedUserIds; // List of blocked user IDs
  final Map<String, dynamic>? activeCall; // Current active call data

  // 🔥 NEW: Task 13 — local override of a room's listing status (roomId ->
  // 'reserved'/'sold'/'available'), applied on top of `ChatRoom.listing` so
  // the UI updates immediately from the transaction API response and/or the
  // `transaction_updated` WS event without waiting for a full room refetch.
  final Map<int, String> listingStatusOverrides;

  // 🔥 NEW: Pagination state
  final int currentPage; // Current page for messages
  final bool hasMoreMessages; // Whether there are more messages to load
  final bool isLoadingOlderMessages; // Loading older messages flag

  ChatState({
    this.chatRooms = const [],
    this.messages = const [],
    this.users = const [],
    this.isLoading = false,
    this.isLoadingMessages = false,
    this.isAuthenticated = false,
    this.token,
    this.currentUserId,
    this.currentUsername,
    this.currentChatRoomId,
    this.error,
    this.typingUsers = const {},
    this.onlineUsers = const {},
    this.blockedUserIds = const [],
    this.activeCall,
    this.currentPage = 1,
    this.hasMoreMessages = true,
    this.isLoadingOlderMessages = false,
    this.listingStatusOverrides = const {},
  });

  ChatState copyWith({
    List<ChatRoom>? chatRooms,
    List<ChatMessage>? messages,
    List<User>? users,
    bool? isLoading,
    bool? isLoadingMessages,
    bool? isAuthenticated,
    String? token,
    int? currentUserId,
    String? currentUsername,
    int? currentChatRoomId,
    String? error,
    Map<int, bool>? typingUsers,
    Map<int, User>? onlineUsers,
    List<int>? blockedUserIds,
    Map<String, dynamic>? activeCall,
    int? currentPage,
    bool? hasMoreMessages,
    bool? isLoadingOlderMessages,
    Map<int, String>? listingStatusOverrides,
  }) {
    return ChatState(
      chatRooms: chatRooms ?? this.chatRooms,
      messages: messages ?? this.messages,
      users: users ?? this.users,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMessages: isLoadingMessages ?? this.isLoadingMessages,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      token: token ?? this.token,
      currentUserId: currentUserId ?? this.currentUserId,
      currentUsername: currentUsername ?? this.currentUsername,
      currentChatRoomId: currentChatRoomId ?? this.currentChatRoomId,
      error: error,
      // 🔥 FIX: Use existing values if not provided, but ensure non-null defaults
      typingUsers: typingUsers != null ? typingUsers : this.typingUsers,
      onlineUsers: onlineUsers != null ? onlineUsers : this.onlineUsers,
      blockedUserIds: blockedUserIds != null ? blockedUserIds : this.blockedUserIds,
      activeCall: activeCall,
      currentPage: currentPage ?? this.currentPage,
      hasMoreMessages: hasMoreMessages ?? this.hasMoreMessages,
      isLoadingOlderMessages: isLoadingOlderMessages ?? this.isLoadingOlderMessages,
      listingStatusOverrides: listingStatusOverrides ?? this.listingStatusOverrides,
    );
  }
}

// Chat Notifier
class ChatNotifier extends StateNotifier<ChatState> {
  ChatNotifier() : super(ChatState()) {
    // 🔥 NEW: Drain the offline outbox whenever the chat socket comes back up.
    _connStateSubscription =
        ConnectionStateController.instance.stream.listen((connState) {
      if (connState == ConnState.connected) {
        _drainOutbox();
      }
    });
  }

  final ChatApiService _apiService = ChatApiService();

  // 🔥 NEW: Reliability core — offline outbox + optimistic send bookkeeping
  MessageOutboxService? _outbox;
  final Map<String, Timer> _ackTimeouts = {};
  StreamSubscription<ConnState>? _connStateSubscription;
  bool _isDraining = false;
  final Random _random = Random();

  // 🔥 FIX: Safe state update that handles disposed widgets
  void _safeUpdateState(ChatState Function(ChatState) updateFn) {
    try {
      state = updateFn(state);
    } catch (e) {
      // Ignore assertion errors when widgets are disposed
      // This happens when WebSocket updates arrive after widget disposal
      final errorStr = e.toString().toLowerCase();
      if (e is AssertionError && 
          (errorStr.contains('defunct') || 
           errorStr.contains('_lifecyclestate') ||
           errorStr.contains('markneedsbuild'))) {
        // Silently ignore - widget is disposed, no need to update
        return;
      }
      // Re-throw other errors
      rethrow;
    }
  }
  ChatListWebSocketService? _chatListWS;
  ChatRoomWebSocketService? _chatRoomWS;
  bool _isInitializing = false;

  // 🔥 Store subscriptions to properly manage them
  StreamSubscription<Map<String, dynamic>>? _chatListSubscription;
  StreamSubscription<Map<String, dynamic>>? _chatRoomSubscription;

  // Initialize - check existing authentication
  Future<void> initialize() async {

    if (_isInitializing || state.isAuthenticated) {

      return;
    }

    _isInitializing = true;

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final userIdString = prefs.getString('userId');
      final username = prefs.getString('username');

      if (token != null && userIdString != null) {
        final userId = int.tryParse(userIdString);
        if (userId != null) {
          // 🔥 NEW: Load blocked users on initialization
          await loadBlockedUsers();

          _safeUpdateState((s) => s.copyWith(
            isAuthenticated: true,
            token: token,
            currentUserId: userId,
            currentUsername: username,
          ));

          await loadChatRooms();
          await _connectToChatList();

          _isInitializing = false;
        } else {

          _safeUpdateState((s) => s.copyWith(isAuthenticated: false));
          _isInitializing = false;
        }
      } else {

        _safeUpdateState((s) => s.copyWith(isAuthenticated: false));
        _isInitializing = false;
      }
    } catch (e) {

      _safeUpdateState((s) => s.copyWith(error: e.toString(), isAuthenticated: false));
      _isInitializing = false;
    }
  }

  // In chat_provider.dart - add this public method

  Future<void> ensureChatListConnected() async {
    if (!state.isAuthenticated) {
      return;
    }

    // Clear any lingering room-level error when returning to the list.
    if (state.error != null && state.currentChatRoomId == null) {
      print('🔵 [ChatProvider] ensureChatListConnected — clearing stale error: ${state.error}');
      _safeUpdateState((s) => s.copyWith(error: null));
    }

    if (_chatListWS == null || _chatListWS?.isConnected == null) {

      // Cancel old subscription if exists
      await _chatListSubscription?.cancel();
      _chatListSubscription = null;

      // Disconnect old WebSocket
      await _chatListWS?.disconnect();
      _chatListWS = null;

      // Reconnect
      await _connectToChatList();
    } else {

    }
  }

  // Check authentication status
  Future<void> checkAuthStatus() async {

    try {
      final isAuth = await _apiService.isAuthenticated();
      if (isAuth != state.isAuthenticated) {
        if (isAuth) {
          await initialize();
        } else {
          await _clearAuthState();
        }
      }
    } catch (e) {

    }
  }

  // Clear authentication state
  Future<void> _clearAuthState() async {

    // Cancel subscriptions
    await _chatListSubscription?.cancel();
    await _chatRoomSubscription?.cancel();
    _chatListSubscription = null;
    _chatRoomSubscription = null;

    // Disconnect WebSockets
    await _chatListWS?.disconnect();
    await _chatRoomWS?.disconnect();
    _chatListWS = null;
    _chatRoomWS = null;

    state = ChatState();
  }

  // KARROT-STYLE: Get or create direct chat
  Future<ChatRoom?> getOrCreateDirectChat(int targetUserId) async {
    print('🔍 [ChatProvider] getOrCreateDirectChat called for userId: $targetUserId');
    print('🔍 [ChatProvider] isAuthenticated: ${state.isAuthenticated}');

    if (!state.isAuthenticated) {
      print('❌ [ChatProvider] Not authenticated, returning null');
      return null;
    }

    try {
      _safeUpdateState((s) => s.copyWith(isLoading: true, error: null));

      print('🔍 [ChatProvider] Checking existing chat rooms...');

      // 🔥 NEW: Check if chat already exists in current chat rooms
      final existingChat = state.chatRooms.firstWhere(
        (room) {
          // Check if it's a direct chat (not group) with this user
          if (room.isGroup) return false;
          
          // Check if target user is a participant
          return room.participants.any((user) => user.id == targetUserId);
        },
        orElse: () => ChatRoom(
          id: -1,
          name: '',
          participants: [],
          unreadCount: 0,
        ),
      );

      // If chat already exists, return it without calling backend
      if (existingChat.id != -1) {
        print('✅ [ChatProvider] Found existing chat: ${existingChat.id}');
        _safeUpdateState((s) => s.copyWith(isLoading: false));
        return existingChat;
      }

      print('🔍 [ChatProvider] No existing chat found, calling API...');

      // 🔥 NEW: Try new start chat endpoint first (KakaoTalk-style)
      try {
        print('🔍 [ChatProvider] Trying startChatWithUser API...');
        final result = await _apiService.startChatWithUser(targetUserId);
        print('✅ [ChatProvider] startChatWithUser returned: $result');
        final chatData = result['chat'] as Map<String, dynamic>?;
        if (chatData != null) {
          final chatRoom = ChatRoom.fromJson(chatData);

          // Check if this is an existing chat (not newly created)
          final wasCreated = result['created'] as bool? ?? false;
          print('✅ [ChatProvider] Chat ${wasCreated ? "created" : "found"}: ${chatRoom.id}');

          // Reload chat list to sync with backend
          await loadChatRooms();

          _safeUpdateState((s) => s.copyWith(isLoading: false));

          return chatRoom;
        }
      } catch (e) {
        print('⚠️ [ChatProvider] startChatWithUser failed: $e');
      }

      // Fallback to old endpoint
      print('🔍 [ChatProvider] Trying fallback getOrCreateDirectChat API...');
      final chatRoom = await _apiService.getOrCreateDirectChat(targetUserId);
      print('✅ [ChatProvider] Fallback returned: ${chatRoom?.id}');

      // Reload chat list
      await loadChatRooms();

      _safeUpdateState((s) => s.copyWith(isLoading: false));

      return chatRoom;
    } catch (e) {
      print('❌ [ChatProvider] getOrCreateDirectChat error: $e');
      _safeUpdateState((s) => s.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
      return null;
    }
  }
  
  // 🔥 NEW: Search users (KakaoTalk-style)
  Future<List<Map<String, dynamic>>> searchUsers({String? query, int? userId}) async {
    if (!state.isAuthenticated) {

      return [];
    }

    try {
      return await _apiService.searchUsers(query: query, userId: userId);
    } catch (e) {

      return [];
    }
  }

  // Chat Rooms
  Future<void> loadChatRooms() async {

    if (!state.isAuthenticated) {

      return;
    }

    try {
      _safeUpdateState((s) => s.copyWith(isLoading: true, error: null));

      final chatRooms = await _apiService.getChatRooms();

      // Apply local pin state
      final prefs = await SharedPreferences.getInstance();
      final pinnedIds = prefs.getStringList('pinned_chats') ?? [];
      final roomsWithPins = chatRooms.map((room) {
        if (pinnedIds.contains(room.id.toString())) {
          return ChatRoom(
            id: room.id,
            name: room.name,
            createdAt: room.createdAt,
            updatedAt: room.updatedAt,
            participants: room.participants,
            lastMessagePreview: room.lastMessagePreview,
            lastMessageTimestamp: room.lastMessageTimestamp,
            unreadCount: room.unreadCount,
            isGroup: room.isGroup,
            isPinned: true,
          );
        }
        return room;
      }).toList();

      // 🔥 DEBUG: Log unread counts from API
      for (var room in roomsWithPins) {
        print('📬 [ChatProvider] Room ${room.id} (${room.name}): unread_count=${room.unreadCount}');
      }

      _safeUpdateState((s) => s.copyWith(
        isLoading: false,
        chatRooms: roomsWithPins,
        // Fresh server data supersedes any local transaction-status
        // overrides — clear them so a stale override can't shadow the
        // listing status the backend just returned.
        listingStatusOverrides: const {},
      ));

      // 🔥 NEW: Also request list refresh via WebSocket to ensure sync
      if (_chatListWS != null && _chatListWS!.isConnected) {
        _chatListWS!.requestListRefresh();
        print('✅ [ChatProvider] Requested chat list refresh via WebSocket');
      }

    } catch (e) {

      if (e.toString().contains('Authentication failed')) {
        await _clearAuthState();
      } else {
        _safeUpdateState((s) => s.copyWith(
          isLoading: false,
          error: e.toString(),
        ));
      }
    }
  }

  Future<bool> createChatRoom(String name, List<int> participantIds) async {

    if (!state.isAuthenticated) {

      return false;
    }

    try {
      _safeUpdateState((s) => s.copyWith(isLoading: true, error: null));

      await _apiService.createChatRoom(name, participantIds);
      await loadChatRooms();

      _safeUpdateState((s) => s.copyWith(isLoading: false));

      return true;
    } catch (e) {

      _safeUpdateState((s) => s.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
      return false;
    }
  }

  /// Toggle pin state for a chat room (stored locally)
  Future<void> togglePinChat(int chatId) async {
    final prefs = await SharedPreferences.getInstance();
    final pinnedIds = prefs.getStringList('pinned_chats') ?? [];

    if (pinnedIds.contains(chatId.toString())) {
      pinnedIds.remove(chatId.toString());
    } else {
      pinnedIds.add(chatId.toString());
    }
    await prefs.setStringList('pinned_chats', pinnedIds);

    final updatedRooms = state.chatRooms.map((room) {
      if (room.id == chatId) {
        return ChatRoom(
          id: room.id,
          name: room.name,
          createdAt: room.createdAt,
          updatedAt: room.updatedAt,
          participants: room.participants,
          lastMessagePreview: room.lastMessagePreview,
          lastMessageTimestamp: room.lastMessageTimestamp,
          unreadCount: room.unreadCount,
          isGroup: room.isGroup,
          isPinned: !room.isPinned,
        );
      }
      return room;
    }).toList();

    _safeUpdateState((s) => s.copyWith(chatRooms: updatedRooms));
  }

  Future<bool> deleteChatRoom(int chatId) async {

    if (!state.isAuthenticated) {
      return false;
    }

    try {
      await _apiService.deleteChatRoom(chatId);

      final updatedRooms =
          state.chatRooms.where((room) => room.id != chatId).toList();
      _safeUpdateState((s) => s.copyWith(chatRooms: updatedRooms));

      return true;
    } catch (e) {

      _safeUpdateState((s) => s.copyWith(error: e.toString()));
      return false;
    }
  }

  // In chat_provider.dart

  Future<void> connectToChatRoom(int roomId) async {

    // 🔥 IMPORTANT: Ensure chat list is still connected
    if (_chatListWS == null || _chatListWS!.isConnected == null) {

      await _connectToChatList();
    }

    if (!state.isAuthenticated) {

      return;
    }

    try {
      // Don't disconnect if we're already connected to the same room
      if (state.currentChatRoomId == roomId &&
          _chatRoomWS != null &&
          _chatRoomWS!.isConnected) {

        return;
      }

      // Only disconnect previous room if connecting to a different one
      if (state.currentChatRoomId != roomId) {
        await _chatRoomSubscription?.cancel();
        await _chatRoomWS?.disconnect();
        _chatRoomSubscription = null;
        _chatRoomWS = null;
      }

      _safeUpdateState((s) => s.copyWith(
        currentChatRoomId: roomId,
        messages: [],
        error: null,
        // 🔥 NEW: Reset pagination when switching rooms
        currentPage: 1,
        hasMoreMessages: true,
        isLoadingOlderMessages: false,
      ));

      // Load messages first
      await loadChatMessages(roomId);
      
      // 🔥 NEW: Reset unread_count when opening a chat room (mark as read)
      final updatedRooms = state.chatRooms.map((room) {
        if (room.id == roomId) {
          return ChatRoom(
            id: room.id,
            name: room.name,
            createdAt: room.createdAt,
            updatedAt: room.updatedAt,
            participants: room.participants,
            lastMessagePreview: room.lastMessagePreview,
            lastMessageTimestamp: room.lastMessageTimestamp,
            unreadCount: 0, // Reset unread count when viewing
            isGroup: room.isGroup,
            isPinned: room.isPinned,
          );
        }
        return room;
      }).toList();
      _safeUpdateState((s) => s.copyWith(chatRooms: updatedRooms));

      // Connect WebSocket — service awaits connection_established before returning.
      _chatRoomWS = ChatRoomWebSocketService();
      await _chatRoomWS!.connectToChatRoom(roomId);

      // Guard: disconnectFromChatRoom() may have been called during the await
      // above (e.g. user pressed back while connecting), which sets _chatRoomWS
      // to null. Bail out silently — no error to show.
      final ws = _chatRoomWS;
      if (ws == null) {
        print('🔵 [ChatProvider] connectToChatRoom: ws nulled during connect, aborting');
        return;
      }

      if (ws.isConnected) {
        print('✅ [ChatProvider] WebSocket connected to room $roomId');

        _chatRoomSubscription = ws.messages.listen(
          (data) { _handleChatRoomMessage(data); },
          onError: (error) {
            print('❌ [ChatProvider] WebSocket error: $error');
          },
          onDone: () {
            print('🔌 [ChatProvider] WebSocket stream done');
          },
        );

        ws.sendReadReceipt();
      } else {
        print('❌ [ChatProvider] WebSocket connected but stream already closed for room $roomId');
        // Stream closed before first use — not a user-visible error, just reconnect
      }
    } catch (e) {
      print('🔴 [ChatProvider] connectToChatRoom error: $e');
      _safeUpdateState((s) => s.copyWith(error: e.toString()));
    }
  }

  Future<void> loadChatMessages(int roomId, {bool loadOlder = false}) async {

    if (!state.isAuthenticated) {
      return;
    }

    try {
      if (loadOlder) {
        // Loading older messages (pagination)
        if (!state.hasMoreMessages || state.isLoadingOlderMessages) {

          return;
        }
        
        _safeUpdateState((s) => s.copyWith(isLoadingOlderMessages: true, error: null));
        
        final nextPage = state.currentPage + 1;
        final result = await _apiService.getChatMessagesPaginated(roomId, page: nextPage, pageSize: 50);
        
        final olderMessages = result['messages'] as List<ChatMessage>;
        final hasNext = result['hasNext'] as bool;
        
        if (olderMessages.isNotEmpty) {
          // Prepend older messages to the beginning
          final updatedMessages = [...olderMessages, ...state.messages];
          _safeUpdateState((s) => s.copyWith(
            isLoadingOlderMessages: false,
            messages: updatedMessages,
            currentPage: nextPage,
            hasMoreMessages: hasNext,
          ));
        } else {
          _safeUpdateState((s) => s.copyWith(
            isLoadingOlderMessages: false,
            hasMoreMessages: false,
          ));

        }
      } else {
        // Initial load
        _safeUpdateState((s) => s.copyWith(isLoadingMessages: true, error: null));

        final result = await _apiService.getChatMessagesPaginated(roomId, page: 1, pageSize: 50);
        final messages = result['messages'] as List<ChatMessage>;
        final hasNext = result['hasNext'] as bool;

        _safeUpdateState((s) => s.copyWith(
          isLoadingMessages: false,
          messages: messages,
          currentPage: 1,
          hasMoreMessages: hasNext,
        ));

      }
    } catch (e) {

      _safeUpdateState((s) => s.copyWith(
        isLoadingMessages: false,
        isLoadingOlderMessages: false,
        error: e.toString(),
      ));
    }
  }
  
  // 🔥 NEW: Load older messages (pagination)
  Future<void> loadOlderMessages() async {
    if (state.currentChatRoomId == null) {
      return;
    }
    await loadChatMessages(state.currentChatRoomId!, loadOlder: true);
  }

  // Add after your existing methods in ChatNotifier class

// 🔥 NEW: Send image message
  Future<bool> sendImageMessage(File imageFile, int roomId) async {

    if (!state.isAuthenticated) {

      return false;
    }

    try {
      _safeUpdateState((s) => s.copyWith(isLoading: true, error: null));

      // Upload image via API
      final message = await _apiService.sendImageMessage(imageFile, roomId);

      // 🔥 FIX: Don't add message here - it will come via WebSocket
      // This prevents double messages. Only add if WebSocket fails to deliver
      // The message will be automatically added when received via WebSocket
      _safeUpdateState((s) => s.copyWith(isLoading: false));

      return true;
    } catch (e) {

      _safeUpdateState((s) => s.copyWith(
        isLoading: false,
        error: 'Failed to send image: $e',
      ));
      return false;
    }
  }

// 🔥 NEW: Send voice message
  Future<bool> sendVoiceMessage(
      File audioFile, int roomId, int duration) async {

    if (!state.isAuthenticated) {

      return false;
    }

    try {
      _safeUpdateState((s) => s.copyWith(isLoading: true, error: null));

      // Upload voice via API
      final message =
          await _apiService.sendVoiceMessage(audioFile, roomId, duration);

      // 🔥 FIX: Don't add message here - it will come via WebSocket
      // This prevents double messages
      _safeUpdateState((s) => s.copyWith(isLoading: false));

      return true;
    } catch (e) {

      _safeUpdateState((s) => s.copyWith(
        isLoading: false,
        error: 'Failed to send voice: $e',
      ));
      return false;
    }
  }

  // 🔥 NEW: Reliability core helpers (optimistic send + offline outbox) ----

  Future<MessageOutboxService> _ensureOutbox() async {
    final existing = _outbox;
    if (existing != null) return existing;
    final prefs = await SharedPreferences.getInstance();
    final created = MessageOutboxService(prefs);
    _outbox = created;
    return created;
  }

  /// Client-generated id for optimistic messages. Not a real UUID — the
  /// `uuid` package isn't a direct dependency here, and timestamp + random
  /// suffix is unique enough for a single-device outbox key.
  String _generateLocalId() {
    final ts = DateTime.now().microsecondsSinceEpoch;
    final rand = _random.nextInt(1 << 32);
    return '$ts-$rand';
  }

  void _updateMessageByLocalId(
    String localId,
    ChatMessage Function(ChatMessage) update,
  ) {
    final idx = state.messages.indexWhere((m) => m.localId == localId);
    if (idx == -1) return;
    final updated = List<ChatMessage>.from(state.messages);
    updated[idx] = update(updated[idx]);
    _safeUpdateState((s) => s.copyWith(messages: updated));
  }

  void _cancelAckTimeout(String localId) {
    _ackTimeouts.remove(localId)?.cancel();
  }

  void _startAckTimeout(String localId, int roomId, String content) {
    _cancelAckTimeout(localId);
    _ackTimeouts[localId] = Timer(const Duration(seconds: 10), () {
      _ackTimeouts.remove(localId);
      _markFailedAndEnqueue(localId, roomId, content);
    });
  }

  Future<void> _markFailedAndEnqueue(
    String localId,
    int roomId,
    String content,
  ) async {
    _updateMessageByLocalId(
      localId,
      (m) => m.copyWith(deliveryStatus: DeliveryStatus.failed),
    );
    final outbox = await _ensureOutbox();
    // 🔥 FIX: Carry forward the existing attempt count for this localId, if
    // already queued. Without this, every re-enqueue (e.g. a fresh 10s ack
    // timeout after a drain retry) resets attempts to 0 and `maxAttempts`
    // never triggers, so a permanently-unreachable message retries forever.
    final existing = outbox.getByLocalId(localId);
    await outbox.enqueue(OutboxEntry(
      localId: localId,
      roomId: roomId,
      content: content,
      createdAt: DateTime.now(),
      attempts: existing?.attempts ?? 0,
    ));
  }

  /// Replays queued messages for the current room, sequentially, once the
  /// connection is back up. Entries that have exhausted [MessageOutboxService.maxAttempts]
  /// are dropped from the queue and left permanently `failed`.
  Future<void> _drainOutbox() async {
    if (_isDraining) return;
    final roomId = state.currentChatRoomId;
    if (roomId == null) return;

    _isDraining = true;
    try {
      final outbox = await _ensureOutbox();
      final pending = outbox.pendingFor(roomId);

      for (final entry in pending) {
        if (_chatRoomWS == null || !_chatRoomWS!.isConnected) break;

        if (entry.attempts + 1 > MessageOutboxService.maxAttempts) {
          await outbox.remove(entry.localId);
          _updateMessageByLocalId(
            entry.localId,
            (m) => m.copyWith(deliveryStatus: DeliveryStatus.failed),
          );
          continue;
        }

        await outbox.incrementAttempts(entry.localId);
        _updateMessageByLocalId(
          entry.localId,
          (m) => m.copyWith(deliveryStatus: DeliveryStatus.sending),
        );
        _chatRoomWS!.sendChatMessage(entry.content ?? '', localId: entry.localId);
        _startAckTimeout(entry.localId, roomId, entry.content ?? '');

        // Small pacing gap so we don't fire the whole queue in one frame.
        await Future.delayed(const Duration(milliseconds: 250));
      }
    } finally {
      _isDraining = false;
    }
  }

  /// Tap-to-retry for a failed bubble: re-enqueues (if needed) and attempts
  /// an immediate resend when connected.
  Future<void> retryMessage(String localId) async {
    ChatMessage? message;
    for (final m in state.messages) {
      if (m.localId == localId) {
        message = m;
        break;
      }
    }
    final roomId = state.currentChatRoomId;
    if (message == null || roomId == null) return;

    _updateMessageByLocalId(
      localId,
      (m) => m.copyWith(deliveryStatus: DeliveryStatus.sending),
    );

    final outbox = await _ensureOutbox();
    final alreadyQueued = outbox.all().any((e) => e.localId == localId);
    if (!alreadyQueued) {
      await outbox.enqueue(OutboxEntry(
        localId: localId,
        roomId: roomId,
        content: message.content,
        createdAt: DateTime.now(),
      ));
    }

    if (_chatRoomWS != null && _chatRoomWS!.isConnected) {
      await _drainOutbox();
    } else {
      _updateMessageByLocalId(
        localId,
        (m) => m.copyWith(deliveryStatus: DeliveryStatus.failed),
      );
    }
  }

  void sendMessage(String content) {
    print('📤 ChatProvider.sendMessage called with: "$content"');
    final trimmedContent = content.trim();

    if (trimmedContent.isEmpty) {
      print('❌ Message is empty, returning');
      return;
    }

    if (!state.isAuthenticated) {
      print('❌ Not authenticated');
      _safeUpdateState((s) => s.copyWith(error: 'Not authenticated'));
      return;
    }

    final roomId = state.currentChatRoomId;
    if (roomId == null || state.currentUserId == null) {
      _safeUpdateState((s) => s.copyWith(error: 'Not connected. Please wait...'));
      return;
    }

    print('📤 _chatRoomWS: ${_chatRoomWS != null ? "exists" : "null"}');
    print('📤 _chatRoomWS.isConnected: ${_chatRoomWS?.isConnected}');

    // 🔥 NEW: Optimistic send — append a `sending` bubble immediately with a
    // client-generated local_id, so the UI never blocks on the network.
    final localId = _generateLocalId();
    final optimisticMessage = ChatMessage(
      id: null,
      messageType: MessageType.text,
      content: trimmedContent,
      sender: User(
        id: state.currentUserId!,
        username: state.currentUsername ?? '',
      ),
      timestamp: DateTime.now(),
      localId: localId,
      deliveryStatus: DeliveryStatus.sending,
    );
    _safeUpdateState(
      (s) => s.copyWith(messages: [...s.messages, optimisticMessage]),
    );

    final socketUp = _chatRoomWS != null && _chatRoomWS!.isConnected;
    if (!socketUp) {
      _markFailedAndEnqueue(localId, roomId, trimmedContent);

      // Try to reconnect
      connectToChatRoom(roomId);
      return;
    }

    print('📤 Calling _chatRoomWS.sendChatMessage');
    _chatRoomWS!.sendChatMessage(trimmedContent, localId: localId);
    _startAckTimeout(localId, roomId, trimmedContent);
  }

  // 🔥 NEW: Task 13 — seller reserve/sold/available action from the chat
  // room app bar. Reflects the resulting status locally right away; the
  // system message(s) + `transaction_updated` WS broadcast also arrive
  // shortly after and are no-ops against this (same target status).
  Future<bool> updateTransactionStatus(int chatId, String action) async {
    if (!state.isAuthenticated) return false;

    try {
      final result = await _apiService.updateTransactionStatus(chatId, action);
      _applyListingStatus(chatId, result.status);
      return true;
    } catch (e) {
      _safeUpdateState((s) => s.copyWith(error: e.toString()));
      return false;
    }
  }

  /// Applies a new listing status for [roomId] to both the override map
  /// (read by `ChatRoomScreen`/`ChatAppBar` for the room currently open,
  /// which may not be present in `chatRooms` yet) and, if present, the
  /// matching entry in `chatRooms` (read by the chat list's listing chip).
  void _applyListingStatus(int roomId, String status) {
    final updatedOverrides = Map<int, String>.from(state.listingStatusOverrides);
    updatedOverrides[roomId] = status;

    final updatedRooms = state.chatRooms.map((room) {
      if (room.id == roomId && room.listing != null) {
        return room.copyWith(listing: room.listing!.copyWith(status: status));
      }
      return room;
    }).toList();

    _safeUpdateState((s) => s.copyWith(
      listingStatusOverrides: updatedOverrides,
      chatRooms: updatedRooms,
    ));
  }

  void sendTypingStatus(bool isTyping) {
    if (_chatRoomWS != null &&
        _chatRoomWS!.isConnected &&
        state.isAuthenticated) {
      _chatRoomWS!.sendTypingStatus(isTyping);
    }
  }

  void disconnectFromChatRoom() {
    print('🔵 [ChatProvider] disconnectFromChatRoom — error before clear: ${state.error}');
    // Only disconnect chat room WebSocket
    _chatRoomSubscription?.cancel();
    _chatRoomWS?.disconnect();
    _chatRoomSubscription = null;
    _chatRoomWS = null;

    _safeUpdateState((s) => s.copyWith(
      currentChatRoomId: null,
      messages: [],
      error: null,
    ));
    print('🟢 [ChatProvider] disconnectFromChatRoom done — error cleared');
  }

  // Users
  Future<void> loadUsers() async {

    if (!state.isAuthenticated) {
      return;
    }

    try {
      final users = await _apiService.getUsers();

      _safeUpdateState((s) => s.copyWith(users: users));

    } catch (e) {

    }
  }

  Future<void> _connectToChatList() async {
    if (!state.isAuthenticated) {

      return;
    }

    try {

      _chatListWS = ChatListWebSocketService();
      await _chatListWS!.connectToChatList();

      // 🔥 Properly set up subscription with error handling
      _chatListSubscription = _chatListWS!.messages.listen(
        (data) {
          _handleChatListMessage(data);
        },
        onError: (error) {

          // Try to reconnect on error
          Future.delayed(const Duration(seconds: 2), () {
            if (state.isAuthenticated) {

              ensureChatListConnected();
            }
          });
        },
        onDone: () {

          // Try to reconnect when closed
          Future.delayed(const Duration(seconds: 2), () {
            if (state.isAuthenticated) {

              ensureChatListConnected();
            }
          });
        },
        cancelOnError: false,
      );

    } catch (e) {

    }
  }

  void _handleChatListMessage(Map<String, dynamic> data) {

    switch (data['type']) {
      case 'chatroom_list':
        try {

          final chatroomsRaw = data['chatrooms'];
          if (chatroomsRaw == null || chatroomsRaw is! List) {

            return;
          }

          // 🔥 NEW: Load full user data for participants if we only have IDs
          final chatRooms = <ChatRoom>[];
          for (var roomData in chatroomsRaw) {
            try {
              final room = ChatRoom.fromJson(roomData);
              
              // 🔥 NEW: If participants are just IDs, try to get full user data from state
              if (room.participants.isEmpty && roomData['participant_ids'] != null) {
                final participantIds = (roomData['participant_ids'] as List).cast<int>();
                final fullParticipants = participantIds.map((id) {
                  // Try to find user in existing state
                  final existingUser = state.users.firstWhere(
                    (u) => u.id == id,
                    orElse: () => User(id: id, username: 'User $id'),
                  );
                  return existingUser;
                }).toList();
                
                // Update room with full participants
                final updatedRoom = ChatRoom(
                  id: room.id,
                  name: room.name,
                  createdAt: room.createdAt,
                  updatedAt: room.updatedAt,
                  participants: fullParticipants,
                  lastMessagePreview: room.lastMessagePreview,
                  lastMessageTimestamp: room.lastMessageTimestamp,
                  unreadCount: room.unreadCount,
                  isGroup: room.isGroup,
                  isPinned: room.isPinned,
                );
                chatRooms.add(updatedRoom);
              } else {
                chatRooms.add(room);
              }
            } catch (e) {

            }
          }

          // 🔥 DEBUG: Log unread counts
          for (var room in chatRooms) {
          }

          // 🔥 NEW: Filter blocked users (backend already filters, but double-check)
          final blockedUserIds = state.blockedUserIds;
          final filteredRooms = chatRooms.where((room) {
            if (!room.isGroup && room.participants.isNotEmpty) {
              // For direct chats, check if any participant is blocked
              return !room.participants.any((p) => blockedUserIds.contains(p.id));
            }
            return true;
          }).toList();

          // 🔥 Update state - this should trigger UI rebuild
          _safeUpdateState((s) => s.copyWith(chatRooms: filteredRooms));

          // Print first room preview
          if (filteredRooms.isNotEmpty) {

          }
        } catch (e, stackTrace) {

        }
        break;

      case 'chatroom_created':

        loadChatRooms();
        break;

      case 'connection_established':

        break;

      case 'error':

        break;

      default:

    }

  }

  /// Builds an updated `chatRooms` list reflecting [message] as the newest
  /// message in its room: refreshes `lastMessagePreview`/`lastMessageTimestamp`
  /// and bumps `unreadCount` when appropriate. Shared by both the normal
  /// incoming-message path and the sender's own ack replace-in-place path,
  /// since the backend only pushes `new_message_notification` to OTHER
  /// participants — the sender must update their own chat-list preview
  /// locally on ack.
  List<ChatRoom> _updatedChatRoomsWithPreview(ChatMessage message) {
    final currentRoomId = state.currentChatRoomId;
    final isFromOtherUser = message.sender.id != state.currentUserId;

    return state.chatRooms.map((room) {
      if (room.id == currentRoomId) {
        // Update last message preview and timestamp
        final newPreview = message.content ??
            (message.messageType == MessageType.image
                ? '📷 Photo'
                : message.messageType == MessageType.voice
                    ? '🎤 Voice message'
                    : room.lastMessagePreview);

        // 🔥 FIX: Increment unread_count only if:
        // 1. Message is from another user
        // 2. User is NOT currently viewing this chat room
        final shouldIncrementUnread = isFromOtherUser &&
            (currentRoomId == null || currentRoomId != room.id);

        return ChatRoom(
          id: room.id,
          name: room.name,
          createdAt: room.createdAt,
          updatedAt: room.updatedAt,
          participants: room.participants,
          lastMessagePreview: newPreview,
          lastMessageTimestamp: message.timestamp,
          unreadCount: shouldIncrementUnread
              ? room.unreadCount + 1
              : room.unreadCount,
          isGroup: room.isGroup,
          isPinned: room.isPinned,
        );
      }
      return room;
    }).toList();
  }

  void _handleChatRoomMessage(Map<String, dynamic> data) {

    switch (data['type']) {
      case 'message':
        try {
          final message = ChatMessage.fromJson(data);

          // 🔥 NEW: Reliability core — if this message echoes a local_id we
          // already have an optimistic (id == null) bubble for, replace that
          // bubble in place instead of appending a duplicate. This is how
          // both the direct-send ack and any drained-outbox resend resolve.
          if (message.localId != null) {
            _cancelAckTimeout(message.localId!);
            final localIdx = state.messages.indexWhere(
              (m) => m.localId == message.localId && m.id == null,
            );
            if (localIdx != -1) {
              final updatedMessages = List<ChatMessage>.from(state.messages);
              updatedMessages[localIdx] = message.copyWith(
                deliveryStatus: message.deliveryStatus == DeliveryStatus.sending
                    ? DeliveryStatus.sent
                    : message.deliveryStatus,
              );
              // 🔥 FIX: The backend only pushes `new_message_notification` to
              // OTHER participants, so the sender's own chat-list preview
              // never refreshes on ack unless we update it here too.
              final updatedChatRoomsForAck = _updatedChatRoomsWithPreview(message);
              _safeUpdateState((s) => s.copyWith(
                messages: updatedMessages,
                chatRooms: updatedChatRoomsForAck,
              ));
              _ensureOutbox().then((o) => o.remove(message.localId!));
              return;
            }
          }

          // 🔥 FIX: Check for duplicate messages by ID to prevent double sending
          final existingIndex = state.messages.indexWhere((m) => m.id == message.id);
          if (existingIndex != -1) {
            // 🔥 NEW: Message exists - check if read_by was updated
            final existingMsg = state.messages[existingIndex];
            final newReaders = message.readBy.where((id) => !existingMsg.readBy.contains(id)).toList();

            if (newReaders.isNotEmpty || message.isRead != existingMsg.isRead) {
              // Update existing message with new read status
              final updatedMessages = List<ChatMessage>.from(state.messages);
              updatedMessages[existingIndex] = ChatMessage(
                id: existingMsg.id,
                messageType: existingMsg.messageType,
                content: existingMsg.content,
                file: existingMsg.file,
                fileUrl: existingMsg.fileUrl,
                duration: existingMsg.duration,
                sender: existingMsg.sender,
                timestamp: existingMsg.timestamp,
                updatedAt: existingMsg.updatedAt,
                isRead: message.isRead || existingMsg.isRead,
                readBy: [...existingMsg.readBy, ...newReaders],
                isEdited: existingMsg.isEdited,
                isDeleted: existingMsg.isDeleted,
                replyTo: existingMsg.replyTo,
                reactions: existingMsg.reactions,
              );
              _safeUpdateState((s) => s.copyWith(messages: updatedMessages));
              print('✅ [ChatProvider] Updated message ${message.id} read status');
            }
            return;
          }

          // 🔥 NEW: If message is from another user and we're viewing this chat,
          // automatically send a read receipt so the sender knows we read it
          final isFromOtherUser = message.sender.id != state.currentUserId;
          if (isFromOtherUser && message.id != null && _chatRoomWS != null && _chatRoomWS!.isConnected) {
            print('📬 [ChatProvider] Auto-sending read receipt for message ${message.id} from ${message.sender.username}');
            _chatRoomWS!.markMessageAsRead(message.id!);
          }

          final updatedMessages = [...state.messages, message];

          // 🔥 NEW: Update unread_count and last message preview in chat room list
          // When a message arrives, update the corresponding chat room
          final updatedChatRooms = _updatedChatRoomsWithPreview(message);

          _safeUpdateState((s) => s.copyWith(
            messages: updatedMessages,
            chatRooms: updatedChatRooms,
          ));

        } catch (e) {

        }
        break;
        
      // 🔥 NEW: Message updated (edited)
      case 'message_updated':
        try {
          final messageId = data['id'] as int?;
          if (messageId != null) {
            final updatedMessages = state.messages.map((msg) {
              if (msg.id == messageId) {
                return ChatMessage(
                  id: msg.id,
                  messageType: msg.messageType,
                  content: data['content'] as String? ?? msg.content,
                  file: msg.file,
                  fileUrl: msg.fileUrl,
                  duration: msg.duration,
                  sender: msg.sender,
                  timestamp: msg.timestamp,
                  updatedAt: data['updated_at'] != null
                      ? DateTime.parse(data['updated_at'] as String).toLocal() // 🔥 Convert UTC to local time
                      : msg.updatedAt,
                  isRead: msg.isRead,
                  readBy: msg.readBy,
                  isEdited: data['is_edited'] as bool? ?? true,
                  isDeleted: msg.isDeleted,
                  replyTo: msg.replyTo,
                  reactions: msg.reactions,
                );
              }
              return msg;
            }).toList();
            _safeUpdateState((s) => s.copyWith(messages: updatedMessages));

          }
        } catch (e) {

        }
        break;
        
      // 🔥 NEW: Message deleted (soft delete)
      case 'message_deleted':
        try {
          final messageId = data['message_id'] as int?;
          if (messageId != null) {
            final updatedMessages = state.messages.map((msg) {
              if (msg.id == messageId) {
                return ChatMessage(
                  id: msg.id,
                  messageType: msg.messageType,
                  content: msg.content,
                  file: msg.file,
                  fileUrl: msg.fileUrl,
                  duration: msg.duration,
                  sender: msg.sender,
                  timestamp: msg.timestamp,
                  updatedAt: msg.updatedAt,
                  isRead: msg.isRead,
                  readBy: msg.readBy,
                  isEdited: msg.isEdited,
                  isDeleted: true,
                  replyTo: msg.replyTo,
                  reactions: msg.reactions,
                );
              }
              return msg;
            }).toList();
            _safeUpdateState((s) => s.copyWith(messages: updatedMessages));

          }
        } catch (e) {

        }
        break;
        
      // 🔥 NEW: Message reaction updated
      case 'message_reaction':
        try {
          final messageId = data['message_id'] as int?;
          if (messageId != null && data['reactions'] != null) {
            final reactionsData = data['reactions'] as Map<String, dynamic>;
            Map<String, List<int>> reactions = {};
            reactionsData.forEach((emoji, userIds) {
              if (userIds is List) {
                reactions[emoji] = userIds.map((id) => id as int).toList();
              }
            });
            
            final updatedMessages = state.messages.map((msg) {
              if (msg.id == messageId) {
                return ChatMessage(
                  id: msg.id,
                  messageType: msg.messageType,
                  content: msg.content,
                  file: msg.file,
                  fileUrl: msg.fileUrl,
                  duration: msg.duration,
                  sender: msg.sender,
                  timestamp: msg.timestamp,
                  updatedAt: msg.updatedAt,
                  isRead: msg.isRead,
                  readBy: msg.readBy,
                  isEdited: msg.isEdited,
                  isDeleted: msg.isDeleted,
                  replyTo: msg.replyTo,
                  reactions: reactions,
                );
              }
              return msg;
            }).toList();
            _safeUpdateState((s) => s.copyWith(messages: updatedMessages));

          }
        } catch (e) {

        }
        break;
        
      // 🔥 NEW: Typing indicator
      case 'typing':
        try {

          final userId = data['user_id'] as int?;
          final username = data['username'] as String?;
          final isTyping = data['is_typing'] as bool? ?? false;

          if (userId != null) {
            // 🔥 FIX: Only ignore if it's the current user typing (we don't need to show our own typing)
            // But we should still process it to update the state correctly
            if (userId == state.currentUserId) {
              // Still update state to clear any stale typing status
              final updatedTypingUsers = Map<int, bool>.from(state.typingUsers);
              updatedTypingUsers.remove(userId);
              _safeUpdateState((s) => s.copyWith(typingUsers: updatedTypingUsers));
            } else {
              // This is another user typing - show it!
              final updatedTypingUsers = Map<int, bool>.from(state.typingUsers);
              if (isTyping) {
                updatedTypingUsers[userId] = true;
              } else {
                updatedTypingUsers.remove(userId);
              }
              _safeUpdateState((s) => s.copyWith(typingUsers: updatedTypingUsers));
            }
          } else {

          }
        } catch (e, stackTrace) {

        }
        break;
        
      // 🔥 NEW: Presence/online status
      case 'presence':
        try {
          final userId = data['user_id'] as int?;
          final isOnline = data['is_online'] as bool? ?? false;
          final lastSeen = data['last_seen'] != null
              ? DateTime.parse(data['last_seen'] as String).toLocal() // 🔥 Convert UTC to local time
              : null;
          
          if (userId != null) {
            final updatedOnlineUsers = Map<int, User>.from(state.onlineUsers);
            
            // 🔥 NEW: Try to get full user data from state.users or chat rooms
            User? userData;
            final existingUser = updatedOnlineUsers[userId];
            if (existingUser != null) {
              userData = existingUser;
            } else {
              // Try to find user in state.users
              try {
                userData = state.users.firstWhere((u) => u.id == userId);
              } catch (e) {
                // Try to find in chat room participants
                for (var room in state.chatRooms) {
                  try {
                    userData = room.participants.firstWhere((p) => p.id == userId);
                    break;
                  } catch (e) {
                    continue;
                  }
                }
                userData ??= User(id: userId, username: 'User $userId');
              }
            }
            
            // Update user with online status
            updatedOnlineUsers[userId] = User(
              id: userData.id,
              username: userData.username,
              email: userData.email,
              firstName: userData.firstName,
              lastName: userData.lastName,
              isOnline: isOnline,
              lastSeen: lastSeen,
            );
            
            // 🔥 NEW: Also update participants in chat rooms
            final updatedChatRooms = state.chatRooms.map((room) {
              final updatedParticipants = room.participants.map((p) {
                if (p.id == userId) {
                  return User(
                    id: p.id,
                    username: p.username,
                    email: p.email,
                    firstName: p.firstName,
                    lastName: p.lastName,
                    isOnline: isOnline,
                    lastSeen: lastSeen,
                  );
                }
                return p;
              }).toList();
              
              return ChatRoom(
                id: room.id,
                name: room.name,
                createdAt: room.createdAt,
                updatedAt: room.updatedAt,
                participants: updatedParticipants,
                lastMessagePreview: room.lastMessagePreview,
                lastMessageTimestamp: room.lastMessageTimestamp,
                unreadCount: room.unreadCount,
                isGroup: room.isGroup,
                isPinned: room.isPinned,
              );
            }).toList();

            _safeUpdateState((s) => s.copyWith(
              onlineUsers: updatedOnlineUsers,
              chatRooms: updatedChatRooms,
            ));

          }
        } catch (e) {

        }
        break;
        
      // 🔥 NEW: Call initiated
      case 'call_initiated':
        try {
          final callData = data['call_data'] as Map<String, dynamic>?;
          if (callData != null) {
            _safeUpdateState((s) => s.copyWith(activeCall: callData));

          }
        } catch (e) {

        }
        break;
        
      // 🔥 NEW: Call updated
      case 'call_updated':
        try {
          final callData = data['call_data'] as Map<String, dynamic>?;
          if (callData != null) {
            _safeUpdateState((s) => s.copyWith(activeCall: callData));

          }
        } catch (e) {

        }
        break;
        
      // 🔥 NEW: WebRTC signaling
      case 'webrtc_signal':
        try {
          final signalType = data['signal_type'] as String?;
          final signalData = data['data'] as Map<String, dynamic>?;

          // Handle WebRTC signaling (offer, answer, ice-candidate)
          // This would typically be handled by a WebRTC service
        } catch (e) {

        }
        break;
        
      case 'connection_established':
        print('✅ [ChatProvider] Connection established');
        break;

      // 🔥 NEW: Task 13 — seller reserve/sold/available broadcast. The
      // system message(s) themselves arrive as separate 'message' events
      // (handled above); this just syncs the listing status chip/menu.
      case 'transaction_updated':
        final rawListingStatus = data['listing_status'];
        final transactionRoomId = state.currentChatRoomId;
        if (rawListingStatus is String && transactionRoomId != null) {
          _applyListingStatus(transactionRoomId, rawListingStatus);
        }
        break;

      // 🔥 NEW: Handle message status update (delivery/read status)
      case 'message_status':
      case 'delivery_status':
        try {
          print('📬 [ChatProvider] Message status update: $data');
          final messageId = data['message_id'] as int? ?? data['id'] as int?;
          final status = data['status'] as String? ?? data['delivery_status'] as String?;
          final isRead = data['is_read'] as bool?;
          final readBy = data['read_by'] as List?;

          if (messageId != null) {
            final updatedMessages = state.messages.map((msg) {
              if (msg.id == messageId) {
                List<int> newReadBy = msg.readBy;
                if (readBy != null) {
                  final serverReadBy = readBy.map((id) => id as int).toList();
                  final newReaders = serverReadBy.where((id) =>
                    id != msg.sender.id && !msg.readBy.contains(id)
                  ).toList();
                  if (newReaders.isNotEmpty) {
                    newReadBy = [...msg.readBy, ...newReaders];
                  }
                }

                return ChatMessage(
                  id: msg.id,
                  messageType: msg.messageType,
                  content: msg.content,
                  file: msg.file,
                  fileUrl: msg.fileUrl,
                  duration: msg.duration,
                  sender: msg.sender,
                  timestamp: msg.timestamp,
                  updatedAt: msg.updatedAt,
                  isRead: isRead ?? (newReadBy.isNotEmpty) || msg.isRead,
                  readBy: newReadBy,
                  isEdited: msg.isEdited,
                  isDeleted: msg.isDeleted,
                  replyTo: msg.replyTo,
                  reactions: msg.reactions,
                );
              }
              return msg;
            }).toList();
            _safeUpdateState((s) => s.copyWith(messages: updatedMessages));
            print('✅ [ChatProvider] Updated message $messageId status');
          }
        } catch (e) {
          print('❌ [ChatProvider] Error handling message status: $e');
        }
        break;

      // 🔥 NEW: Handle new message notification on chat list (updates unread count)
      case 'new_message':
      case 'message_notification':
      case 'chat_update':
        try {
          print('📬 [ChatProvider] New message notification received: $data');
          final roomId = data['room_id'] as int? ?? data['chat_id'] as int?;
          final senderId = data['sender_id'] as int?;
          final messagePreview = data['message'] as String? ?? data['content'] as String? ?? data['preview'] as String?;
          final timestamp = data['timestamp'] != null
              ? DateTime.tryParse(data['timestamp'] as String)?.toLocal()
              : DateTime.now();
          final unreadCountFromServer = data['unread_count'] as int?;

          if (roomId != null) {
            // Update the specific chat room with new message info and unread count
            final updatedRooms = state.chatRooms.map((room) {
              if (room.id == roomId) {
                // Only increment unread if:
                // 1. Not currently viewing this room
                // 2. Message is from another user
                final isCurrentlyViewing = state.currentChatRoomId == roomId;
                final isFromOtherUser = senderId != state.currentUserId;
                final shouldIncrementUnread = !isCurrentlyViewing && isFromOtherUser;

                return ChatRoom(
                  id: room.id,
                  name: room.name,
                  createdAt: room.createdAt,
                  updatedAt: room.updatedAt,
                  participants: room.participants,
                  lastMessagePreview: messagePreview ?? room.lastMessagePreview,
                  lastMessageTimestamp: timestamp ?? room.lastMessageTimestamp,
                  unreadCount: unreadCountFromServer ?? (shouldIncrementUnread
                      ? room.unreadCount + 1
                      : room.unreadCount),
                  isGroup: room.isGroup,
                  isPinned: room.isPinned,
                );
              }
              return room;
            }).toList();

            _safeUpdateState((s) => s.copyWith(chatRooms: updatedRooms));
            print('✅ [ChatProvider] Updated room $roomId with new message notification');
          }
        } catch (e) {
          print('❌ [ChatProvider] Error handling new message notification: $e');
        }
        break;

      case 'error':
        final errorMsg = data['error'] as String? ?? data['message'] as String? ?? '';
        print('❌ [ChatProvider] WebSocket error: $errorMsg');
        break;

      // 🔥 Handle read receipts (KakaoTalk-style)
      case 'read_receipt':
      case 'messages_read':
      case 'mark_read':
      case 'messages_marked_read':
        try {
          print('📬 [ChatProvider] Read receipt received: $data');
          final readerId = data['reader_id'] as int? ?? data['user_id'] as int?;
          final messageIds = data['message_ids'] as List?;
          final lastReadMessageId = data['last_read_message_id'] as int?;

          // 🔥 NEW: Also handle read_by array from server
          final readByFromServer = data['read_by'] as List?;

          if (readerId != null && readerId != state.currentUserId) {
            int updatedCount = 0;

            // Update messages to show they've been read
            final updatedMessages = state.messages.map((msg) {
              // Only update messages sent by current user (our messages)
              if (msg.sender.id != state.currentUserId) {
                return msg;
              }

              // Check if already marked as read by this reader
              if (msg.readBy.contains(readerId)) {
                return msg;
              }

              bool shouldUpdate = false;

              // If specific message IDs provided, only update those
              if (messageIds != null && messageIds.contains(msg.id)) {
                shouldUpdate = true;
              } else if (lastReadMessageId != null && msg.id != null && msg.id! <= lastReadMessageId) {
                // Mark all messages up to lastReadMessageId as read
                shouldUpdate = true;
              } else if (messageIds == null && lastReadMessageId == null) {
                // No specific IDs - mark all own unread messages as read by this reader
                shouldUpdate = true;
              }

              if (shouldUpdate) {
                updatedCount++;
                return ChatMessage(
                  id: msg.id,
                  messageType: msg.messageType,
                  content: msg.content,
                  file: msg.file,
                  fileUrl: msg.fileUrl,
                  duration: msg.duration,
                  sender: msg.sender,
                  timestamp: msg.timestamp,
                  updatedAt: msg.updatedAt,
                  isRead: true,
                  readBy: [...msg.readBy, readerId],
                  isEdited: msg.isEdited,
                  isDeleted: msg.isDeleted,
                  replyTo: msg.replyTo,
                  reactions: msg.reactions,
                );
              }

              return msg;
            }).toList();

            if (updatedCount > 0) {
              _safeUpdateState((s) => s.copyWith(messages: updatedMessages));
              print('✅ [ChatProvider] Marked $updatedCount messages as read by user $readerId');
            }
          } else if (readByFromServer != null) {
            // 🔥 NEW: Handle bulk read_by update from server
            final readerIds = readByFromServer.map((id) => id as int).toList();
            int updatedCount = 0;

            final updatedMessages = state.messages.map((msg) {
              if (msg.sender.id != state.currentUserId) {
                return msg;
              }

              // Check if there are new readers not in current readBy
              final newReaders = readerIds.where((id) =>
                id != state.currentUserId && !msg.readBy.contains(id)
              ).toList();

              if (newReaders.isNotEmpty) {
                updatedCount++;
                return ChatMessage(
                  id: msg.id,
                  messageType: msg.messageType,
                  content: msg.content,
                  file: msg.file,
                  fileUrl: msg.fileUrl,
                  duration: msg.duration,
                  sender: msg.sender,
                  timestamp: msg.timestamp,
                  updatedAt: msg.updatedAt,
                  isRead: true,
                  readBy: [...msg.readBy, ...newReaders],
                  isEdited: msg.isEdited,
                  isDeleted: msg.isDeleted,
                  replyTo: msg.replyTo,
                  reactions: msg.reactions,
                );
              }
              return msg;
            }).toList();

            if (updatedCount > 0) {
              _safeUpdateState((s) => s.copyWith(messages: updatedMessages));
              print('✅ [ChatProvider] Bulk updated $updatedCount messages with read_by');
            }
          }
        } catch (e) {
          print('❌ [ChatProvider] Error handling read receipt: $e');
        }
        break;

      default:
        print('⚠️ [ChatProvider] Unknown message type: ${data['type']}');
    }
  }

  // Helpers
  List<User> getAvailableUsers() {
    return state.users.where((user) => user.id != state.currentUserId).toList();
  }

  ChatRoom? getChatRoomById(int id) {
    try {
      return state.chatRooms.firstWhere((room) => room.id == id);
    } catch (e) {
      return null;
    }
  }

  // 🔥 NEW: Send message with reply
  void sendMessageWithReply(String content, int? replyToMessageId) {
    final trimmedContent = content.trim();

    if (trimmedContent.isEmpty) {
      return;
    }

    if (!state.isAuthenticated || state.currentChatRoomId == null) {
      return;
    }

    // Use API to send message with reply
    _apiService.sendMessageWithReply(
      state.currentChatRoomId!,
      trimmedContent,
      replyToMessageId,
    ).catchError((e) {
      _safeUpdateState((s) => s.copyWith(error: 'Failed to send message: $e'));
    });
  }

  // 🔥 NEW: Edit message
  Future<bool> editMessage(int messageId, String newContent) async {
    if (!state.isAuthenticated || state.currentChatRoomId == null) {

      return false;
    }

    try {
      final updatedMessage = await _apiService.editMessage(
        state.currentChatRoomId!,
        messageId,
        newContent,
      );
      
      // Update message in state
      final updatedMessages = state.messages.map<ChatMessage>((msg) {
        if (msg.id == messageId) {
          return updatedMessage;
        }
        return msg;
      }).toList();
      
      _safeUpdateState((s) => s.copyWith(messages: updatedMessages));

      return true;
    } catch (e) {

      _safeUpdateState((s) => s.copyWith(error: 'Failed to edit message: $e'));
      return false;
    }
  }

  // 🔥 NEW: Delete message
  Future<bool> deleteMessage(int messageId) async {
    if (!state.isAuthenticated || state.currentChatRoomId == null) {

      return false;
    }

    try {
      await _apiService.deleteMessage(state.currentChatRoomId!, messageId);
      
      // Update message in state (soft delete)
      final updatedMessages = state.messages.map((msg) {
        if (msg.id == messageId) {
          return ChatMessage(
            id: msg.id,
            messageType: msg.messageType,
            content: msg.content,
            file: msg.file,
            fileUrl: msg.fileUrl,
            duration: msg.duration,
            sender: msg.sender,
            timestamp: msg.timestamp,
            updatedAt: msg.updatedAt,
            isRead: msg.isRead,
            readBy: msg.readBy,
            isEdited: msg.isEdited,
            isDeleted: true,
            replyTo: msg.replyTo,
            reactions: msg.reactions,
          );
        }
        return msg;
      }).toList();
      
      _safeUpdateState((s) => s.copyWith(messages: updatedMessages));

      return true;
    } catch (e) {

      _safeUpdateState((s) => s.copyWith(error: 'Failed to delete message: $e'));
      return false;
    }
  }

  // 🔥 NEW: Toggle reaction
  Future<bool> toggleReaction(int messageId, String emoji) async {
    if (!state.isAuthenticated || state.currentChatRoomId == null) {

      return false;
    }

    try {
      final reactions = await _apiService.toggleReaction(
        state.currentChatRoomId!,
        messageId,
        emoji,
      );
      
      // Update message reactions in state
      final updatedMessages = state.messages.map((msg) {
        if (msg.id == messageId) {
          return ChatMessage(
            id: msg.id,
            messageType: msg.messageType,
            content: msg.content,
            file: msg.file,
            fileUrl: msg.fileUrl,
            duration: msg.duration,
            sender: msg.sender,
            timestamp: msg.timestamp,
            updatedAt: msg.updatedAt,
            isRead: msg.isRead,
            readBy: msg.readBy,
            isEdited: msg.isEdited,
            isDeleted: msg.isDeleted,
            replyTo: msg.replyTo,
            reactions: reactions,
          );
        }
        return msg;
      }).toList();
      
      _safeUpdateState((s) => s.copyWith(messages: updatedMessages));

      return true;
    } catch (e) {

      _safeUpdateState((s) => s.copyWith(error: 'Failed to toggle reaction: $e'));
      return false;
    }
  }

  // 🔥 NEW: Block user
  Future<bool> blockUser(int userId) async {
    if (!state.isAuthenticated) {

      return false;
    }

    try {
      await _apiService.blockUser(userId);
      
      // Update blocked users list
      final updatedBlockedIds = [...state.blockedUserIds, userId];
      _safeUpdateState((s) => s.copyWith(blockedUserIds: updatedBlockedIds));
      
      // Remove blocked user's chat rooms immediately
      final roomsBefore = state.chatRooms.length;
      final updatedRooms = state.chatRooms.where((room) {
        if (!room.isGroup) {
          // For direct chats, check if the other participant is the blocked user
          return !room.participants.any((p) => p.id == userId);
        }
        return true; // Keep group chats
      }).toList();
      _safeUpdateState((s) => s.copyWith(chatRooms: updatedRooms));
      
      // 🔥 NEW: Request updated chat list from WebSocket
      if (_chatListWS != null && _chatListWS!.isConnected) {
        _chatListWS!.requestListRefresh();
      } else {
        // Fallback: reload via API
        await loadChatRooms();
      }

      return true;
    } catch (e) {

      _safeUpdateState((s) => s.copyWith(error: 'Failed to block user: $e'));
      return false;
    }
  }

  // 🔥 NEW: Unblock user
  Future<bool> unblockUser(int userId) async {
    if (!state.isAuthenticated) {

      return false;
    }

    try {
      await _apiService.unblockUser(userId);
      
      // Update blocked users list
      final updatedBlockedIds = state.blockedUserIds.where((id) => id != userId).toList();
      _safeUpdateState((s) => s.copyWith(blockedUserIds: updatedBlockedIds));

      // 🔥 NEW: Request updated chat list from WebSocket to show unblocked user's chats
      if (_chatListWS != null && _chatListWS!.isConnected) {
        _chatListWS!.requestListRefresh();
      } else {
        // Fallback: reload via API
        await loadChatRooms();
      }
      
      return true;
    } catch (e) {

      _safeUpdateState((s) => s.copyWith(error: 'Failed to unblock user: $e'));
      return false;
    }
  }

  // 🔥 NEW: Load blocked users
  Future<void> loadBlockedUsers() async {
    if (!state.isAuthenticated) {
      return;
    }

    try {
      final blockedUsers = await _apiService.getBlockedUsers();
      final blockedIds = blockedUsers.map((u) => u.id).toList();
      
      // 🔥 NEW: Also add blocked users to the users list if not already there
      final existingUserIds = state.users.map((u) => u.id).toSet();
      final newBlockedUsers = blockedUsers.where((u) => !existingUserIds.contains(u.id)).toList();
      final updatedUsers = [...state.users, ...newBlockedUsers];
      
      _safeUpdateState((s) => s.copyWith(
        blockedUserIds: blockedIds,
        users: updatedUsers,
      ));

    } catch (e) {

    }
  }
  
  // 🔥 NEW: Get blocked users list (for UI)
  List<User> getBlockedUsersList() {
    final blockedUserIds = state.blockedUserIds;
    return state.users.where((user) => blockedUserIds.contains(user.id)).toList();
  }

  // 🔥 NEW: Initiate call
  Future<bool> initiateCall(String callType) async {
    if (!state.isAuthenticated || state.currentChatRoomId == null) {

      return false;
    }

    try {
      final callData = await _apiService.initiateCall(
        state.currentChatRoomId!,
        callType, // 'voice' or 'video'
      );
      _safeUpdateState((s) => s.copyWith(activeCall: callData));

      return true;
    } catch (e) {

      _safeUpdateState((s) => s.copyWith(error: 'Failed to initiate call: $e'));
      return false;
    }
  }

  // 🔥 NEW: Update call (answer/reject/end)
  Future<bool> updateCall(int callId, String action) async {
    if (!state.isAuthenticated || state.currentChatRoomId == null) {

      return false;
    }

    try {
      final callData = await _apiService.updateCall(
        state.currentChatRoomId!,
        callId,
        action, // 'answer', 'reject', or 'end'
      );
      _safeUpdateState((s) => s.copyWith(activeCall: callData));

      return true;
    } catch (e) {

      _safeUpdateState((s) => s.copyWith(error: 'Failed to update call: $e'));
      return false;
    }
  }

  // Refresh data
  Future<void> refresh() async {

    if (state.isAuthenticated) {
      await loadChatRooms();
      if (state.currentChatRoomId != null) {
        await loadChatMessages(state.currentChatRoomId!);
      }
    }
  }

  // 🔥 NEW: Refresh only message read statuses (lightweight refresh)
  Future<void> refreshMessageReadStatus() async {
    if (!state.isAuthenticated || state.currentChatRoomId == null) {
      return;
    }

    try {
      print('🔄 [ChatProvider] Refreshing message read status...');
      final result = await _apiService.getChatMessagesPaginated(
        state.currentChatRoomId!,
        page: 1,
        pageSize: 50,
      );

      final freshMessages = result['messages'] as List<ChatMessage>;

      // Update existing messages with fresh read_by data
      final updatedMessages = state.messages.map((msg) {
        final freshMsg = freshMessages.firstWhere(
          (m) => m.id == msg.id,
          orElse: () => msg,
        );

        // Only update if read status changed
        if (freshMsg.id == msg.id &&
            (freshMsg.isRead != msg.isRead ||
             freshMsg.readBy.length != msg.readBy.length)) {
          return ChatMessage(
            id: msg.id,
            messageType: msg.messageType,
            content: msg.content,
            file: msg.file,
            fileUrl: msg.fileUrl,
            duration: msg.duration,
            sender: msg.sender,
            timestamp: msg.timestamp,
            updatedAt: msg.updatedAt,
            isRead: freshMsg.isRead,
            readBy: freshMsg.readBy,
            isEdited: msg.isEdited,
            isDeleted: msg.isDeleted,
            replyTo: msg.replyTo,
            reactions: msg.reactions,
          );
        }
        return msg;
      }).toList();

      _safeUpdateState((s) => s.copyWith(messages: updatedMessages));
      print('✅ [ChatProvider] Message read status refreshed');
    } catch (e) {
      print('❌ [ChatProvider] Error refreshing read status: $e');
    }
  }

  @override
  void dispose() {

    _chatListSubscription?.cancel();
    _chatRoomSubscription?.cancel();
    _connStateSubscription?.cancel();
    for (final timer in _ackTimeouts.values) {
      timer.cancel();
    }
    _ackTimeouts.clear();
    _chatListWS?.disconnect();
    _chatRoomWS?.disconnect();
    super.dispose();
  }
}

// Provider
final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  return ChatNotifier();
});

// Helper providers for specific states
final chatRoomsProvider = Provider<List<ChatRoom>>((ref) {
  return ref.watch(chatProvider).chatRooms;
});

final messagesProvider = Provider<List<ChatMessage>>((ref) {
  return ref.watch(chatProvider).messages;
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(chatProvider).isAuthenticated;
});

final isLoadingProvider = Provider<bool>((ref) {
  return ref.watch(chatProvider).isLoading;
});

final currentUserIdProvider = Provider<int?>((ref) {
  return ref.watch(chatProvider).currentUserId;
});

final availableUsersProvider = Provider<List<User>>((ref) {
  return ref.watch(chatProvider.notifier).getAvailableUsers();
});

final totalUnreadCountProvider = Provider<int>((ref) {
  final chatRooms = ref.watch(chatProvider).chatRooms;
  return chatRooms.fold(0, (sum, room) => sum + room.unreadCount);
});

// Sorted messages provider - caches sorted result to avoid O(n log n) on every rebuild
final sortedMessagesProvider = Provider<List<ChatMessage>>((ref) {
  final messages = ref.watch(chatProvider).messages;
  if (messages.isEmpty) return const [];
  final sorted = List<ChatMessage>.from(messages);
  sorted.sort((a, b) => a.timestamp.compareTo(b.timestamp));
  return sorted;
});
