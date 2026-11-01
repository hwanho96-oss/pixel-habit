class PlayerProgress {
  const PlayerProgress({this.xp = 0});

  final int xp;

  static const int xpPerLevel = 100;

  int get level => (xp ~/ xpPerLevel) + 1;

  int get xpIntoLevel => xp % xpPerLevel;

  double get levelProgress => xpIntoLevel / xpPerLevel;

  PlayerProgress copyWith({int? xp}) => PlayerProgress(xp: xp ?? this.xp);

  Map<String, Object?> toJson() => {'xp': xp};

  factory PlayerProgress.fromJson(Map<String, Object?> json) {
    return PlayerProgress(xp: json['xp'] as int? ?? 0);
  }
}
