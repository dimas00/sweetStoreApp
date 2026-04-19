import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../auth/login_page.dart';
import 'user_service.dart';

class UserController {

  Map<String, dynamic>? usuario;

  final service = UserService();

  Future<Map<String, dynamic>?> carregarUsuario() async {
    try {
      final data = await service.getUsuario();

      // 🔥 salva no estado global
      usuario = data;

      return usuario;
    } catch (e) {
      // se der erro (token inválido, etc)
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
    final ok = await service.atualizarUsuario(nome, email);

    if (ok) {
      // atualiza local sem precisar bater na API de novo
      usuario?["nome"] = nome;
      usuario?["email"] = email;
    }

    return ok;
  }

  void limpar() {
    usuario = null;
  }

  bool get isLogado => usuario != null;
}