import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/museum.dart';
import '../models/artifact.dart';
import '../data/museum_quests.dart';
import '../data/museum_stories.dart';

import 'collection_screen.dart';
import 'museum_history_screen.dart';
import 'photo_quest_screen.dart';
import 'text_input_quest_screen.dart';
import 'qr_quest_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final LatLng _initialPosition = const LatLng(57.768102, 40.926250);
  late final MapController _mapController;
  Position? _currentPosition;

  final List<Museum> _museums = [];

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _getCurrentLocation();
    _initMuseums();
    _loadArtifactsState();
  }

  void _initMuseums() {
    _museums.addAll([
      Museum(
        id: 'cheese',
        name: 'Музей Сыра',
        location: const LatLng(57.762517, 40.930541),
        description: 'Узнайте всё о сыре и его истории.',
        history: MuseumStories.cheeseMuseumHistory,
        artifacts: MuseumQuests.cheeseMuseumQuests.map((q) => Artifact(
          id: q['id'] ?? '',
          name: q['name'] ?? '',
          description: q['description'] ?? '',
          type: q['type'] ?? '',
          answer: q['answer'] ?? '',
        )).toList(),
      ),
      Museum(
        id: 'nature_museum',
        name: 'Музей природы',
        location: const LatLng(57.765759, 40.924066),
        description: 'Погрузитесь в природу и её разнообразие.',
        history: MuseumStories.natureMuseumHistory,
        artifacts: MuseumQuests.natureMuseumQuests.map((q) => Artifact(
          id: q['id'] ?? '',
          name: q['name'] ?? '',
          description: q['description'] ?? '',
          type: q['type'] ?? '',
          answer: q['answer'] ?? '',
        )).toList(),
      ),
      Museum(
        id: 'military',
        name: 'Гауптвахта',
        location: const LatLng(57.768799, 40.926776),
        description: 'Откройте для себя военную историю региона.',
        history: MuseumStories.guardMuseumHistory,
        artifacts: MuseumQuests.guardMuseumQuests.map((q) => Artifact(
          id: q['id'] ?? '',
          name: q['name'] ?? '',
          description: q['description'] ?? '',
          type: q['type'] ?? '',
          answer: q['answer'] ?? '',
        )).toList(),
      ),
    ]);
  }

  Future<void> _loadArtifactsState() async {
    final prefs = await SharedPreferences.getInstance();
    for (var museum in _museums) {
      for (var artifact in museum.artifacts) {
        bool found = prefs.getBool('${museum.id}_${artifact.id}') ?? false;
        artifact.found = found;
      }
    }
    setState(() {});
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

  Future<void> _onMuseumTap(Museum museum) async {
    final prefs = await SharedPreferences.getInstance();
    final visited = prefs.getBool('visited_${museum.id}') ?? false;

    if (!visited) {
      await prefs.setBool('visited_${museum.id}', true);
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => MuseumHistoryScreen(museum: museum)),
      );
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CollectionScreen(museum: museum)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Карта музеев')),
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
                point: museum.location,
                width: 40,
                height: 40,
                child: GestureDetector(
                  onTap: () => _onMuseumTap(museum),
                  child: const Icon(Icons.location_on, color: Colors.red, size: 40),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
