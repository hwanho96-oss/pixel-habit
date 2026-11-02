import 'package:flutter_test/flutter_test.dart';
import 'package:pixel_habit/domain/models/habit_stat.dart';
import 'package:pixel_habit/domain/models/player_progress.dart';
import 'package:pixel_habit/domain/models/routine.dart';
import 'package:pixel_habit/domain/models/todo.dart';
import 'package:pixel_habit/ui/features/routine/view_models/routine_view_model.dart';
import 'package:pixel_habit/ui/features/todo/view_models/todo_view_model.dart';

import '../../../support/in_memory_routine_repository.dart';
import '../../../support/in_memory_todo_repository.dart';

void main() {
  group('TodoViewModel', () {
    late InMemoryRoutineRepository routines;
    late InMemoryTodoRepository repository;
    late RoutineViewModel rewards;
    late TodoViewModel viewModel;

    setUp(() async {
      routines = InMemoryRoutineRepository(
        routines: [
          Routine(
            id: 'r1',
            title: '아침 수련',
            xpReward: 15,
            avatarSeed: 0,
            createdAt: DateTime(2026, 1, 1),
          ),
        ],
      );
      rewards = RoutineViewModel(repository: routines);
      await rewards.load();
      repository = InMemoryTodoRepository();
      viewModel = TodoViewModel(repository: repository, rewards: rewards);
      await viewModel.load();
    });

    test('이름이 없으면 추가하지 않는다', () async {
      final saved = await viewModel.addTodo(title: '   ');

      expect(saved, isFalse);
      expect(viewModel.todos, isEmpty);
    });

    test('날짜와 스탯을 저장하고 완료한 항목은 아래로 보낸다', () async {
      await viewModel.addTodo(title: '장보기', stat: HabitStat.strength);
      await viewModel.addTodo(
        title: '편지 쓰기',
        date: DateTime(2026, 11, 4, 18),
        stat: HabitStat.wisdom,
      );

      final firstId = viewModel.todos.first.id;
      await viewModel.toggleCompleted(firstId);

      expect(viewModel.todos.map((todo) => todo.title), ['편지 쓰기', '장보기']);
      expect(viewModel.todos.first.date, DateTime(2026, 11, 4));
      expect(viewModel.todos.first.stat, HabitStat.wisdom);
      expect(viewModel.todos.last.completed, isTrue);

      await viewModel.toggleCompleted(firstId);
      expect(viewModel.todos.map((todo) => todo.title), ['장보기', '편지 쓰기']);
    });

    test('완료하면 루틴과 같은 골드와 경험치를 주고 해제하면 거둔다', () async {
      await viewModel.addTodo(title: '장보기');
      final id = viewModel.todos.single.id;

      await viewModel.toggleCompleted(id);

      expect(viewModel.todos.single.completed, isTrue);
      expect(rewards.progress.gold, PlayerProgress.goldPerCompletion);
      expect(rewards.progress.xp, Todo.defaultXpReward);
      expect(viewModel.lastGrantedGold, PlayerProgress.goldPerCompletion);
      expect(viewModel.lastGrantedXp, Todo.defaultXpReward);

      await viewModel.toggleCompleted(id);

      expect(viewModel.todos.single.completed, isFalse);
      expect(rewards.progress.gold, 0);
      expect(rewards.progress.xp, 0);
      expect(viewModel.lastGrantedGold, isNull);
      expect(viewModel.lastGrantedXp, isNull);
    });

    test('루틴 보상과 할 일 보상은 한 곳에 쌓인다', () async {
      await viewModel.addTodo(title: '장보기');
      await rewards.toggleCompleted('r1');
      await viewModel.toggleCompleted(viewModel.todos.single.id);

      expect(rewards.progress.gold, PlayerProgress.goldPerCompletion * 2);
      expect(rewards.progress.xp, 15 + Todo.defaultXpReward);
    });

    test('보유 골드보다 많이 거두어도 0 아래로 내려가지 않는다', () async {
      routines = InMemoryRoutineRepository(
        progress: const PlayerProgress(xp: 4, gold: 3),
      );
      rewards = RoutineViewModel(repository: routines);
      await rewards.load();
      repository = InMemoryTodoRepository(
        todos: [
          Todo(
            id: 't1',
            title: '장보기',
            createdAt: DateTime(2026, 11, 1),
            completed: true,
            xpReward: Todo.defaultXpReward,
          ),
        ],
      );
      viewModel = TodoViewModel(repository: repository, rewards: rewards);
      await viewModel.load();

      await viewModel.toggleCompleted('t1');

      expect(viewModel.todos.single.completed, isFalse);
      expect(rewards.progress.gold, 0);
      expect(rewards.progress.xp, 0);
    });

    test('삭제해도 목록에서만 빠지고 이미 받은 골드는 그대로다', () async {
      await viewModel.addTodo(title: '장보기');
      final id = viewModel.todos.single.id;
      await viewModel.toggleCompleted(id);
      await viewModel.deleteTodo(id);

      expect(viewModel.todos, isEmpty);
      expect(rewards.progress.gold, PlayerProgress.goldPerCompletion);
      final stored = await repository.loadTodos();
      expect(stored, isEmpty);
    });
  });
}
