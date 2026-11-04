import 'package:flutter_test/flutter_test.dart';
import 'package:pixel_habit/data/services/local_storage_service.dart';
import 'package:pixel_habit/domain/models/habit_stat.dart';
import 'package:pixel_habit/domain/models/personality_trait.dart';
import 'package:pixel_habit/ui/features/avatar/view_models/personality_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PersonalityProvider', () {
    test('시작 시 Lv1 노드가 열리고, 경험치를 올리면 상위·조합 노드가 열린다', () async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();
      final provider = PersonalityProvider(LocalStorageService(preferences));

      await provider.load();

      expect(provider.openedIds, {
        'relation_1',
        'emotion_1',
        'action_1',
      });
      expect(provider.levelOf(PersonalityTrait.relation), 1);

      // Lv3 = XP 200 이상. 해제해도 열린 노드는 남는다.
      await provider.applyTodoTraitXp(
        stat: HabitStat.strength,
        xpReward: 200,
        completed: true,
      );
      await provider.applyTodoTraitXp(
        stat: HabitStat.intelligence,
        xpReward: 200,
        completed: true,
      );

      expect(provider.levelOf(PersonalityTrait.relation), 3);
      expect(provider.openedIds, containsAll(['relation_3', 'combo_warm_neighbor']));

      await provider.applyTodoTraitXp(
        stat: HabitStat.strength,
        xpReward: 200,
        completed: false,
      );
      expect(provider.levelOf(PersonalityTrait.relation), 1);
      expect(provider.openedIds, contains('relation_3'));
      expect(preferences.getKeys(), contains(PersonalityProvider.storageKey));
    });
  });
}
