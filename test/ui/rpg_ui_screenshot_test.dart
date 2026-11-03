import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixel_habit/app.dart';
import 'package:pixel_habit/domain/models/habit_stat.dart';
import 'package:pixel_habit/domain/models/player_progress.dart';
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

  testWidgets('홈', (tester) async {
    final now = DateTime.now();
    Routine quest(String id, String title, HabitStat stat) {
      return Routine(
        id: id,
        title: title,
        xpReward: 10,
        avatarSeed: 0,
        createdAt: now,
        completedToday: true,
        lastCompletedAt: now,
        stat: stat,
      );
    }

    await _boot(
      tester,
      progress: const PlayerProgress(gold: 40, xp: 30),
      routines: [
        quest('study', '30분 공부', HabitStat.intelligence),
        quest('stretch', '스트레칭 10분', HabitStat.strength),
        quest('water', '물 2L 마시기', HabitStat.wisdom),
        quest('sleep', '일찍 자기', HabitStat.wisdom),
      ],
    );
    await _capture(tester, 'home');
    expect(find.text('Lv.1 훈련생'), findsOneWidget);
    expect(find.text('40 골드'), findsOneWidget);
    expect(find.text('오늘 퀘스트 완료! 푹 쉬어, 모험가'), findsOneWidget);
  });

  testWidgets('홈 보상', (tester) async {
    final now = DateTime.now();
    await _boot(
      tester,
      progress: const PlayerProgress(gold: 30),
      routines: [
        Routine(
          id: 'water',
          title: '물 마시기',
          xpReward: 10,
          avatarSeed: 0,
          createdAt: now,
          stat: HabitStat.wisdom,
        ),
      ],
    );
    await tester.tap(find.byType(PixelCheckbox));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 120));
    await _capture(tester, 'home_reward');
    expect(find.textContaining('+10 골드'), findsWidgets);
  });

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
    await tester.tap(find.text('투두'));
    await _settle(tester);
    await _capture(tester, 'todo_tab');
  });

  testWidgets('상점', (tester) async {
    await _boot(
      tester,
      progress: const PlayerProgress(gold: 500, xp: 30),
      routines: const [],
      size: const Size(400, 860),
    );
    await tester.tap(find.text('아바타'));
    await _paint(tester);
    await _capture(tester, 'shop_top', pixelRatio: 1);
    await tester.tap(find.text('배경'));
    await _paint(tester);
    await _capture(tester, 'shop_bg', pixelRatio: 1);
    await tester.tap(find.text('설산'));
    await _paint(tester);
    await tester.tap(find.text('상의'));
    await _paint(tester);
    await tester.tap(find.text('갈색 튜닉'));
    await _paint(tester);
    await tester.tap(find.text('홈'));
    await _paint(tester);
    await _capture(tester, 'home_after', pixelRatio: 1);
    expect(find.text('340 골드'), findsWidgets);
  });

  testWidgets('상점 맞춤', (tester) async {
    await _boot(
      tester,
      progress: const PlayerProgress(gold: 500, xp: 30),
      routines: const [],
      size: const Size(400, 860),
    );
    await tester.tap(find.text('아바타'));
    await _paint(tester);
    await tester.tap(find.text('갈색 튜닉'));
    await _paint(tester);
    expect(find.text('착용 중'), findsOneWidget);
    expect(find.text('보유'), findsOneWidget);
    await _capture(tester, 'shop_fixed', pixelRatio: 1);
    await tester.tap(find.text('무기'));
    await _paint(tester);
    await tester.tap(find.text('철 도끼'));
    await _paint(tester);
    await _capture(tester, 'fit_check', pixelRatio: 1);
    expect(find.text('착용 중'), findsOneWidget);
  });

  testWidgets('설정 탭 크레딧', (tester) async {
    await _boot(tester, routines: const []);
    await tester.tap(find.text('설정'));
    await _settle(tester);
    await _capture(tester, 'settings_credit');
    expect(
      find.text('https://franuka.itch.io/rpg-ui-pack-demo'),
      findsOneWidget,
    );
    expect(find.text('https://kenney.nl/assets/rpg-audio'), findsOneWidget);
  });
}

Future<void> _boot(
  WidgetTester tester, {
  List<Routine>? routines,
  List<Todo>? todos,
  PlayerProgress? progress,
  Size size = const Size(390, 844),
}) async {
  await tester.runAsync(_loadFonts);

  final view = tester.view;
  view.physicalSize = size;
  view.devicePixelRatio = 1;
  addTearDown(view.resetPhysicalSize);
  addTearDown(view.resetDevicePixelRatio);

  SharedPreferences.setMockInitialValues({});
  final preferences = await SharedPreferences.getInstance();
  final repository = InMemoryRoutineRepository(
    progress: progress,
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

var _fontsLoaded = false;

Future<void> _loadFonts() async {
  if (_fontsLoaded) {
    return;
  }
  final pretendard = FontLoader('Pretendard')
    ..addFont(rootBundle.load('assets/fonts/pretendard/Pretendard-Regular.otf'))
    ..addFont(
      rootBundle.load('assets/fonts/pretendard/Pretendard-SemiBold.otf'),
    );
  final galmuri = FontLoader('Galmuri')
    ..addFont(rootBundle.load('assets/fonts/galmuri/Galmuri11.ttf'));
  final materialFile = _materialIconsFile();
  if (materialFile == null) {
    throw StateError('MaterialIcons-Regular.otf 를 찾지 못했습니다.');
  }
  final materialBytes = await materialFile.readAsBytes();
  final material = FontLoader('MaterialIcons')
    ..addFont(Future.value(ByteData.sublistView(materialBytes)));
  await Future.wait([pretendard.load(), galmuri.load(), material.load()]);
  _fontsLoaded = true;
}

File? _materialIconsFile() {
  final executable = File(Platform.resolvedExecutable);
  final candidates = [
    File(
      '${executable.parent.parent.parent.path}/artifacts/material_fonts/MaterialIcons-Regular.otf',
    ),
    if (Platform.environment['FLUTTER_ROOT'] != null)
      File(
        '${Platform.environment['FLUTTER_ROOT']}/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf',
      ),
  ];
  for (final file in candidates) {
    if (file.existsSync()) {
      return file;
    }
  }
  return null;
}

Future<void> _paint(WidgetTester tester) async {
  await tester.pumpAndSettle();
  await tester.runAsync(
    () => Future<void>.delayed(const Duration(milliseconds: 400)),
  );
  await tester.pump();
}

Future<void> _settle(WidgetTester tester) async {
  await tester.pump();
  await tester.runAsync(
    () => Future<void>.delayed(const Duration(milliseconds: 200)),
  );
  await tester.pump();
}

const _artifactShots = {
  'home',
  'home_reward',
  'shop_top',
  'shop_bg',
  'home_after',
  'shop_fixed',
  'fit_check',
};

Future<void> _capture(
  WidgetTester tester,
  String name, {
  double pixelRatio = 2,
}) async {
  final boundary = tester.renderObject<RenderRepaintBoundary>(
    find.byKey(const Key('shot')),
  );
  await tester.runAsync(() async {
    final image = boundary.toImageSync(pixelRatio: pixelRatio);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();
    final png = bytes!.buffer.asUint8List();
    final directory = Directory('/tmp/pixel_habit_shots');
    await directory.create(recursive: true);
    await File('${directory.path}/$name.png').writeAsBytes(png);
    if (_artifactShots.contains(name)) {
      final artifacts = Directory('/opt/cursor/artifacts');
      await artifacts.create(recursive: true);
      await File('${artifacts.path}/$name.png').writeAsBytes(png);
    }
    debugPrint('wrote $name ${png.length}');
  });
}
