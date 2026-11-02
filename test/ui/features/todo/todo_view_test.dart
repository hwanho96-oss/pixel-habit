import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixel_habit/app.dart';
import 'package:pixel_habit/domain/models/habit_stat.dart';
import 'package:pixel_habit/domain/models/routine.dart';
import 'package:pixel_habit/domain/models/todo.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../support/in_memory_routine_repository.dart';
import '../../../support/in_memory_todo_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('할 일 탭에서 추가하고 완료하면 아래로 내려간다', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      PixelHabitApp(
        preferences: preferences,
        repository: InMemoryRoutineRepository(),
        todoRepository: InMemoryTodoRepository(),
        showDebugBanner: false,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('할 일'));
    await tester.pumpAndSettle();

    expect(find.text('아직 할 일이 없습니다.\n+ 버튼으로 첫 할 일을 추가하세요.'), findsOneWidget);

    await tester.tap(find.byKey(const Key('add_todo_button')));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('todo_name_field')), '장보기');
    await tester.pump();
    await tester.tap(find.text('오늘'));
    await tester.tap(find.text('힘'));
    await tester.pump();
    await tester.tap(find.text('등록'));
    await tester.pumpAndSettle();

    expect(find.text('장보기'), findsOneWidget);
    expect(find.text('오늘'), findsOneWidget);
    expect(find.text('힘'), findsOneWidget);

    await tester.tap(find.text('장보기'));
    await tester.pumpAndSettle();

    expect(find.textContaining('할 일 완료'), findsOneWidget);
    expect(find.textContaining('+10 골드'), findsWidgets);
    expect(find.text('완료'), findsOneWidget);

    await tester.tap(find.text('루틴'));
    await tester.pumpAndSettle();

    expect(find.text('10 골드'), findsOneWidget);
    expect(find.text('10/100'), findsOneWidget);
  });

  testWidgets('완료된 할 일은 아직 남은 할 일 아래에 있다', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final today = DateTime.now();

    await tester.pumpWidget(
      PixelHabitApp(
        preferences: preferences,
        repository: InMemoryRoutineRepository(),
        todoRepository: InMemoryTodoRepository(
          todos: [
            Todo(
              id: 'done',
              title: '끝난 일',
              createdAt: DateTime(2026, 11, 1),
              completed: true,
              stat: HabitStat.wisdom,
            ),
            Todo(
              id: 'open',
              title: '남은 일',
              createdAt: DateTime(2026, 11, 2),
              date: DateTime(today.year, today.month, today.day + 1),
              stat: HabitStat.intelligence,
            ),
          ],
        ),
        showDebugBanner: false,
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('할 일'));
    await tester.pumpAndSettle();

    expect(find.text('내일'), findsOneWidget);
    expect(find.text('지능'), findsOneWidget);
    expect(find.text('지혜'), findsOneWidget);

    final openTop = tester.getTopLeft(find.text('남은 일')).dy;
    final doneTop = tester.getTopLeft(find.text('끝난 일')).dy;
    expect(openTop, lessThan(doneTop));
  });

  testWidgets('루틴 카드에도 스탯 배지가 보인다', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      PixelHabitApp(
        preferences: preferences,
        repository: InMemoryRoutineRepository(
          routines: [
            Routine(
              id: 'r1',
              title: '마법 공부',
              xpReward: 20,
              avatarSeed: 2,
              createdAt: DateTime(2026, 1, 1),
              stat: HabitStat.intelligence,
            ),
          ],
        ),
        todoRepository: InMemoryTodoRepository(),
        showDebugBanner: false,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('마법 공부'), findsOneWidget);
    expect(find.text('지능'), findsOneWidget);
  });
}
