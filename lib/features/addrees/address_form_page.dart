import 'package:flutter/material.dart';
import 'address_service.dart';

class AddressFormPage extends StatefulWidget {
  final Map<String, dynamic>? enderecoParaEditar; // Se vier nulo, é criação. Se vier preenchido, é edição.

  const AddressFormPage({Key? key, this.enderecoParaEditar}) : super(key: key);

  @override
  State<AddressFormPage> createState() => _AddressFormPageState();
}

class _AddressFormPageState extends State<AddressFormPage> {
  final nomeController = TextEditingController();
  final ruaController = TextEditingController();
  final numeroController = TextEditingController();
  final bairroController = TextEditingController();
  final cidadeController = TextEditingController();
  final cepController = TextEditingController();
  final complementoController = TextEditingController();

  bool isPadrao = false;
  String? erro;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Se for edição, preenche os campos automaticamente
    if (widget.enderecoParaEditar != null) {
      final e = widget.enderecoParaEditar!;
      nomeController.text = e['nome'] ?? '';
      ruaController.text = e['rua'] ?? '';
      numeroController.text = e['numero'] ?? '';
      bairroController.text = e['bairro'] ?? '';
      cidadeController.text = e['cidade'] ?? '';
      cepController.text = e['cep'] ?? '';
      complementoController.text = e['complemento'] ?? '';
      isPadrao = e['padrao'] ?? false;
    }
  }

  void salvarEndereco() async {



    final erroValidacao = validarEndereco();
    setState(() => erro = erroValidacao);
    if (erroValidacao != null) return;

    setState(() => isLoading = true); // Adicione um estado de carregamento


    // 📦 Monte o objeto exatamente como o Endereco.java espera
    final dados = {
      "nomeEndereco": nomeController.text, // Nome correto conforme o Java
      "rua": ruaController.text,
      "numero": numeroController.text,
      "bairro": bairroController.text,
      "cidade": cidadeController.text,
      "estado": "RS", // Você pode adicionar um campo para o estado depois
      "cep": cepController.text,
      "complemento": complementoController.text,
      "padrao": isPadrao,
    };

    if (widget.enderecoParaEditar == null) {
      // ➕ CRIAR NOVO
      final sucesso = await AddressService.save(dados);
      if (sucesso) Navigator.pop(context, true);
    } else {
      // ✏️ EDITAR EXISTENTE
      final id = widget.enderecoParaEditar!['id'];
      final sucesso = await AddressService.update(id, dados);
      if (sucesso) Navigator.pop(context, true);
    }

    final sucesso = await AddressService.save(dados);

    if (!mounted) return;
    setState(() => isLoading = false);

    if (sucesso) {
      Navigator.pop(context, true);
    } else {
      setState(() => erro = "Erro ao salvar no servidor. Tente novamente.");
    }
  }

  String? validarEndereco() {
    if (nomeController.text.isEmpty) return "Informe o nome do endereço";
    if (ruaController.text.isEmpty) return "Informe a rua";
    if (numeroController.text.isEmpty) return "Informe o número";
    if (bairroController.text.isEmpty) return "Informe o bairro";
    if (cidadeController.text.isEmpty) return "Informe a cidade";
    if (cepController.text.isEmpty) return "Informe o CEP";
    return null;
  }

  Widget buildInput(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditando = widget.enderecoParaEditar != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditando ? "Editar Endereço" : "Cadastrar Endereço"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                buildInput(nomeController, "Nome do endereço (Ex: Casa, Trabalho)"),
                buildInput(cepController, "CEP"),
                buildInput(ruaController, "Rua"),
                buildInput(numeroController, "Número"),
                buildInput(bairroController, "Bairro"),
                buildInput(cidadeController, "Cidade"),
                buildInput(complementoController, "Complemento (opcional)"),

                // Checkbox para tornar padrão logo na criação
                SwitchListTile(
                  title: const Text("Definir como endereço padrão"),
                  value: isPadrao,
                  activeColor: Colors.deepPurple,
                  onChanged: (bool value) {
                    setState(() => isPadrao = value);
                  },
                ),

                if (erro != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(erro!, style: const TextStyle(color: Colors.red)),
                  ),

                const SizedBox(height: 20),

                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, foregroundColor: Colors.white),
                    onPressed: salvarEndereco,
                    child: const Text("Salvar Endereço"),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}