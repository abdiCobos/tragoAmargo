import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String id;
  final String shopId;
  final String userId;
  final String userName;
  final String userPhoto;
  final double qualityRating;
  final double flavorRating;
  final double roastRating;
  final double overallRating;
  final String comment;
  final List<String> photos;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.shopId,
    required this.userId,
    this.userName = '',
    this.userPhoto = '',
    required this.qualityRating,
    required this.flavorRating,
    required this.roastRating,
    double? overallRating,
    this.comment = '',
    this.photos = const [],
    required this.createdAt,
  }) : overallRating = overallRating ??
            ((qualityRating + flavorRating + roastRating) / 3.0);

  factory Review.fromMap(String id, Map<String, dynamic> data) {
    return Review(
      id: id,
      shopId: data['shopId'] is DocumentReference
          ? (data['shopId'] as DocumentReference).id
          : data['shopId'] ?? '',
      userId: data['userId'] is DocumentReference
          ? (data['userId'] as DocumentReference).id
          : data['userId'] ?? '',
      userName: data['userName'] ?? '',
      userPhoto: data['userPhoto'] ?? '',
      qualityRating: (data['qualityRating'] ?? 0.0).toDouble(),
      flavorRating: (data['flavorRating'] ?? 0.0).toDouble(),
      roastRating: (data['roastRating'] ?? 0.0).toDouble(),
      overallRating: (data['overallRating'] ?? 0.0).toDouble(),
      comment: data['comment'] ?? '',
      photos: List<String>.from(data['photos'] ?? []),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'shopId': shopId,
      'userId': userId,
      'userName': userName,
      'userPhoto': userPhoto,
      'qualityRating': qualityRating,
      'flavorRating': flavorRating,
      'roastRating': roastRating,
      'overallRating': overallRating,
      'comment': comment,
      'photos': photos,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
