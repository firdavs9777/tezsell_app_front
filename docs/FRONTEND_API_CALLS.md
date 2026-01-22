# Frontend API Calls - Search & Start Chat

## Overview
This document explains how the frontend calls the new backend endpoints for user search and starting chats.

---

## 1. User Search Flow

### **UI Trigger** (`lib/pages/chat/user_list.dart`)

```dart
// User types in search field
TextField(
  controller: _searchController,
  // ... search field UI
)

// Search is debounced (500ms delay)
void _onSearchChanged() {
  _searchDebounceTimer?.cancel();
  _searchDebounceTimer = Timer(const Duration(milliseconds: 500), () {
    if (_searchController.text.isNotEmpty) {
      _performSearch(_searchController.text); // 🔥 Triggers search
    }
  });
}
```

### **Frontend Call** (`lib/pages/chat/user_list.dart`)

```dart
Future<void> _performSearch(String query) async {
  setState(() {
    _isSearching = true;
  });
  
  try {
    // 🔥 Call provider method
    final results = await ref.read(chatProvider.notifier).searchUsers(
      query: query.trim()
    );
    
    setState(() {
      _searchResults = results; // Display results
      _isSearching = false;
    });
  } catch (e) {
    // Handle error
  }
}
```

### **Provider Layer** (`lib/providers/provider_root/chat_provider.dart`)

```dart
Future<List<Map<String, dynamic>>> searchUsers({String? query, int? userId}) async {
  if (!state.isAuthenticated) {
    return [];
  }

  try {
    // 🔥 Call API service
    return await _apiService.searchUsers(query: query, userId: userId);
  } catch (e) {
    print('🚨 Error searching users: $e');
    return [];
  }
}
```

### **API Service** (`lib/providers/provider_root/chat_api_service.dart`)

```dart
Future<List<Map<String, dynamic>>> searchUsers({String? query, int? userId}) async {
  final headers = await _getHeaders();
  
  // 🔥 Build URL with query parameters
  final uri = Uri.parse('$baseUrl$chatBasePath/search-users/').replace(
    queryParameters: {
      if (query != null && query.isNotEmpty) 'q': query,
      if (userId != null) 'user_id': userId.toString(),
    },
  );
  
  // 🔥 HTTP GET request
  final response = await http.get(uri, headers: headers);
  
  if (response.statusCode == 200) {
    final data = json.decode(utf8.decode(response.bodyBytes));
    // Parse response
    if (data is List) {
      return data.cast<Map<String, dynamic>>();
    } else if (data is Map && data.containsKey('results')) {
      return (data['results'] as List).cast<Map<String, dynamic>>();
    }
    return [];
  } else {
    throw Exception('Failed to search users: ${response.statusCode}');
  }
}
```

### **Backend Endpoint**
```
GET /chats/search-users/?q=username
GET /chats/search-users/?user_id=123
```

### **Response Format**
```json
[
  {
    "user": {
      "id": 123,
      "username": "john_doe",
      "display_name": "John Doe",
      "profile_image": "https://api.webtezsell.com/media/...",
      "is_online": true
    },
    "has_chat": true,
    "chat_id": 45
  }
]
```

---

## 2. Start Chat Flow

### **UI Trigger** (`lib/pages/chat/user_list.dart`)

```dart
// User taps on search result or user tile
InkWell(
  onTap: () => _startChatFromSearch(result), // 🔥 Triggers start chat
  child: // ... user tile UI
)
```

### **Frontend Call** (`lib/pages/chat/user_list.dart`)

```dart
Future<void> _startChatFromSearch(Map<String, dynamic> searchResult) async {
  final userId = searchResult['user_id'] as int? ?? searchResult['id'] as int?;
  
  // Show loading dialog
  showDialog(/* loading indicator */);
  
  try {
    // 🔥 Call provider method
    final chatRoom = await ref.read(chatProvider.notifier).getOrCreateDirectChat(userId);
    
    // Navigate to chat room
    if (chatRoom != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ChatRoomScreen(chatRoom: chatRoom),
        ),
      );
    }
  } catch (e) {
    // Handle error
  }
}
```

### **Provider Layer** (`lib/providers/provider_root/chat_provider.dart`)

```dart
Future<ChatRoom?> getOrCreateDirectChat(int targetUserId) async {
  try {
    state = state.copyWith(isLoading: true);
    
    // 🔥 Try new start chat endpoint first
    try {
      final result = await _apiService.startChatWithUser(targetUserId);
      final chatData = result['chat'] as Map<String, dynamic>?;
      if (chatData != null) {
        final chatRoom = ChatRoom.fromJson(chatData);
        await loadChatRooms(); // Refresh chat list
        return chatRoom;
      }
    } catch (e) {
      print('⚠️ Start chat endpoint failed, trying fallback: $e');
    }
    
    // 🔥 Fallback to old endpoint
    final chatRoom = await _apiService.getOrCreateDirectChat(targetUserId);
    await loadChatRooms();
    return chatRoom;
  } catch (e) {
    // Handle error
    return null;
  }
}
```

### **API Service - New Endpoint** (`lib/providers/provider_root/chat_api_service.dart`)

```dart
Future<Map<String, dynamic>> startChatWithUser(int userId) async {
  final headers = await _getHeaders();
  
  // 🔥 HTTP GET request to new endpoint
  final response = await http.get(
    Uri.parse('$baseUrl$chatBasePath/start/$userId/'),
    headers: headers,
  );
  
  if (response.statusCode == 200) {
    final data = json.decode(utf8.decode(response.bodyBytes));
    return data as Map<String, dynamic>;
  } else {
    throw Exception('Failed to start chat: ${response.statusCode}');
  }
}
```

### **API Service - Fallback Endpoint**

```dart
Future<ChatRoom> getOrCreateDirectChat(int targetUserId) async {
  final headers = await _getHeaders();
  
  // 🔥 HTTP POST request to old endpoint
  final response = await http.post(
    Uri.parse('$baseUrl$chatBasePath/direct/'),
    headers: headers,
    body: json.encode({'target_user_id': targetUserId}),
    encoding: utf8,
  );
  
  if (response.statusCode == 200 || response.statusCode == 201) {
    final data = json.decode(utf8.decode(response.bodyBytes));
    return ChatRoom.fromJson(data);
  } else {
    throw Exception('Failed to get/create direct chat: ${response.statusCode}');
  }
}
```

### **Backend Endpoints**
```
GET /chats/start/123/          (New - preferred)
POST /chats/direct/             (Fallback)
```

### **Response Format (New Endpoint)**
```json
{
  "chat": {
    "id": 45,
    "name": "john_doe",
    "participants": [...],
    "last_message": {...},
    "unread_count": 0
  },
  "created": true,
  "target_user": {...}
}
```

---

## 3. Complete Flow Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                    USER INTERACTION                           │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│  UserListScreen (UI)                                         │
│  - User types in search field                                │
│  - Debounce timer (500ms)                                    │
│  - Calls _performSearch()                                     │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│  ChatProvider (State Management)                             │
│  - searchUsers(query: "john")                                │
│  - Validates authentication                                  │
│  - Calls API service                                         │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│  ChatApiService (API Layer)                                  │
│  - Builds URL: /chats/search-users/?q=john                  │
│  - Adds auth headers                                         │
│  - Makes HTTP GET request                                    │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│  Backend API                                                │
│  GET /chats/search-users/?q=john                             │
│  - Validates token                                           │
│  - Searches users                                            │
│  - Returns results with online status, chat info            │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│  Response Processing                                         │
│  - Decodes UTF-8 response                                    │
│  - Parses JSON                                               │
│  - Returns List<Map<String, dynamic>>                        │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│  UI Update                                                  │
│  - Displays search results                                   │
│  - Shows "Chat exists" badges                                │
│  - Shows online status                                       │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│  User Taps Result                                            │
│  - Calls _startChatFromSearch()                               │
│  - Extracts user_id                                          │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│  ChatProvider.getOrCreateDirectChat()                        │
│  - Tries new endpoint: GET /chats/start/123/                │
│  - Falls back to: POST /chats/direct/                        │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│  ChatApiService                                              │
│  - Makes HTTP request                                        │
│  - Parses chat room data                                     │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│  Navigation                                                  │
│  - Opens ChatRoomScreen                                      │
│  - User can start messaging                                  │
└─────────────────────────────────────────────────────────────┘
```

---

## 4. Key Implementation Details

### **Search Debouncing**
- Prevents excessive API calls while typing
- 500ms delay after user stops typing
- Cancels previous timer if user continues typing

### **Error Handling**
- Try-catch blocks at each layer
- User-friendly error messages via SnackBar
- Fallback to old endpoint if new one fails

### **State Management**
- Uses Riverpod for state management
- Updates UI reactively when search completes
- Shows loading indicators during API calls

### **UTF-8 Encoding**
- All API responses decoded with `utf8.decode(response.bodyBytes)`
- Ensures proper handling of Korean characters and emojis

### **Authentication**
- Token included in headers: `Authorization: Token <token>`
- Checks authentication before making API calls

---

## 5. Usage Examples

### **Example 1: Search by Username**
```dart
// User types "john" in search field
// After 500ms, calls:
await ref.read(chatProvider.notifier).searchUsers(query: "john");

// Makes request: GET /chats/search-users/?q=john
// Returns users matching "john"
```

### **Example 2: Search by User ID**
```dart
// Direct user ID lookup
await ref.read(chatProvider.notifier).searchUsers(userId: 123);

// Makes request: GET /chats/search-users/?user_id=123
// Returns specific user info
```

### **Example 3: Start Chat from Search Result**
```dart
// User taps on search result
final result = {
  "user": {"id": 123, "username": "john"},
  "has_chat": false
};

// Calls:
await ref.read(chatProvider.notifier).getOrCreateDirectChat(123);

// Tries: GET /chats/start/123/
// If fails, tries: POST /chats/direct/ with body: {"target_user_id": 123}
// Returns ChatRoom object
```

---

## 6. Files Involved

1. **UI Layer**: `lib/pages/chat/user_list.dart`
   - Search input field
   - Search results display
   - User interaction handling

2. **State Management**: `lib/providers/provider_root/chat_provider.dart`
   - `searchUsers()` method
   - `getOrCreateDirectChat()` method
   - State updates

3. **API Layer**: `lib/providers/provider_root/chat_api_service.dart`
   - `searchUsers()` HTTP call
   - `startChatWithUser()` HTTP call
   - `getOrCreateDirectChat()` HTTP call (fallback)

4. **Navigation**: `lib/pages/chat/chat_list.dart`
   - Button to open UserListScreen
   - Integration with chat list

---

## 7. Testing the Flow

1. **Open Chat List** → Tap "+" button
2. **Search Users** → Type in search field (e.g., "john")
3. **View Results** → See matching users with online status
4. **Start Chat** → Tap on any user
5. **Chat Opens** → Navigate to chat room automatically

---

## 8. Error Scenarios

### **Search Fails**
- Shows SnackBar with error message
- Keeps existing user list visible
- User can retry search

### **Start Chat Fails**
- Shows error dialog
- User stays on user list screen
- Can try again or select different user

### **Network Issues**
- Handled by HTTP client
- Shows appropriate error messages
- No app crash

---

This implementation provides a smooth, KakaoTalk-like experience for searching and starting chats!

