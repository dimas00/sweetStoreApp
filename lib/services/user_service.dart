import 'dart:convert';
import 'api_client.dart';

class UserService {

  final api = ApiClient();

  // 🔍 busca usuário logado
  Future<Map<String, dynamic>?> getUsuario() async {
    try {
      final response = await api.get("/usuario/me");

      print("GET USER STATUS: ${response.statusCode}");
      print("GET USER BODY: ${response.body}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }

      // ❗ se não for 200 → considera não logado
      return null;

    } catch (e) {
      print("Erro ao buscar usuário: $e");
      return null;
    }
  }

  // ✏️ atualiza usuário
  Future<bool> atualizarUsuario(String nome, String email) async {
    try {
      final response = await api.post("/usuario", {
        "nome": nome,
        "email": email,
      });

      return response.statusCode == 200;

    } catch (e) {
      print("Erro ao atualizar usuário: $e");
      return false;
    }
  }
}