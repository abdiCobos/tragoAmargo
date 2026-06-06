import 'package:cloud_firestore/cloud_firestore.dart';

class MenuItem {
  final String id;
  final String shopId;
  final String name;
  final String category;
  final double price;
  final bool showPrice;
  final String description;
  final String photo;
  final bool isSignature;
  final double averageRating;
  final int totalRatings;
  final DateTime createdAt;

  MenuItem({
    required this.id,
    required this.shopId,
    required this.name,
    this.category = 'Bebida',
    required this.price,
    this.showPrice = true,
    this.description = '',
    this.photo = '',
    this.isSignature = false,
    this.averageRating = 0.0,
    this.totalRatings = 0,
    required this.createdAt,
  });

  factory MenuItem.fromMap(String id, Map<String, dynamic> data, String shopId) {
    return MenuItem(
      id: id,
      shopId: shopId,
      name: data['name'] ?? '',
      category: data['category'] ?? 'Bebida',
      price: (data['price'] ?? 0.0).toDouble(),
      showPrice: data['showPrice'] ?? true,
      description: data['description'] ?? '',
      photo: data['photo'] ?? '',
      isSignature: data['isSignature'] ?? false,
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
      'showPrice': showPrice,
      'description': description,
      'photo': photo,
      'isSignature': isSignature,
      'averageRating': averageRating,
      'totalRatings': totalRatings,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
