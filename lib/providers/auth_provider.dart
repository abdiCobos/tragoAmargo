import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../models/app_user.dart';
import '../models/notification.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;
  final FirestoreService _firestoreService;

  User? _user;
  AppUser? _appUser;
  bool _isLoading = false;
  String? _error;

  AuthProvider(this._authService, this._firestoreService) {
    _authService.authStateChanges.listen(_onAuthStateChanged);
  }

  User? get user => _user;
  AppUser? get appUser => _appUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;
  String? get error => _error;

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<void> _onAuthStateChanged(User? firebaseUser) async {
    _user = firebaseUser;
    if (firebaseUser != null) {
      _appUser = await _firestoreService.getUser(firebaseUser.uid);
      if (_appUser == null) {
        final newUser = AppUser.fromFirebaseUser(
          firebaseUser.uid,
          firebaseUser.displayName,
          firebaseUser.email,
          firebaseUser.photoURL,
        );
        await _firestoreService.createUser(newUser);
        _appUser = newUser;
        _firestoreService.sendNotification(AppNotification(
          id: '', userId: firebaseUser.uid, title: '¡Bienvenido a Trago Amargo!',
          body: 'Muchas cafeterías, poca calidad y sabor. Ayúdanos a encontrar las mejores.',
          type: 'welcome', createdAt: DateTime.now(),
        ));
      }
    } else {
      _appUser = null;
    }
    notifyListeners();
  }

  Future<bool> signInWithEmail(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _authService.signInWithEmail(email, password);
      return true;
    } on FirebaseAuthException catch (e) {
      _error = _getAuthErrorMessage(e.code);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> registerWithEmail(
    String email,
    String password,
    String displayName,
  ) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final credential =
          await _authService.registerWithEmail(email, password);
      await _authService.updateDisplayName(displayName);

      final newUser = AppUser.fromFirebaseUser(
        credential.user!.uid,
        displayName,
        email,
        null,
      );
      await _firestoreService.createUser(newUser);
      return true;
    } on FirebaseAuthException catch (e) {
      _error = _getAuthErrorMessage(e.code);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signInWithGoogle() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _authService.signInWithGoogle();
      return true;
    } on FirebaseAuthException catch (e) {
      _error = _getAuthErrorMessage(e.code);
      return false;
    } catch (e) {
      _error = 'Error al iniciar sesión con Google';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }

  Future<void> toggleFavorite(String shopId) async {
    if (_appUser == null) return;

    final isFav = _appUser!.favoriteShops.contains(shopId);
    final previousFavs = List<String>.from(_appUser!.favoriteShops);
    final updatedFavs = List<String>.from(previousFavs);

    if (isFav) {
      updatedFavs.remove(shopId);
    } else {
      updatedFavs.add(shopId);
    }

    _appUser = _appUser!.copyWith(favoriteShops: updatedFavs);
    notifyListeners();

    try {
      await _firestoreService.toggleFavorite(_appUser!.uid, shopId, !isFav);
    } catch (e) {
      _appUser = _appUser!.copyWith(favoriteShops: previousFavs);
      notifyListeners();
      rethrow;
    }
  }

  bool isFavorite(String shopId) {
    return _appUser?.favoriteShops.contains(shopId) ?? false;
  }

  bool isOwnerOf(String shopId) {
    return _appUser?.ownedShops.contains(shopId) ?? false;
  }

  bool isOwnerOfShop(String? verifiedOwnerUid) {
    if (verifiedOwnerUid == null || _user == null) return false;
    return verifiedOwnerUid == _user!.uid;
  }

  Future<void> claimShop(String shopId) async {
    if (_appUser == null) return;
    final updated = List<String>.from(_appUser!.ownedShops);
    if (!updated.contains(shopId)) updated.add(shopId);
    _appUser = _appUser!.copyWith(ownedShops: updated);
    await _firestoreService.updateUser(_appUser!);
    notifyListeners();
  }

  Future<void> addOwnedShop(String shopId) async {
    await claimShop(shopId);
  }

  Future<bool> requireLogin(BuildContext context) async {
    if (isAuthenticated) return true;
    final result = await Navigator.pushNamed(context, '/login');
    return result == true || isAuthenticated;
  }

  String _getAuthErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No existe una cuenta con este email';
      case 'wrong-password':
        return 'Contraseña incorrecta';
      case 'email-already-in-use':
        return 'Este email ya está registrado';
      case 'invalid-email':
        return 'Email inválido';
      case 'weak-password':
        return 'La contraseña debe tener al menos 6 caracteres';
      case 'invalid-credential':
        return 'Email o contraseña incorrectos';
      default:
        return 'Error de autenticación: $code';
    }
  }
}
