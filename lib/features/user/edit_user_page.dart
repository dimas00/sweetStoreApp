import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/state/app_state.dart';

class EditUserPage extends StatefulWidget {
  const EditUserPage({super.key});

  @override
  State<EditUserPage> createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  final controller = AppState.userController;

  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final telefoneController = TextEditingController();
  final cpfController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Editar Perfil")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: nomeController, decoration: const InputDecoration(labelText: "Nome")),
            TextField(controller: emailController, decoration: const InputDecoration(labelText: "Email")),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Chama a função de salvar do seu controller
                final ok = await controller.atualizar(nomeController.text, emailController.text);
                if (ok && mounted) Navigator.pop(context); // Volta se deu certo
              },
              child: const Text("Salvar Alterações"),
            )
          ],
        ),
      ),
    );
  }
}