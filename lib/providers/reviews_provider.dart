import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../models/review.dart';

class ReviewsProvider extends ChangeNotifier {
  final FirestoreService _firestoreService;

  List<Review> _reviews = [];
  bool _isLoading = false;
  String? _error;

  ReviewsProvider(this._firestoreService);

  List<Review> get reviews => _reviews;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void loadReviews(String shopId) {
    _isLoading = true;
    notifyListeners();

    _firestoreService.getReviews(shopId).listen((reviews) {
      _reviews = reviews;
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<bool> addReview({
    required String shopId,
    required String userId,
    required String userName,
    required String userPhoto,
    required double qualityRating,
    required double flavorRating,
    required double roastRating,
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
        comment: comment,
        createdAt: DateTime.now(),
      );

      await _firestoreService.addReview(review);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
