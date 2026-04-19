import 'package:flutter/material.dart';
import 'package:sweet_store/core/utils/app_alert.dart';
import '../../core/state/app_state.dart';
import '../auth/auth_service.dart';

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
        AppAlert.showInfo(context, "Faça login para continuar");

        final result = await Navigator.pushNamed(context, '/login');

        if (result == true) {
          carregar(); // 🔥 tenta de novo depois do login
        }else{
          setState(() {
            loading=false;
          });
        }

        return;
      }

      nomeController.text = user["nome"] ?? "";
      emailController.text = user["email"] ?? "";
      telefoneController.text = user["telefone"] ?? "";
      cpfController.text = user["cpf"] ?? "";

      setState(() => loading = false);

    } catch (e) {
      if (!mounted) return;

      AppAlert.showInfo(context, "Erro ao carregar usuário");
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
    Navigator.pushReplacementNamed(context, "/home");
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
      child: Column(
        children: [
          TextField(
            controller: nomeController,
            decoration: InputDecoration(labelText: "Nome", errorText: erroNome),
          ),

          SizedBox(height: 10),

          TextField(
            controller: emailController,
            decoration: InputDecoration(
              labelText: "Email",
              errorText: erroEmail,
            ),
          ),

          TextField(
            controller: telefoneController,
            decoration: InputDecoration(labelText: "Telefone"),
          ),
          SizedBox(height: 10),

          TextField(
            controller: cpfController,
            decoration: InputDecoration(labelText: "CPF"),
          ),
          SizedBox(height: 15),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(onPressed: salvar, child: Text("Salvar")),
          ),
        ],
      ),
    );
  }

  Widget buildEnderecos() {
    final enderecos = controller.usuario?["enderecos"] ?? [];

    return buildSection(
      title: "Endereços",
      child: Column(
        children: [
          if (enderecos.isEmpty)
            Column(
              children: [
                Text("Nenhum endereço cadastrado"),
                TextButton(
                  onPressed: () {
                    // ir para cadastro
                  },
                  child: Text("Cadastrar endereço"),
                ),
              ],
            ),

          ...enderecos.map<Widget>((e) {
            return Container(
              margin: EdgeInsets.only(bottom: 10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${e["rua"]}, ${e["numero"]}"),
                  Text("${e["bairro"]} - ${e["cidade"]}"),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          // editar endereço
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          // deletar endereço
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),

          SizedBox(height: 10),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                // novo endereço
              },
              icon: Icon(Icons.add),
              label: Text("Novo endereço"),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPedidos() {
    final pedidos = controller.usuario?["pedidos"] ?? [];

    return buildSection(
      title: "Pedidos",
      child: Column(
        children: [
          if (pedidos.isEmpty) Text("Nenhum pedido realizado"),

          ...pedidos.map<Widget>((p) {
            return Container(
              margin: EdgeInsets.only(bottom: 10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Pedido #${p["id"]}"),
                      Text("R\$ ${p["total"]}"),
                    ],
                  ),

                  ElevatedButton(
                    onPressed: () {
                      // abrir detalhe
                    },
                    child: Text("Detalhes"),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
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
        children: [buildUsuario(), buildEnderecos(), buildPedidos()],
      ),
    );
  }
}
