import 'package:flutter/material.dart';
import 'package:sweet_store/core/utils/app_alert.dart';
import '../../core/network/api_exception.dart';
import '../../core/state/app_state.dart';
import '../addrees/address_page.dart';
import '../addrees/address_service.dart';
import '../auth/auth_service.dart';
import 'edit_user_page.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  Map<String, dynamic>? usuario;

  bool salvando = false;
  String? erroNome;
  String? erroEmail;

  final controller = AppState.userController;
  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final telefoneController = TextEditingController();
  final cpfController = TextEditingController();

  bool loading = true;

  @override
  void initState() {
    super.initState();
    AddressService.fetchAddresses();
    carregar();
  }

  bool validar() {
    erroNome = null;
    erroEmail = null;

    if (nomeController.text.isEmpty) {
      erroNome = "Nome obrigatório";
    }

    if (emailController.text.isEmpty) {
      erroEmail = "Email obrigatório";
    }

    return erroNome == null && erroEmail == null;
  }

  void carregar() async {
    try {
      final user = await controller.carregarUsuario();

      if (!mounted) return;

      if (user == null) {
        Navigator.pushReplacementNamed(context, '/login');
        return;
      }

      nomeController.text = user["nome"] ?? "";
      emailController.text = user["email"] ?? "";

      setState(() => loading = false);

    } on ApiException catch (e) {
      AppAlert.showInfo(context, e.message);
    }
  }

  Future<void> salvar() async {
    if (!validar()) {
      setState(() {});
      return;
    }

    setState(() {
      salvando = true;
    });

    try {
      final ok = await controller.atualizar(
        nomeController.text,
        emailController.text,
      );

      if (!mounted) return;

      if (ok) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Dados atualizados com sucesso")),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Erro ao atualizar dados")));
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erro inesperado")));
    }

    if (!mounted) return;

    setState(() {
      salvando = false;
    });
  }

  void logout() {
    AuthService.logout();
    controller.usuario = null; // 🔥 limpa estado global

    Navigator.pushNamedAndRemoveUntil(
      context,
      "/home",
          (route) => false,
    );
  }

  Widget buildSection({required String title, required Widget child}) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  Widget buildUsuario() {
    return buildSection(
      title: "Informações do Usuário",
      // 👈 O botão de editar igual ao dos endereços
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Nome: ${nomeController.text}", style: const TextStyle(fontSize: 15)),
          const SizedBox(height: 5),
          Text("Email: ${emailController.text}", style: const TextStyle(fontSize: 15)),
          const SizedBox(height: 5),
          Text("Telefone: ${telefoneController.text}", style: const TextStyle(fontSize: 15)),
        ],
      ),
    );
  }

// Dentro da sua UserPage.dart

  Widget buildEndereco(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Meu Endereço",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 10),

        // Escuta as mudanças nos endereços em tempo real
        ValueListenableBuilder<List<Map<String, dynamic>>>(
          valueListenable: AddressService.addresses,
          builder: (context, lista, child) {

            // 🔍 Busca o endereço padrão. Se não tiver nenhum padrão definido, pega o primeiro. Se a lista for vazia, retorna null.
            final enderecoPadrao = lista.isNotEmpty
                ? lista.firstWhere((e) => e['padrao'] == true, orElse: () => lista.first)
                : null;

            return InkWell( // Deixa o card clicável com efeitinho de ondinha
              onTap: () {
                // 🚀 Vai para o Gerenciador de Endereços
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddressPage()),
                );
              },
              borderRadius: BorderRadius.circular(12),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.deepPurple, size: 30),
                      const SizedBox(width: 15),
                      Expanded(
                        child: enderecoPadrao != null
                            ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              enderecoPadrao['nomeEndereco'] ?? 'Endereço Principal',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 4),
                            Text("${enderecoPadrao['rua']}, ${enderecoPadrao['numero']}"),
                            Text("${enderecoPadrao['bairro']} - ${enderecoPadrao['cidade']}"),
                          ],
                        )
                            : const Text(
                          "Nenhum endereço cadastrado.\nClique aqui para adicionar.",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Minha Conta"),
        actions: [IconButton(onPressed: logout, icon: Icon(Icons.logout))],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [buildUsuario(), buildEndereco(context)],
      ),
    );
  }
}
