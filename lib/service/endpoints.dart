class Endpoints {
  static String baseURL = "htpp://127.0.0.1:8000/api/v1/";
  static String wsUrl = 'ws://127.0.0.1:8000/';
  static String loginURL = "auth/login";
  static String registerURL = "auth/register";
  static String productsURL = "products";
  static String chatURL = 'chats/';
  static const String chatListWsPath = '/ws/chatrooms/';
  static const String chatRoomWsPath = '/ws/chat/'; // append room_id

  // API Endpoints
  static const String chatListPath = '/api/chats/';
  static const String userListPath = '/api/users/';
  static const String authPath = '/api/auth/';

  // Local Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userIdKey = 'user_id';
  static const String usernameKey = 'username';

  // UI Constants
  static const int messagePageSize = 50;
  static const int chatListPageSize = 20;
  static const Duration connectionTimeout = Duration(seconds: 10);
  static const Duration reconnectDelay = Duration(seconds: 3);

  // Message Types
  static const String messageTypeText = 'text';
  static const String messageTypeImage = 'image';
  static const String messageTypeFile = 'file';

  // WebSocket Message Types
  static const String wsMessageType = 'message';
  static const String wsConnectionEstablished = 'connection_established';
  static const String wsChatroomList = 'chatroom_list';
  static const String wsChatroomCreated = 'chatroom_created';
  static const String wsError = 'error';

  // Chat Validation
  static const int maxMessageLength = 1000;
  static const int maxChatNameLength = 100;
  static const int maxParticipants = 50;
  // static String commentUrl = "comments";
  // static String messageUrl = "messages";
  // static String userUrl = "user";
  // static String senderUrl = "senders";
  // static String usersURL = "auth/users";
}
