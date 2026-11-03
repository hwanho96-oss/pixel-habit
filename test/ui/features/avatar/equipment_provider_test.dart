import 'package:flutter_test/flutter_test.dart';
import 'package:pixel_habit/data/services/local_storage_service.dart';
import 'package:pixel_habit/domain/models/item.dart';
import 'package:pixel_habit/ui/features/avatar/view_models/equipment_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('EquipmentProvider', () {
    test('새 사용자는 흰 셔츠와 갈색 바지를 공짜로 입고 시작한다', () async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();
      final provider = EquipmentProvider(LocalStorageService(preferences));

      await provider.load();

      expect(provider.items, hasLength(31));
      expect(provider.ownedIds, {
        EquipmentProvider.starterTopId,
        EquipmentProvider.starterBottomId,
      });
      expect(
        provider.equippedId(ItemCategory.top),
        EquipmentProvider.starterTopId,
      );
      expect(
        provider.equippedId(ItemCategory.bottom),
        EquipmentProvider.starterBottomId,
      );
      expect(
        provider.backgroundAsset,
        EquipmentProvider.defaultBackgroundAsset,
      );
      expect(provider.layerAsset(ItemCategory.weapon), isNull);
      expect(provider.items.map((item) => item.category).toSet(), {
        ItemCategory.top,
        ItemCategory.bottom,
        ItemCategory.weapon,
        ItemCategory.pet,
        ItemCategory.background,
      });
      expect(preferences.getKeys(), contains(EquipmentProvider.storageKey));

      await provider.unequip(ItemCategory.top);
      final again = EquipmentProvider(LocalStorageService(preferences));
      await again.load();
      expect(again.equippedId(ItemCategory.top), isNull);
      expect(again.ownedIds, contains(EquipmentProvider.starterTopId));
    });

    test('가지지 않은 장비는 장착되지 않고, 가진 장비는 다시 열어도 남는다', () async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();
      final provider = EquipmentProvider(LocalStorageService(preferences));
      await provider.load();
      final top = provider.items.firstWhere(
        (item) => item.category == ItemCategory.top,
      );
      final background = provider.items.firstWhere(
        (item) => item.id == 'bg_fantasy_castle',
      );

      await provider.equip(top.id);
      expect(
        provider.equippedId(ItemCategory.top),
        EquipmentProvider.starterTopId,
      );

      await provider.addOwned(top.id);
      await provider.addOwned(background.id);
      await provider.equip(top.id);
      await provider.equip(background.id);

      final reloaded = EquipmentProvider(LocalStorageService(preferences));
      await reloaded.load();

      expect(reloaded.ownedIds, {
        top.id,
        background.id,
        EquipmentProvider.starterTopId,
        EquipmentProvider.starterBottomId,
      });
      expect(reloaded.equippedId(ItemCategory.top), top.id);
      expect(reloaded.layerAsset(ItemCategory.top), top.asset);
      expect(reloaded.backgroundAsset, background.asset);
      expect(preferences.getKeys(), contains(EquipmentProvider.storageKey));

      await reloaded.unequip(ItemCategory.background);
      expect(
        reloaded.backgroundAsset,
        EquipmentProvider.defaultBackgroundAsset,
      );
    });

    test('깨진 저장값은 무시한다', () async {
      SharedPreferences.setMockInitialValues({
        EquipmentProvider.storageKey: '{',
      });
      final preferences = await SharedPreferences.getInstance();
      final provider = EquipmentProvider(LocalStorageService(preferences));
      await provider.load();
      expect(provider.ownedIds, isEmpty);
    });

    test('목록에 없거나 칸이 다른 아이디는 장착하지 않는다', () async {
      SharedPreferences.setMockInitialValues({
        EquipmentProvider.storageKey: '{"owned":["missing","top_white_shirt"],"equipped":{"top":"missing","weapon":"top_white_shirt"}}',
      });
      final preferences = await SharedPreferences.getInstance();
      final provider = EquipmentProvider(LocalStorageService(preferences));
      await provider.load();

      expect(provider.ownedIds, {'top_white_shirt'});
      expect(provider.equippedId(ItemCategory.top), isNull);
      expect(provider.equippedId(ItemCategory.weapon), isNull);
    });
  });
}
