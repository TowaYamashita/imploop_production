import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imploop/domain/status.dart';
import 'package:imploop/domain/task.dart';
import 'package:imploop/domain/todo.dart';
import 'package:imploop/domain/todo_type.dart';
import 'package:imploop/repository/todo_repository.dart';
import 'package:imploop/service/todo_type_service.dart';

final todoServiceProvider = StateProvider(
  (ref) => TodoService(
    ref.read,
    TodoRepository(),
  ),
);

class TodoService {
  final Reader read;
  final TodoRepository repository;

  TodoService(this.read, this.repository);

  Future<Todo?> registerNewTodo(
    Task task,
    String name,
    int estimate,
    TodoType? todoType,
  ) async {
    if (todoType == null) {
      return null;
    }

    late final TodoType registeredTodoType;
    if (todoType.todoTypeId == -1) {
      final tmp = await read(todoTypeServiceProvider).add(todoType.name);
      if (tmp == null) {
        return null;
      }
      registeredTodoType = tmp;
    } else {
      registeredTodoType = todoType;
    }

    return await repository.create(
      taskId: task.taskId,
      name: name,
      estimate: estimate,
      todoTypeId: registeredTodoType.todoTypeId,
    );
  }

  Future<bool> editTodo(Todo updatedTodo) async {
    if (await read(todoTypeServiceProvider)
        .existsTodoType(updatedTodo.todoTypeId)) {
      return await repository.update(updatedTodo);
    }
    return false;
  }

  Future<bool> deleteTodo(Todo deletedTodo) async {
    return await repository.delete(deletedTodo);
  }

  Future<bool> finishTodo(Todo finishedTodo, int elapsed) async {
    return await repository.update(
      finishedTodo.copyWith(
        elapsed: elapsed,
        statusId: Status.getStatusNumber(StatusProcess.done),
      ),
    );
  }

  Future<bool> existsTodo(Todo todo) async {
    return await repository.get(todo.todoId) != null;
  }

  Future<Todo?> getTodo(int todoId) async {
    return await repository.get(todoId);
  }

  Future<List<Todo>?> getTodoByTodoType(int todoTypeId) async {
    return await repository.getByTodoTypeId(todoTypeId);
  }

  Future<List<Todo>?> getByTaskId(int taskId) async {
    return await repository.getByTaskId(taskId);
  }
}
