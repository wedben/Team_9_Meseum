class Artifact {
  final String id;
  final String name;
  final String description;
  final String type;
  final String answer;
  bool found;

  Artifact({
    required this.id,
    required this.name,
    required this.description,
    this.type = '',
    this.answer = '',
    this.found = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type,
      'answer': answer,
      'found': found,
    };
  }

  factory Artifact.fromMap(Map<String, dynamic> map) {
    return Artifact(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      type: map['type'] ?? '',
      answer: map['answer'] ?? '',
      found: map['found'] ?? false,
    );
  }
}