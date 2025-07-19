// lib/services/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class ApiService {
  static const String _baseUrl = 'http://10.0.2.2:8000';

  // Ubah fungsi untuk menerima parameter input
  static Future<List<LatLng>> getRouteFromApi(
    String startLocation,
    String endLocation,
    int? preference,
  ) async {
    try {
      // Ubah menjadi POST request
      final response = await http.post(
        Uri.parse('$_baseUrl/api/v1/route'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        // Kirim data input sebagai JSON body
        body: json.encode({
          'start_location': startLocation,
          'end_location': endLocation,
          'preference': preference,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List points = data['route_points'];
        return points.map((p) => LatLng(p['lat'], p['lon'])).toList();
      } else {
        throw Exception('Gagal memuat rute dari server');
      }
    } catch (e) {
      print(e);
      throw Exception('Tidak dapat terhubung ke server');
    }
  }
}
