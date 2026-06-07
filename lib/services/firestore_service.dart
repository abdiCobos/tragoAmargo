import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/constants/firebase_collections.dart';
import '../models/coffee_shop.dart';
import '../models/review.dart';
import '../models/app_user.dart';
import '../models/product.dart';
import '../models/report.dart';
import '../models/menu_item.dart';
import '../models/owner_claim.dart';
import '../models/notification.dart';

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

  Future<void> addOwnedShop(String uid, String shopId) async {
    await _firestore.collection(FirestoreCollections.users).doc(uid).update({
      'ownedShops': FieldValue.arrayUnion([shopId]),
    });
  }

  // ─── Coffee Shops ───

  Stream<List<CoffeeShop>> getCoffeeShops({
    String? searchQuery,
    String? roastLevel,
    String? priceRange,
    bool? hasWiFi,
    String? cityFilter,
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
      var shops = snapshot.docs.map((doc) {
        return CoffeeShop.fromMap(doc.id, doc.data()! as Map<String, dynamic>);
      }).toList();

      if (searchQuery != null && searchQuery.isNotEmpty) {
        final q = searchQuery.toLowerCase();
        shops = shops.where((s) {
          return s.name.toLowerCase().contains(q) ||
              s.address.toLowerCase().contains(q) ||
              s.description.toLowerCase().contains(q);
        }).toList();
      }

      if (cityFilter != null && cityFilter.isNotEmpty) {
        final q = cityFilter.toLowerCase();
        shops = shops.where((s) {
          return s.city.toLowerCase() == q || s.address.toLowerCase().contains(q);
        }).toList();
      }

      return shops;
    });
  }

  Future<CoffeeShop?> getCoffeeShopByAddress(String address) async {
    final normalized = address.trim().toLowerCase();
    final snapshot = await _firestore
        .collection(FirestoreCollections.coffeeShops)
        .where('addressLower', isEqualTo: normalized)
        .limit(1)
        .get();
    if (snapshot.docs.isEmpty) return null;
    return CoffeeShop.fromMap(snapshot.docs.first.id, snapshot.docs.first.data());
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

  Future<void> updateProductRating({
    required String shopId,
    required String productId,
    required double averageRating,
    required int totalRatings,
  }) async {
    await _firestore
        .collection(FirestoreCollections.coffeeShops)
        .doc(shopId)
        .collection(FirestoreCollections.products)
        .doc(productId)
        .update({
      'averageRating': averageRating,
      'totalRatings': totalRatings,
    });
  }

  // ─── Menu ───

  Stream<List<MenuItem>> getMenu(String shopId) {
    return _firestore
        .collection(FirestoreCollections.coffeeShops)
        .doc(shopId)
        .collection(FirestoreCollections.menu)
        .orderBy('name', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => MenuItem.fromMap(doc.id, doc.data(), shopId))
          .toList();
    });
  }

  Future<void> addMenuItem(MenuItem item) async {
    await _firestore
        .collection(FirestoreCollections.coffeeShops)
        .doc(item.shopId)
        .collection(FirestoreCollections.menu)
        .add(item.toMap());
  }

  Future<void> updateMenuItem(MenuItem item) async {
    await _firestore
        .collection(FirestoreCollections.coffeeShops)
        .doc(item.shopId)
        .collection(FirestoreCollections.menu)
        .doc(item.id)
        .update(item.toMap());
  }

  Future<void> deleteMenuItem(String shopId, String itemId) async {
    await _firestore
        .collection(FirestoreCollections.coffeeShops)
        .doc(shopId)
        .collection(FirestoreCollections.menu)
        .doc(itemId)
        .delete();
  }

  Future<void> rateMenuItem({
    required String shopId,
    required String itemId,
    required double averageRating,
    required int totalRatings,
  }) async {
    await _firestore
        .collection(FirestoreCollections.coffeeShops)
        .doc(shopId)
        .collection(FirestoreCollections.menu)
        .doc(itemId)
        .update({
      'averageRating': averageRating,
      'totalRatings': totalRatings,
    });
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

  Future<Review?> getExistingReview(String shopId, String userId) async {
    final snapshot = await _firestore
        .collection(FirestoreCollections.reviews)
        .where('shopId', isEqualTo: shopId)
        .where('userId', isEqualTo: userId)
        .limit(1)
        .get();
    if (snapshot.docs.isEmpty) return null;
    return Review.fromMap(snapshot.docs.first.id, snapshot.docs.first.data());
  }

  Future<List<Review>> getReviewsByUser(String userId) async {
    final snapshot = await _firestore
        .collection(FirestoreCollections.reviews)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs
        .map((doc) => Review.fromMap(doc.id, doc.data()))
        .toList();
  }

  Future<void> addReview(Review review) async {
    // Query for existing review outside the transaction
    final existingSnap = await _firestore
        .collection(FirestoreCollections.reviews)
        .where('shopId', isEqualTo: review.shopId)
        .where('userId', isEqualTo: review.userId)
        .limit(1)
        .get();

    final isUpdate = existingSnap.docs.isNotEmpty;
    final existingDoc = isUpdate ? existingSnap.docs.first : null;
    final prevOverall = isUpdate
        ? (existingDoc!['overallRating'] as double?) ?? 0.0
        : 0.0;
    final oldQuality = isUpdate ? (existingDoc!['qualityRating'] as double?) ?? 0.0 : 0.0;
    final oldFlavor = isUpdate ? (existingDoc!['flavorRating'] as double?) ?? 0.0 : 0.0;
    final oldRoast = isUpdate ? (existingDoc!['roastRating'] as double?) ?? 0.0 : 0.0;
    final oldService = isUpdate ? (existingDoc!['serviceRating'] as double?) ?? 0.0 : 0.0;

    final reviewRef = isUpdate
        ? existingDoc!.reference
        : _firestore.collection(FirestoreCollections.reviews).doc();

    await _firestore.runTransaction((tx) async {
      final shopRef = _firestore
          .collection(FirestoreCollections.coffeeShops)
          .doc(review.shopId);

      final shopDoc = await tx.get(shopRef);
      if (!shopDoc.exists) return;

      tx.set(reviewRef, review.toMap());

      final d = shopDoc.data()!;
      final n = (d['totalReviews'] as int?) ?? 0;
      final curQ = (d['averageQuality'] as double?) ?? 0.0;
      final curF = (d['averageFlavor'] as double?) ?? 0.0;
      final curR = (d['averageRoast'] as double?) ?? 0.0;
      final curS = (d['averageService'] as double?) ?? 0.0;
      final curOverall = (d['averageRating'] as double?) ?? 0.0;

      if (isUpdate) {
        final m = n > 0 ? n : 1;
        tx.update(shopRef, {
          'averageQuality': ((curQ * m) - oldQuality + review.qualityRating) / m,
          'averageFlavor': ((curF * m) - oldFlavor + review.flavorRating) / m,
          'averageRoast': ((curR * m) - oldRoast + review.roastRating) / m,
          'averageService': ((curS * m) - oldService + review.serviceRating) / m,
          'averageRating': ((curOverall * m) - prevOverall + review.overallRating) / m,
        });
      } else {
        final newTotal = n + 1;
        tx.update(shopRef, {
          'totalReviews': newTotal,
          'averageQuality': ((curQ * n) + review.qualityRating) / newTotal,
          'averageFlavor': ((curF * n) + review.flavorRating) / newTotal,
          'averageRoast': ((curR * n) + review.roastRating) / newTotal,
          'averageService': ((curS * n) + review.serviceRating) / newTotal,
          'averageRating': ((curOverall * n) + review.overallRating) / newTotal,
        });
      }
    });
  }

  // ─── Owner Claims ───

  Future<void> submitOwnerClaim(OwnerClaim claim) async {
    await _firestore.collection(FirestoreCollections.ownerClaims).add(claim.toMap());
  }

  Future<void> addReviewReply(String reviewId, String userName, String text) async {
    await _firestore.collection(FirestoreCollections.reviews).doc(reviewId).update({
      'replies': FieldValue.arrayUnion([{
        'userName': userName,
        'text': text,
        'createdAt': FieldValue.serverTimestamp(),
      }]),
    });
  }

  Future<bool> hasPendingClaim(String shopId, String userId) async {
    final snapshot = await _firestore
        .collection(FirestoreCollections.ownerClaims)
        .where('shopId', isEqualTo: shopId)
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: 'pending')
        .limit(1)
        .get();
    return snapshot.docs.isNotEmpty;
  }

  // ─── Notifications ───

  Future<void> sendNotification(AppNotification notif) async {
    await _firestore.collection(FirestoreCollections.notifications).add(notif.toMap());
  }

  Stream<List<AppNotification>> getNotifications(String userId) {
    return _firestore
        .collection(FirestoreCollections.notifications)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => AppNotification.fromMap(d.id, d.data())).toList());
  }

  Future<int> getUnreadCount(String userId) async {
    final snap = await _firestore
        .collection(FirestoreCollections.notifications)
        .where('userId', isEqualTo: userId)
        .where('read', isEqualTo: false)
        .count()
        .get();
    return snap.count ?? 0;
  }

  Stream<int> getUnreadCountStream(String userId) {
    return _firestore
        .collection(FirestoreCollections.notifications)
        .where('userId', isEqualTo: userId)
        .where('read', isEqualTo: false)
        .snapshots()
        .map((snap) => snap.docs.length);
  }

  Future<void> markAllRead(String userId) async {
    final batch = _firestore.batch();
    final snap = await _firestore
        .collection(FirestoreCollections.notifications)
        .where('userId', isEqualTo: userId)
        .where('read', isEqualTo: false)
        .get();
    for (final doc in snap.docs) {
      batch.update(doc.reference, {'read': true});
    }
    await batch.commit();
  }

  // ─── Reports ───

  Future<void> submitReport(Report report) async {
    await _firestore.collection(FirestoreCollections.reports).add(report.toMap());
  }
}
