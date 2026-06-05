import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String uid;
  final String displayName;
  final String email;
  final String photoUrl;
  final List<String> favoriteShops;
  final DateTime createdAt;

  AppUser({
    required this.uid,
    this.displayName = '',
    required this.email,
    this.photoUrl = '',
    this.favoriteShops = const [],
    required this.createdAt,
  });

  factory AppUser.fromFirebaseUser(
    String uid,
    String? displayName,
    String? email,
    String? photoUrl,
  ) {
    return AppUser(
      uid: uid,
      displayName: displayName ?? '',
      email: email ?? '',
      photoUrl: photoUrl ?? '',
      createdAt: DateTime.now(),
    );
  }

  factory AppUser.fromMap(Map<String, dynamic> data) {
    return AppUser(
      uid: data['uid'] ?? '',
      displayName: data['displayName'] ?? '',
      email: data['email'] ?? '',
      photoUrl: data['photoUrl'] ?? '',
      favoriteShops: List<String>.from(data['favoriteShops'] ?? []),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'displayName': displayName,
      'email': email,
      'photoUrl': photoUrl,
      'favoriteShops': favoriteShops,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  AppUser copyWith({
    String? displayName,
    String? photoUrl,
    List<String>? favoriteShops,
  }) {
    return AppUser(
      uid: uid,
      displayName: displayName ?? this.displayName,
      email: email,
      photoUrl: photoUrl ?? this.photoUrl,
      favoriteShops: favoriteShops ?? this.favoriteShops,
      createdAt: createdAt,
    );
  }
}
