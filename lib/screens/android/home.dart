import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sweet_store/models/cart_model.dart';
import 'package:sweet_store/models/product_model.dart';
import 'package:sweet_store/screens/android/splash/splash_page.dart';

import 'login.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final buscaController = TextEditingController();

  List<CartModel> carrinhoList = [
    CartModel(
      id: '1',
      product: ProductModel(
        name: "bolo",
        desc: "um bolo",
        id: '1',
        image: "",
        price: 12.0,
      ),
      quantity: 1,
    ),
    CartModel(
      id: '1',
      product: ProductModel(
        name: "bombom",
        desc: "um bolo",
        id: '1',
        image: "",
        price: 12.0,
      ),
      quantity: 1,
    ),
    CartModel(
      id: '1',
      product: ProductModel(
        name: "torta",
        desc: "um bolo",
        id: '1',
        image: "",
        price: 12.0,
      ),
      quantity: 1,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(180),
          child: Padding(
            padding: const EdgeInsets.only(top: 80, left: 16, right: 16),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: buscaController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      labelText: "Pesquisa",
                      contentPadding: EdgeInsets.zero,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                    ),
                  ),
                ),
                IconButton(onPressed: () {}, icon: Icon(Icons.shopping_cart)),
                IconButton(onPressed: () {}, icon: Icon(Icons.person)),
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text("status da loja")],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  TextButton(onPressed: () {}, child: Text("Bolo de pote")),
                  TextButton(onPressed: () {}, child: Text("Bombom")),
                  TextButton(onPressed: () {}, child: Text("Tortas")),
                  TextButton(onPressed: () {}, child: Text("Tortas")),
                ],
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  for (CartModel carrinho in carrinhoList)
                    Card(
                      child: Row(
                        children: [
                          Container(
                            width: 200.0,
                            margin: const EdgeInsets.all(30),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                            ),
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  carrinho.product.name,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(carrinho.product.desc),
                                SizedBox(height: 10),
                                Text('R\$${carrinho.product.price}'),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              FlutterLogo(size: 80),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.remove_circle_outline),
                                  ),
                                  Text("${carrinho.quantity}"),
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.add_circle_outline),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  Container(
                    child: Row(
                      children: [
                        Text(
                          'Total: R\$${carrinhoList.map((value) => value.quantity.toDouble() * value.product.price).fold(0.0, (prev, element) => prev + element)}',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
