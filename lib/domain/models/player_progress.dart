class PlayerProgress {
  const PlayerProgress({this.xp = 0, this.gold = 0});

  final int xp;
  final int gold;

  static const int xpPerLevel = 100;

  static const int goldPerCompletion = 10;

  static const int _maxStoredXp = 1 << 30;

  int get level => (xp ~/ xpPerLevel) + 1;

  int get xpIntoLevel => xp % xpPerLevel;

  double get levelProgress => xpIntoLevel / xpPerLevel;

  PlayerProgress copyWith({int? xp, int? gold}) =>
      PlayerProgress(xp: xp ?? this.xp, gold: gold ?? this.gold);

  PlayerProgress grantCompletionReward({required int xpReward}) {
    return copyWith(xp: xp + xpReward, gold: gold + goldPerCompletion);
  }

  PlayerProgress revokeCompletionReward({required int xpReward}) {
    return copyWith(
      xp: _clampXp(xp - xpReward),
      gold: _floorAtZero(gold - goldPerCompletion),
    );
  }

  Map<String, Object?> toJson() => {'xp': xp, 'gold': gold};

  factory PlayerProgress.fromJson(Map<String, Object?> json) {
    return PlayerProgress(
      xp: json['xp'] as int? ?? 0,
      gold: _nonNegativeInt(json['gold']),
    );
  }

  static int _clampXp(int value) {
    if (value < 0) {
      return 0;
    }
    if (value > _maxStoredXp) {
      return _maxStoredXp;
    }
    return value;
  }

  static int _floorAtZero(int value) => value < 0 ? 0 : value;

  static int _nonNegativeInt(Object? value) {
    if (value is! num) {
      return 0;
    }
    final asInt = value.toInt();
    return asInt < 0 ? 0 : asInt;
  }
}
