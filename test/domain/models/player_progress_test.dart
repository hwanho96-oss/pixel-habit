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
    });

    test('음수 골드는 0으로 읽는다', () {
      final decoded = PlayerProgress.fromJson({'xp': 1, 'gold': -5});

      expect(decoded.xp, 1);
      expect(decoded.gold, 0);
    });
  });
}
