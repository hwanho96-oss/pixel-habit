import 'package:pixel_habit/domain/models/habit_stat.dart';

/// 성격 트리의 세 축. 화면 라벨(힘/지능/지혜)은 나중에 바꿀 때까지 [HabitStat]에 묶인다.
enum PersonalityTrait {
  relation,
  emotion,
  action;

  /// 할 일에 고른 스탯을 성격으로 본다. 없으면 경험치를 주지 않는다.
  static PersonalityTrait? fromHabitStat(HabitStat? stat) {
    return switch (stat) {
      HabitStat.strength => PersonalityTrait.relation,
      HabitStat.intelligence => PersonalityTrait.emotion,
      HabitStat.wisdom => PersonalityTrait.action,
      null => null,
    };
  }

  static PersonalityTrait? tryParse(Object? raw) {
    if (raw is! String || raw.isEmpty) {
      return null;
    }
    for (final trait in PersonalityTrait.values) {
      if (trait.name == raw) {
        return trait;
      }
    }
    return null;
  }
}
