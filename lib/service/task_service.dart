import 'package:imploop/domain/status.dart';
import 'package:imploop/domain/task.dart';
import 'package:imploop/domain/task_type.dart';
import 'package:imploop/domain/todo.dart';
import 'package:imploop/repository/task_repository.dart';
import 'package:imploop/repository/todo_repository.dart';
import 'package:imploop/service/task_type_service.dart';

class TaskService {
  static Future<Task?> registerNewTask(String name, TaskType? taskType) async {
    if (taskType == null) {
      return null;
    }

    late final TaskType registeredTaskType;
    if (taskType.taskTypeId == -1) {
      // TODO: TaskTypeServiceはProvider経由で触るようなクラスだが、やっつけで使う度にnewしている（設計変更のタイミングで一緒に治す）
      final tmp = await TaskTypeService().add(taskType.name);
      if (tmp == null) {
        return null;
      }
      registeredTaskType = tmp;
    } else {
      registeredTaskType = taskType;
    }

    return await TaskRepository.create(name, registeredTaskType.taskTypeId);
  }

  static Future<List<Task>> getAllTask() async {
    return await TaskRepository.getAll() ?? [];
  }

  static Future<List<Task>> getAllTaskWithoutFinished() async {
    final List<Task> result = [];
    final List<Task>? taskList = await TaskRepository.getAll();
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

  static Future<Task?> get(int taskId) async {
    return await TaskRepository.get(taskId);
  }

  static Future<List<Todo>> getAllTodoInTask(int taskId) async {
    return await TodoRepository.getByTaskId(taskId) ?? [];
  }

  /// 引数のtaskIdを持つ完了状態ではないTodoの一覧を取得する
  static Future<List<Todo>> getAllTodoWithoutFinishedInTask(int taskId) async {
    final List<Todo> result = [];
    final List<Todo>? todoList = await TodoRepository.getByTaskId(taskId);
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

  static Future<bool> editTask(Task updatedTask) async {
    if (await TaskTypeService().existsTaskType(updatedTask.taskTypeId)) {
      return await TaskRepository.update(updatedTask);
    }
    return false;
  }

  static Future<bool> deleteTask(Task deletedTask) async {
    return await TaskRepository.delete(deletedTask);
  }

  /// 引数のTaskに完了状態ではないTodoがあるかどうか判定する
  ///
  /// 完了状態ではないTodoが1つでもあればtrue、そうでなければfalseを返す
  static Future<bool> containsNonFinishedTodo(int taskId) async {
    return (await getAllTodoWithoutFinishedInTask(taskId)).isNotEmpty;
  }

  static Future<bool> existsTask(Task task) async {
    return await TaskRepository.get(task.taskId) != null;
  }

  static Future<bool> finishTask(Task finishedTask) async {
    return await TaskRepository.update(
      finishedTask.copyWith(
        statusId: Status.getStatusNumber(StatusProcess.done),
      ),
    );
  }

  static Future<Map<String, int>> getTodoStatusList(Task task) async {
    final todoList = await TodoRepository.getByTaskId(task.taskId);
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
