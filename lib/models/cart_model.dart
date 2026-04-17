

import 'package:sweet_store/models/product_model.dart';

class CartModel {
  final String id;
  final ProductModel product;
  int quantity;
  String? observation;

  CartModel({
    required this.id,
    required this.product,
    required this.quantity,
    this.observation,
  }) ;
}
