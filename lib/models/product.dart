import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String shopId;
  final String name;
  final String category;
  final double price;
  final String description;
  final String photo;
  final double averageRating;
  final int totalRatings;
  final DateTime createdAt;

  Product({
    required this.id,
    required this.shopId,
    required this.name,
    this.category = 'Bebida insignia',
    required this.price,
    this.description = '',
    this.photo = '',
    this.averageRating = 0.0,
    this.totalRatings = 0,
    required this.createdAt,
  });

  factory Product.fromMap(String id, Map<String, dynamic> data, String shopId) {
    return Product(
      id: id,
      shopId: shopId,
      name: data['name'] ?? '',
      category: data['category'] ?? 'Bebida insignia',
      price: (data['price'] ?? 0.0).toDouble(),
      description: data['description'] ?? '',
      photo: data['photo'] ?? '',
      averageRating: (data['averageRating'] ?? 0.0).toDouble(),
      totalRatings: data['totalRatings'] ?? 0,
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
      'averageRating': averageRating,
      'totalRatings': totalRatings,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
