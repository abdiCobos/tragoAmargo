import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/constants/firebase_collections.dart';
import '../models/coffee_shop.dart';
import '../models/review.dart';
import '../models/app_user.dart';
import '../models/product.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ─── Users ───

  Future<void> createUser(AppUser user) async {
    await _firestore
        .collection(FirestoreCollections.users)
        .doc(user.uid)
        .set(user.toMap());
  }

  Future<AppUser?> getUser(String uid) async {
    final doc =
        await _firestore.collection(FirestoreCollections.users).doc(uid).get();
    if (!doc.exists) return null;
    return AppUser.fromMap(doc.data()!);
  }

  Future<void> updateUser(AppUser user) async {
    await _firestore
        .collection(FirestoreCollections.users)
        .doc(user.uid)
        .update(user.toMap());
  }

  Future<void> toggleFavorite(String uid, String shopId, bool add) async {
    final ref = _firestore.collection(FirestoreCollections.users).doc(uid);
    if (add) {
      await ref.update({
        'favoriteShops': FieldValue.arrayUnion([shopId]),
      });
    } else {
      await ref.update({
        'favoriteShops': FieldValue.arrayRemove([shopId]),
      });
    }
  }

  // ─── Coffee Shops ───

  Stream<List<CoffeeShop>> getCoffeeShops({
    String? searchQuery,
    String? roastLevel,
    String? priceRange,
    bool? hasWiFi,
  }) {
    Query query = _firestore
        .collection(FirestoreCollections.coffeeShops)
        .orderBy('createdAt', descending: true);

    if (roastLevel != null) {
      query = query.where('roastLevels', arrayContains: roastLevel);
    }
    if (priceRange != null) {
      query = query.where('priceRange', isEqualTo: priceRange);
    }
    if (hasWiFi != null) {
      query = query.where('hasWiFi', isEqualTo: hasWiFi);
    }

    return query.snapshots().map((snapshot) {
      final shops = snapshot.docs.map((doc) {
        return CoffeeShop.fromMap(doc.id, doc.data()! as Map<String, dynamic>);
      }).toList();

      if (searchQuery != null && searchQuery.isNotEmpty) {
        final query = searchQuery.toLowerCase();
        return shops.where((s) {
          return s.name.toLowerCase().contains(query) ||
              s.address.toLowerCase().contains(query) ||
              s.description.toLowerCase().contains(query);
        }).toList();
      }

      return shops;
    });
  }

  Future<CoffeeShop?> getCoffeeShop(String shopId) async {
    final doc = await _firestore
        .collection(FirestoreCollections.coffeeShops)
        .doc(shopId)
        .get();
    if (!doc.exists) return null;
    return CoffeeShop.fromMap(doc.id, doc.data()!);
  }

  Future<String> addCoffeeShop(CoffeeShop shop) async {
    final docRef = await _firestore
        .collection(FirestoreCollections.coffeeShops)
        .add(shop.toMap());
    return docRef.id;
  }

  Future<void> updateCoffeeShop(CoffeeShop shop) async {
    await _firestore
        .collection(FirestoreCollections.coffeeShops)
        .doc(shop.id)
        .update(shop.toMap());
  }

  // ─── Products ───

  Stream<List<Product>> getProducts(String shopId) {
    return _firestore
        .collection(FirestoreCollections.coffeeShops)
        .doc(shopId)
        .collection(FirestoreCollections.products)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Product.fromMap(doc.id, doc.data(), shopId))
          .toList();
    });
  }

  Future<void> addProduct(String shopId, Product product) async {
    await _firestore
        .collection(FirestoreCollections.coffeeShops)
        .doc(shopId)
        .collection(FirestoreCollections.products)
        .add(product.toMap());
  }

  // ─── Reviews ───

  Stream<List<Review>> getReviews(String shopId) {
    return _firestore
        .collection(FirestoreCollections.reviews)
        .where('shopId', isEqualTo: shopId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Review.fromMap(doc.id, doc.data()))
          .toList();
    });
  }

  Future<void> addReview(Review review) async {
    final batch = _firestore.batch();

    final reviewRef =
        _firestore.collection(FirestoreCollections.reviews).doc();
    batch.set(reviewRef, {
      ...review.toMap(),
      'shopId':
          _firestore.collection(FirestoreCollections.coffeeShops).doc(review.shopId),
      'userId':
          _firestore.collection(FirestoreCollections.users).doc(review.userId),
    });

    final shopRef = _firestore
        .collection(FirestoreCollections.coffeeShops)
        .doc(review.shopId);

    final shopDoc = await shopRef.get();
    final currentTotal = shopDoc.data()?['totalReviews'] as int? ?? 0;

    final newTotal = currentTotal + 1;
    final currentAvgQuality =
        shopDoc.data()?['averageQuality'] as double? ?? 0.0;
    final currentAvgFlavor =
        shopDoc.data()?['averageFlavor'] as double? ?? 0.0;
    final currentAvgRoast = shopDoc.data()?['averageRoast'] as double? ?? 0.0;
    final currentAvgRating =
        shopDoc.data()?['averageRating'] as double? ?? 0.0;

    batch.update(shopRef, {
      'totalReviews': newTotal,
      'averageQuality':
          ((currentAvgQuality * currentTotal) + review.qualityRating) /
              newTotal,
      'averageFlavor':
          ((currentAvgFlavor * currentTotal) + review.flavorRating) / newTotal,
      'averageRoast':
          ((currentAvgRoast * currentTotal) + review.roastRating) / newTotal,
      'averageRating':
          ((currentAvgRating * currentTotal) + review.overallRating) /
              newTotal,
    });

    await batch.commit();
  }
}
