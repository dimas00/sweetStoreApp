import 'package:flutter/material.dart';
import 'package:sweet_store/features/auth/auth_service.dart';
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
        Navigator.pop(context, true);
        print(token);
      }
    } catch (e) {
      AppAlert.showError(context, "Erro ao conectar");
    }

    if (!mounted) return;
    setState(() => isLoading = false);
  }

  // Função auxiliar para criar os campos seguindo seu padrão de design
  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
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

            buildTextField(controller: nomeController, label: 'Nome Completo'),
            buildTextField(controller: emailController, label: 'E-mail', keyboardType: TextInputType.emailAddress),
            buildTextField(controller: telefoneController, label: 'Telefone', keyboardType: TextInputType.phone),
            buildTextField(controller: cpfController, label: 'CPF', keyboardType: TextInputType.number),
            buildTextField(controller: senhaController, label: 'Senha', obscureText: true,),

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