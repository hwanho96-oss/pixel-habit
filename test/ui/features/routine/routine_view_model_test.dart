import 'package:flutter_test/flutter_test.dart';
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
    });

    test('deleteRoutine은 목록에서 제거한다', () async {
      await viewModel.load();
      await viewModel.deleteRoutine('r1');
      expect(viewModel.routines, isEmpty);
    });
  });
}
