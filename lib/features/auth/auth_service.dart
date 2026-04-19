import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/config/api_config.dart';



class AuthService {
  static String? token;

  final String baseUrl = ApiConfig.baseUrl;


  Future<String?> login(String email, String senha) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "senha": senha,
        }),
      );

      print('STATUS: ${response.statusCode}');
      print('BODY: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        token = data["token"];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", token!);

        return token;
      } else {
        print("Erro backend: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Erro REAL: $e");
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