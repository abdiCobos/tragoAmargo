import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import '../core/constants/app_constants.dart';

class GeocodingService {
  final String _baseUrl = AppConstants.nominatimUrl;

  Future<LatLng?> searchAddress(String address) async {
    try {
      final uri = Uri.parse(
        '$_baseUrl/search?format=json&q=${Uri.encodeComponent(address)}&limit=1',
      );
      final response = await http.get(uri, headers: {
        'User-Agent': AppConstants.userAgent,
        'Accept-Language': 'es',
      });

      if (response.statusCode == 200) {
        final results = jsonDecode(response.body) as List;
        if (results.isNotEmpty) {
          return LatLng(
            double.parse(results[0]['lat']),
            double.parse(results[0]['lon']),
          );
        }
      }
    } catch (_) {}
    return null;
  }

  Future<String?> reverseGeocode(LatLng point) async {
    try {
      final uri = Uri.parse(
        '$_baseUrl/reverse?format=json&lat=${point.latitude}&lon=${point.longitude}',
      );
      final response = await http.get(uri, headers: {
        'User-Agent': AppConstants.userAgent,
        'Accept-Language': 'es',
      });

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        return result['display_name'] as String?;
      }
    } catch (_) {}
    return null;
  }

  Future<Map<String, dynamic>?> getAddressDetails(LatLng point) async {
    try {
      final uri = Uri.parse(
        '$_baseUrl/reverse?format=jsonv2&lat=${point.latitude}&lon=${point.longitude}',
      );
      final response = await http.get(uri, headers: {
        'User-Agent': AppConstants.userAgent,
        'Accept-Language': 'es',
      });
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        final address = result['address'] as Map<String, dynamic>? ?? {};
        return {
          'city': address['city'] ?? address['town'] ?? address['village'] ?? address['municipality'] ?? '',
          'state': address['state'] ?? '',
          'displayName': result['display_name'] ?? '',
        };
      }
    } catch (_) {}
    return null;
  }

  Future<List<Map<String, dynamic>>> searchPlaces(String query) async {
    try {
      final uri = Uri.parse(
        '$_baseUrl/search?format=json&q=${Uri.encodeComponent(query)}&limit=5',
      );
      final response = await http.get(uri, headers: {
        'User-Agent': AppConstants.userAgent,
        'Accept-Language': 'es',
      });

      if (response.statusCode == 200) {
        final results = jsonDecode(response.body) as List;
        return results.map((r) => {
          'lat': double.parse(r['lat']),
          'lon': double.parse(r['lon']),
          'displayName': r['display_name'],
        }).toList();
      }
    } catch (_) {}
    return [];
  }
}
