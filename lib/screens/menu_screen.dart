import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'museum_history_screen.dart';

class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final LatLng _initialPosition = LatLng(57.768102, 40.926250);

  final List<Map<String, dynamic>> _museums = [
    {
      'name': 'Музей Сыра',
      'location': LatLng(57.762517, 40.930541),
    },
    {
      'name': 'Военно-исторический музей',
      'location': LatLng(57.768799, 40.926776),
    },
    {
      'name': 'Музей природы',
      'location': LatLng(57.765759, 40.924066),
    },
  ];

  late final MapController _mapController;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    final hasPermission = await _handlePermission();
    if (!hasPermission) return;

    final position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = position;
    });
  }

  Future<bool> _handlePermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      return permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Карта музеев')),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: _initialPosition,
          initialZoom: 15.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: const ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: _museums.map((museum) {
              return Marker(
                point: museum['location'],
                width: 40,
                height: 40,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => MuseumHistoryScreen()),
                    );
                  },
                  child: Icon(Icons.location_on, color: Colors.red, size: 40),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
