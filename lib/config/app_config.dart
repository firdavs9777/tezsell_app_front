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
  static const String usersPath = '/api/accounts/users/';
  static const String sendSmsPath = '/accounts/send-sms/';
  static const String verifySmsPath = '/accounts/verify-code/';
  static const String regionsPath = '/accounts/regions/';
  static const String districtsPath = '/accounts/districts/';
  static const String refreshTokenPath = '/accounts/refresh-token/';
  static const String verifyTokenPath = '/accounts/verify-token/';
  static const String logoutPath = '/accounts/logout/';

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
  static const String realEstateMapBoundsPath = '/real_estate/api/map/bounds/';
  static const String realEstateMapStatsPath = '/real_estate/api/map/stats/';
  static const String realEstateInquiriesPath = '/real_estate/api/inquiries/';
  static const String realEstateLocationsChoicesPath =
      '/real_estate/api/locations/choices/';
  static const String realEstateLocationsUserLocationsPath =
      '/real_estate/api/locations/user-locations/';
  static const String realEstateStatsPath = '/real_estate/api/stats/';
  static const String realEstateAgentsPath = '/real_estate/api/agents/';
  static const String realEstateAgentBecomePath = '/real_estate/api/agent/become/';
  static const String realEstateAgentProfilePath =
      '/real_estate/api/agent/profile/';
  static const String realEstateAgentStatusPath =
      '/real_estate/api/agent/status/';
  static const String realEstateAgentApplicationStatusPath =
      '/real_estate/api/agent/application-status/';
  static const String realEstateAgentDashboardPath =
      '/real_estate/api/agent/dashboard/';
  static const String realEstateAgentInquiriesPath =
      '/real_estate/api/agent/inquiries/';
  static const String realEstateAgentTopPath = '/real_estate/api/agents/top/';

  // Global/Likes Endpoints
  static const String favoriteItemsPath = '/global/liked-items/';
  static const String productLikePath = '/global/like/product/';
  static const String serviceLikePath = '/global/like/service/';
  static const String productDislikePath = '/global/unlike/product/';
  static const String serviceDislikePath = '/global/unlike/service/';

  // Comments Endpoints
  static const String commentPath = '/comments';

  // Content Reporting Endpoints
  static const String reportPath = '/api/reports/';

  // Admin Endpoints (under real_estate app)
  static const String adminDashboardPath = '/real_estate/admin/dashboard/';
  static const String adminDashboardChartsPath = '/real_estate/admin/dashboard/charts/';
  static const String adminAgentVerificationPath = '/real_estate/admin/agents/verification/';
  static const String adminPendingAgentsPath = '/real_estate/api/admin/agents/pending/';
  static const String adminVerifyAgentPath = '/real_estate/api/admin/agents/{id}/verify/';
  // Note: Reports, Users, Content endpoints need to be implemented in backend
  // For now, using placeholder paths that match the pattern
  static const String adminReportsPath = '/api/admin/reports/';
  static const String adminUsersPath = '/api/admin/users/';
  static const String adminContentPath = '/api/admin/content/';
  static const String adminStatsPath = '/api/admin/stats/';
  static const String adminUserSuspendPath = '/api/admin/users/{id}/suspend/';
  static const String adminUserBanPath = '/api/admin/users/{id}/ban/';
  static const String adminContentRemovePath = '/api/admin/content/{id}/remove/';
  static const String adminReportUpdatePath = '/api/admin/reports/{id}/update/';

  // Chat Endpoints (using v1 API)
  static const String chatListPath = '/api/chats/';
  static const String userListPath = '/api/users/';
  static const String authPath = '/api/auth/';
  static const String chatPath = 'chats/';

  // Notification Endpoints
  static const String notificationsPath = '/api/notifications/';
  static const String notificationsUnreadCountPath = '/api/notifications/unread-count/';
  static const String notificationsMarkAllReadPath = '/api/notifications/mark-all-read/';
  static const String fcmTokenPath = '/accounts/fcm-token/'; // FCM token registration endpoint

  // WebSocket Paths
  static const String chatListWsPath = '/ws/chatrooms/';
  static const String chatRoomWsPath = '/ws/chat/'; // append room_id
  static const String notificationsWsPath = '/ws/notifications/';

  // Local Storage Keys
  static const String tokenKey = 'token'; // Access token (backward compatible)
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userIdKey = 'userId';
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
  static String getRefreshTokenUrl() => '$baseUrl$refreshTokenPath';
  static String getVerifyTokenUrl() => '$baseUrl$verifyTokenPath';
  static String getLogoutUrl() => '$baseUrl$logoutPath';
  static String getProductsUrl() => '$baseUrl$productsPath';
  static String getServicesUrl() => '$baseUrl$servicesPath';
  static String getChatListUrl() => '$baseUrl$chatListPath';
  static String getUserListUrl() => '$baseUrl$userListPath';
  static String getNotificationsUrl() => '$baseUrl$notificationsPath';
  static String getNotificationsUnreadCountUrl() => '$baseUrl$notificationsUnreadCountPath';
  static String getNotificationsMarkAllReadUrl() => '$baseUrl$notificationsMarkAllReadPath';
  static String getFcmTokenUrl() => '$baseUrl$fcmTokenPath';
  
  // WebSocket URLs
  static String getChatListWsUrl() => '$wsBaseUrl$chatListWsPath';
  static String getChatRoomWsUrl(String roomId) => '$wsBaseUrl$chatRoomWsPath$roomId';
  static String getNotificationsWsUrl() => '$wsBaseUrl$notificationsWsPath';
}

