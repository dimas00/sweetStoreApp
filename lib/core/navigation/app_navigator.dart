import 'package:flutter/cupertino.dart';
import 'package:sweet_store/core/navigation/route_guard.dart';

import '../state/app_state.dart';

class AppNavigator {

  static Future<void> push(BuildContext context, String route) async {

    final controller = AppState.userController;

    // 🔒 verifica se rota precisa de login
    if (RouteGuard.rotasProtegidas.contains(route)) {

      final user = controller.usuario ?? await controller.carregarUsuario();

      if (user == null) {

        final result = await Navigator.pushNamed(context, '/login');

        // ❌ usuário desistiu
        if (result != true) return;

      }
    }

    // ✅ navegação normal
    Navigator.pushNamed(context, route);
  }
}