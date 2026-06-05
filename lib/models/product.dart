import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String shopId;
  final String name;
  final String category;
  final double price;
  final String description;
  final String photo;
  final DateTime createdAt;

  Product({
    required this.id,
    required this.shopId,
    required this.name,
    this.category = 'Bebida caliente',
    required this.price,
    this.description = '',
    this.photo = '',
    required this.createdAt,
  });

  factory Product.fromMap(String id, Map<String, dynamic> data, String shopId) {
    return Product(
      id: id,
      shopId: shopId,
      name: data['name'] ?? '',
      category: data['category'] ?? 'Bebida caliente',
      price: (data['price'] ?? 0.0).toDouble(),
      description: data['description'] ?? '',
      photo: data['photo'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'price': price,
      'description': description,
      'photo': photo,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
