import 'package:latlong2/latlong.dart';
import 'artifact.dart';

class Museum {
  final String id;
  final String name;
  final LatLng location;
  final String description;
  final String history;
  final List<Artifact> artifacts;

  Museum({
    required this.id,
    required this.name,
    required this.location,
    required this.description,
    required this.history,
    required this.artifacts,
  });
}