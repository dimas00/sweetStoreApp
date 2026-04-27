import 'package:flutter/material.dart';
import 'package:sweet_store/features/cart/cart_service.dart';
import 'package:sweet_store/features/checkout/checkout_page.dart';

import '../../core/navigation/app_navigator.dart';
import '../../core/utils/app_alert.dart';
import '../cart/cart_page.dart';
import '../order/order_page.dart';
import '../product/product_model.dart';
import '../product/product_service.dart';
import '../user/user_controller.dart';
import '../user/user_page.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final buscaController = TextEditingController();
  final userController = UserController();



  List<ProductModel> productList = [];

  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  void finalizarCompra() async {

    if (CartService.isEmpty()) {
      AppAlert.showInfo(context, "Adicione algo no carrinho!");
      return;
    }

    AppNavigator.push(context, '/checkout');

  }

  Future<void> carregarDados() async {
    try {
      final products = await ProductService.getProducts();

      setState(() {
        productList = products;
        print("SETANDO LISTA: ${products.length}");
        isLoading = false;
      });

    } catch (e) {
      setState(() {
        isLoading = false;
      });

      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          toolbarHeight: 100,
          title: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: buscaController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(Icons.search),
                      labelText: "Pesquisa",
                      contentPadding: EdgeInsets.zero,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                    ),
                  ),
                ),
                ValueListenableBuilder(
                  valueListenable: CartService.cart,
                  builder: (context, cart, child) {
                    final totalItems = CartService.getTotalItems();

                    return Stack(
                      children: [
                        IconButton(
                          onPressed: cart.isEmpty
                              ? null
                              : () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Carrinho(),
                                    ),
                                  );
                                },
                          icon: Icon(Icons.shopping_cart),
                        ),

                        // 🔴 BADGE
                        if (totalItems > 0)
                          Positioned(
                            right: 6,
                            top: 6,
                            child: Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              constraints: BoxConstraints(
                                minWidth: 18,
                                minHeight: 18,
                              ),
                              child: Text(
                                '$totalItems',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => OrderPage()),
                    );
                  },
                  icon: Icon(Icons.receipt),
                ),

                IconButton(
                  onPressed: () {
                    AppNavigator.push(context, '/user');

                  },
                  icon: Icon(Icons.person),
                ),
              ],
            ),
          ),
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text("status da loja")],
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: Text("Bolo de pote "),
                        ),
                        TextButton(onPressed: () {}, child: Text("Bombom")),
                        TextButton(onPressed: () {}, child: Text("Pave")),
                        TextButton(onPressed: () {}, child: Text("Tortas")),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: productList.length,
                      itemBuilder: (context, index) {
                        final product = productList[index];
                        return Card(
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.all(30),
                                  decoration: BoxDecoration(
                                    // border: Border.all(color: Colors.black),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.nome,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(product.descricao),
                                      SizedBox(height: 10),
                                      Text('R\$${product.preco}'),
                                    ],
                                  ),
                                ),
                              ),
                              Column(
                                children: [
                                  Image.network(
                                    product.imagemUrl.isNotEmpty
                                        ? "http://192.168.1.7:8080/produto/imagem/" +
                                              product.imagemUrl
                                        : "https://via.placeholder.com/150",
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(Icons.image_not_supported);
                                    },
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          CartService.remove(product);
                                        },
                                        icon: Icon(Icons.remove_circle_outline),
                                      ),
                                      ValueListenableBuilder(
                                        valueListenable: CartService.cart,
                                        builder: (context, cart, child) {
                                          return Text(
                                            "${CartService.getQuantidade(product)}",
                                          );
                                        },
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          CartService.add(product);
                                        },
                                        icon: Icon(Icons.add_circle_outline),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 00),
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.zero,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ValueListenableBuilder(
                            valueListenable: CartService.cart,
                            builder: (context, cart, child) {
                              return Text(
                                'Total: R\$${CartService.getTotal().toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              );
                            },
                          ),

                          ValueListenableBuilder(
                            valueListenable: CartService.cart,
                            builder: (context, cart, child) {
                              return ElevatedButton(
                                onPressed: cart.isEmpty
                                    ? null
                                    : finalizarCompra,
                                child: Text("Finalizar"),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
