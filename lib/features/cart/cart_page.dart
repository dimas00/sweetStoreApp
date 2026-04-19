import 'package:flutter/material.dart';
import 'package:sweet_store/features/cart/cart_service.dart';

class Carrinho extends StatefulWidget {
  const Carrinho({Key? key}) : super(key: key);

  @override
  State<Carrinho> createState() => _CarrinhoState();
}

class _CarrinhoState extends State<Carrinho> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Carrinho"),
      ),

      body: ValueListenableBuilder(
        valueListenable: CartService.cart,
        builder: (context, cart, child) {

          if (cart.isEmpty) {
            return Center(child: Text("Carrinho vazio"));
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cart.length,
                  itemBuilder: (context, index) {
                    final item = cart[index];

                    return Card(
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.all(16),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.product.nome,
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(item.product.descricao),

                                  SizedBox(height: 8),

                                  Text(
                                    'R\$${item.product.preco}',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),

                                  SizedBox(height: 10),

                                  // 🆕 CAMPO DE OBSERVAÇÃO
                                  TextField(
                                    decoration: InputDecoration(
                                      hintText: "Observação (ex: sem açúcar)",
                                      border: OutlineInputBorder(),
                                      isDense: true,
                                    ),
                                    onChanged: (value) {
                                      item.observation = value;
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),

                          Column(
                            children: [
                              FlutterLogo(size: 80),

                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      CartService.remove(item.product);
                                    },
                                    icon: Icon(Icons.remove_circle_outline),
                                  ),

                                  Text("${item.quantity}"),

                                  IconButton(
                                    onPressed: () {
                                      CartService.add(item.product);
                                    },
                                    icon: Icon(Icons.add_circle_outline),
                                  ),
                                ],
                              ),

                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Text(
                                  "R\$${(item.product.preco * item.quantity).toStringAsFixed(2)}",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // BOTÃO FINALIZAR
              Container(
                margin: EdgeInsetsGeometry.fromSTEB(20,60,20,20),
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total: R\$${CartService.getTotal().toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),

                      ElevatedButton(
                        onPressed: () {
                          // ação final
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                        child: Text(
                          "Finalizar",
                          style: TextStyle(color: Colors.deepPurple),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}