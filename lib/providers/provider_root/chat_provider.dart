
// lib/providers/chat_provider.dart

import 'package:app/providers/provider_models/message_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';


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
    );
  }
}

// Chat Notifier
class ChatNotifier extends StateNotifier<ChatState> {
  ChatNotifier() : super(ChatState()) {
    print('🔥 ChatNotifier: Created');
  }

  final ChatApiService _apiService = ChatApiService();
  ChatListWebSocketService? _chatListWS;
  ChatRoomWebSocketService? _chatRoomWS;

  // Initialize - check existing authentication from your auth service
  Future<void> initialize() async {
    print('🔥 ChatNotifier: Initialize called');

    try {
      // Use your existing SharedPreferences keys
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token'); // Your existing token key
      final userIdString = prefs.getString('userId'); // Your existing userId key
      final username = prefs.getString('username'); // If you store username

      if (token != null && userIdString != null) {
        final userId = int.tryParse(userIdString);
        if (userId != null) {
          print('🔥 Found existing auth: userId=$userId, token exists: ${token.isNotEmpty}');
          state = state.copyWith(
            isAuthenticated: true,
            token: token,
            currentUserId: userId,
            currentUsername: username,
          );

          await loadChatRooms();
          await _connectToChatList();
        } else {
          print('🚨 Invalid userId format: $userIdString');
          state = state.copyWith(isAuthenticated: false);
        }
      } else {
        print('🚨 No existing auth found - token: ${token != null}, userId: ${userIdString != null}');
        state = state.copyWith(isAuthenticated: false);
      }
    } catch (e) {
      print('🚨 Initialize error: $e');
      state = state.copyWith(error: e.toString(), isAuthenticated: false);
    }
  }

  // Check authentication status (called when returning from other screens)
  Future<void> checkAuthStatus() async {
    print('🔥 ChatNotifier: Checking auth status');

    try {
      final isAuth = await _apiService.isAuthenticated();
      if (isAuth != state.isAuthenticated) {
        if (isAuth) {
          // User logged in elsewhere, reinitialize
          await initialize();
        } else {
          // User logged out elsewhere, clear state
          await _clearAuthState();
        }
      }
    } catch (e) {
      print('🚨 Auth status check error: $e');
    }
  }

  // Clear authentication state
  Future<void> _clearAuthState() async {
    print('🔥 ChatNotifier: Clearing auth state');

    // Disconnect WebSockets
    await _chatListWS?.disconnect();
    await _chatRoomWS?.disconnect();

    // Reset state
    state = ChatState();
  }

  // Chat Rooms
  Future<void> loadChatRooms() async {
    print('🔥 ChatNotifier: Loading chat rooms...');

    if (!state.isAuthenticated) {
      print('🚨 Cannot load chat rooms - not authenticated');
      return;
    }

    try {
      state = state.copyWith(isLoading: true, error: null);

      final chatRooms = await _apiService.getChatRooms();

      state = state.copyWith(
        isLoading: false,
        chatRooms: chatRooms,
      );

      print('🔥 Successfully loaded ${chatRooms.length} chat rooms');
    } catch (e) {
      print('🚨 Error loading chat rooms: $e');

      // Handle authentication errors
      if (e.toString().contains('Authentication failed')) {
        await _clearAuthState();
      } else {
        state = state.copyWith(
          isLoading: false,
          error: e.toString(),
        );
      }
    }
  }

  Future<bool> createChatRoom(String name, List<int> participantIds) async {
    print('🔥 ChatNotifier: Creating chat room: $name');

    if (!state.isAuthenticated) {
      print('🚨 Cannot create chat room - not authenticated');
      return false;
    }

    try {
      state = state.copyWith(isLoading: true, error: null);

      await _apiService.createChatRoom(name, participantIds);
      await loadChatRooms(); // Reload list

      state = state.copyWith(isLoading: false);

      print('🔥 Chat room created successfully');
      return true;
    } catch (e) {
      print('🚨 Error creating chat room: $e');
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  Future<bool> deleteChatRoom(int chatId) async {
    print('🔥 ChatNotifier: Deleting chat room $chatId');

    if (!state.isAuthenticated) {
      return false;
    }

    try {
      await _apiService.deleteChatRoom(chatId);

      // Remove from local state
      final updatedRooms = state.chatRooms.where((room) => room.id != chatId).toList();
      state = state.copyWith(chatRooms: updatedRooms);

      print('🔥 Chat room deleted successfully');
      return true;
    } catch (e) {
      print('🚨 Error deleting chat room: $e');
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  // Chat Messages
  Future<void> connectToChatRoom(int roomId) async {
    print('🔥 ChatNotifier: Connecting to chat room $roomId');

    if (!state.isAuthenticated) {
      print('🚨 Cannot connect to chat room - not authenticated');
      return;
    }

    try {
      // Disconnect previous room
      await _chatRoomWS?.disconnect();

      state = state.copyWith(currentChatRoomId: roomId, messages: []);

      // Load messages first
      await loadChatMessages(roomId);

      // Connect WebSocket
      _chatRoomWS = ChatRoomWebSocketService();
      await _chatRoomWS!.connectToChatRoom(roomId);

      // Listen for new messages
      _chatRoomWS!.messages.listen((data) {
        _handleChatRoomMessage(data);
      });

      print('🔥 Connected to chat room $roomId');
    } catch (e) {
      print('🚨 Error connecting to chat room: $e');
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> loadChatMessages(int roomId) async {
    print('🔥 ChatNotifier: Loading messages for room $roomId');

    if (!state.isAuthenticated) {
      return;
    }

    try {
      state = state.copyWith(isLoadingMessages: true, error: null);

      final messages = await _apiService.getChatMessages(roomId);

      state = state.copyWith(
        isLoadingMessages: false,
        messages: messages,
      );

      print('🔥 Loaded ${messages.length} messages');
    } catch (e) {
      print('🚨 Error loading messages: $e');
      state = state.copyWith(
        isLoadingMessages: false,
        error: e.toString(),
      );
    }
  }

  void sendMessage(String content) {
    if (_chatRoomWS != null && content.trim().isNotEmpty && state.isAuthenticated) {
      print('🔥 Sending message: $content');
      _chatRoomWS!.sendChatMessage(content.trim());
    } else {
      print('🚨 Cannot send message - WS: ${_chatRoomWS != null}, auth: ${state.isAuthenticated}, content: ${content.trim().isNotEmpty}');
    }
  }

  void disconnectFromChatRoom() {
    print('🔥 ChatNotifier: Disconnecting from chat room');
    _chatRoomWS?.disconnect();
    state = state.copyWith(currentChatRoomId: null, messages: []);
  }

  // Users
  Future<void> loadUsers() async {
    print('🔥 ChatNotifier: Loading users...');

    if (!state.isAuthenticated) {
      return;
    }

    try {
      final users = await _apiService.getUsers();

      state = state.copyWith(users: users);

      print('🔥 Loaded ${users.length} users');
    } catch (e) {
      print('🚨 Error loading users: $e');
      // Don't set error for users loading failure
    }
  }

  // Private methods
  Future<void> _connectToChatList() async {
    if (!state.isAuthenticated) {
      print('🚨 Cannot connect to chat list WebSocket - not authenticated');
      return;
    }

    try {
      _chatListWS = ChatListWebSocketService();
      await _chatListWS!.connectToChatList();

      _chatListWS!.messages.listen((data) {
        _handleChatListMessage(data);
      });

      print('🔥 Connected to chat list WebSocket');
    } catch (e) {
      print('🚨 Error connecting to chat list WebSocket: $e');
      // Don't set error state for WebSocket connection failures
    }
  }

  void _handleChatListMessage(Map<String, dynamic> data) {
    print('🔥 Chat list message: ${data['type']}');

    switch (data['type']) {
    case 'chatroom_list':
    try {
    final chatRooms = (data['chatrooms'] as List)
        .map((room) => ChatRoom.fromJson(room))
        .toList();
    state = state.copyWith(chatRooms: chatRooms);
    print('🔥 Updated chat rooms from WebSocket: ${chatRooms.length}');// lib/providers/chat_provider.dart

    import 'package:flutter_riverpod/flutter_riverpod.dart';
    import 'package:shared_preferences/shared_preferences.dart';
    import '../models/chat_models.dart';
    import '../services/chat_api_service.dart';
    import '../services/websocket_service.dart';

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
    );
    }
    }

// Chat Notifier
    class ChatNotifier extends StateNotifier<ChatState> {
    ChatNotifier() : super(ChatState()) {
    print('🔥 ChatNotifier: Created');
    }

    final ChatApiService _apiService = ChatApiService();
    ChatListWebSocketService? _chatListWS;
    ChatRoomWebSocketService? _chatRoomWS;

    // Initialize
    Future<void> initialize() async {
    print('🔥 ChatNotifier: Initialize called');

    try {
    // Check existing auth
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final userId = prefs.getInt('user_id');
    final username = prefs.getString('username');

    if (token != null && userId != null) {
    print('🔥 Found existing auth: userId=$userId');
    state = state.copyWith(
    isAuthenticated: true,
    token: token,
    currentUserId: userId,
    currentUsername: username,
    );

    await loadChatRooms();
    await _connectToChatList();
    } else {
    print('🚨 No existing auth found');
    state = state.copyWith(isAuthenticated: false);
    }
    } catch (e) {
    print('🚨 Initialize error: $e');
    state = state.copyWith(error: e.toString());
    }
    }

    // Authentication
    Future<bool> login(String username, String password) async {
    print('🔥 ChatNotifier: Login attempt for $username');

    try {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _apiService.login(username, password);

    state = state.copyWith(
    isLoading: false,
    isAuthenticated: true,
    token: result['token'],
    currentUserId: result['user_id'] ?? result['id'],
    currentUsername: result['username'] ?? username,
    );

    await loadChatRooms();
    await _connectToChatList();

    print('🔥 Login successful');
    return true;
    } catch (e) {
    print('🚨 Login failed: $e');
    state = state.copyWith(
    isLoading: false,
    error: e.toString(),
    );
    return false;
    }
    }

    Future<void> logout() async {
    print('🔥 ChatNotifier: Logout called');

    try {
    // Disconnect WebSockets
    await _chatListWS?.disconnect();
    await _chatRoomWS?.disconnect();

    // Clear storage
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_id');
    await prefs.remove('username');

    // Reset state
    state = ChatState();

    print('🔥 Logout successful');
    } catch (e) {
    print('🚨 Logout error: $e');
    }
    }

    // Chat Rooms
    Future<void> loadChatRooms() async {
    print('🔥 ChatNotifier: Loading chat rooms...');

    if (!state.isAuthenticated) {
    print('🚨 Cannot load chat rooms - not authenticated');
    return;
    }

    try {
    state = state.copyWith(isLoading: true, error: null);

    final chatRooms = await _apiService.getChatRooms();

    state = state.copyWith(
    isLoading: false,
    chatRooms: chatRooms,
    );

    print('🔥 Successfully loaded ${chatRooms.length} chat rooms');
    } catch (e) {
    print('🚨 Error loading chat rooms: $e');
    state = state.copyWith(
    isLoading: false,
    error: e.toString(),
    );
    }
    }

    Future<bool> createChatRoom(String name, List<int> participantIds) async {
    print('🔥 ChatNotifier: Creating chat room: $name');

    try {
    state = state.copyWith(isLoading: true, error: null);

    await _apiService.createChatRoom(name, participantIds);
    await loadChatRooms(); // Reload list

    state = state.copyWith(isLoading: false);

    print('🔥 Chat room created successfully');
    return true;
    } catch (e) {
    print('🚨 Error creating chat room: $e');
    state = state.copyWith(
    isLoading: false,
    error: e.toString(),
    );
    return false;
    }
    }

    // Chat Messages
    Future<void> connectToChatRoom(int roomId) async {
    print('🔥 ChatNotifier: Connecting to chat room $roomId');

    try {
    // Disconnect previous room
    await _chatRoomWS?.disconnect();

    state = state.copyWith(currentChatRoomId: roomId);

    // Load messages first
    await loadChatMessages(roomId);

    // Connect WebSocket
    _chatRoomWS = ChatRoomWebSocketService();
    await _chatRoomWS!.connectToChatRoom(roomId);

    // Listen for new messages
    _chatRoomWS!.messages.listen((data) {
    _handleChatRoomMessage(data);
    });

    print('🔥 Connected to chat room $roomId');
    } catch (e) {
    print('🚨 Error connecting to chat room: $e');
    state = state.copyWith(error: e.toString());
    }
    }

    Future<void> loadChatMessages(int roomId) async {
    print('🔥 ChatNotifier: Loading messages for room $roomId');

    try {
    state = state.copyWith(isLoadingMessages: true);

    final messages = await _apiService.getChatMessages(roomId);

    state = state.copyWith(
    isLoadingMessages: false,
    messages: messages,
    );

    print('🔥 Loaded ${messages.length} messages');
    } catch (e) {
    print('🚨 Error loading messages: $e');
    state = state.copyWith(
    isLoadingMessages: false,
    error: e.toString(),
    );
    }
    }

    void sendMessage(String content) {
    if (_chatRoomWS != null && content.trim().isNotEmpty) {
    print('🔥 Sending message: $content');
    _chatRoomWS!.sendChatMessage(content.trim());
    }
    }

    void disconnectFromChatRoom() {
    _chatRoomWS?.disconnect();
    state = state.copyWith(currentChatRoomId: null, messages: []);
    }

    // Users
    Future<void> loadUsers() async {
    print('🔥 ChatNotifier: Loading users...');

    try {
    final users = await _apiService.getUsers();

    state = state.copyWith(users: users);

    print('🔥 Loaded ${users.length} users');
    } catch (e) {
    print('🚨 Error loading users: $e');
    }
    }

    // Private methods
    Future<void> _connectToChatList() async {
    try {
    _chatListWS = ChatListWebSocketService();
    await _chatListWS!.connectToChatList();

    _chatListWS!.messages.listen((data) {
    _handleChatListMessage(data);
    });

    print('🔥 Connected to chat list WebSocket');
    } catch (e) {
    print('🚨 Error connecting to chat list WebSocket: $e');
    }
    }

    void _handleChatListMessage(Map<String, dynamic> data) {
    print('🔥 Chat list message: ${data['type']}');

    switch (data['type']) {
    case 'chatroom_list':
    final chatRooms = (data['chatrooms'] as List)
        .map((room) => ChatRoom.fromJson(room))
        .toList();
    state = state.copyWith(chatRooms: chatRooms);
    break;
    } catch (e) {
    print('🚨 Error parsing chat rooms from WebSocket: $e');
    }
    break;
    case 'chatroom_created':
    print('🔥 New chat room created, reloading list');
    loadChatRooms(); // Reload list
    break;
    case 'error':
    print('🚨 Chat list WebSocket error: ${data['error']}');
    break;
    }
    }

    void _handleChatRoomMessage(Map<String, dynamic> data) {
    print('🔥 Chat room message: ${data['type']}');

    switch (data['type']) {
    case 'message':
    try {
    final message = ChatMessage.fromJson(data);
    final updatedMessages = [...state.messages, message];
    state = state.copyWith(messages: updatedMessages);
    print('🔥 Added new message from WebSocket');
    } catch (e) {
    print('🚨 Error parsing message from WebSocket: $e');
    }
    break;
    case 'connection_established':
    print('🔥 Chat room WebSocket connection established');
    break;
    case 'error':
    print('🚨 Chat room WebSocket error: ${data['error']}');
    break;
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

    // Refresh data (called when app comes to foreground)
    Future<void> refresh() async {
    print('🔥 ChatNotifier: Refreshing data');

    if (state.isAuthenticated) {
    await loadChatRooms();
    if (state.currentChatRoomId != null) {
    await loadChatMessages(state.currentChatRoomId!);
    }
    }
    }

    @override
    void dispose() {
    print('🔥 ChatNotifier: Disposing');
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