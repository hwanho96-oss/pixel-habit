import 'package:flutter_test/flutter_test.dart';
import 'package:pixel_habit/data/repositories/routine_repository.dart';
import 'package:pixel_habit/data/services/local_storage_service.dart';
import 'package:pixel_habit/domain/models/player_progress.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LocalRoutineRepository player progress', () {
    test('골드는 XP와 함께 저장되고 앱을 다시 열어도 유지된다', () async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();
      final repository = LocalRoutineRepository(
        LocalStorageService(preferences),
      );

      await repository.saveProgress(const PlayerProgress(xp: 40, gold: 30));

      final reloaded = LocalRoutineRepository(LocalStorageService(preferences));
      final progress = await reloaded.loadProgress();

      expect(progress.xp, 40);
      expect(progress.gold, 30);
      expect(progress.level, 1);
      expect(preferences.getKeys(), contains('player_progress_v1'));
    });

    test('골드가 없던 기존 저장값은 경험치를 유지하고 골드는 0이다', () async {
      SharedPreferences.setMockInitialValues({
        'player_progress_v1': '{"xp": 120}',
      });
      final preferences = await SharedPreferences.getInstance();
      final repository = LocalRoutineRepository(
        LocalStorageService(preferences),
      );

      final progress = await repository.loadProgress();

      expect(progress.xp, 120);
      expect(progress.gold, 0);
      expect(progress.level, 2);
    });
  });
}
