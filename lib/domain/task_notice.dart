// ignore_for_file: constant_identifier_names

enum TaskNoticeArgument {
  task_notice_id,
  task_id,
  body,
}

class TaskNotice {
  TaskNotice({
    required this.taskNoticeId,
    required this.taskId,
    required this.body,
  });

  factory TaskNotice.fromMap(Map<String, dynamic> taskNotice) {
    return TaskNotice(
      taskNoticeId: taskNotice[TaskNoticeArgument.task_notice_id.name] as int,
      taskId: taskNotice[TaskNoticeArgument.task_id.name] as int,
      body: taskNotice[TaskNoticeArgument.body.name] as String,
    );
  }

  final int taskNoticeId;
  final int taskId;
  final String body;
}
