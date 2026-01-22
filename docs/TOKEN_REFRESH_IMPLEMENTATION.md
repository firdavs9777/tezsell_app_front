# Token Refresh Implementation Guide

This document explains the token refresh system implementation in the Flutter app.

## Overview

The app now implements a **two-token system**:
- **Access Token**: Short-lived (24 hours) - used for API requests
- **Refresh Token**: Long-lived (30 days) - used to get new access tokens

This keeps users logged in for **30 days** while maintaining security through token rotation.

---

## Implementation Details

### 1. Updated Components

#### `lib/config/app_config.dart`
- Added new endpoints: `refreshTokenPath`, `verifyTokenPath`, `logoutPath`
- Added storage keys: `accessTokenKey`, `refreshTokenKey`

#### `lib/service/authentication_service.dart`
- Updated `Token` class to include `refreshToken`, `expiresIn`, `refreshExpiresIn`
- Updated `login()` and `register()` to handle both tokens
- Added `refreshToken()` method
- Added `verifyToken()` method
- Updated `logout()` to revoke tokens on backend
- Updated `_saveUserDataAsync()` to store both tokens and expiry times

#### `lib/service/http_client_service.dart` (NEW)
- HTTP client wrapper with automatic token refresh on 401 errors
- Automatically retries failed requests after refreshing token
- Singleton pattern for efficient resource usage

#### `lib/service/token_refresh_service.dart` (NEW)
- Automatic proactive token refresh (every 23 hours)
- Checks token expiry and refreshes if needed
- Can be started/stopped as needed

---

## Usage

### 1. Automatic Token Refresh (Recommended)

The `TokenRefreshService` automatically refreshes tokens every 23 hours. Initialize it after login:

```dart
import 'package:app/service/token_refresh_service.dart';
import 'package:app/service/authentication_service.dart';

// After successful login
final authService = ref.read(authenticationServiceProvider);
final tokenRefreshService = TokenRefreshService(authService);
tokenRefreshService.start(); // Starts automatic refresh
```

**Where to initialize:**
- In `login.dart` after successful login
- In `main.dart` if user is already logged in (check `isLoggedIn()`)

### 2. Using HttpClientService (Recommended for new code)

For new API calls, use `HttpClientService` which automatically handles token refresh:

```dart
import 'package:app/service/http_client_service.dart';
import 'package:app/service/authentication_service.dart';

final authService = ref.read(authenticationServiceProvider);
final httpClient = HttpClientService(authService);

// Make API call - token refresh happens automatically on 401
final response = await httpClient.get(
  Uri.parse('https://api.example.com/data'),
);
```

### 3. Manual Token Refresh

If you need to manually refresh the token:

```dart
final authService = ref.read(authenticationServiceProvider);
final newToken = await authService.refreshToken();

if (newToken != null) {
  // Token refreshed successfully
} else {
  // Refresh failed - user needs to login again
}
```

### 4. Verify Token

Check if current token is valid:

```dart
final authService = ref.read(authenticationServiceProvider);
final isValid = await authService.verifyToken();

if (!isValid) {
  // Token is invalid - try refreshing or redirect to login
}
```

---

## Migration Guide

### Existing Code Using `http` Package

**Before:**
```dart
import 'package:http/http.dart' as http;

final response = await http.get(
  Uri.parse('https://api.example.com/data'),
  headers: {
    'Authorization': 'Token $token',
  },
);
```

**After (Option 1 - Use HttpClientService):**
```dart
import 'package:app/servichttp_client_service.dart';

final httpClient = HttpClientService(authService);
final response = await httpClient.get(
  Uri.parse('https://api.example.com/data'),
);
```

**After (Option 2 - Manual refresh on 401):**
```dart
import 'package:http/http.dart' as http;

var response = await http.get(
  Uri.parse('https://api.example.com/data'),
  headers: {'Authorization': 'Token $token'},
);

if (response.statusCode == 401) {
  // Try to refresh token
  final newToken = await authService.refreshToken();
  if (newToken != null) {
    // Retry request
    response = await http.get(
      Uri.parse('https://api.example.com/data'),
      headers: {'Authorization': 'Token ${newToken.accessToken}'},
    );
  }
}
```

### Existing Code Using AuthenticationService

The `Token` class is backward compatible:
```dart
// Old code still works
final token = await authService.login(context, phone, password);
final tokenString = token?.token; // Still works!

// New code can use accessToken
final token = await authService.login(context, phone, password);
final accessToken = token?.accessToken;
final refreshToken = token?.refreshToken;
```

---

## Storage Keys

Tokens are stored in SharedPreferences with these keys:

- `token` - Access token (backward compatible)
- `access_token` - Access token (new key)
- `refresh_token` - Refresh token
- `token_expires_in` - Expiry time in seconds
- `token_expires_at` - Expiry timestamp (ISO 8601)
- `refresh_token_expires_in` - Refresh token expiry in seconds
- `refresh_token_expires_at` - Refresh token expiry timestamp

---

## Error Handling

### Token Refresh Fails

If token refresh fails (refresh token expired/invalid):
1. `refreshToken()` returns `null`
2. User should be redirected to login
3. All stored tokens are cleared on logout

### 401 Errors

When using `HttpClientService`:
1. Automatically detects 401 error
2. Attempts to refresh token
3. Retries original request with new token
4. Returns 401 if refresh fails

---

## Testing

### Test Login
```dart
final token = await authService.login(context, phone, password);
assert(token != null);
assert(token!.accessToken.isNotEmpty);
assert(token.refreshToken != null);
```

### Test Token Refresh
```dart
final newToken = await authService.refreshToken();
assert(newToken != null);
assert(newToken!.accessToken.isNotEmpty);
```

### Test Automatic Refresh
```dart
final tokenRefreshService = TokenRefreshService(authService);
tokenRefreshService.start();
// Wait 23 hours or manually trigger refresh
```

---

## Backend Requirements

The backend must implement these endpoints:

1. **POST /api/accounts/refresh-token/**
   - Request: `{"refresh_token": "..."}`
   - Response: `{"access_token": "...", "refresh_token": "...", "expires_in": 86400}`

2. **GET /api/accounts/verify-token/**
   - Headers: `Authorization: Token <access_token>`
   - Response: `{"success": true}`

3. **POST /api/accounts/logout/**
   - Headers: `Authorization: Token <access_token>`
   - Request: `{"refresh_token": "..."}` (optional)
   - Response: `{"success": true}`

---

## Security Features

✅ **Short-lived access tokens** (24 hours) - Limits damage if stolen  
✅ **Long-lived refresh tokens** (30 days) - Keeps users logged in  
✅ **Token revocation** - Logged out tokens cannot be reused  
✅ **Automatic expiry** - Tokens expire automatically  
✅ **Backward compatible** - Existing `token` field still works  

---

## Next Steps

1. **Initialize TokenRefreshService** after login
2. **Migrate API calls** to use `HttpClientService` (optional but recommended)
3. **Test token refresh** flow
4. **Monitor logs** for token refresh events

---

## Troubleshooting

### Token refresh not working
- Check if refresh token is stored: `await authService.getStoredRefreshToken()`
- Check backend endpoint: `/api/accounts/refresh-token/`
- Check logs for errors

### User logged out unexpectedly
- Check refresh token expiry (30 days)
- Check if logout was called
- Check backend token revocation

### 401 errors persist
- Ensure `HttpClientService` is used or manual refresh is implemented
- Check if refresh token is valid
- Verify backend token validation

---

**Generated:** 2024  
**Last Updated:** After token refresh implementation

