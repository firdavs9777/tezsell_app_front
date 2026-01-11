import 'dart:async';
import 'package:app/providers/provider_models/message_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/service/chat_api_service.dart';
import 'package:app/service/websocket_service.dart';
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
    );
  }
}

// Chat Notifier
class ChatNotifier extends StateNotifier<ChatState> {
  ChatNotifier() : super(ChatState()) {

  }

  final ChatApiService _apiService = ChatApiService();
  
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
    if (!state.isAuthenticated) {

      return null;
    }

    try {
      _safeUpdateState((s) => s.copyWith(isLoading: true, error: null));

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

        _safeUpdateState((s) => s.copyWith(isLoading: false));
        return existingChat;
      }

      // 🔥 NEW: Try new start chat endpoint first (KakaoTalk-style)
      try {
        final result = await _apiService.startChatWithUser(targetUserId);
        final chatData = result['chat'] as Map<String, dynamic>?;
        if (chatData != null) {
          final chatRoom = ChatRoom.fromJson(chatData);
          
          // Check if this is an existing chat (not newly created)
          final wasCreated = result['created'] as bool? ?? false;
          if (!wasCreated) {

          } else {

          }
          
          // Reload chat list to sync with backend
          await loadChatRooms();
          
          _safeUpdateState((s) => s.copyWith(isLoading: false));
          
          return chatRoom;
        }
      } catch (e) {

      }

      // Fallback to old endpoint
      final chatRoom = await _apiService.getOrCreateDirectChat(targetUserId);

      // Reload chat list
      await loadChatRooms();

      _safeUpdateState((s) => s.copyWith(isLoading: false));

      return chatRoom;
    } catch (e) {

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

      _safeUpdateState((s) => s.copyWith(
        isLoading: false,
        chatRooms: chatRooms,
      ));

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
          );
        }
        return room;
      }).toList();
      _safeUpdateState((s) => s.copyWith(chatRooms: updatedRooms));

      // Connect WebSocket
      _chatRoomWS = ChatRoomWebSocketService();
      await _chatRoomWS!.connectToChatRoom(roomId);

      // Wait a bit for connection to be established
      await Future.delayed(const Duration(milliseconds: 500));

      // Verify connection
      if (_chatRoomWS!.isConnected) {

        // 🔥 Properly set up subscription
        _chatRoomSubscription = _chatRoomWS!.messages.listen(
          (data) {

            _handleChatRoomMessage(data);
          },
          onError: (error) {

          },
          onDone: () {

          },
        );
      } else {

        _safeUpdateState((s) => s.copyWith(
          error: 'Failed to establish connection',
        ));
      }
    } catch (e) {

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

    print('📤 _chatRoomWS: ${_chatRoomWS != null ? "exists" : "null"}');
    print('📤 _chatRoomWS.isConnected: ${_chatRoomWS?.isConnected}');

    if (_chatRoomWS == null || !_chatRoomWS!.isConnected) {
      print('❌ Not connected to WebSocket');
      _safeUpdateState((s) => s.copyWith(error: 'Not connected. Please wait...'));

      // Try to reconnect
      if (state.currentChatRoomId != null) {
        print('🔄 Attempting to reconnect to room ${state.currentChatRoomId}');
        connectToChatRoom(state.currentChatRoomId!);
      }
      return;
    }

    print('📤 Calling _chatRoomWS.sendChatMessage');
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

  void _handleChatRoomMessage(Map<String, dynamic> data) {

    switch (data['type']) {
      case 'message':
        try {
          final message = ChatMessage.fromJson(data);
          
          // 🔥 FIX: Check for duplicate messages by ID to prevent double sending
          final messageExists = state.messages.any((m) => m.id == message.id);
          if (messageExists) {

            return;
          }
          
          final updatedMessages = [...state.messages, message];
          
          // 🔥 NEW: Update unread_count and last message preview in chat room list
          // When a message arrives, update the corresponding chat room
          final isFromOtherUser = message.sender.id != state.currentUserId;
          final currentRoomId = state.currentChatRoomId;
          
          List<ChatRoom> updatedChatRooms = state.chatRooms;
          
          // Find the chat room that contains this message's sender
          updatedChatRooms = state.chatRooms.map((room) {
            final roomHasSender = room.participants.any((p) => p.id == message.sender.id);
            
            if (roomHasSender) {
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
                    : room.unreadCount, // Don't increment if viewing the room
                isGroup: room.isGroup,
              );
            }
            return room;
          }).toList();
          
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

        break;
      case 'error':

        break;
        
      default:

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

  @override
  void dispose() {

    _chatListSubscription?.cancel();
    _chatRoomSubscription?.cancel();
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
