import 'package:flutter/material.dart';

import '../features/auth/auth_service.dart';
// import '../features/auth/login_page.dart'; // Não é mais necessário aqui
import '../shered/constants/app_colors.dart';
import 'state/app_state.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final controller = AppState.userController;

  @override
  void initState() {
    super.initState(); // Removi a duplicata que tinha aqui
    iniciarApp();
  }

  void iniciarApp() async {
    try {
      // Tenta carregar o usuário
      final user = await controller.carregarUsuario();

      print("Splash - Usuário carregado: $user");

      if (user == null) {
        // 🔥 se retornou null, token inválido ou não existe
        AuthService.logout();
        controller.limpar();
      }
    } catch (e) {
      // ⚠️ Se cair aqui, a API tá fora do ar ou sem internet
      print("Erro grave ao iniciar app: $e");
      AuthService.logout();
      controller.limpar();
    } finally {
      // ✅ FINALLY: Executa independentemente de dar erro ou sucesso!
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomLeft,
            colors: [AppColors.purpleone, AppColors.purpletwo],
          ),
        ),
        child: const CircularProgressIndicator(color: Colors.white),
      ),
    );
  }
}