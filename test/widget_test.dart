import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixel_habit/app.dart';
import 'package:pixel_habit/domain/models/routine.dart';
import 'package:pixel_habit/ui/core/widgets/pixel_avatar.dart';
import 'package:pixel_habit/ui/core/widgets/pixel_checkbox.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/in_memory_routine_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('홈에서 루틴을 체크하면 골드가 오르고 +10이 떠오른다', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final repository = InMemoryRoutineRepository(
      routines: [
        Routine(
          id: 'r1',
          title: '아침 수련',
          xpReward: 15,
          avatarSeed: 0,
          createdAt: DateTime(2026, 1, 1),
        ),
      ],
    );

    await tester.pumpWidget(
      PixelHabitApp(preferences: preferences, repository: repository),
    );
    await tester.pumpAndSettle();

    expect(find.text('아침 수련'), findsOneWidget);
    expect(find.text('루틴'), findsWidgets);
    expect(find.text('Lv.1 훈련생'), findsOneWidget);
    expect(find.text('0 골드'), findsOneWidget);
    expect(find.byKey(const Key('gold_badge')), findsOneWidget);
    expect(find.byType(PixelAvatar), findsNothing);

    await tester.tap(find.byType(PixelCheckbox));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.textContaining('+10 골드'), findsWidgets);
    await tester.pumpAndSettle();

    expect(find.text('10 골드'), findsOneWidget);
    expect(
      tester.widget<PixelCheckbox>(find.byType(PixelCheckbox)).value,
      isTrue,
    );
  });

  testWidgets('루틴 카드를 탭하면 완료되고 다시 탭하면 골드가 돌아온다', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final repository = InMemoryRoutineRepository(
      routines: [
        Routine(
          id: 'r1',
          title: '아침 수련',
          xpReward: 15,
          avatarSeed: 0,
          createdAt: DateTime(2026, 1, 1),
        ),
      ],
    );

    await tester.pumpWidget(
      PixelHabitApp(preferences: preferences, repository: repository),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('아침 수련'));
    await tester.pumpAndSettle();

    expect(find.text('10 골드'), findsOneWidget);
    expect(
      tester.widget<PixelCheckbox>(find.byType(PixelCheckbox)).value,
      isTrue,
    );

    await tester.tap(find.text('아침 수련'));
    await tester.pumpAndSettle();

    expect(find.text('0 골드'), findsOneWidget);
    expect(
      tester.widget<PixelCheckbox>(find.byType(PixelCheckbox)).value,
      isFalse,
    );
  });

  testWidgets('하단 탭이 4개다', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      PixelHabitApp(
        preferences: preferences,
        repository: InMemoryRoutineRepository(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('홈'), findsOneWidget);
    expect(find.text('아바타'), findsOneWidget);
    expect(find.text('기록'), findsOneWidget);
    expect(find.text('설정'), findsOneWidget);
    expect(find.text('함께 키워갈 첫 루틴을 골라볼까?'), findsOneWidget);
  });
}
