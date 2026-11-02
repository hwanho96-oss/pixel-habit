import 'package:pixel_habit/data/repositories/todo_repository.dart';
import 'package:pixel_habit/domain/models/todo.dart';

class InMemoryTodoRepository implements TodoRepository {
  InMemoryTodoRepository({List<Todo>? todos})
    : _todos = List.of(todos ?? const []);

  List<Todo> _todos;

  @override
  Future<List<Todo>> loadTodos() async => List.of(_todos);

  @override
  Future<void> saveTodos(List<Todo> todos) async {
    _todos = List.of(todos);
  }
}
