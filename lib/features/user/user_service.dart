import 'package:shared_preferences/shared_preferences.dart';

import '../../core/network/api_client.dart';
import '../../core/network/api_exception.dart';

class UserService {

  final api = ApiClient();

  Future<Map<String, dynamic>?>
  getUsuario() async {

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null || token.isEmpty) {
      print("Nenhum token encontrado. Pulando requisição /usuario/me.");
      return null;
    }
    try {
      final data = await api.get("/usuario/me");
      print("fazendo a requisição");

      print("GET USER DATA: $data");

      return data["data"]; // 🔥 já vem pronto

    } on ApiException catch (e) {
      print("🔥 ApiException: ${e.message} (${e.statusCode})");

      if (e.statusCode == 401) {
        return null; // não logado
      }

      rethrow; // 🔥 não esconde erro

    } catch (e, stack) {
      print("Stack: $stack");
      print("Erro inesperado: $e");
      rethrow;
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