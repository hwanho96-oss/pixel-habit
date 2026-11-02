import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixel_habit/app.dart';
import 'package:pixel_habit/domain/models/habit_stat.dart';
import 'package:pixel_habit/domain/models/routine.dart';
import 'package:pixel_habit/domain/models/todo.dart';
import 'package:pixel_habit/ui/core/widgets/pixel_checkbox.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../support/in_memory_routine_repository.dart';
import '../support/in_memory_todo_repository.dart';

/// `PIXEL_HABIT_SCREENSHOTS=1 flutter test test/ui/rpg_ui_screenshot_test.dart`
/// 화면을 래스터라이즈한 뒤 프로세스가 바로 끝나지 않을 수 있어, 기본 `flutter test`에서는 건너뛴다.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  if (Platform.environment['PIXEL_HABIT_SCREENSHOTS'] != '1') {
    test('스크린샷 생성은 PIXEL_HABIT_SCREENSHOTS=1 일 때만 실행된다', () {});
    return;
  }

  testWidgets('루틴 목록', (tester) async {
    await _boot(tester);
    await _capture(tester, 'routine_list');
  });

  testWidgets('루틴 완료', (tester) async {
    await _boot(tester);
    await tester.tap(find.byType(PixelCheckbox).first);
    await _settle(tester);
    await _capture(tester, 'routine_completed');
  });

  testWidgets('루틴 추가 시트', (tester) async {
    await _boot(tester);
    await tester.tap(find.byKey(const Key('add_routine_button')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await _settle(tester);
    debugPrint('sheet titles ${find.text('새 퀘스트 등록').evaluate().length}');
    await _capture(tester, 'add_routine_sheet');
  });

  testWidgets('루틴 추가 시트 아래쪽', (tester) async {
    await _boot(tester);
    await tester.tap(find.byKey(const Key('add_routine_button')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await _settle(tester);
    await tester.dragFrom(const Offset(200, 500), const Offset(0, -480));
    await tester.pump(const Duration(milliseconds: 300));
    await _settle(tester);
    await _capture(tester, 'add_routine_sheet_scrolled');
  });

  testWidgets('할 일 탭', (tester) async {
    final today = DateTime.now();
    await _boot(
      tester,
      todos: [
        Todo(
          id: 'open',
          title: '장보기',
          createdAt: DateTime(2026, 11, 2),
          date: DateTime(today.year, today.month, today.day),
          stat: HabitStat.strength,
        ),
        Todo(
          id: 'study',
          title: '보고서 읽기',
          createdAt: DateTime(2026, 11, 2, 1),
          stat: HabitStat.intelligence,
        ),
        Todo(
          id: 'done',
          title: '화분에 물 주기',
          createdAt: DateTime(2026, 11, 1),
          completed: true,
          stat: HabitStat.wisdom,
        ),
      ],
    );
    await tester.tap(find.text('할 일'));
    await _settle(tester);
    await _capture(tester, 'todo_tab');
  });

  testWidgets('종합 탭 크레딧', (tester) async {
    await _boot(tester, routines: const []);
    await tester.tap(find.text('종합'));
    await _settle(tester);
    await _capture(tester, 'summary_credit');
    expect(
      find.text('https://franuka.itch.io/rpg-ui-pack-demo'),
      findsOneWidget,
    );
  });
}

Future<void> _boot(
  WidgetTester tester, {
  List<Routine>? routines,
  List<Todo>? todos,
}) async {
  await tester.runAsync(_loadFonts);

  final view = tester.view;
  view.physicalSize = const Size(390, 844);
  view.devicePixelRatio = 1;
  addTearDown(view.resetPhysicalSize);
  addTearDown(view.resetDevicePixelRatio);

  SharedPreferences.setMockInitialValues({});
  final preferences = await SharedPreferences.getInstance();
  final repository = InMemoryRoutineRepository(
    routines:
        routines ??
        [
          Routine(
            id: 'r1',
            title: '아침 수련',
            note: '검술 30분',
            xpReward: 15,
            avatarSeed: 0,
            createdAt: DateTime(2026, 1, 1),
          ),
          Routine(
            id: 'r2',
            title: '물 마시기',
            xpReward: 5,
            avatarSeed: 1,
            createdAt: DateTime(2026, 1, 2),
          ),
        ],
  );

  await tester.pumpWidget(
    RepaintBoundary(
      key: const Key('shot'),
      child: PixelHabitApp(
        preferences: preferences,
        repository: repository,
        todoRepository: InMemoryTodoRepository(todos: todos),
        showDebugBanner: false,
      ),
    ),
  );
  await _settle(tester);
}

Future<void> _loadFonts() async {
  final pretendard = FontLoader('Pretendard')
    ..addFont(
      rootBundle.load('assets/fonts/pretendard/Pretendard-Regular.otf'),
    )
    ..addFont(
      rootBundle.load('assets/fonts/pretendard/Pretendard-SemiBold.otf'),
    );
  final galmuri = FontLoader('Galmuri')
    ..addFont(rootBundle.load('assets/fonts/galmuri/Galmuri11.ttf'));
  await Future.wait([pretendard.load(), galmuri.load()]);
}

Future<void> _settle(WidgetTester tester) async {
  await tester.pump();
  await tester.runAsync(
    () => Future<void>.delayed(const Duration(milliseconds: 200)),
  );
  await tester.pump();
}

Future<void> _capture(WidgetTester tester, String name) async {
  final boundary = tester.renderObject<RenderRepaintBoundary>(
    find.byKey(const Key('shot')),
  );
  final image = boundary.toImageSync(pixelRatio: 2);
  final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
  image.dispose();
  await tester.runAsync(() async {
    final directory = Directory('/tmp/pixel_habit_shots');
    await directory.create(recursive: true);
    await File('${directory.path}/$name.png')
        .writeAsBytes(bytes!.buffer.asUint8List());
  });
  debugPrint('wrote $name ${bytes?.lengthInBytes}');
}
