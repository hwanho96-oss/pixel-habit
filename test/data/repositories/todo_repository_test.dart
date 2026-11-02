import 'package:flutter_test/flutter_test.dart';
import 'package:pixel_habit/data/repositories/todo_repository.dart';
import 'package:pixel_habit/data/services/local_storage_service.dart';
import 'package:pixel_habit/domain/models/habit_stat.dart';
import 'package:pixel_habit/domain/models/todo.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('할 일은 루틴과 같은 저장소에 따로 남는다', () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final repository = LocalTodoRepository(LocalStorageService(preferences));

    await repository.saveTodos([
      Todo(
        id: 't1',
        title: '장보기',
        createdAt: DateTime(2026, 11, 2),
        date: DateTime(2026, 11, 3),
        stat: HabitStat.intelligence,
      ),
    ]);

    final reloaded = LocalTodoRepository(LocalStorageService(preferences));
    final todos = await reloaded.loadTodos();

    expect(todos, hasLength(1));
    expect(todos.single.title, '장보기');
    expect(todos.single.date, DateTime(2026, 11, 3));
    expect(todos.single.stat, HabitStat.intelligence);
    expect(preferences.getKeys(), contains(LocalTodoRepository.todosKey));
    expect(preferences.getKeys(), isNot(contains('routines_v1')));
  });

  test('시간 필드가 없는 예전 저장값도 읽는다', () async {
    SharedPreferences.setMockInitialValues({
      LocalTodoRepository.todosKey:
          '[{"id":"old","title":"장보기","createdAt":"2026-11-02T09:00:00.000"}]',
    });
    final preferences = await SharedPreferences.getInstance();
    final repository = LocalTodoRepository(LocalStorageService(preferences));

    final todos = await repository.loadTodos();

    expect(todos, hasLength(1));
    expect(todos.single.title, '장보기');
    expect(todos.single.date, isNull);
    expect(todos.single.hasTime, isFalse);
    expect(todos.single.completed, isFalse);
  });

  test('저장된 할 일이 없으면 빈 목록이다', () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final repository = LocalTodoRepository(LocalStorageService(preferences));

    expect(await repository.loadTodos(), isEmpty);
  });
}
