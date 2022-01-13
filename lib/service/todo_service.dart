import 'package:imploop/domain/status.dart';
import 'package:imploop/domain/task.dart';
import 'package:imploop/domain/todo.dart';
import 'package:imploop/domain/todo_type.dart';
import 'package:imploop/repository/todo_repository.dart';
import 'package:imploop/service/todo_type_service.dart';

class TodoService {
  static Future<Todo?> registerNewTodo(
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
      final tmp = await TodoTypeService().add(todoType.name);
      if (tmp == null) {
        return null;
      }
      registeredTodoType = tmp;
    } else {
      registeredTodoType = todoType;
    }

    return await TodoRepository.create(
      taskId: task.taskId,
      name: name,
      estimate: estimate,
      todoTypeId: registeredTodoType.todoTypeId,
    );
  }

  static Future<bool> editTodo(Todo updatedTodo) async {
    if (await TodoTypeService().existsTodoType(updatedTodo.todoTypeId)) {
      return await TodoRepository.update(updatedTodo);
    }
    return false;
  }

  static Future<bool> deleteTodo(Todo deletedTodo) async {
    return await TodoRepository.delete(deletedTodo);
  }

  static Future<bool> finishTodo(Todo finishedTodo, int elapsed) async {
    return await TodoRepository.update(
      finishedTodo.copyWith(
        elapsed: elapsed,
        statusId: Status.getStatusNumber(StatusProcess.done),
      ),
    );
  }

  static Future<bool> existsTodo(Todo todo) async {
    return await TodoRepository.get(todo.todoId) != null;
  }

  static Future<Todo?> getTodo(int todoId) async {
    return await TodoRepository.get(todoId);
  }

  static Future<List<Todo>?> getTodoByTodoType(int todoTypeId) async {
    return await TodoRepository.getByTodoTypeId(todoTypeId);
  }
}
