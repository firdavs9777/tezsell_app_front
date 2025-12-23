import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:app/service/authentication_service.dart';
import 'package:app/config/app_config.dart';
import 'package:app/utils/app_logger.dart';
import 'package:flutter/foundation.dart';

/// HTTP client service with automatic token refresh on 401 errors
/// 
/// This service wraps http.Client and automatically:
/// - Adds Authorization headers to requests
/// - Refreshes tokens on 401 errors
/// - Retries failed requests with new tokens
class HttpClientService {
  static HttpClientService? _instance;
  final AuthenticationService _authService;
  http.Client? _client;
  bool _isRefreshing = false;
  Completer<bool>? _refreshCompleter;

  HttpClientService._(this._authService);

  factory HttpClientService(AuthenticationService authService) {
    _instance ??= HttpClientService._(authService);
    return _instance!;
  }

  http.Client get client {
    _client ??= http.Client();
    return _client!;
  }

  /// Make a GET request with automatic token refresh
  Future<http.Response> get(
    Uri url, {
    Map<String, String>? headers,
    bool retryOn401 = true,
  }) async {
    return _makeRequest(
      () => client.get(url, headers: await _addAuthHeaders(headers)),
      retryOn401: retryOn401,
    );
  }

  /// Make a POST request with automatic token refresh
  Future<http.Response> post(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
    bool retryOn401 = true,
  }) async {
    return _makeRequest(
      () => client.post(
        url,
        headers: await _addAuthHeaders(headers),
        body: body,
        encoding: encoding,
      ),
      retryOn401: retryOn401,
    );
  }

  /// Make a PUT request with automatic token refresh
  Future<http.Response> put(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
    bool retryOn401 = true,
  }) async {
    return _makeRequest(
      () => client.put(
        url,
        headers: await _addAuthHeaders(headers),
        body: body,
        encoding: encoding,
      ),
      retryOn401: retryOn401,
    );
  }

  /// Make a DELETE request with automatic token refresh
  Future<http.Response> delete(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
    bool retryOn401 = true,
  }) async {
    return _makeRequest(
      () => client.delete(
        url,
        headers: await _addAuthHeaders(headers),
        body: body,
        encoding: encoding,
      ),
      retryOn401: retryOn401,
    );
  }

  /// Make a PATCH request with automatic token refresh
  Future<http.Response> patch(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
    bool retryOn401 = true,
  }) async {
    return _makeRequest(
      () => client.patch(
        url,
        headers: await _addAuthHeaders(headers),
        body: body,
        encoding: encoding,
      ),
      retryOn401: retryOn401,
    );
  }

  /// Add authentication headers to request
  Future<Map<String, String>> _addAuthHeaders(Map<String, String>? headers) async {
    final token = await _authService.getStoredToken();
    final finalHeaders = Map<String, String>.from(headers ?? {});
    
    if (token != null && token.isNotEmpty) {
      finalHeaders['Authorization'] = 'Token $token';
    }
    
    // Add default headers if not present
    finalHeaders.putIfAbsent('Content-Type', () => 'application/json');
    finalHeaders.putIfAbsent('Accept', () => 'application/json');
    
    return finalHeaders;
  }

  /// Make a request with automatic retry on 401
  Future<http.Response> _makeRequest(
    Future<http.Response> Function() request, {
    required bool retryOn401,
  }) async {
    var response = await request();

    // If 401 and retry is enabled, try to refresh token and retry
    if (response.statusCode == 401 && retryOn401) {
      AppLogger.warning('Received 401, attempting token refresh');
      
      final refreshed = await _refreshTokenIfNeeded();
      if (refreshed) {
        // Retry the request with new token
        AppLogger.info('Retrying request with refreshed token');
        response = await request();
      } else {
        AppLogger.error('Token refresh failed, request will return 401');
      }
    }

    return response;
  }

  /// Refresh token if not already refreshing
  Future<bool> _refreshTokenIfNeeded() async {
    if (_isRefreshing) {
      // Wait for ongoing refresh
      if (_refreshCompleter != null) {
        return await _refreshCompleter!.future;
      }
      return false;
    }

    _isRefreshing = true;
    _refreshCompleter = Completer<bool>();
    
    try {
      final token = await _authService.refreshToken();
      final success = token != null;
      _refreshCompleter!.complete(success);
      return success;
    } catch (e) {
      _refreshCompleter!.complete(false);
      return false;
    } finally {
      _isRefreshing = false;
      _refreshCompleter = null;
    }
  }

  /// Close the HTTP client
  void close() {
    _client?.close();
    _client = null;
  }

  /// Dispose resources
  void dispose() {
    close();
    _instance = null;
  }
}

