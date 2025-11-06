// lib/providers/chat_provider.dart

import 'package:app/providers/provider_models/message_model.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:app/service/chat_api_service.dart';
import 'package:app/service/websocket_service.dart';

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
  bool _isInitializing = false;

  // Initialize - check existing authentication
  Future<void> initialize() async {
    print('🔥 ChatNotifier: Initialize called');
    if (_isInitializing || state.isAuthenticated) {
      print('🔥 ChatNotifier: Already initialized or initializing');
      return;
    }
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final userIdString = prefs.getString('userId');

      final username = prefs.getString('username');
      if (token != null && userIdString != null) {
        final userId = int.tryParse(userIdString);
        if (userId != null) {
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
          print('🚨 Invalid userId format: $userIdString');
          state = state.copyWith(isAuthenticated: false);
        }
      } else {
        print('🚨 No existing auth found');
        state = state.copyWith(isAuthenticated: false);
      }
    } catch (e) {
      print('🚨 Initialize error: $e');
      state = state.copyWith(error: e.toString(), isAuthenticated: false);
    }
  }

  // Check authentication status
  Future<void> checkAuthStatus() async {
    print('🔥 ChatNotifier: Checking auth status');

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
      print('🚨 Auth status check error: $e');
    }
  }

  // Clear authentication state
  Future<void> _clearAuthState() async {
    print('🔥 ChatNotifier: Clearing auth state');
    await _chatListWS?.disconnect();
    await _chatRoomWS?.disconnect();
    state = ChatState();
  }

  // KARROT-STYLE: Get or create direct chat
  Future<ChatRoom?> getOrCreateDirectChat(int targetUserId) async {
    print(
        '🔥 ChatNotifier: Getting or creating direct chat with user $targetUserId');

    if (!state.isAuthenticated) {
      print('🚨 Cannot create chat - not authenticated');
      return null;
    }

    try {
      state = state.copyWith(isLoading: true, error: null);

      final chatRoom = await _apiService.getOrCreateDirectChat(targetUserId);

      // Reload chat list
      await loadChatRooms();

      state = state.copyWith(isLoading: false);

      print('🔥 Direct chat ready: ${chatRoom.id}');
      return chatRoom;
    } catch (e) {
      print('🚨 Error getting/creating direct chat: $e');
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return null;
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
      await loadChatRooms();

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

      final updatedRooms =
          state.chatRooms.where((room) => room.id != chatId).toList();
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
      // Don't disconnect if we're already connected to the same room
      if (state.currentChatRoomId == roomId &&
          _chatRoomWS != null &&
          _chatRoomWS!.isConnected) {
        print('✅ Already connected to room $roomId');
        return;
      }

      // Only disconnect if connecting to a different room
      if (state.currentChatRoomId != roomId) {
        await _chatRoomWS?.disconnect();
        _chatRoomWS = null;
      }

      state = state.copyWith(
        currentChatRoomId: roomId,
        messages: [],
        error: null,
      );

      // Load messages first
      await loadChatMessages(roomId);

      // Connect WebSocket
      _chatRoomWS = ChatRoomWebSocketService();
      await _chatRoomWS!.connectToChatRoom(roomId);

      // Wait a bit for connection to be established
      await Future.delayed(const Duration(milliseconds: 500));

      // Verify connection
      if (_chatRoomWS!.isConnected) {
        print('✅ Successfully connected to chat room $roomId');

        // Listen for new messages
        _chatRoomWS!.messages.listen((data) {
          _handleChatRoomMessage(data);
        });
      } else {
        print('🚨 Failed to connect to chat room $roomId');
        state = state.copyWith(
          error: 'Failed to establish connection',
        );
      }
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
      print(messages);

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
    final trimmedContent = content.trim();

    if (trimmedContent.isEmpty) {
      print('🚨 Cannot send empty message');
      return;
    }

    if (!state.isAuthenticated) {
      print('🚨 Cannot send message - not authenticated');
      state = state.copyWith(error: 'Not authenticated');
      return;
    }

    if (_chatRoomWS == null || !_chatRoomWS!.isConnected) {
      print('🚨 Cannot send message - WebSocket not connected');
      state = state.copyWith(error: 'Not connected. Please wait...');

      // Try to reconnect
      if (state.currentChatRoomId != null) {
        print('🔄 Attempting to reconnect...');
        connectToChatRoom(state.currentChatRoomId!);
      }
      return;
    }

    print('📤 Sending message: $trimmedContent');
    _chatRoomWS!.sendChatMessage(trimmedContent);
  }

  void sendTypingStatus(bool isTyping) {
    if (_chatRoomWS != null &&
        _chatRoomWS!.isConnected &&
        state.isAuthenticated) {
      _chatRoomWS!.sendTypingStatus(isTyping);
    }
  }

  void disconnectFromChatRoom() {
    print('🔥 ChatNotifier: Disconnecting from chat room');
    _chatRoomWS?.disconnect();
    _chatRoomWS = null;
    state = state.copyWith(
      currentChatRoomId: null,
      messages: [],
      error: null,
    );
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
          print('🔥 Updated chat rooms from WebSocket: ${chatRooms.length}');
        } catch (e) {
          print('🚨 Error parsing chat rooms from WebSocket: $e');
        }
        break;
      case 'chatroom_created':
        print('🔥 New chat room created, reloading list');
        loadChatRooms();
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
      case 'typing':
        // Handle typing indicator
        print('🔥 User ${data['username']} is typing: ${data['is_typing']}');
        // TODO: Add typing state management if needed
        break;
      case 'presence':
        // Handle online/offline status
        print('🔥 User ${data['username']} is ${data['status']}');
        // TODO: Add presence state management if needed
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

  // Refresh data
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

final availableUsersProvider = Provider<List<User>>((ref) {
  return ref.watch(chatProvider.notifier).getAvailableUsers();
});
