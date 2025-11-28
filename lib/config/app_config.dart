/// Application configuration with environment-based settings.
/// 
/// This class provides a single source of truth for all API endpoints,
/// base URLs, and configuration values. Supports environment-based
/// configuration for different build variants (dev, staging, production).
class AppConfig {
  // Environment-based configuration
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.webtezsell.com',
  );

  static const String wsBaseUrl = String.fromEnvironment(
    'WS_BASE_URL',
    defaultValue: 'wss://api.webtezsell.com',
  );

  // API Version
  static const String apiVersion = '/api/v1';

  // Authentication Endpoints
  static const String loginPath = '/accounts/login/';
  static const String registerPath = '/accounts/register/';
  static const String userInfoPath = '/accounts/user/info/';
  static const String sendSmsPath = '/accounts/send-sms/';
  static const String verifySmsPath = '/accounts/verify-code/';
  static const String regionsPath = '/accounts/regions/';
  static const String districtsPath = '/accounts/districts/';

  // Products Endpoints
  static const String productsPath = '/products/api/products/';
  static const String userProductsPath = '/products/api/user/products/';
  static const String categoriesPath = '/products/api/categories/';

  // Services Endpoints
  static const String servicesPath = '/services/api/services';
  static const String userServicesPath = '/services/api/user/services/';
  static const String serviceCategoriesPath = '/services/api/categories';

  // Real Estate Endpoints
  static const String realEstatePropertiesPath = '/real_estate/api/properties/';
  static const String realEstateSavedPropertiesPath =
      '/real_estate/api/properties/saved/';

  // Global/Likes Endpoints
  static const String favoriteItemsPath = '/global/liked-items/';
  static const String productLikePath = '/global/like/product/';
  static const String serviceLikePath = '/global/like/service/';
  static const String productDislikePath = '/global/unlike/product/';
  static const String serviceDislikePath = '/global/unlike/service/';

  // Comments Endpoints
  static const String commentPath = '/comments';

  // Chat Endpoints (using v1 API)
  static const String chatListPath = '/api/chats/';
  static const String userListPath = '/api/users/';
  static const String authPath = '/api/auth/';
  static const String chatPath = 'chats/';

  // WebSocket Paths
  static const String chatListWsPath = '/ws/chatrooms/';
  static const String chatRoomWsPath = '/ws/chat/'; // append room_id

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

  // Helper methods for building full URLs
  static String getLoginUrl() => '$baseUrl$loginPath';
  static String getRegisterUrl() => '$baseUrl$registerPath';
  static String getUserInfoUrl() => '$baseUrl$userInfoPath';
  static String getProductsUrl() => '$baseUrl$productsPath';
  static String getServicesUrl() => '$baseUrl$servicesPath';
  static String getChatListUrl() => '$baseUrl$chatListPath';
  static String getUserListUrl() => '$baseUrl$userListPath';
  
  // WebSocket URLs
  static String getChatListWsUrl() => '$wsBaseUrl$chatListWsPath';
  static String getChatRoomWsUrl(String roomId) => '$wsBaseUrl$chatRoomWsPath$roomId';
}

