import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'auth_page.dart';
import 'main.dart';
import 'auth_service.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  ApiService._internal();

  final String _baseUrl = "192.168.43.152:8000";
  final storage = const FlutterSecureStorage();

  // The primary method to handle all requests
  Future<dynamic> request({
    required String method,
    required String endpoint,
    Map<String, dynamic>? data,
    Map<String, String>? queryParams,
    bool requiresAuth = true,
  }) async {
    final uri = Uri.http(_baseUrl, "/api$endpoint", queryParams);

    // Prepare Headers
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    // Inject Token if required
    if (requiresAuth) {
      final token = await getValidAccessToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer ${token['access']}';
      }
    }

    try {
      http.Response response;
      switch (method.toUpperCase()) {
        case 'GET':
          response = await http.get(uri, headers: headers);
          break;
        case 'POST':
          response =
              await http.post(uri, headers: headers, body: jsonEncode(data));
          break;
        case 'PUT':
          response =
              await http.put(uri, headers: headers, body: jsonEncode(data));
          break;
        case 'DELETE':
          response = await http.delete(uri, headers: headers);
          break;
        default:
          throw Exception("Method $method not supported");
      }

      return _handleResponse(response);
    } catch (e) {
      throw Exception("Network Error: $e");
    }
  }

  // Centralized response logic
  dynamic _handleResponse(http.Response response) {
    final body = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    } else if (response.statusCode == 401) {
      // Logic for Unauthorized: redirect to login
      storage.delete(key: 'access_token');
      storage.delete(key: 'refresh_token');
      storage.delete(key: 'token_expiry');

      navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => AuthPage()),
        (route) =>
            false, // This clears the navigation stack so they can't go back
      );
      throw Exception("Session expired. Please login again.");
    } else {
      // Extract the most relevant error message from the response body
      String message = "Error: ${response.statusCode}";
      if (body is Map) {
        message = body['message'] ??
            body['detail'] ??
            body['error'] ??
            body.values.first.toString();
      } else if (body is String) {
        message = body;
      }
      throw Exception(message);
    }
  }
}
