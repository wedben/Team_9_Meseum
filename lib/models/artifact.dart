class Artifact {
  final String id;
  final String name;
  final String description;
  bool found;

  Artifact({
    required this.id,
    required this.name,
    required this.description,
    this.found = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'found': found,
    };
  }

  factory Artifact.fromMap(Map<String, dynamic> map) {
    return Artifact(
      id: map['id'],
      name: map['name'],
      description: map['description'] ?? '',
      found: map['found'] ?? false,
    );
  }
}