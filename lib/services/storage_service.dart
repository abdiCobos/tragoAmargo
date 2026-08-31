import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../core/utils/crash_reporting.dart';

class StorageService {
  static final String _apiKey = _loadApiKey();
  static const String _uploadUrl = 'https://api.imgbb.com/1/upload';

  static String _loadApiKey() {
    if (kIsWeb) {
      return const String.fromEnvironment('IMGBB_API_KEY', defaultValue: '');
    }
    return 'ff323192c406894e2bd3ba54dd9f9f16';
  }

  Future<String> uploadImageBytes(Uint8List bytes, {String? name}) async {
    try {
      final request = http.MultipartRequest('POST', Uri.parse(_uploadUrl));
      request.fields['key'] = _apiKey;
      if (name != null) request.fields['name'] = name;
      request.files.add(http.MultipartFile.fromBytes(
        'image', bytes,
        filename: '${DateTime.now().millisecondsSinceEpoch}.jpg',
      ));

      final response = await request.send();
      final body = jsonDecode(await response.stream.bytesToString());
      if (body['success'] == true) {
        return body['data']['url'] as String;
      }
      throw Exception(body['error']?['message'] ?? 'Error al subir imagen');
    } catch (e, stack) {
      CrashReporting.recordError(e, stack, reason: 'StorageService.uploadImageBytes');
      rethrow;
    }
  }

  Future<String> uploadShopPhoto(String shopId, Uint8List bytes) =>
      uploadImageBytes(bytes, name: 'shop_$shopId');

  Future<String> uploadProductPhoto(String shopId, Uint8List bytes) =>
      uploadImageBytes(bytes, name: 'product_$shopId');

  Future<String> uploadUserPhoto(String uid, Uint8List bytes) =>
      uploadImageBytes(bytes, name: 'user_$uid');
}
