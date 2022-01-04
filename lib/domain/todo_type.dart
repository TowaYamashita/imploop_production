// ignore_for_file: constant_identifier_names

enum TodoTypeArgument {
  todo_type_id,
  name,
}

class TodoType {
  const TodoType({
    required this.todoTypeId,
    required this.name,
  });

  factory TodoType.fromMap(Map<String, dynamic> tag) {
    return TodoType(
      todoTypeId: tag[TodoTypeArgument.todo_type_id.name] as int,
      name: tag[TodoTypeArgument.name.name] as String,
    );
  }

  final int todoTypeId;
  final String name;
}
