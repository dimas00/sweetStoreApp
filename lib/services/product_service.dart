import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sweet_store/screens/android/config/api_config.dart';

import '../models/product_model.dart';

class ProductService {
  static const String baseUrl = ApiConfig.baseUrl;

  static Future<List<ProductModel>> getProducts() async {
    final response = await http.get(
      Uri.parse("$baseUrl/produto/listar"),
    );

    if (response.statusCode == 200) {
      List jsonList = json.decode(response.body);

      return jsonList
          .map((json) => ProductModel.fromJson(json))
          .toList();
    } else {
      throw Exception("Erro ao carregar produtos");
    }
  }
}