import 'package:flutter_test/flutter_test.dart';
import 'package:pixel_habit/domain/models/habit_stat.dart';
import 'package:pixel_habit/domain/models/routine.dart';
import 'package:pixel_habit/domain/models/routine_checklist_item.dart';

void main() {
  test('구버전 JSON은 새 필드 기본값으로 로드된다', () {
    final routine = Routine.fromJson({
      'id': 'legacy',
      'title': '아침 수련',
      'note': '물 한 잔',
      'xpReward': 15,
      'avatarSeed': 0,
      'completedToday': false,
      'createdAt': '2026-01-01T00:00:00.000',
      'lastCompletedAt': null,
    });

    expect(routine.checklist, isEmpty);
    expect(routine.startDate, isNull);
    expect(routine.reminderHour, isNull);
    expect(routine.reminderMinute, isNull);
    expect(routine.repeatWeekdays, isEmpty);
    expect(routine.tags, isEmpty);
    expect(routine.stat, isNull);
  });

  test('스탯 값이 없거나 모르면 태그 없음으로 읽는다', () {
    final missing = Routine.fromJson({
      'id': 'legacy',
      'title': '아침 수련',
      'xpReward': 15,
      'avatarSeed': 0,
      'createdAt': '2026-01-01T00:00:00.000',
      'stat': null,
    });
    final unknown = Routine.fromJson({
      'id': 'legacy',
      'title': '아침 수련',
      'xpReward': 15,
      'avatarSeed': 0,
      'createdAt': '2026-01-01T00:00:00.000',
      'stat': 'luck',
    });

    expect(missing.stat, isNull);
    expect(unknown.stat, isNull);
  });

  test('새 필드는 toJson/fromJson 왕복이 된다', () {
    final original = Routine(
      id: 'r1',
      title: '마트 가기',
      xpReward: 15,
      avatarSeed: 1,
      createdAt: DateTime(2026, 1, 1),
      checklist: const [
        RoutineChecklistItem(id: 'c1', title: '당근 사기', isDone: true),
      ],
      startDate: DateTime(2026, 11, 2),
      reminderHour: 7,
      reminderMinute: 30,
      repeatWeekdays: {DateTime.monday, DateTime.sunday},
      tags: const ['life'],
      stat: HabitStat.wisdom,
    );

    final restored = Routine.fromJson(original.toJson());
    expect(restored.checklist.single.title, '당근 사기');
    expect(restored.checklist.single.isDone, isTrue);
    expect(restored.startDate, DateTime(2026, 11, 2));
    expect(restored.reminderHour, 7);
    expect(restored.reminderMinute, 30);
    expect(restored.repeatWeekdays, {DateTime.monday, DateTime.sunday});
    expect(restored.tags, ['life']);
    expect(restored.stat, HabitStat.wisdom);
  });
}
