class Routine {
  const Routine({
    required this.id,
    required this.title,
    required this.xpReward,
    required this.avatarSeed,
    required this.createdAt,
    this.note,
    this.completedToday = false,
    this.lastCompletedAt,
  });

  final String id;
  final String title;
  final String? note;
  final int xpReward;
  final int avatarSeed;
  final bool completedToday;
  final DateTime createdAt;
  final DateTime? lastCompletedAt;

  Routine copyWith({
    String? title,
    String? note,
    int? xpReward,
    int? avatarSeed,
    bool? completedToday,
    DateTime? lastCompletedAt,
  }) {
    return Routine(
      id: id,
      title: title ?? this.title,
      note: note ?? this.note,
      xpReward: xpReward ?? this.xpReward,
      avatarSeed: avatarSeed ?? this.avatarSeed,
      completedToday: completedToday ?? this.completedToday,
      createdAt: createdAt,
      lastCompletedAt: lastCompletedAt ?? this.lastCompletedAt,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'title': title,
      'note': note,
      'xpReward': xpReward,
      'avatarSeed': avatarSeed,
      'completedToday': completedToday,
      'createdAt': createdAt.toIso8601String(),
      'lastCompletedAt': lastCompletedAt?.toIso8601String(),
    };
  }

  factory Routine.fromJson(Map<String, Object?> json) {
    return Routine(
      id: json['id']! as String,
      title: json['title']! as String,
      note: json['note'] as String?,
      xpReward: json['xpReward']! as int,
      avatarSeed: json['avatarSeed']! as int,
      completedToday: json['completedToday'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt']! as String),
      lastCompletedAt: json['lastCompletedAt'] == null
          ? null
          : DateTime.parse(json['lastCompletedAt']! as String),
    );
  }
}
