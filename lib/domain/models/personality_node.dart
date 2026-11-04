import 'package:pixel_habit/domain/models/personality_trait.dart';

class PersonalityNode {
  const PersonalityNode({
    required this.id,
    required this.name,
    required this.traits,
    required this.level,
    required this.requires,
  });

  final String id;
  final String name;
  final List<PersonalityTrait> traits;
  final int level;
  final List<String> requires;

  factory PersonalityNode.fromJson(Map<String, Object?> json) {
    final rawTraits = json['traits'];
    final rawRequires = json['requires'];
    return PersonalityNode(
      id: json['id']! as String,
      name: json['name']! as String,
      traits: [
        for (final entry in rawTraits as List<dynamic>)
          PersonalityTrait.tryParse(entry)!,
      ],
      level: (json['level']! as num).toInt(),
      requires: [
        if (rawRequires is List)
          for (final entry in rawRequires)
            if (entry is String) entry,
      ],
    );
  }
}
