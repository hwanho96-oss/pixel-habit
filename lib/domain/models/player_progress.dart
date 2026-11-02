class PlayerProgress {
  const PlayerProgress({this.xp = 0, this.gold = 0, this.lastCompletionDate});

  final int xp;
  final int gold;

  /// 마지막으로 퀘스트를 완료한 날. 없으면 아직 완료한 적이 없다.
  final DateTime? lastCompletionDate;

  static const int xpPerLevel = 100;

  static const int goldPerCompletion = 10;

  static const int _maxStoredXp = 1 << 30;

  int get level => (xp ~/ xpPerLevel) + 1;

  int get xpIntoLevel => xp % xpPerLevel;

  double get levelProgress => xpIntoLevel / xpPerLevel;

  PlayerProgress copyWith({int? xp, int? gold, DateTime? lastCompletionDate}) {
    return PlayerProgress(
      xp: xp ?? this.xp,
      gold: gold ?? this.gold,
      lastCompletionDate: lastCompletionDate ?? this.lastCompletionDate,
    );
  }

  PlayerProgress grantCompletionReward({
    required int xpReward,
    DateTime? completedOn,
  }) {
    final stamp = completedOn ?? DateTime.now();
    return copyWith(
      xp: xp + xpReward,
      gold: gold + goldPerCompletion,
      lastCompletionDate: DateTime(stamp.year, stamp.month, stamp.day),
    );
  }

  /// 마지막 완료가 어제보다 오래됐으면, 어제는 쉰 날로 본다.
  /// 한 번도 완료한 적이 없으면 쉬어 간 것이 아니라 시작 전이다.
  bool skippedYesterday({DateTime? now}) {
    final last = lastCompletionDate;
    if (last == null) {
      return false;
    }
    final clock = now ?? DateTime.now();
    final today = DateTime(clock.year, clock.month, clock.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final lastDay = DateTime(last.year, last.month, last.day);
    return lastDay.isBefore(yesterday);
  }

  PlayerProgress revokeCompletionReward({required int xpReward}) {
    return copyWith(
      xp: _clampXp(xp - xpReward),
      gold: _floorAtZero(gold - goldPerCompletion),
    );
  }

  Map<String, Object?> toJson() => {
    'xp': xp,
    'gold': gold,
    'lastCompletionDate': _formatDay(lastCompletionDate),
  };

  factory PlayerProgress.fromJson(Map<String, Object?> json) {
    return PlayerProgress(
      xp: json['xp'] as int? ?? 0,
      gold: _nonNegativeInt(json['gold']),
      lastCompletionDate: _parseDay(json['lastCompletionDate']),
    );
  }

  static String? _formatDay(DateTime? value) {
    if (value == null) {
      return null;
    }
    final year = value.year.toString().padLeft(4, '0');
    final month = value.month.toString().padLeft(2, '0');
    final day = value.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  static DateTime? _parseDay(Object? raw) {
    if (raw is! String || raw.length < 10) {
      return null;
    }
    final year = int.tryParse(raw.substring(0, 4));
    final month = int.tryParse(raw.substring(5, 7));
    final day = int.tryParse(raw.substring(8, 10));
    if (year == null || month == null || day == null) {
      return null;
    }
    if (month < 1 || month > 12 || day < 1 || day > 31) {
      return null;
    }
    return DateTime(year, month, day);
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
