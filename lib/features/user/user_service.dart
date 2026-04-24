import '../../core/network/api_client.dart';
import '../../core/network/api_exception.dart';

class UserService {

  final api = ApiClient();

  Future<Map<String, dynamic>?> getUsuario() async {
    try {
      final data = await api.get("/usuario/me");

      print("GET USER DATA: $data");

      return data["data"]; // 🔥 já vem pronto

    } on ApiException catch (e) {
      print("Erro ao buscar usuário: ${e.message}");

      if (e.statusCode == 401) {
        return null; // não logado
      }

      rethrow; // 🔥 não esconde erro

    } catch (e) {
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