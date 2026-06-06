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
  final double serviceRating;
  final double overallRating;
  final String comment;
  final List<String> photos;
  final List<Map<String, dynamic>> replies;
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
    required this.serviceRating,
    double? overallRating,
    this.comment = '',
    this.photos = const [],
    this.replies = const [],
    required this.createdAt,
  }) : overallRating = overallRating ??
            ((qualityRating + flavorRating + roastRating + serviceRating) / 4.0);

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
      serviceRating: (data['serviceRating'] ?? 0.0).toDouble(),
      overallRating: (data['overallRating'] ?? 0.0).toDouble(),
      comment: data['comment'] ?? '',
      photos: List<String>.from(data['photos'] ?? []),
      replies: List<Map<String, dynamic>>.from(data['replies'] ?? []),
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
      'serviceRating': serviceRating,
      'overallRating': overallRating,
      'comment': comment,
      'photos': photos,
      'replies': replies,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
