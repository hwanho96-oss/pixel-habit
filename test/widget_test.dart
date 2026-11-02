import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixel_habit/app.dart';
import 'package:pixel_habit/domain/models/routine.dart';
import 'package:pixel_habit/ui/core/widgets/pixel_avatar.dart';
import 'package:pixel_habit/ui/core/widgets/pixel_checkbox.dart';
import 'package:pixel_habit/ui/core/widgets/pixel_exp_bar.dart';
import 'package:pixel_habit/ui/core/widgets/profile_avatar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/in_memory_routine_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('루틴 탭에서 체크하면 완료 토스트가 보인다', (tester) async {
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
    expect(find.text('EXP'), findsOneWidget);
    expect(find.text('0/100'), findsOneWidget);
    expect(find.text('0 골드'), findsOneWidget);
    expect(find.byKey(const Key('gold_badge')), findsOneWidget);
    expect(find.byType(ProfileAvatar), findsOneWidget);
    expect(find.byType(PixelExpBar), findsOneWidget);
    expect(find.byType(PixelAvatar), findsNothing);

    await tester.tap(find.byType(PixelCheckbox));
    await tester.pumpAndSettle();

    expect(find.textContaining('퀘스트 완료'), findsOneWidget);
    expect(find.textContaining('+10 골드'), findsWidgets);
    expect(find.text('10 골드'), findsOneWidget);
    expect(find.text('15/100'), findsOneWidget);
    expect(find.text('완료'), findsOneWidget);
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

    expect(find.textContaining('퀘스트 완료'), findsOneWidget);
    expect(find.text('10 골드'), findsOneWidget);
    expect(find.text('완료'), findsOneWidget);

    await tester.tap(find.text('아침 수련'));
    await tester.pumpAndSettle();

    expect(find.text('0 골드'), findsOneWidget);
    expect(find.text('0/100'), findsOneWidget);
    expect(find.text('완료'), findsNothing);
  });

  testWidgets('하단 탭이 5개다', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      PixelHabitApp(
        preferences: preferences,
        repository: InMemoryRoutineRepository(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('To do'), findsOneWidget);
    expect(find.text('캘린더'), findsOneWidget);
    expect(find.text('캐릭터'), findsOneWidget);
    expect(find.text('종합'), findsOneWidget);
  });
}
