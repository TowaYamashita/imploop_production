// ignore_for_file: constant_identifier_names

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:imploop/domain/status.dart';
part 'todo.freezed.dart';

enum TodoArgument {
  todo_id,
  task_id,
  name,
  status_id,
  todo_type_id,
  estimate,
  elapsed,
}

@freezed
abstract class Todo implements _$Todo {
  const Todo._();
  const factory Todo({
    required int todoId,
    required int taskId,
    required String name,
    required int statusId,
    required int todoTypeId,
    required int estimate,
    int? elapsed,
  }) = _Todo;

  factory Todo.fromMap(Map<String, dynamic> todo) {
    return Todo(
      todoId: todo[TodoArgument.todo_id.name] as int,
      taskId: todo[TodoArgument.task_id.name] as int,
      name: todo[TodoArgument.name.name] as String,
      statusId: todo[TodoArgument.status_id.name] as int,
      todoTypeId: todo[TodoArgument.todo_type_id.name] as int,
      estimate: todo[TodoArgument.estimate.name] as int,
      elapsed: todo[TodoArgument.elapsed.name] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      TodoArgument.todo_id.name: todoId,
      TodoArgument.task_id.name: taskId,
      TodoArgument.name.name: name,
      TodoArgument.status_id.name: statusId,
      TodoArgument.todo_type_id.name: todoTypeId,
      TodoArgument.estimate.name: estimate,
      TodoArgument.elapsed.name: elapsed,
    };
  }

  bool isNotFinished() {
    return statusId != Status.getStatusNumber(StatusProcess.done);
  }
}
