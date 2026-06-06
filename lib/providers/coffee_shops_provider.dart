import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../services/firestore_service.dart';
import '../services/geocoding_service.dart';
import '../services/storage_service.dart';
import '../models/coffee_shop.dart';
import '../models/product.dart';

class CoffeeShopsProvider extends ChangeNotifier {
  final FirestoreService _firestoreService;
  final GeocodingService _geocodingService;
  final StorageService _storageService;

  List<CoffeeShop> _shops = [];
  List<Product> _currentProducts = [];
  CoffeeShop? _selectedShop;
  bool _isLoading = false;
  String? _error;

  String? _searchQuery;
  String? _roastFilter;
  String? _priceFilter;
  bool? _wifiFilter;

  CoffeeShopsProvider(
    this._firestoreService,
    this._geocodingService,
    this._storageService,
  ) {
    loadShops();
  }

  List<CoffeeShop> get shops => _shops;
  List<Product> get currentProducts => _currentProducts;
  CoffeeShop? get selectedShop => _selectedShop;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get searchQuery => _searchQuery;
  String? get roastFilter => _roastFilter;
  String? get priceFilter => _priceFilter;
  bool? get wifiFilter => _wifiFilter;
  bool get hasActiveFilters =>
      _searchQuery != null || _roastFilter != null || _priceFilter != null || _wifiFilter != null;

  void setSearchQuery(String? query) { _searchQuery = query; loadShops(); }
  void setRoastFilter(String? roast) { _roastFilter = roast; loadShops(); }
  void setPriceFilter(String? price) { _priceFilter = price; loadShops(); }
  void setWifiFilter(bool? wifi) { _wifiFilter = wifi; loadShops(); }

  void clearFilters() {
    _searchQuery = null; _roastFilter = null; _priceFilter = null; _wifiFilter = null;
    loadShops();
  }

  void loadShops() {
    _isLoading = true; notifyListeners();
    _firestoreService.getCoffeeShops(
      searchQuery: _searchQuery, roastLevel: _roastFilter,
      priceRange: _priceFilter, hasWiFi: _wifiFilter,
    ).listen((shops) { _shops = shops; _isLoading = false; notifyListeners(); });
  }

  Future<void> selectShop(String shopId) async {
    _isLoading = true; notifyListeners();
    final shop = await _firestoreService.getCoffeeShop(shopId);
    _selectedShop = shop; _isLoading = false; notifyListeners();
    _firestoreService.getProducts(shopId).listen((products) {
      _currentProducts = products; notifyListeners();
    });
  }

  Future<String?> addCoffeeShop({
    required String name, required String description,
    required String originAndAltitude, required List<String> roastLevels,
    required List<String> brewingMethods, required String priceRange,
    required bool hasWiFi, required String seatingMode,
    required Map<String, String> openingHours, required String phone,
    required String instagram, required String address,
    required List<Uint8List> photos, required String? userId,
  }) async {
    _isLoading = true; _error = null; notifyListeners();
    try {
      final existing = await _firestoreService.getCoffeeShopByAddress(address);
      if (existing != null) {
        _error = 'Ya existe una cafetería con esta dirección.';
        _isLoading = false; notifyListeners();
        return null;
      }

      GeoPoint location;
      final latLng = await _geocodingService.searchAddress(address);
      if (latLng != null) {
        location = GeoPoint(latLng.latitude, latLng.longitude);
      } else {
        location = const GeoPoint(0, 0);
      }

      final docRef = await _firestoreService.addCoffeeShop(CoffeeShop(
        id: '', name: name, description: description,
        originAndAltitude: originAndAltitude, roastLevels: roastLevels,
        brewingMethods: brewingMethods, priceRange: priceRange,
        hasWiFi: hasWiFi, seatingMode: seatingMode, openingHours: openingHours,
        phone: phone, instagram: instagram, location: location, address: address,
        createdAt: DateTime.now(), createdBy: userId,
      ));

      final photoUrls = <String>[];
      for (final bytes in photos) {
        final url = await _storageService.uploadImageBytes(bytes);
        photoUrls.add(url);
      }

      if (photoUrls.isNotEmpty) {
        await _firestoreService.updateCoffeeShop(CoffeeShop(
          id: docRef, name: name, description: description,
          originAndAltitude: originAndAltitude, roastLevels: roastLevels,
          brewingMethods: brewingMethods, priceRange: priceRange,
          hasWiFi: hasWiFi, seatingMode: seatingMode, openingHours: openingHours,
          phone: phone, instagram: instagram, location: location, address: address,
          photos: photoUrls, createdAt: DateTime.now(), createdBy: userId,
        ));
      }

      _isLoading = false; notifyListeners(); return docRef;
    } catch (e) {
      _error = e.toString(); _isLoading = false; notifyListeners(); return null;
    }
  }

  Future<void> addProduct({
    required String shopId,
    required String name,
    required double price,
    required String description,
    required String photoUrl,
  }) async {
    final product = Product(
      id: '', shopId: shopId, name: name, price: price,
      description: description, photo: photoUrl, createdAt: DateTime.now(),
    );
    await _firestoreService.addProduct(shopId, product);
  }
}
