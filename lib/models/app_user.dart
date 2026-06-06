import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String uid;
  final String displayName;
  final String email;
  final String photoUrl;
  final List<String> favoriteShops;
  final List<String> ownedShops;
  final DateTime createdAt;

  AppUser({
    required this.uid,
    this.displayName = '',
    required this.email,
    this.photoUrl = '',
    this.favoriteShops = const [],
    this.ownedShops = const [],
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
      ownedShops: const [],
      createdAt: DateTime.now(),
    );
  }

  factory AppUser.fromMap(Map<String, dynamic> data) {
    return AppUser(
      uid: data['uid'] ?? '',
      displayName: data['displayName'] ?? '',
      email: data['email'] ?? '',
      photoUrl: data['photoUrl'] ?? '',
      favoriteShops: _toStringList(data['favoriteShops']),
      ownedShops: _toStringList(data['ownedShops']),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  static List<String> _toStringList(dynamic value) {
    if (value == null) return [];
    if (value is List) return List<String>.from(value);
    if (value is String) return [value];
    return [];
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'displayName': displayName,
      'email': email,
      'photoUrl': photoUrl,
      'favoriteShops': favoriteShops,
      'ownedShops': ownedShops,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  AppUser copyWith({
    String? displayName,
    String? photoUrl,
    List<String>? favoriteShops,
    List<String>? ownedShops,
  }) {
    return AppUser(
      uid: uid,
      displayName: displayName ?? this.displayName,
      email: email,
      photoUrl: photoUrl ?? this.photoUrl,
      favoriteShops: favoriteShops ?? this.favoriteShops,
      ownedShops: ownedShops ?? this.ownedShops,
      createdAt: createdAt,
    );
  }
}
