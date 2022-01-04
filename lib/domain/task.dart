// ignore_for_file: constant_identifier_names

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:imploop/domain/status.dart';
part 'task.freezed.dart';

enum TaskArgument {
  task_id,
  name,
  status_id,
  task_type_id,
}

@freezed
abstract class Task implements _$Task {
  const Task._();
  const factory Task({
    required int taskId,
    required String name,
    required int statusId,
    required int taskTypeId,
  }) = _Task;

  factory Task.fromMap(Map<String, dynamic> task) {
    return Task(
      taskId: task[TaskArgument.task_id.name] as int,
      name: task[TaskArgument.name.name] as String,
      statusId: task[TaskArgument.status_id.name] as int,
      taskTypeId: task[TaskArgument.task_type_id.name] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      TaskArgument.task_id.name: taskId,
      TaskArgument.name.name: name,
      TaskArgument.status_id.name: statusId,
      TaskArgument.task_type_id.name: taskTypeId,
    };
  }

  bool isNotFinished() {
    return statusId != Status.getStatusNumber(StatusProcess.done);
  }
}
