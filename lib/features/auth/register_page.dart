import 'package:flutter/material.dart';
import 'package:sweet_store/features/auth/auth_service.dart';
import '../../core/network/api_exception.dart';
import '../../core/state/app_state.dart';
import '../../core/utils/app_alert.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  AuthService authService = AuthService();
  bool isLoading = false;

  // Controladores para capturar os dados
  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final telefoneController = TextEditingController();
  final cpfController = TextEditingController();
  final senhaController = TextEditingController();

  String? erroNome;
  String? erroEmail;
  String? erroSenha;
  String? erroCpf;
  String? erroTelefone;

  bool validar() {
    erroNome = null;
    erroEmail = null;
    erroSenha = null;
    erroCpf = null;
    erroTelefone = null;

    if (nomeController.text.isEmpty) {
      erroNome = "Nome obrigatório";
    }

    if (emailController.text.isEmpty || !emailController.text.contains("@")) {
      erroEmail = "Email inválido";
    }

    if (senhaController.text.length < 3) {
      erroSenha = "Senha deve ter pelo menos 6 caracteres";
    }

    if (cpfController.text.isEmpty) {
      erroCpf = "CPF obrigatório";
    }

    if (telefoneController.text.isEmpty) {
      erroTelefone = "Telefone obrigatório";
    }

    return erroNome == null &&
        erroEmail == null &&
        erroSenha == null &&
        erroCpf == null &&
        erroTelefone == null;
  }

  void registrar() async {
    if (!validar()) {
      setState(() {});
      return;
    }

    setState(() => isLoading = true);

    try {
      final token = await authService.register(
        nomeController.text,
        emailController.text,
        senhaController.text,
        cpfController.text,
        telefoneController.text,
      );

      if (token != null) {
        await AppState.userController.carregarUsuario();

        if (!mounted) return;
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/home',
              (route) => false,
        );
        print("Token: ");
        print( token);
      }

    } on ApiException catch (e) {
      AppAlert.showError(context, e.message); // 🔥 ex: "Email já cadastrado"

    } catch (e) {
      AppAlert.showError(context, "Erro inesperado");
    }

    if (!mounted) return;
    setState(() => isLoading = false);
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    String? errorText, // 🔥 novo
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        errorText: errorText, // 🔥 aqui mostra o erro
        border: OutlineInputBorder(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Criar Conta", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            buildTextField(
              controller: nomeController,
              label: 'Nome Completo',
              errorText: erroNome,
            ),
            buildTextField(
              controller: emailController,
              label: 'Email',
              errorText: erroEmail,
            ),

            buildTextField(
              controller: telefoneController,
              label: 'Telefone',
              errorText: erroTelefone,
            ),
            buildTextField(
              controller: cpfController,
              label: 'Cpf',
              errorText: erroCpf,
            ),

            buildTextField(
              controller: senhaController,
              label: 'Senha',
              errorText: erroSenha,
              obscureText: true,
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isLoading ? null : registrar,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Cadastrar"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}