// ignore_for_file: constant_identifier_names

enum TodoNoticeArgument {
  todo_notice_id,
  todo_id,
  body,
}

class TodoNotice {
  TodoNotice({
    required this.todoNoticeId,
    required this.todoId,
    required this.body,
  });

  factory TodoNotice.fromMap(Map<String, dynamic> todoNotice) {
    return TodoNotice(
      todoNoticeId: todoNotice[TodoNoticeArgument.todo_notice_id.name] as int,
      todoId: todoNotice[TodoNoticeArgument.todo_id.name] as int,
      body: todoNotice[TodoNoticeArgument.body.name] as String,
    );
  }

  final int todoNoticeId;
  final int todoId;
  final String body;
}
