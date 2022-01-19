import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imploop/domain/status.dart';
import 'package:imploop/domain/task.dart';
import 'package:imploop/domain/task_type.dart';
import 'package:imploop/domain/todo.dart';
import 'package:imploop/repository/task_repository.dart';
import 'package:imploop/service/task_type_service.dart';
import 'package:imploop/service/todo_service.dart';

final taskServiceProvider = StateProvider(
  (ref) => TaskService(
    ref.read,
    TaskRepository(),
  ),
);

class TaskService {
  final Reader read;
  final TaskRepository repository;

  TaskService(
    this.read,
    this.repository,
  );

  Future<Task?> registerNewTask(String name, TaskType? taskType) async {
    if (taskType == null) {
      return null;
    }

    late final TaskType registeredTaskType;
    if (taskType.taskTypeId == -1) {
      final tmp = await read(taskTypeServiceProvider).add(taskType.name);
      if (tmp == null) {
        return null;
      }
      registeredTaskType = tmp;
    } else {
      registeredTaskType = taskType;
    }

    return await repository.create(name, registeredTaskType.taskTypeId);
  }

  Future<List<Task>> getAllTask() async {
    return await repository.getAll() ?? [];
  }

  Future<List<Task>> getAllTaskWithoutFinished() async {
    final List<Task> result = [];
    final List<Task>? taskList = await repository.getAll();
    if (taskList == null) {
      return [];
    }

    for (Task task in taskList) {
      if (await containsNonFinishedTodo(task.taskId)) {
        result.add(task);
      }
    }
    return result;
  }

  Future<Task?> get(int taskId) async {
    return await repository.get(taskId);
  }

  Future<List<Todo>> getAllTodoInTask(int taskId) async {
    return await read(todoServiceProvider).getByTaskId(taskId) ?? [];
  }

  /// 引数のtaskIdを持つ完了状態ではないTodoの一覧を取得する
  Future<List<Todo>> getAllTodoWithoutFinishedInTask(int taskId) async {
    final List<Todo> result = [];
    final List<Todo>? todoList =
        await read(todoServiceProvider).getByTaskId(taskId);
    if (todoList == null) {
      return [];
    }

    for (Todo todo in todoList) {
      if (todo.isNotFinished()) {
        result.add(todo);
      }
    }
    return result;
  }

  Future<bool> editTask(Task updatedTask) async {
    if (await read(taskTypeServiceProvider)
        .existsTaskType(updatedTask.taskTypeId)) {
      return await repository.update(updatedTask);
    }
    return false;
  }

  Future<bool> deleteTask(Task deletedTask) async {
    return await repository.delete(deletedTask);
  }

  /// 引数のTaskに完了状態ではないTodoがあるかどうか判定する
  ///
  /// 完了状態ではないTodoが1つでもあればtrue、そうでなければfalseを返す
  Future<bool> containsNonFinishedTodo(int taskId) async {
    return (await getAllTodoWithoutFinishedInTask(taskId)).isNotEmpty;
  }

  Future<bool> existsTask(Task task) async {
    return await repository.get(task.taskId) != null;
  }

  Future<bool> finishTask(Task finishedTask) async {
    return await repository.update(
      finishedTask.copyWith(
        statusId: Status.getStatusNumber(StatusProcess.done),
      ),
    );
  }

  Future<Map<String, int>> getTodoStatusList(Task task) async {
    final todoList = await read(todoServiceProvider).getByTaskId(task.taskId);
    if (todoList == null) {
      return {};
    }
    int countTodo = 0;
    int countDoing = 0;
    int countDone = 0;
    for (var todo in todoList) {
      switch (todo.statusId) {
        case 1:
          countTodo++;
          break;
        case 2:
          countDoing++;
          break;
        case 3:
          countDone++;
          break;
      }
    }
    return {
      "todo": countTodo,
      "doing": countDoing,
      "done": countDone,
    };
  }
}
