import 'package:cloud_firestore/cloud_firestore.dart';

class CoffeeShop {
  final String id;
  final String name;
  final String description;
  final String originAndAltitude;
  final List<String> roastLevels;
  final List<String> brewingMethods;
  final String priceRange;
  final bool hasWiFi;
  final String seatingMode;
  final Map<String, String> openingHours;
  final String phone;
  final String instagram;
  final GeoPoint location;
  final String address;
  final String city;
  final List<String> photos;
  final double averageRating;
  final double averageQuality;
  final double averageFlavor;
  final double averageRoast;
  final double averageService;
  final int totalReviews;
  final DateTime createdAt;
  final String? createdBy;
  final String? verifiedOwnerUid;

  CoffeeShop({
    required this.id,
    required this.name,
    this.description = '',
    this.originAndAltitude = '',
    this.roastLevels = const [],
    this.brewingMethods = const [],
    this.priceRange = r'$',
    this.hasWiFi = false,
    this.seatingMode = '',
    this.openingHours = const {},
    this.phone = '',
    this.instagram = '',
    required this.location,
    this.address = '',
    this.city = '',
    this.photos = const [],
    this.averageRating = 0.0,
    this.averageQuality = 0.0,
    this.averageFlavor = 0.0,
    this.averageRoast = 0.0,
    this.averageService = 0.0,
    this.totalReviews = 0,
    required this.createdAt,
    this.createdBy,
    this.verifiedOwnerUid,
  });

  factory CoffeeShop.fromMap(String id, Map<String, dynamic> data) {
    return CoffeeShop(
      id: id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      originAndAltitude: data['originAndAltitude'] ?? '',
      roastLevels: List<String>.from(data['roastLevels'] ?? []),
      brewingMethods: List<String>.from(data['brewingMethods'] ?? []),
      priceRange: data['priceRange'] ?? r'$',
      hasWiFi: data['hasWiFi'] ?? false,
      seatingMode: data['seatingMode'] ?? '',
      openingHours: Map<String, String>.from(data['openingHours'] ?? {}),
      phone: data['phone'] ?? '',
      instagram: data['instagram'] ?? '',
      location: data['location'],
      address: data['address'] ?? '',
      city: data['city'] ?? '',
      photos: List<String>.from(data['photos'] ?? []),
      averageRating: (data['averageRating'] ?? 0.0).toDouble(),
      averageQuality: (data['averageQuality'] ?? 0.0).toDouble(),
      averageFlavor: (data['averageFlavor'] ?? 0.0).toDouble(),
      averageRoast: (data['averageRoast'] ?? 0.0).toDouble(),
      averageService: (data['averageService'] ?? 0.0).toDouble(),
      totalReviews: data['totalReviews'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      createdBy: data['createdBy'],
      verifiedOwnerUid: data['verifiedOwnerUid'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'originAndAltitude': originAndAltitude,
      'roastLevels': roastLevels,
      'brewingMethods': brewingMethods,
      'priceRange': priceRange,
      'hasWiFi': hasWiFi,
      'seatingMode': seatingMode,
      'openingHours': openingHours,
      'phone': phone,
      'instagram': instagram,
      'location': location,
      'address': address,
      'city': city,
      'addressLower': address.trim().toLowerCase(),
      'photos': photos,
      'averageRating': averageRating,
      'averageQuality': averageQuality,
      'averageFlavor': averageFlavor,
      'averageRoast': averageRoast,
      'averageService': averageService,
      'totalReviews': totalReviews,
      'createdAt': Timestamp.fromDate(createdAt),
      'createdBy': createdBy,
      'verifiedOwnerUid': verifiedOwnerUid,
    };
  }

  CoffeeShop copyWith({
    String? id,
    String? name,
    String? description,
    String? originAndAltitude,
    List<String>? roastLevels,
    List<String>? brewingMethods,
    String? priceRange,
    bool? hasWiFi,
    String? seatingMode,
    Map<String, String>? openingHours,
    String? phone,
    String? instagram,
    GeoPoint? location,
    String? address,
    String? city,
    List<String>? photos,
    double? averageRating,
    double? averageQuality,
    double? averageFlavor,
    double? averageRoast,
    double? averageService,
    int? totalReviews,
    DateTime? createdAt,
    String? createdBy,
    String? verifiedOwnerUid,
  }) {
    return CoffeeShop(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      originAndAltitude: originAndAltitude ?? this.originAndAltitude,
      roastLevels: roastLevels ?? this.roastLevels,
      brewingMethods: brewingMethods ?? this.brewingMethods,
      priceRange: priceRange ?? this.priceRange,
      hasWiFi: hasWiFi ?? this.hasWiFi,
      seatingMode: seatingMode ?? this.seatingMode,
      openingHours: openingHours ?? this.openingHours,
      phone: phone ?? this.phone,
      instagram: instagram ?? this.instagram,
      location: location ?? this.location,
      address: address ?? this.address,
      city: city ?? this.city,
      photos: photos ?? this.photos,
      averageRating: averageRating ?? this.averageRating,
      averageQuality: averageQuality ?? this.averageQuality,
      averageFlavor: averageFlavor ?? this.averageFlavor,
      averageRoast: averageRoast ?? this.averageRoast,
      averageService: averageService ?? this.averageService,
      totalReviews: totalReviews ?? this.totalReviews,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      verifiedOwnerUid: verifiedOwnerUid ?? this.verifiedOwnerUid,
    );
  }
}
