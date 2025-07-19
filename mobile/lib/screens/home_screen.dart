import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MapController _mapController = MapController();
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _endController = TextEditingController();

  int? _selectedChipIndex;
  List<LatLng> _routePoints = [];
  bool _isLoading = false;
  LatLng? _currentPosition;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _mapController.dispose();
    _startController.dispose();
    _endController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
      _mapController.move(_currentPosition!, 15.0);
    });
  }

  void _findRoute() async {
    final startLocation = _startController.text;
    final endLocation = _endController.text;

    if (startLocation.isEmpty || endLocation.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lokasi awal dan tujuan harus diisi')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _routePoints = [];
    });

    try {
      final route = await ApiService.getRouteFromApi(
        startLocation,
        endLocation,
        _selectedChipIndex,
      );
      setState(() {
        _routePoints = route;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: LatLng(-6.2088, 106.8456), // Fallback
                    initialZoom: 13.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.rutesejuk.app',
                    ),
                    if (_routePoints.isNotEmpty)
                      PolylineLayer(
                        polylines: [
                          Polyline(
                            points: _routePoints,
                            color: Colors.blue.withOpacity(0.8),
                            strokeWidth: 6,
                          ),
                        ],
                      ),
                    if (_currentPosition != null)
                      MarkerLayer(
                        markers: [
                          Marker(
                            width: 80.0,
                            height: 80.0,
                            point: _currentPosition!,
                            child: const Icon(
                              Icons.my_location,
                              color: Colors.blue,
                              size: 40.0,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        controller: _startController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.location_on),
                          labelText: 'Lokasi Awal',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _endController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.flag),
                          labelText: 'Tujuan',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ChoiceChip(
                            avatar: const Icon(Icons.park),
                            label: const Text('Sejuk'),
                            selected: _selectedChipIndex == 0,
                            onSelected: (bool selected) {
                              setState(() {
                                _selectedChipIndex = selected ? 0 : null;
                              });
                            },
                          ),
                          ChoiceChip(
                            avatar: const Icon(Icons.air),
                            label: const Text('Bersih'),
                            selected: _selectedChipIndex == 1,
                            onSelected: (bool selected) {
                              setState(() {
                                _selectedChipIndex = selected ? 1 : null;
                              });
                            },
                          ),
                          ChoiceChip(
                            avatar: const Icon(Icons.volume_off),
                            label: const Text('Tenang'),
                            selected: _selectedChipIndex == 2,
                            onSelected: (bool selected) {
                              setState(() {
                                _selectedChipIndex = selected ? 2 : null;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _isLoading ? null : _findRoute,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text(
                          'Cari Rute',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
