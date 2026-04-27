import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/config/api_config.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_exception.dart';



class AuthService {
  static String? token;

  final String baseUrl = ApiConfig.baseUrl;
  final api = ApiClient();



  Future<String?> login(String email, String senha) async {
    try {
      final data = await ApiClient().post(
        "/auth",
        {
          "email": email,
          "senha": senha,
        },
        auth: false, // 🔥 login não usa token
      );

      final token = data["data"]["token"];
      print("TOKEN RECEBIDO: $token");
      if (token != null) {
        await salvarToken(token);
        return token;
      }

      throw ApiException("Token não retornado", 500);

    } on ApiException {
      rethrow; // 🔥 deixa a UI tratar
    }
  }

  Future<String?> register(
      String nome,
      String email,
      String senha,
      String cpf,
      String telefone,
      ) async {
    try {
      final data = await ApiClient().post(
        "/auth/register",
        {
          "nome": nome,
          "email": email,
          "senha": senha,
          "cpf": cpf,
          "telefone": telefone,
        },
        auth: false,
      );

      final token = data["data"]?["token"];
      print("token recebido:  $token");

      if (token != null) {
        await salvarToken(token);
        AuthService.token = token;
        return token;
      }

      throw ApiException("Erro ao registrar", 500);

    } on ApiException {
      rethrow;
    }
  }

  static void logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");

  }

  Future<void> salvarToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", token);
    print("token salvo: $token");
  }

}