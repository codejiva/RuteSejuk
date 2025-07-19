// lib/services/fake_routing_service.dart

// PASTIKAN BARIS INI BENAR
import 'package:latlong2/latlong.dart';

class FakeRoutingService {
  static Future<List<LatLng>> getFakeRoute() async {
    await Future.delayed(const Duration(seconds: 2));

    return [
      LatLng(-6.17, 106.82),
      LatLng(-6.17, 106.84),
      LatLng(-6.19, 106.84),
      LatLng(-6.19, 106.82),
      LatLng(-6.17, 106.82),
    ];
  }
}
