import 'package:flutter/cupertino.dart';
import 'package:sweet_store/core/navigation/route_guard.dart';

import '../state/app_state.dart';
import '../utils/app_alert.dart';

class AppNavigator {
  static Future<void> push(BuildContext context, String route) async {
    final controller = AppState.userController;

    // 🔒 rota protegida
    if (RouteGuard.rotasProtegidas.contains(route)) {

      // 🔁 tenta carregar usuário (caso não esteja em memória)
      if (controller.usuario == null) {
        await controller.carregarUsuario();
      }

      // ❌ ainda não tem usuário → BLOQUEIA
      if (controller.usuario == null) {
        AppAlert.showInfo(context, "Faça login para continuar!");

        final result = await Navigator.pushNamed(context, '/login');

        // ❌ usuário desistiu
        if (result != true) return;

        // 🔁 tenta novamente depois do login
        await controller.carregarUsuario();

        // ❌ ainda falhou → cancela
        if (controller.usuario == null) return;
      }
    }

    // ✅ só chega aqui se tiver usuário
    Navigator.pushNamed(context, route);
  }
}