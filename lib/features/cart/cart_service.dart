import 'package:flutter/material.dart';
import 'cart_model.dart';
import '../product/product_model.dart';

class CartService {
  static final ValueNotifier<List<CartModel>> cart = ValueNotifier([]);

  static void add(ProductModel product) {
    final list = cart.value;

    final index = list.indexWhere(
          (item) => item.product.id == product.id,
    );

    if (index != -1) {
      list[index].quantity++;
    } else {
      list.add(
        CartModel(
          id: product.id.toString(),
          product: product,
          quantity: 1,
        ),
      );
    }

    cart.value = [...list]; // força atualização
  }

  static void remove(ProductModel product) {
    final list = cart.value;

    final index = list.indexWhere(
          (item) => item.product.id == product.id,
    );

    if (index != -1) {
      if (list[index].quantity > 1) {
        list[index].quantity--;
      } else {
        list.removeAt(index);
      }
    }

    cart.value = [...list];
  }

  static int getQuantidade(ProductModel product) {
    final index = cart.value.indexWhere(
          (item) => item.product.id == product.id,
    );

    if (index != -1) {
      return cart.value[index].quantity;
    }

    return 0;
  }

  static int getTotalItems() {
    return cart.value.fold(
      0,
          (total, item) => total + item.quantity,
    );
  }

  static double getTotal() {
    return cart.value.fold(
      0.0,
          (total, item) => total + item.product.preco * item.quantity,
    );
  }

  static bool isEmpty() {
    return cart.value.isEmpty;
  }
}