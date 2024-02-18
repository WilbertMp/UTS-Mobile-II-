import 'dart:convert';

import 'package:utsmobilewilbert/data/model/product.dart';
import 'package:http/http.dart' as http;

class RemoteDataSource {
  final String baseUrl =
      'https://65aa725c081bd82e1d96f870.mockapi.io/chemicy/api/item';

  Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      Iterable jsonResponse = json.decode(response.body);
      final productList =
          jsonResponse.map((product) => Product.fromJson(product)).toList();
      return productList;
    } else {
      throw Exception('Failed to load Products');
    }
  }

  Future<List<Product>> SearchProduct(String query) async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      Iterable jsonResponse = json.decode(response.body);
      var productList =
          jsonResponse.map((product) => Product.fromJson(product)).toList();
      if (query.isEmpty) {
        productList = productList
            .where((Product) =>
                Product.name.toLowerCase().contains(query.toLowerCase()) ||
                Product.category.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }

      return productList;
    } else {
      throw Exception('Failed to load Products');
    }
  }

  Future<Product> createProduct(Product product) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(product.toJson()),
    );

    if (response.statusCode == 201) {
      return Product.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create Product');
    }
  }

  Future<Product> updateProduct(Product product) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${product.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(product.toJson()),
    );

    if (response.statusCode == 200) {
      return Product.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update Product');
    }
  }

  Future<void> deleteProduct(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete Product');
    }
  }
}
