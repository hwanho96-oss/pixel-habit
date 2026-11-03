import 'package:flutter_test/flutter_test.dart';
import 'package:pixel_habit/domain/models/player_progress.dart';

void main() {
  group('PlayerProgress', () {
    test('완료 보상은 루틴 XP와 고정 골드를 더한다', () {
      expect(PlayerProgress.goldPerCompletion, 10);

      const progress = PlayerProgress(xp: 90, gold: 5);
      final next = progress.grantCompletionReward(xpReward: 15);

      expect(progress.xp, 90);
      expect(progress.gold, 5);
      expect(next.xp, 105);
      expect(next.gold, 15);
      expect(next.level, 2);
      expect(next.xpIntoLevel, 5);
    });

    test('보상 회수는 XP와 골드를 0에서 멈춘다', () {
      const progress = PlayerProgress(xp: 4, gold: 3);
      final next = progress.revokeCompletionReward(xpReward: 15);

      expect(next.xp, 0);
      expect(next.gold, 0);
    });

    test('골드가 충분하면 고정 금액만 회수한다', () {
      const progress = PlayerProgress(xp: 40, gold: 25);
      final next = progress.revokeCompletionReward(xpReward: 15);

      expect(next.xp, 25);
      expect(next.gold, 15);
      expect(next.level, 1);
    });

    test('XP 회수 상한은 기존 clamp와 같다', () {
      final progress = PlayerProgress(xp: (1 << 30) + 50, gold: 10);
      final next = progress.revokeCompletionReward(xpReward: 10);

      expect(next.xp, 1 << 30);
      expect(next.gold, 0);
    });

    test('copyWith는 바꾸지 않은 스탯을 유지한다', () {
      const progress = PlayerProgress(xp: 3, gold: 7);

      expect(progress.copyWith(xp: 9).gold, 7);
      expect(progress.copyWith(gold: 1).xp, 3);
    });

    test('toJson과 fromJson은 골드와 XP를 함께 보존한다', () {
      const progress = PlayerProgress(xp: 12, gold: 40);
      final decoded = PlayerProgress.fromJson(progress.toJson());

      expect(decoded.xp, 12);
      expect(decoded.gold, 40);
      expect(decoded.level, progress.level);
    });

    test('골드 필드가 없는 저장값은 0으로 읽는다', () {
      final decoded = PlayerProgress.fromJson({'xp': 120});

      expect(decoded.xp, 120);
      expect(decoded.gold, 0);
      expect(decoded.level, 2);
      expect(decoded.xpIntoLevel, 20);
      expect(decoded.lastCompletionDate, isNull);
    });

    test('완료한 날을 저장하고 어제를 쉬었는지 구분한다', () {
      const progress = PlayerProgress(xp: 10, gold: 10);
      final done = progress.grantCompletionReward(
        xpReward: 10,
        completedOn: DateTime(2026, 10, 30, 22),
      );

      expect(done.lastCompletionDate, DateTime(2026, 10, 30));
      expect(done.skippedYesterday(now: DateTime(2026, 10, 31)), isFalse);
      expect(done.skippedYesterday(now: DateTime(2026, 11, 2)), isTrue);
      expect(const PlayerProgress().skippedYesterday(), isFalse);

      final revoked = done.revokeCompletionReward(xpReward: 10);
      expect(revoked.gold, 10);
      expect(revoked.lastCompletionDate, DateTime(2026, 10, 30));

      final restored = PlayerProgress.fromJson(done.toJson());
      expect(restored.lastCompletionDate, DateTime(2026, 10, 30));
      expect(
        PlayerProgress.fromJson({'xp': 1, 'lastCompletionDate': 'not-a-day'})
            .lastCompletionDate,
        isNull,
      );
    });

    test('골드가 충분할 때만 차감한다', () {
      const progress = PlayerProgress(xp: 4, gold: 30);

      expect(progress.trySpendGold(30)!.gold, 0);
      expect(progress.trySpendGold(30)!.xp, 4);
      expect(progress.trySpendGold(31), isNull);
      expect(progress.trySpendGold(-1), isNull);
      expect(progress.trySpendGold(0), same(progress));
      expect(progress.gold, 30);
    });

    test('음수 골드는 0으로 읽는다', () {
      final decoded = PlayerProgress.fromJson({'xp': 1, 'gold': -5});

      expect(decoded.xp, 1);
      expect(decoded.gold, 0);
    });
  });
}
