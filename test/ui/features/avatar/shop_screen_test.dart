import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixel_habit/app.dart';
import 'package:pixel_habit/domain/models/player_progress.dart';
import 'package:pixel_habit/ui/core/theme/home_assets.dart';
import 'package:pixel_habit/ui/core/widgets/pixel_asset_image.dart';
import 'package:pixel_habit/ui/features/avatar/view_models/equipment_provider.dart';
import 'package:pixel_habit/ui/features/avatar/views/avatar_screen.dart';
import 'package:pixel_habit/ui/features/home/views/home_scene.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../support/in_memory_routine_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('골드가 있으면 사고 바로 입고, 가진 것은 벗긴다', (tester) async {
    await _boot(tester, gold: 200);

    expect(_homeImage(HomeAssets.background), findsOneWidget);
    expect(
      _homeImage('assets/items/tops/top_white_shirt_16.png'),
      findsOneWidget,
    );

    await _openAvatar(tester);
    expect(find.text('상점'), findsOneWidget);
    expect(find.text('상의'), findsOneWidget);
    expect(find.text('200 골드'), findsWidgets);

    await tester.tap(find.text('초록 튜닉'));
    await tester.pumpAndSettle();
    expect(find.text('160 골드'), findsWidgets);
    await _openHome(tester);
    expect(
      _homeImage('assets/items/tops/top_green_tunic_16.png'),
      findsOneWidget,
    );
    expect(
      _homeImage('assets/items/tops/top_white_shirt_16.png'),
      findsNothing,
    );

    await _openAvatar(tester);
    await tester.tap(find.text('초록 튜닉'));
    await tester.pumpAndSettle();
    expect(find.text('160 골드'), findsWidgets);
    await _openHome(tester);
    expect(
      _homeImage('assets/items/tops/top_green_tunic_16.png'),
      findsNothing,
    );

    await _openAvatar(tester);
    await tester.tap(find.text('배경'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('설산'));
    await tester.pumpAndSettle();
    expect(find.text('40 골드'), findsWidgets);
    await _openHome(tester);
    expect(
      _homeImage('assets/backgrounds/shop_bg_mountain.png'),
      findsOneWidget,
    );

    await _openAvatar(tester);
    await tester.tap(find.text('설산'));
    await tester.pumpAndSettle();
    expect(find.text('40 골드'), findsWidgets);
    await _openHome(tester);
    expect(_homeImage('assets/backgrounds/shop_bg_mountain.png'), findsNothing);
    expect(_homeImage(HomeAssets.background), findsOneWidget);

    await _openAvatar(tester);
    await tester.tap(find.text('무기'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('마법 도끼'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('골드가 조금 모자라. 퀘스트를 해 보면 어때?'), findsOneWidget);
    expect(find.text('40 골드'), findsWidgets);
    final equipment = Provider.of<EquipmentProvider>(
      tester.element(find.byType(AvatarScreen)),
      listen: false,
    );
    expect(equipment.ownedIds.contains('weapon_axe_magic'), isFalse);
    await tester.pumpAndSettle();

    await tester.tap(find.text('성격'));
    await tester.pumpAndSettle();
    expect(find.text('성격은 다음에 이 자리에 들어올 거야.'), findsOneWidget);
    expect(find.text('상의'), findsNothing);
  });
}

Future<void> _openHome(WidgetTester tester) async {
  await tester.tap(find.text('홈'));
  await tester.pumpAndSettle();
}

Future<void> _openAvatar(WidgetTester tester) async {
  await tester.tap(find.text('아바타'));
  await tester.pumpAndSettle();
}

Finder _homeImage(String path) {
  return find.descendant(
    of: find.byType(HomeScene),
    matching: find.byWidgetPredicate(
      (widget) => widget is PixelAssetImage && widget.path == path,
    ),
  );
}

Future<void> _boot(WidgetTester tester, {required int gold}) async {
  await tester.binding.setSurfaceSize(const Size(390, 844));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  SharedPreferences.setMockInitialValues({});
  final preferences = await SharedPreferences.getInstance();
  await tester.pumpWidget(
    PixelHabitApp(
      preferences: preferences,
      repository: InMemoryRoutineRepository(
        progress: PlayerProgress(gold: gold),
      ),
      showDebugBanner: false,
    ),
  );
  await tester.pumpAndSettle();
}
