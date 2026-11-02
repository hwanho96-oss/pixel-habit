import 'package:flutter/foundation.dart';
import 'package:pixel_habit/data/repositories/todo_repository.dart';
import 'package:pixel_habit/domain/models/habit_stat.dart';
import 'package:pixel_habit/domain/models/todo.dart';
import 'package:pixel_habit/ui/features/routine/view_models/routine_view_model.dart';
import 'package:uuid/uuid.dart';

class TodoViewModel extends ChangeNotifier {
  TodoViewModel({
    required this._repository,
    required this._rewards,
    Uuid? uuid,
  }) : _uuid = uuid ?? const Uuid();

  final TodoRepository _repository;
  final RoutineViewModel _rewards;
  final Uuid _uuid;

  List<Todo> _todos = const [];
  bool _isLoading = false;
  String? _errorMessage;

  /// 아직 하지 않은 할 일이 위, 완료한 할 일이 아래다.
  List<Todo> get todos {
    final open = <Todo>[];
    final done = <Todo>[];
    for (final todo in _todos) {
      if (todo.completed) {
        done.add(todo);
      } else {
        open.add(todo);
      }
    }
    return List.unmodifiable([...open, ...done]);
  }

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int? get lastGrantedXp => _rewards.lastGrantedXp;
  int? get lastGrantedGold => _rewards.lastGrantedGold;

  Future<void> load() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _todos = await _repository.loadTodos();
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addTodo({
    required String title,
    DateTime? date,
    HabitStat? stat,
  }) async {
    final trimmed = title.trim();
    if (trimmed.isEmpty) {
      return false;
    }

    final todo = Todo(
      id: _uuid.v4(),
      title: trimmed,
      createdAt: DateTime.now(),
      date: Todo.dateOnly(date),
      stat: stat,
    );

    final previous = _todos;
    _todos = [..._todos, todo];
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.saveTodos(_todos);
      return true;
    } catch (error) {
      _todos = previous;
      _errorMessage = error.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> toggleCompleted(String id) async {
    final index = _todos.indexWhere((todo) => todo.id == id);
    if (index == -1) {
      return;
    }

    final todo = _todos[index];
    final willComplete = !todo.completed;
    _todos = [..._todos]..[index] = todo.copyWith(completed: willComplete);
    notifyListeners();
    await _repository.saveTodos(_todos);
    await _rewards.applyCompletionReward(
      completed: willComplete,
      xpReward: todo.xpReward,
    );
  }

  Future<void> deleteTodo(String id) async {
    _todos = _todos.where((todo) => todo.id != id).toList();
    notifyListeners();
    await _repository.saveTodos(_todos);
  }
}
