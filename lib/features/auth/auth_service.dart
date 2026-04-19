import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/config/api_config.dart';
import '../../core/network/api_client.dart';



class AuthService {
  static String? token;

  final String baseUrl = ApiConfig.baseUrl;
  final api = ApiClient();



  Future<String?> login(String email, String senha) async {
    try {
      final response = await api.post(
        "/login",
        {
          "email": email,
          "senha": senha,
        },
        auth: false, // 🔥 SEM TOKEN
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final token = data["token"];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", token);

        return token;
      }

      return null;

    } catch (e) {
      print("Erro login: $e");
      return null;
    }
  }

  Future<void> salvarToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  Future<bool> isLogged() async {
    final token = await getToken();
    return token != null;
  }



  static void logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");

  }
}