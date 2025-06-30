class Artifact {
  final String name;
  bool found;

  Artifact({required this.name, this.found = false});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'found': found,
    };
  }

  factory Artifact.fromMap(Map<String, dynamic> map) {
    return Artifact(
      name: map['name'],
      found: map['found'] ?? false,
    );
  }
}
