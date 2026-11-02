import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixel_habit/app.dart';
import 'package:pixel_habit/domain/models/habit_stat.dart';
import 'package:pixel_habit/ui/core/widgets/pixel_checkbox.dart';
import 'package:pixel_habit/ui/core/widgets/pixel_icon.dart';
import 'package:pixel_habit/domain/models/player_progress.dart';
import 'package:pixel_habit/domain/models/routine.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../support/in_memory_routine_repository.dart';
import '../../../support/in_memory_todo_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('추천 칩을 누르면 루틴이 바로 생긴다', (tester) async {
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

    expect(find.text('함께 키워갈 첫 루틴을 골라볼까?'), findsOneWidget);
    await tester.tap(find.text('물 마시기'));
    await tester.pumpAndSettle();

    expect(find.text('함께 키워갈 첫 루틴을 골라볼까?'), findsNothing);
    expect(find.text('물 마시기'), findsOneWidget);
    expect(find.text('지혜'), findsWidgets);
  });

  testWidgets('어제 완료가 없으면 쉬어 간 문구를 보여 준다', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final today = DateTime.now();
    final threeDaysAgo = DateTime(
      today.year,
      today.month,
      today.day,
    ).subtract(const Duration(days: 3));

    await tester.pumpWidget(
      PixelHabitApp(
        preferences: preferences,
        repository: InMemoryRoutineRepository(
          progress: PlayerProgress(lastCompletionDate: threeDaysAgo),
          routines: [
            Routine(
              id: 'r1',
              title: '아침 수련',
              xpReward: 10,
              avatarSeed: 0,
              createdAt: threeDaysAgo,
              stat: HabitStat.strength,
            ),
          ],
        ),
        todoRepository: InMemoryTodoRepository(),
        showDebugBanner: false,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('어제는 쉬어갔구나. 오늘은 하나만 해볼까?'), findsOneWidget);
  });

  testWidgets('오늘 할 일을 모두 끝내면 완료 문구를 보여 준다', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final now = DateTime.now();

    await tester.pumpWidget(
      PixelHabitApp(
        preferences: preferences,
        repository: InMemoryRoutineRepository(
          routines: [
            Routine(
              id: 'r1',
              title: '일찍 자기',
              xpReward: 10,
              avatarSeed: 0,
              createdAt: now,
              completedToday: true,
              lastCompletedAt: now,
              stat: HabitStat.wisdom,
            ),
          ],
        ),
        todoRepository: InMemoryTodoRepository(),
        showDebugBanner: false,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('오늘 퀘스트 완료! 푹 쉬어, 모험가'), findsOneWidget);
  });

  testWidgets('체크하면 금색 별이 커진다', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final now = DateTime.now();

    await tester.pumpWidget(
      PixelHabitApp(
        preferences: preferences,
        repository: InMemoryRoutineRepository(
          routines: [
            Routine(
              id: 'r1',
              title: '물 마시기',
              xpReward: 10,
              avatarSeed: 0,
              createdAt: now,
            ),
          ],
        ),
        todoRepository: InMemoryTodoRepository(),
        showDebugBanner: false,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(PixelCheckbox));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 120));

    final grown = tester
        .widgetList<PixelIcon>(find.byType(PixelIcon))
        .where((icon) => icon.asset == PixelIcons.star && icon.size > 16)
        .length;
    expect(grown, greaterThanOrEqualTo(5));
    expect(find.textContaining('+10 골드'), findsWidgets);
  });

  testWidgets('기록 탭은 캘린더 자리만 비워 둔다', (tester) async {
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

    await tester.tap(find.text('기록'));
    await tester.pumpAndSettle();

    expect(find.text('캘린더는 다음에 이 자리에 들어올 거야.'), findsOneWidget);

    await tester.tap(find.text('설정'));
    await tester.pumpAndSettle();
    expect(find.text('https://kenney.nl/assets/rpg-audio'), findsOneWidget);
  });
}
