import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/network/api_exception.dart';
import '../auth/auth_service.dart';
import '../auth/login_page.dart';
import 'user_service.dart';

class UserController {

  Map<String, dynamic>? usuario;

  final userService = UserService();
  final authService = AuthService();


  Future<bool> login(String email, String senha) async {
    try {
      final token = await authService.login(email, senha);

      if (token == null) return false;

      // 🔥 importante: depois do login, carrega usuário
      usuario = await userService.getUsuario();

      return usuario != null;

    } catch (e) {
      return false;
    }
  }

  Future<Map<String, dynamic>?> carregarUsuario() async {
    try {
      usuario = await userService.getUsuario();
      return usuario;
    } on ApiException catch (e) {
      if (e.statusCode == 401 || e.statusCode == 403) {
        usuario = null;
        return null;
      }
      // Outros erros da API (403, 500, etc)
      print("Erro da API ao carregar usuário: ${e.message}");
      usuario = null;
      return null;
    } catch (e) {
      // 🔥 Erros de internet, servidor fora do ar, etc.
      print("Erro de conexão ao carregar usuário: $e");
      usuario = null;
      return null;
    }
  }

  Future<bool> exigirLogin(BuildContext context) async {
    // 1. já tem usuário em memória?
    if (usuario != null) return true;

    // 2. tenta carregar com token salvo
    await carregarUsuario();

    if (usuario != null) return true;

    // 3. precisa logar → abre tela
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => Login()),
    );

    // 4. se logou, tenta carregar de novo
    if (result == true) {
      await carregarUsuario();
      return usuario != null;
    }

    return false;
  }

  Future<bool> atualizar(String nome, String email) async {
    try {
      await userService.atualizarUsuario(nome, email);

      await carregarUsuario(); // 🔥 mantém sincronizado

      return true;
    } on ApiException {
      return false;
    }
  }

  void limpar() {
    usuario = null;
  }

  bool get isLogado => usuario != null;
}