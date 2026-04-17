import 'package:flutter/material.dart';

import '../../app_state.dart';
import '../../services/auth_service.dart';
import 'common/constants/app_colors.dart';
import 'login.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    super.initState();
    iniciarApp();
  }

  final controller = AppState.userController;


  void iniciarApp() async {
    final user = await controller.carregarUsuario();

    if (!mounted) return;

    // 🔥 se não conseguiu carregar → token inválido
    if (user == null) {
      AuthService.logout(); // limpa token do storage
      controller.limpar(); // limpa estado global
    }

    // segue normal (sem obrigar login)
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomLeft,
            colors: [AppColors.purpleone, AppColors.purpletwo],
          ),
        ),
        child: Container(child: CircularProgressIndicator(color: Colors.white)),
      ),
    );
  }
}
