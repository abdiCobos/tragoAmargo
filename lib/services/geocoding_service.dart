import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import '../core/constants/app_constants.dart';
import '../core/utils/crash_reporting.dart';

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
            double.parse(results[0]['lat'].toString()),
            double.parse(results[0]['lon'].toString()),
          );
        }
      }
    } catch (e, stack) {
      CrashReporting.recordError(e, stack, reason: 'GeocodingService.searchAddress');
    }
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
    } catch (e, stack) {
      CrashReporting.recordError(e, stack, reason: 'GeocodingService.reverseGeocode');
    }
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
    } catch (e, stack) {
      CrashReporting.recordError(e, stack, reason: 'GeocodingService.getAddressDetails');
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> searchPlaces(String query) async {
    return _search(query);
  }

  Future<List<Map<String, dynamic>>> searchStructured(String query) async {
    return _search(query);
  }

  Future<List<Map<String, dynamic>>> _search(String query) async {
    try {
      final uri = Uri.parse(
        '$_baseUrl/search?format=jsonv2&q=${Uri.encodeComponent(query)}&limit=5&addressdetails=1&countrycodes=mx&accept-language=es',
      );
      final response = await http.get(uri, headers: {
        'User-Agent': AppConstants.userAgent,
        'Accept-Language': 'es',
      });
      if (response.statusCode == 200) {
        final results = jsonDecode(response.body) as List;
        return results.map((r) => {
          'lat': double.parse((r['lat'] as dynamic).toString()),
          'lon': double.parse((r['lon'] as dynamic).toString()),
          'displayName': r['display_name'] as String? ?? '',
        }).toList();
      }
    } catch (e, stack) {
      CrashReporting.recordError(e, stack, reason: 'GeocodingService._search');
    }
    return [];
  }
}
