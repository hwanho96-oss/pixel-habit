/// 할 일과 루틴이 함께 쓰는 스탯 태그. 수치나 바는 없다.
enum HabitStat {
  strength,
  intelligence,
  wisdom;

  /// 저장값에 없거나 모르는 문자열이면 태그 없음으로 본다.
  static HabitStat? tryParse(Object? raw) {
    if (raw is! String || raw.isEmpty) {
      return null;
    }
    for (final stat in HabitStat.values) {
      if (stat.name == raw) {
        return stat;
      }
    }
    return null;
  }
}
