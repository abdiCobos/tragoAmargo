import 'package:cloud_firestore/cloud_firestore.dart';

class OwnerClaim {
  final String id;
  final String shopId;
  final String shopName;
  final String shopAddress;
  final String userId;
  final String userName;
  final String userEmail;
  final List<String> documentPhotos;
  final List<String> selfiePhotos;
  final String status; // pending, approved, denied
  final DateTime createdAt;

  OwnerClaim({
    required this.id,
    required this.shopId,
    required this.shopName,
    required this.shopAddress,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.documentPhotos,
    required this.selfiePhotos,
    this.status = 'pending',
    required this.createdAt,
  });

  factory OwnerClaim.fromMap(String id, Map<String, dynamic> data) {
    return OwnerClaim(
      id: id,
      shopId: data['shopId'] ?? '',
      shopName: data['shopName'] ?? '',
      shopAddress: data['shopAddress'] ?? '',
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      userEmail: data['userEmail'] ?? '',
      documentPhotos: List<String>.from(data['documentPhotos'] ?? []),
      selfiePhotos: List<String>.from(data['selfiePhotos'] ?? []),
      status: data['status'] ?? 'pending',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'shopId': shopId,
      'shopName': shopName,
      'shopAddress': shopAddress,
      'userId': userId,
      'userName': userName,
      'userEmail': userEmail,
      'documentPhotos': documentPhotos,
      'selfiePhotos': selfiePhotos,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
