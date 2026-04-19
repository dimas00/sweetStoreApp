import 'package:flutter/material.dart';

import '../../core/state/app_state.dart';
import 'auth_service.dart';
import '../../core/utils/app_alert.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  AuthService authService = AuthService();
  bool isLoading = false;

  final emailController = TextEditingController();
  final senhaController = TextEditingController();

  void fazerLogin() async {
    setState(() => isLoading = true);

    final controller = AppState.userController;

    final sucesso = await controller.login(
      emailController.text,
      senhaController.text,
    );

    if (!mounted) return;

    if (sucesso) {
      Navigator.pop(context, true); // 🔥 volta pro guard
    } else {
      mostrarErro("Login inválido");
    }

    setState(() => isLoading = false);
  }

  void mostrarErro(String msg) {
    AppAlert.showError(context, msg);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text("Login", style: TextStyle(color: Colors.white)),
        actionsIconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(height: 40),

            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Login',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),

            SizedBox(height: 20),

            TextField(
              controller: senhaController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Senha',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),

            SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isLoading ? null : fazerLogin,
                child: isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text("Entrar"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
