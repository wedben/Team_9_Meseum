import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/museum.dart';
import '../models/artifact.dart';
import 'museum_history_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final LatLng _initialPosition = const LatLng(57.768102, 40.926250);
  late final MapController _mapController;
  Position? _currentPosition;

  final List<Museum> _museums = [
    Museum(
      id: 'cheese',
      name: 'Музей Сыра',
      location: const LatLng(57.762517, 40.930541),
      description: 'Узнайте всё о сыре и его истории.',
      history: 'История про сырного алхимика Пантелея...',
      artifacts: [
        Artifact(
          id: 'cheese_1',
          name: 'Самый старый сырный пресс',
          description: 'Определи его вес по маркировке',
        ),
        Artifact(
          id: 'cheese_2',
          name: 'Пазл-этикетка',
          description: 'Восстанови старинную упаковку костромского сыра',
        ),
        Artifact(
          id: 'cheese_3',
          name: 'Секретный ингредиент',
          description: 'Отыщи необычную добавку в сыр среди экспонатов',
        ),
        Artifact(
          id: 'cheese_4',
          name: 'Определи сорт сыра',
          description: 'В дегустационной зоне угадай 1 из 3 предложенных сыров',
        ),
      ],
    ),
    Museum(
      id: 'nature',
      name: 'Музей природы',
      location: const LatLng(57.765759, 40.924066),
      description: 'Погрузитесь в природу и её разнообразие.',
      history: 'История про профессора Вертинского и Код Природы...',
      artifacts: [
        Artifact(
          id: 'nature_1',
          name: 'Самый крупный экспонат',
          description: 'Измерь его размеры (можно сравнить с ростомером)',
        ),
        Artifact(
          id: 'nature_2',
          name: 'Цепь питания',
          description: 'Разложи карточки с животными в правильном порядке',
        ),
        Artifact(
          id: 'nature_3',
          name: 'Определи птицу по голосу',
          description: 'Прослушай аудиозапись и найди соответствующее чучело',
        ),
        Artifact(
          id: 'nature_4',
          name: 'Краснокнижный экспонат',
          description: 'Отметь на карте Костромской области, где он обитает',
        ),
      ],
    ),
    Museum(
      id: 'military',
      name: 'Гауптвахта',
      location: const LatLng(57.768799, 40.926776),
      description: 'Откройте для себя военную историю региона.',
      history: 'История про караульного Коробицына...',
      artifacts: [
        Artifact(
          id: 'military_1',
          name: 'Самое старое оружие',
          description: 'Запиши его тип и год изготовления',
        ),
        Artifact(
          id: 'military_2',
          name: 'Шифр донесения',
          description: 'Расшифруй простое сообщение (например, заменой букв)',
        ),
        Artifact(
          id: 'military_3',
          name: 'Нарушитель устава',
          description: 'По описанию найдите, за что могли арестовать солдата',
        ),
        Artifact(
          id: 'military_4',
          name: 'Караульный график',
          description: 'По количеству солдат распредели смены за сутки',
        ),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _getCurrentLocation();
    _loadArtifactsState();
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
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MuseumHistoryScreen(museum: museum),
                      ),
                    );
                  },
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