import 'dart:convert';

import 'package:pixel_habit/data/services/local_storage_service.dart';
import 'package:pixel_habit/domain/models/todo.dart';

abstract class TodoRepository {
  Future<List<Todo>> loadTodos();

  Future<void> saveTodos(List<Todo> todos);
}

/// 루틴과 같은 [LocalStorageService]에 할 일 목록만 따로 넣는다.
class LocalTodoRepository implements TodoRepository {
  LocalTodoRepository(this._storage);

  static const todosKey = 'todos_v1';

  final LocalStorageService _storage;

  @override
  Future<List<Todo>> loadTodos() async {
    final raw = _storage.readString(todosKey);
    if (raw == null || raw.isEmpty) {
      return const [];
    }
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((item) => Todo.fromJson(Map<String, Object?>.from(item as Map)))
        .toList();
  }

  @override
  Future<void> saveTodos(List<Todo> todos) {
    final payload = jsonEncode(todos.map((todo) => todo.toJson()).toList());
    return _storage.writeString(todosKey, payload);
  }
}
