// ignore_for_file: constant_identifier_names

enum TaskTypeArgument {
  task_type_id,
  name,
}

class TaskType {
  const TaskType({
    required this.taskTypeId,
    required this.name,
  });

  factory TaskType.fromMap(Map<String, dynamic> tag) {
    return TaskType(
      taskTypeId: tag[TaskTypeArgument.task_type_id.name] as int,
      name: tag[TaskTypeArgument.name.name] as String,
    );
  }

  final int taskTypeId;
  final String name;
}
