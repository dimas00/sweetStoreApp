import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/auth_service.dart';
import '../../features/auth/session_manager.dart';
import '../../main.dart';
import '../config/api_config.dart';
import '../network/api_exception.dart';
import '../state/app_state.dart';
import '../utils/app_alert.dart';


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
  // DELETE
  // ========================
  Future<dynamic> delete(String endpoint) async {
    final headers = await _getHeaders();

    final response = await http.delete(
      Uri.parse("${ApiConfig.baseUrl}$endpoint"),
      headers: headers,
    );

    return _handleResponse(response);
  }

  // ========================
  // CENTRALIZA TUDO AQUI
  // ========================
  dynamic _handleResponse(http.Response response) {
    final statusCode = response.statusCode;

    dynamic body;
    try {
      body = jsonDecode(response.body);
    } catch (_) {
      body = null;
    }

    // 🚨 401 (Não Autorizado) ou 403 (Proibido) → TOKEN EXPIRADO
    if (statusCode == 401 || statusCode == 403) {
      print("TOKEN EXPIRADO → KICK GLOBAL");

      // 1. Limpa os dados de sessão
      AuthService.logout();
      AppState.userController.limpar();

      // 2. Pega o contexto da tela atual através da chave global
      final context = navigatorKey.currentContext;

      if (context != null) {
        // 3. Avisa o usuário!
        AppAlert.showError(context, "Sua sessão expirou. Por favor, faça login novamente.");

        // 4. Redireciona para o login apagando o histórico (pra não ter como voltar)
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      }

      throw ApiException(body?["message"] ?? "Sessão expirada", statusCode);
    }

    // ❌ Outros erros (400, 404, 500)
    if (statusCode >= 400) {
      throw ApiException(body?["message"] ?? "Erro inesperado", statusCode);
    }

    // ✅ sucesso
    return body;
  }
}