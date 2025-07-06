import 'package:uuid/uuid.dart';

class Spell {
  final String id;
  final String title;
  final String description;
  final int level;

  Spell({
    required this.id,
    required this.title,
    required this.description,
    this.level = 1,
  });

  factory Spell.fromJson(Map<String, dynamic> json) {
    return Spell(
      id: Uuid().v4(),
      title: json['title'],
      description: json['description'],
      level: json['level'],
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'level': level,
  };
}
