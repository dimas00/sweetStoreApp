import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/session_manager.dart';
import '../config/api_config.dart';
import '../network/api_exception.dart';


class ApiClient {

  // 🔐 monta headers (com ou sem token)
  Future<Map<String, String>> _getHeaders({bool auth = true}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    print("TOKEN DO STORAGE: $token");

    return {
      "Content-Type": "application/json",
      if (auth && token != null) "Authorization": "Bearer $token",
    };
  }

  // ========================
  // GET
  // ========================
  Future<dynamic> get(String endpoint) async {
    final headers = await _getHeaders();

    final response = await http.get(
      Uri.parse("${ApiConfig.baseUrl}$endpoint"),
      headers: headers,
    );

    return _handleResponse(response);
  }

  // ========================
  // POST
  // ========================
  Future<dynamic> post(String endpoint, Map body, {bool auth = true}) async {
    final headers = await _getHeaders(auth: auth);

    final response = await http.post(
      Uri.parse("${ApiConfig.baseUrl}$endpoint"),
      headers: headers,
      body: jsonEncode(body),
    );

    return _handleResponse(response);
  }

  // ========================
  // PUT
  // ========================
  Future<dynamic> put(String endpoint, Map body) async {
    final headers = await _getHeaders();

    final response = await http.put(
      Uri.parse("${ApiConfig.baseUrl}$endpoint"),
      headers: headers,
      body: jsonEncode(body),
    );

    return _handleResponse(response);
  }

  // ========================
  // CENTRALIZA TUDO AQUI
  // ========================
  dynamic _handleResponse(http.Response response) {
    final statusCode = response.statusCode;

    // tenta ler body
    dynamic body;
    try {
      body = jsonDecode(response.body);
    } catch (_) {
      body = null;
    }

    // 🔐 401 → logout
    if (statusCode == 401) {

      print("TOKEN EXPIRADO → LOGOUT AUTOMÁTICO");

      SessionManager.logout();

      throw ApiException(
        body?["message"] ?? "Sessão expirada",
        statusCode,
      );
    }

    // ❌ erros gerais (400, 403, 409, 500...)
    if (statusCode >= 400) {
      throw ApiException(
        body?["message"] ?? "Erro inesperado",
        statusCode,
      );
    }

    // ✅ sucesso
    return body;
  }
}