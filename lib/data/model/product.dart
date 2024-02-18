class Product {
  final int id;
  final String name;
  final String description;
  final String imageUrl;
  final String category;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: int.parse(json['id']),
      name: json['name'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      category: json['category'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'category': category,
    };
  }
}

class DataProduct {
  final List<Product> data;
  DataProduct({required this.data});
  factory DataProduct.fromJson(List<dynamic> json) => DataProduct(
        data: json.map((product) => Product.fromJson(product)).toList(),
      );
}
