import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixel_habit/app.dart';
import 'package:pixel_habit/ui/core/theme/home_assets.dart';
import 'package:pixel_habit/ui/core/widgets/avatar_view.dart';
import 'package:pixel_habit/ui/core/widgets/pixel_asset_image.dart';
import 'package:pixel_habit/ui/features/avatar/view_models/equipment_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../support/in_memory_routine_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('홈과 아바타 탭이 같은 레이어 아바타와 골드를 보여 준다', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      PixelHabitApp(
        preferences: preferences,
        repository: InMemoryRoutineRepository(),
        showDebugBanner: false,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Lv.1 훈련생'), findsOneWidget);
    expect(find.text('0 골드'), findsOneWidget);
    expect(find.byType(AvatarView), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is PixelAssetImage &&
            widget.path == 'assets/images/avatar_wizard.png',
      ),
      findsNothing,
    );
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is PixelAssetImage &&
            widget.path == EquipmentProvider.baseAsset,
      ),
      findsOneWidget,
    );
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is PixelAssetImage && widget.path == HomeAssets.background,
      ),
      findsOneWidget,
    );

    await tester.tap(find.text('아바타'));
    await tester.pumpAndSettle();

    expect(find.byType(AvatarView), findsWidgets);
    expect(find.text('0 골드'), findsWidgets);
    expect(find.text('Lv.1 훈련생'), findsNothing);
    final avatar = tester.widgetList<AvatarView>(find.byType(AvatarView));
    expect(avatar.any((view) => view.characterSize == 256), isTrue);
  });
}
