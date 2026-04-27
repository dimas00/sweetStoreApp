import 'package:flutter/material.dart';
import 'address_service.dart';
import 'address_form_page.dart'; // Criaremos este arquivo no passo 3

class AddressPage extends StatefulWidget {
  const AddressPage({Key? key}) : super(key: key);

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {

  @override
  void initState() {
    super.initState();
    AddressService.fetchAddresses();
    // Garante que o redirecionamento ocorra logo após a tela carregar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Verifica se a lista de endereços do serviço está vazia
      if (AddressService.addresses.value.isEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddressFormPage()),
        ); // Navega para o formulário de cadastro
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meus Endereços"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // 🔵 BOTÃO DE CADASTRAR
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text("Cadastrar Novo Endereço"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddressFormPage()),
                  );
                },
              ),
            ),
          ),

          // 🔵 LISTA DE ENDEREÇOS
          Expanded(
            child: ValueListenableBuilder<List<Map<String, dynamic>>>(
              valueListenable: AddressService.addresses,
              builder: (context, lista, child) {
                if (lista.isEmpty) {
                  return const Center(
                    child: Text("Nenhum endereço cadastrado.", style: TextStyle(fontSize: 16)),
                  );
                }

                return ListView.builder(
                  itemCount: lista.length,
                  itemBuilder: (context, index) {
                    final endereco = lista[index];
                    final isPadrao = endereco['padrao'] == true;

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      elevation: 2,
                      child: ListTile(
                        title: Row(
                          children: [
                            Text(endereco['nome'] ?? 'Endereço', style: const TextStyle(fontWeight: FontWeight.bold)),
                            if (isPadrao) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Text("Padrão", style: TextStyle(color: Colors.white, fontSize: 10)),
                              ),
                            ]
                          ],
                        ),
                        subtitle: Text("${endereco['rua']}, ${endereco['numero']}\n${endereco['bairro']} - ${endereco['cidade']}"),
                        isThreeLine: true,
                        // 🔵 MENU DE OPÇÕES (Editar, Excluir, Padrão)
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'edit') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => AddressFormPage(enderecoParaEditar: endereco)),
                              );
                            } else if (value == 'delete') {
                              AddressService.removeAddress(endereco['id']);
                            } else if (value == 'default') {
                              AddressService.setAsDefault(endereco['id']);
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(value: 'edit', child: Text("Editar")),
                            const PopupMenuItem(value: 'delete', child: Text("Excluir", style: TextStyle(color: Colors.red))),
                            if (!isPadrao)
                              const PopupMenuItem(value: 'default', child: Text("Tornar Padrão")),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}