import 'dart:convert';

class ProductModel {
  //inisialisasi data
  final String name;
  final String description;
  final int price;

  // constructor
  ProductModel({
    required this.name,
    required this.description,
    required this.price,
  });

  //Object -> Map
  Map<String, dynamic> toMap() {
    return {'name': name, 'description': description, 'price': price};
  }

  // map -> object
  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: map['price'] ?? 0,
    );
  }

  //object -> json string
  String toJson() => jsonEncode(toMap());

  // json - object
  factory ProductModel.fromJson(String source) {
    return ProductModel.fromMap(jsonDecode(source));
  }
}
