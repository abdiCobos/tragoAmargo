import 'package:flutter/foundation.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../core/utils/crash_reporting.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> _uploadToPath(String path, Uint8List bytes) async {
    try {
      final ref = _storage.ref().child(path);
      final metadata = SettableMetadata(contentType: 'image/jpeg');
      final snapshot = await ref.putData(bytes, metadata);
      final url = await snapshot.ref.getDownloadURL();
      return url;
    } catch (e, stack) {
      CrashReporting.recordError(e, stack, reason: 'StorageService._uploadToPath');
      rethrow;
    }
  }

  Future<String> uploadShopPhoto(String shopId, Uint8List bytes) {
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    return _uploadToPath('shops/$shopId/photos/$fileName', bytes);
  }

  Future<String> uploadProductPhoto(String shopId, Uint8List bytes) {
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    return _uploadToPath('shops/$shopId/products/$fileName', bytes);
  }

  Future<String> uploadUserPhoto(String uid, Uint8List bytes) {
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    return _uploadToPath('users/$uid/$fileName', bytes);
  }
}
