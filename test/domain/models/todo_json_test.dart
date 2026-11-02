import 'package:flutter_test/flutter_test.dart';
import 'package:pixel_habit/domain/models/habit_stat.dart';
import 'package:pixel_habit/domain/models/todo.dart';

void main() {
  test('선택 필드가 없는 JSON은 날짜·스탯 없음으로 로드된다', () {
    final todo = Todo.fromJson({
      'id': 't1',
      'title': '장보기',
      'createdAt': '2026-11-02T09:00:00.000',
    });

    expect(todo.date, isNull);
    expect(todo.stat, isNull);
    expect(todo.completed, isFalse);
    expect(todo.xpReward, Todo.defaultXpReward);
  });

  test('모르는 스탯과 깨진 날짜는 없는 값으로 읽는다', () {
    final todo = Todo.fromJson({
      'id': 't1',
      'title': '장보기',
      'createdAt': '2026-11-02T09:00:00.000',
      'date': 'not-a-date',
      'stat': 'luck',
    });

    expect(todo.date, isNull);
    expect(todo.stat, isNull);
  });

  test('날짜는 달력 날짜만 왕복하고 스탯도 유지된다', () {
    final original = Todo(
      id: 't1',
      title: '장보기',
      createdAt: DateTime(2026, 11, 2, 9),
      date: DateTime(2026, 11, 3, 15, 30),
      stat: HabitStat.strength,
      completed: true,
      xpReward: 10,
    );

    final restored = Todo.fromJson(original.toJson());

    expect(restored.title, '장보기');
    expect(restored.date, DateTime(2026, 11, 3));
    expect(restored.stat, HabitStat.strength);
    expect(restored.completed, isTrue);
    expect(restored.xpReward, 10);
    expect(restored.toJson()['date'], '2026-11-03');
  });
}
