import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/android/config/api_config.dart';
import 'session_manager.dart';

class ApiClient {

  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    return {
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
  }

  Future<http.Response> get(String endpoint) async {
    final headers = await _getHeaders();

    final response = await http.get(
      Uri.parse("${ApiConfig.baseUrl}$endpoint"),
      headers: headers,
    );

    _handleAuthError(response);
    return response;
  }

  Future<http.Response> post(String endpoint, Map body) async {
    final headers = await _getHeaders();

    final response = await http.post(
      Uri.parse("${ApiConfig.baseUrl}$endpoint"),
      headers: headers,
      body: jsonEncode(body),
    );

    _handleAuthError(response);
    return response;
  }

  Future<http.Response> put(String endpoint, Map body) async {
    final headers = await _getHeaders();

    final response = await http.put(
      Uri.parse("${ApiConfig.baseUrl}$endpoint"),
      headers: headers,
      body: jsonEncode(body),
    );

    _handleAuthError(response);
    return response;
  }

  void _handleAuthError(http.Response response) {
    if (response.statusCode == 401) {
      print("TOKEN EXPIRADO → LOGOUT AUTOMÁTICO");
      SessionManager.logout();
    }
  }
}