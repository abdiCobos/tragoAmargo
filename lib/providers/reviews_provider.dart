import 'package:flutter/material.dart';
import 'dart:async';
import '../services/firestore_service.dart';
import '../models/review.dart';
import '../core/utils/crash_reporting.dart';

class ReviewsProvider extends ChangeNotifier {
  final FirestoreService _firestoreService;

  List<Review> _reviews = [];
  Review? _existingReview;
  bool _isLoading = false;
  String? _error;
  StreamSubscription? _subscription;

  ReviewsProvider(this._firestoreService);

  List<Review> get reviews => _reviews;
  Review? get existingReview => _existingReview;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isEditing => _existingReview != null;

  void loadReviews(String shopId) {
    _subscription?.cancel();
    _isLoading = true;
    notifyListeners();

    _subscription = _firestoreService.getReviews(shopId).listen((reviews) {
      _reviews = reviews;
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> checkExistingReview(String shopId, String userId) async {
    final review = await _firestoreService.getExistingReview(shopId, userId);
    _existingReview = review;
    notifyListeners();
  }

  Future<bool> addReview({
    required String shopId,
    required String userId,
    required String userName,
    required String userPhoto,
    required double qualityRating,
    required double flavorRating,
    required double roastRating,
    required double serviceRating,
    required String comment,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final review = Review(
        id: '',
        shopId: shopId,
        userId: userId,
        userName: userName,
        userPhoto: userPhoto,
        qualityRating: qualityRating,
        flavorRating: flavorRating,
        roastRating: roastRating,
        serviceRating: serviceRating,
        comment: comment,
        createdAt: DateTime.now(),
      );

      await _firestoreService.addReview(review);
      _existingReview = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e, stack) {
      CrashReporting.recordError(e, stack, reason: 'ReviewsProvider.addReview');
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
