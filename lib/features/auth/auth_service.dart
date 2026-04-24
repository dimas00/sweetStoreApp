import 'dart:convert';
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
        "/auth",
        {
          "email": email,
          "senha": senha,
        },
        auth: false, // 🔥 SEM TOKEN
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        // 🔍 Verifica se a chave 'data' existe (do seu ApiResponseDto do Java)
        if (jsonResponse["data"] != null) {
          // Acessa o token que está DENTRO do objeto 'data'
          final tokenDaApi = jsonResponse["data"]["token"];

          // Se o token realmente existir, salva no SharedPreferences
          if (tokenDaApi != null) {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString("token", tokenDaApi);
            return tokenDaApi;
          }
        }
        return null; // Retorna nulo se não achou o token
      }

      return null; // Retorna nulo se o status não for 200

    } catch (e) {
      print("Erro login: $e");
      return null;
    }
  }

  Future<bool> register(String nome, String email, String telefone, String cpf, String senha) async {
    try {
      final response = await api.post(
        "/auth/register",
        {
          "nome": nome,
          "email": email,
          "telefone": telefone,
          "cpf": cpf,
          "senha": senha,
        },
        auth: false, // Sem token, pois está criando a conta
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        // 🔍 Verifica se a chave 'data' existe e contém o token
        if (jsonResponse["data"] != null) {
          final tokenDaApi = jsonResponse["data"]["token"];

          if (tokenDaApi != null) {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString("token", tokenDaApi);
            return true; // Sucesso e logado!
          }
        }
      }
      print(response);
      return false; // Falha no cadastro
    } catch (e) {
      print("Erro de conexão ao cadastrar: $e");
      return false;
    }
  }


  static void logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");

  }

}