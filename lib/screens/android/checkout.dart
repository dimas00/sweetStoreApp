import 'package:flutter/material.dart';
import 'package:sweet_store/screens/android/common/app_alert.dart';

import '../../services/address_service.dart';
import '../../services/cart_service.dart';
import '../../widgets/buildFooter.dart';
import 'address.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({Key? key}) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {

  String? erroTroco;

  String pagamento = "pix"; // pix | credito | dinheiro
  bool precisaTroco = false;
  double? valorTroco;
  String tipoEntrega = "entrega"; // entrega | retirada

  bool temEndereco = false; // simula API

  String? validarPedido() {
    erroTroco = null; // limpa erro antes

    if (CartService.isEmpty()) {
      return "Adicione itens no carrinho";
    }

    if (pagamento == "dinheiro") {
      if (precisaTroco) {
        if (valorTroco == null || valorTroco! <= 0) {
          erroTroco = "Informe o valor do troco";
          return erroTroco;
        }

        if (valorTroco! < CartService.getTotal()) {
          erroTroco = "Troco menor que o total";
          return erroTroco;
        }
      }
    }

    if (tipoEntrega == "entrega" && !AddressService.hasAddress()) {
      return "Cadastre um endereço";
    }

    return null;
  }

  Widget buildSection({
    required String title,
    required Widget child,
  }) {
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

  Widget buildResumo() {
    return ValueListenableBuilder(
      valueListenable: CartService.cart,
      builder: (context, cart, child) {
        return buildSection(
          title: "Resumo do Pedido",
          child: Column(
            children: cart.map((item) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${item.quantity}x ${item.product.nome}"),
                        if (item.observation != null &&
                            item.observation!.isNotEmpty)
                          Text(
                            item.observation!,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Text(
                    "R\$ ${(item.product.preco * item.quantity).toStringAsFixed(2)}",
                  ),
                ],
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget buildOption(String value, String label) {
    final selected = pagamento == value;

    return GestureDetector(
      onTap: () {
        setState(() => pagamento = value);
      },
      child: Container(
        margin: EdgeInsets.all(4),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected ? Colors.deepPurple : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.deepPurple),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : Colors.deepPurple,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPagamento() {
    return buildSection(
      title: "Pagamento",
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: buildOption("pix", "Pix")),
              Expanded(child: buildOption("credito", "Crédito")),
              Expanded(child: buildOption("dinheiro", "Dinheiro")),
            ],
          ),

          if (pagamento == "dinheiro") ...[
            SizedBox(height: 10),

            SwitchListTile(
              title: Text("Precisa de troco?"),
              value: precisaTroco,
              onChanged: (value) {
                setState(() => precisaTroco = value);
              },
            ),

            if (precisaTroco)
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Troco para quanto?",
                  border: OutlineInputBorder(),

                  // 🔴 BORDA VERMELHA
                  errorText: erroTroco,
                ),
                onChanged: (value) {
                  setState(() {
                    valorTroco = double.tryParse(value);

                    // limpa erro ao digitar
                    erroTroco = null;
                  });
                },
              ),
          ]
        ],
      ),
    );
  }

  Widget buildRetirada() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Endereço da loja: Rua da Loja, 123"),
        SizedBox(height: 5),
        Text("Tempo estimado: 30 min"),
      ],
    );
  }

  Widget buildEndereco() {
    return ValueListenableBuilder(
      valueListenable: AddressService.address,
      builder: (context, address, child) {

        if (address == null) {
          return Column(
            children: [
              Text("Nenhum endereço cadastrado"),
              TextButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EnderecoPage(),
                    ),
                  );
                },
                child: Text("Cadastrar endereço"),
              ),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${address["rua"]}, ${address["numero"]}"),
            Text("${address["bairro"]} - ${address["cidade"]}"),

            TextButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EnderecoPage(),
                  ),
                );
              },
              child: Text("Alterar endereço"),
            ),
          ],
        );
      },
    );
  }

  Widget buildEntrega() {
    return buildSection(
      title: "Entrega",
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: buildEntregaOption("entrega", "Entrega")),
              Expanded(child: buildEntregaOption("retirada", "Retirada")),
            ],
          ),

          SizedBox(height: 10),

          if (tipoEntrega == "entrega") buildEndereco(),
          if (tipoEntrega == "retirada") buildRetirada(),
        ],
      ),
    );
  }

  Widget buildEntregaOption(String value, String label) {
    final selected = tipoEntrega == value;

    return GestureDetector(
      onTap: () {
        setState(() => tipoEntrega = value);
      },
      child: Container(
        margin: EdgeInsets.all(4),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected ? Colors.deepPurple : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.deepPurple),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : Colors.deepPurple,
            ),
          ),
        ),
      ),
    );
  }

  void finalizarPedido() {
    final erro = validarPedido();

    setState(() {});

    if (erro != null) {
      AppAlert.showInfo(context, erro);
      return;
    }
    print("Pagamento: $pagamento");
    print("Troco: $precisaTroco");
    print("Entrega: $tipoEntrega");

   AppAlert.showSuccess(context, "Pedido realizado com sucesso!");
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Finalizar Pedido"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [

                buildResumo(),

                SizedBox(height: 20),

                buildPagamento(),

                SizedBox(height: 20),

                buildEntrega(),

              ],
            ),
          ),

          ValueListenableBuilder(
            valueListenable: CartService.cart,
            builder: (context, value, child) {
              return buildFooter(
                total: CartService.getTotal(),
                onPressed: finalizarPedido,
              );
            }
          ),
        ],
      ),
    );
  }
}