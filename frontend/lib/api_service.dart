import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'auth_page.dart';
import 'main.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  static const String baseUrl = "rahhal-final-production.up.railway.app";
  final storage = const FlutterSecureStorage();

  Future<dynamic> request({
    required String method,
    required String endpoint,
    Map<String, dynamic>? data,
    Map<String, String>? queryParams,
    bool requiresAuth = true,
  }) async {
    String path = endpoint.startsWith('/') ? "/api$endpoint" : "/api/$endpoint";
    path = path.replaceAll('//', '/');
    final uri = Uri.https(baseUrl, path, queryParams);

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (requiresAuth) {
      String? token = await storage.read(key: 'access_token');
      if (token != null) headers['Authorization'] = 'Bearer $token';
    }

    try {
      debugPrint(" API Request: ${method.toUpperCase()} to $uri");
      http.Response response;
      final body = data != null ? jsonEncode(data) : null;

      switch (method.toUpperCase()) {
        case 'GET':
          response = await http
              .get(uri, headers: headers)
              .timeout(const Duration(seconds: 50));
          break;
        case 'POST':
          response = await http
              .post(uri, headers: headers, body: body)
              .timeout(const Duration(seconds: 50));
          break;
        case 'PATCH':
          response = await http
              .patch(uri, headers: headers, body: body)
              .timeout(const Duration(seconds: 50));
          break;
        default:
          throw Exception("Method $method not supported");
      }

      return _handleResponse(response);
    } catch (e) {
      debugPrint(" Network/API Error: $e");
      throw Exception("Request failed: $e");
    }
  }

  dynamic _handleResponse(http.Response response) {
    dynamic body;
    try {
      body = jsonDecode(utf8.decode(response.bodyBytes));
    } catch (_) {
      body = response.body;
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    } else if (response.statusCode == 401) {
      debugPrint(" Session Expired - Logging out");
      _logout();
      throw Exception("Session expired. Please login again.");
    } else {
      String message = body is Map
          ? (body['detail'] ?? body['error'] ?? "Server Error")
          : body.toString();
      throw Exception(message);
    }
  }

  void _logout() {
    storage.deleteAll();
    navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => AuthPage()),
      (route) => false,
    );
  }
}
