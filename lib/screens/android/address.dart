import 'package:flutter/material.dart';

import '../../services/address_service.dart';
import '../../widgets/buildFooter.dart';

class EnderecoPage extends StatefulWidget {
  const EnderecoPage({Key? key}) : super(key: key);

  @override
  State<EnderecoPage> createState() => _EnderecoPageState();
}

class _EnderecoPageState extends State<EnderecoPage> {
  Widget buildInput(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  final nomeController = TextEditingController();
  final ruaController = TextEditingController();
  final numeroController = TextEditingController();
  final bairroController = TextEditingController();
  final cidadeController = TextEditingController();
  final cepController = TextEditingController();
  final complementoController = TextEditingController();

  String? erro;

  void salvarEndereco() {
    final erroValidacao = validarEndereco();

    setState(() {
      erro = erroValidacao;
    });

    if (erroValidacao != null) return;

    final endereco = {
      "nome": nomeController.text,
      "rua": ruaController.text,
      "numero": numeroController.text,
      "bairro": bairroController.text,
      "cidade": cidadeController.text,
      "cep": cepController.text,
      "complemento": complementoController.text,
    };

    AddressService.setAddress(endereco);

    Navigator.pop(context, true);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cadastrar Endereço")),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                buildInput(nomeController, "Nome do endereço"),
                buildInput(ruaController, "Rua"),
                buildInput(numeroController, "Número"),
                buildInput(bairroController, "Bairro"),
                buildInput(cidadeController, "Cidade"),
                buildInput(cepController, "CEP"),
                buildInput(complementoController, "Complemento (opcional)"),

                if (erro != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(erro!, style: TextStyle(color: Colors.red)),
                  ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}
