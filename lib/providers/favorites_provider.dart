import 'package:flutter/material.dart';
import '../models/coffee_shop.dart';

class FavoritesProvider extends ChangeNotifier {
  List<CoffeeShop> _favorites = [];
  final bool _isLoading = false;

  List<CoffeeShop> get favorites => _favorites;
  bool get isLoading => _isLoading;

  void setFavorites(List<CoffeeShop> shops) {
    _favorites = shops;
    notifyListeners();
  }

  void addFavorite(CoffeeShop shop) {
    if (!_favorites.any((s) => s.id == shop.id)) {
      _favorites.add(shop);
      notifyListeners();
    }
  }

  void removeFavorite(String shopId) {
    _favorites.removeWhere((s) => s.id == shopId);
    notifyListeners();
  }

  bool isFavorite(String shopId) {
    return _favorites.any((s) => s.id == shopId);
  }
}
