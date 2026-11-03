import 'package:flutter_test/flutter_test.dart';
import 'package:pixel_habit/domain/models/habit_stat.dart';
import 'package:pixel_habit/domain/models/player_progress.dart';
import 'package:pixel_habit/domain/models/routine.dart';
import 'package:pixel_habit/domain/models/routine_checklist_item.dart';
import 'package:pixel_habit/ui/features/routine/view_models/routine_view_model.dart';

import '../../../support/in_memory_routine_repository.dart';

void main() {
  group('RoutineViewModel', () {
    late InMemoryRoutineRepository repository;
    late RoutineViewModel viewModel;

    final sample = Routine(
      id: 'r1',
      title: '아침 수련',
      xpReward: 15,
      avatarSeed: 0,
      createdAt: DateTime(2026, 1, 1),
    );

    setUp(() {
      repository = InMemoryRoutineRepository(
        routines: [sample],
        progress: const PlayerProgress(),
      );
      viewModel = RoutineViewModel(repository: repository);
    });

    test('load는 저장소의 루틴을 불러온다', () async {
      await viewModel.load();
      expect(viewModel.routines, hasLength(1));
      expect(viewModel.routines.first.title, '아침 수련');
    });

    test('toggleCompleted는 완료 처리하고 XP를 지급한다', () async {
      await viewModel.load();
      await viewModel.toggleCompleted('r1');

      expect(viewModel.routines.first.completedToday, isTrue);
      expect(viewModel.progress.xp, 15);
      expect(viewModel.lastGrantedXp, 15);
    });

    test('같은 루틴을 다시 끄면 XP가 회수된다', () async {
      await viewModel.load();
      await viewModel.toggleCompleted('r1');
      await viewModel.toggleCompleted('r1');

      expect(viewModel.routines.first.completedToday, isFalse);
      expect(viewModel.progress.xp, 0);
    });

    test('addRoutine은 제목이 있을 때만 추가한다', () async {
      await viewModel.load();
      await viewModel.addRoutine(title: '   ');
      expect(viewModel.routines, hasLength(1));

      await viewModel.addRoutine(title: '마법 공부', note: '30분');
      expect(viewModel.routines, hasLength(2));
      expect(viewModel.routines.last.title, '마법 공부');
    });

    test('addRoutine은 체크리스트·요일·태그를 저장한다', () async {
      await viewModel.load();
      final saved = await viewModel.addRoutine(
        title: '마트 가기',
        checklist: const [
          RoutineChecklistItem(id: 'c1', title: '당근 사기'),
          RoutineChecklistItem(id: 'c2', title: '오이 사기'),
        ],
        startDate: DateTime(2026, 11, 2),
        reminderHour: 7,
        reminderMinute: 30,
        repeatWeekdays: {DateTime.monday, DateTime.wednesday},
        tags: const ['life', 'health'],
      );

      expect(saved, isTrue);
      final routine = viewModel.routines.last;
      expect(routine.checklist, hasLength(2));
      expect(routine.checklist.first.title, '당근 사기');
      expect(routine.startDate, DateTime(2026, 11, 2));
      expect(routine.reminderHour, 7);
      expect(routine.reminderMinute, 30);
      expect(routine.repeatWeekdays, {DateTime.monday, DateTime.wednesday});
      expect(routine.tags, ['life', 'health']);
      expect(routine.stat, isNull);
    });

    test('addRoutine은 스탯 태그를 저장하고 없으면 null이다', () async {
      await viewModel.load();
      final saved = await viewModel.addRoutine(
        title: '마법 공부',
        stat: HabitStat.intelligence,
      );

      expect(saved, isTrue);
      expect(viewModel.routines.last.stat, HabitStat.intelligence);
    });

    test('deleteRoutine은 목록에서 제거한다', () async {
      await viewModel.load();
      await viewModel.deleteRoutine('r1');
      expect(viewModel.routines, isEmpty);
    });

    test('완료하면 고정 골드를 지급하고 같은 날 해제하면 회수한다', () async {
      await viewModel.load();
      await viewModel.toggleCompleted('r1');

      expect(viewModel.progress.gold, PlayerProgress.goldPerCompletion);
      expect(viewModel.lastGrantedGold, PlayerProgress.goldPerCompletion);
      expect(viewModel.progress.xp, sample.xpReward);

      await viewModel.toggleCompleted('r1');

      expect(viewModel.routines.first.completedToday, isFalse);
      expect(viewModel.progress.gold, 0);
      expect(viewModel.progress.xp, 0);
      expect(viewModel.lastGrantedGold, isNull);
      expect(viewModel.lastGrantedXp, isNull);

      final stored = await repository.loadProgress();
      expect(stored.gold, 0);
      expect(stored.xp, 0);
    });

    test('루틴마다 같은 골드를 받고 하나만 해제하면 그만큼만 돌아간다', () async {
      await viewModel.load();
      final added = await viewModel.addRoutine(title: '마법 공부', xpReward: 40);
      expect(added, isTrue);
      final secondId = viewModel.routines.last.id;

      await viewModel.toggleCompleted('r1');
      await viewModel.toggleCompleted(secondId);

      expect(viewModel.progress.gold, PlayerProgress.goldPerCompletion * 2);
      expect(viewModel.progress.xp, sample.xpReward + 40);
      expect(viewModel.lastGrantedGold, PlayerProgress.goldPerCompletion);

      await viewModel.toggleCompleted('r1');

      expect(viewModel.progress.gold, PlayerProgress.goldPerCompletion);
      expect(viewModel.progress.xp, 40);
      expect(viewModel.lastGrantedGold, isNull);

      final stored = await repository.loadProgress();
      expect(stored.gold, PlayerProgress.goldPerCompletion);
      expect(stored.xp, 40);
    });

    test('체크를 반복해도 골드를 늘릴 수 없다', () async {
      await viewModel.load();
      for (var i = 0; i < 3; i++) {
        await viewModel.toggleCompleted('r1');
        await viewModel.toggleCompleted('r1');
      }

      expect(viewModel.progress.gold, 0);
      expect(viewModel.progress.xp, 0);
    });

    test('상점 결제는 한 번만 빠지고 모자라면 거절한다', () async {
      final wallet = InMemoryRoutineRepository(
        routines: [sample],
        progress: const PlayerProgress(gold: 40),
      );
      final buyer = RoutineViewModel(repository: wallet);
      await buyer.load();

      final first = buyer.spendGold(30);
      final second = buyer.spendGold(30);

      expect(await first, isTrue);
      expect(await second, isFalse);
      expect(buyer.progress.gold, 10);
      expect(buyer.progress.xp, 0);
      expect((await wallet.loadProgress()).gold, 10);
    });

    test('보유 골드보다 많이 회수해도 0 아래로 내려가지 않는다', () async {
      final completed = Routine(
        id: 'r1',
        title: '아침 수련',
        xpReward: 15,
        avatarSeed: 0,
        createdAt: DateTime(2026, 1, 1),
        completedToday: true,
        lastCompletedAt: DateTime.now(),
      );
      repository = InMemoryRoutineRepository(
        routines: [completed],
        progress: const PlayerProgress(xp: 4, gold: 3),
      );
      viewModel = RoutineViewModel(repository: repository);

      await viewModel.load();
      await viewModel.toggleCompleted('r1');

      expect(viewModel.routines.first.completedToday, isFalse);
      expect(viewModel.progress.gold, 0);
      expect(viewModel.progress.xp, 0);
      expect(viewModel.lastGrantedGold, isNull);
    });

    test('날짜가 바뀌어 완료 표시가 풀려도 이미 받은 골드는 유지된다', () async {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      repository = InMemoryRoutineRepository(
        routines: [
          Routine(
            id: 'r1',
            title: '아침 수련',
            xpReward: 15,
            avatarSeed: 0,
            createdAt: DateTime(2026, 1, 1),
            completedToday: true,
            lastCompletedAt: yesterday,
          ),
        ],
        progress: const PlayerProgress(
          xp: 15,
          gold: PlayerProgress.goldPerCompletion,
        ),
      );
      viewModel = RoutineViewModel(repository: repository);

      await viewModel.load();

      expect(viewModel.routines.first.completedToday, isFalse);
      expect(viewModel.progress.gold, PlayerProgress.goldPerCompletion);
      expect(viewModel.progress.xp, 15);
      expect(viewModel.progress.level, 1);
    });
  });
}
