import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

const _tokenExpiryKey = 'token_expiry';
const _accessTokenKey = 'access_token';
const _refreshTokenKey = 'refresh_token';
const _rememberMeKey = 'remember_me';

// remember me
Future<void> saveRememberMe(bool value) async {
  final storage = const FlutterSecureStorage();
  await storage.write(key: _rememberMeKey, value: value.toString());
}

Future<bool> shouldRememberMe() async {
  final storage = const FlutterSecureStorage();
  String? value = await storage.read(key: _rememberMeKey);
  return value == 'true';
}

// saving tokens
Future<void> _saveTokensWithExpiry(String access, String refresh) async {
  final storage = const FlutterSecureStorage();
  await storage.write(key: _accessTokenKey, value: access);
  await storage.write(key: _refreshTokenKey, value: refresh);

  bool remember = await shouldRememberMe();

  final duration =
      remember ? const Duration(days: 7) : const Duration(minutes: 30);

  final expiryTime = DateTime.now().add(duration).toIso8601String();
  await storage.write(key: _tokenExpiryKey, value: expiryTime);
}

Future<void> saveTokens(String access, String refresh) async {
  await _saveTokensWithExpiry(access, refresh);
}

// Expiry Check
Future<bool> _isTokenExpired() async {
  final storage = const FlutterSecureStorage();
  final expiryStr = await storage.read(key: _tokenExpiryKey);
  if (expiryStr == null) return true;
  final expiryTime = DateTime.tryParse(expiryStr);
  if (expiryTime == null) return true;

  return DateTime.now().isAfter(expiryTime);
}

// refresh
Future<bool> _refreshTokens() async {
  if (await shouldRememberMe() == false) return false;

  final storage = const FlutterSecureStorage();
  final refresh = await storage.read(key: _refreshTokenKey);
  if (refresh == null) return false;

  try {
    final response = await http.post(
      Uri.parse("http://10.0.2.2:8000/api/refresh/"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({'refresh': refresh}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await _saveTokensWithExpiry(data['access'], data['refresh'] ?? refresh);
      return true;
    }
  } catch (e) {
    return false;
  }
  return false;
}

Future<Map<String, String>?> getValidAccessToken() async {
  final storage = const FlutterSecureStorage();
  String? access = await storage.read(key: _accessTokenKey);
  String? refresh = await storage.read(key: _refreshTokenKey);

  if (access == null || refresh == null) return null;

  if (await _isTokenExpired()) {
    // This only attempts refresh if "Remember Me" is true
    final refreshed = await _refreshTokens();
    if (refreshed) {
      access = await storage.read(key: _accessTokenKey);
      refresh = await storage.read(key: _refreshTokenKey);
    } else {
      // If refresh is disabled (Remember=False) or failed, user is logged out
      return null;
    }
  } else {
    // If they ARE remembered, extend the window by 7 days every time they use it
    if (await shouldRememberMe()) {
      final newExpiry =
          DateTime.now().add(const Duration(days: 7)).toIso8601String();
      await storage.write(key: _tokenExpiryKey, value: newExpiry);
    }
  }

  return {'access': access!, 'refresh': refresh!};
}

// logout
Future<void> logout() async {
  final storage = const FlutterSecureStorage();
  await storage.delete(key: _accessTokenKey);
  await storage.delete(key: _refreshTokenKey);
  await storage.delete(key: _tokenExpiryKey);
}
