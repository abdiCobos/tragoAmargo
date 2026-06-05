import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class StorageService {
  static const String _apiKey = '2138a891968bd4fca786ab8cff4d1ba4';
  static const String _uploadUrl = 'https://api.imgbb.com/1/upload';

  Future<String> uploadImage(File file, {String? name}) async {
    final request = http.MultipartRequest('POST', Uri.parse(_uploadUrl));
    request.fields['key'] = _apiKey;
    if (name != null) request.fields['name'] = name;

    final bytes = await file.readAsBytes();
    request.files.add(
      http.MultipartFile.fromBytes('image', bytes, filename: '${DateTime.now().millisecondsSinceEpoch}.jpg'),
    );

    final response = await request.send();
    final body = jsonDecode(await response.stream.bytesToString());
    if (body['success'] == true) {
      return body['data']['url'] as String;
    }
    throw Exception(body['error']?['message'] ?? 'Error al subir imagen');
  }

  Future<String> uploadShopPhoto(String shopId, File file) =>
      uploadImage(file, name: 'shop_$shopId');

  Future<String> uploadReviewPhoto(String reviewId, File file) =>
      uploadImage(file, name: 'review_$reviewId');

  Future<String> uploadProductPhoto(String shopId, File file) =>
      uploadImage(file, name: 'product_$shopId');

  Future<String> uploadUserPhoto(String uid, File file) =>
      uploadImage(file, name: 'user_$uid');

  Future<void> deleteFile(String url) async {}
}
