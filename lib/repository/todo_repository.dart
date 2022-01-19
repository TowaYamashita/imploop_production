import 'package:imploop/domain/todo.dart';
import 'package:imploop/repository/database_provider.dart';

/// Todoの永続化処理を行う
class TodoRepository {
  static String table = 'todo';
  static DBProvider instance = DBProvider.instance;

  /// Todoを新規追加する
  Future<Todo> create({
    required int taskId,
    required String name,
    required int estimate,
    required int todoTypeId,
    int? elapsed,
  }) async {
    final Map<String, dynamic> row = {
      "task_id": taskId,
      "name": name,
      "estimate": estimate,
      "elapsed": elapsed,
      "todo_type_id": todoTypeId,
    };

    final db = await instance.database;
    final id = await db.insert(table, row);

    return Todo(
      todoId: id,
      taskId: row["task_id"] as int,
      name: row["name"] as String,
      statusId: 1,
      todoTypeId: row["todo_type_id"] as int,
      estimate: row["estimate"] as int,
      elapsed: row["elapsed"] as int?,
    );
  }

  /// 引数をtodo_idに持つtodoを取得する
  Future<Todo?> get(int todoId) async {
    final db = await instance.database;
    final rows =
        await db.rawQuery('SELECT * FROM $table WHERE todo_id = ?', [todoId]);
    if (rows.isEmpty) return null;

    return Todo.fromMap(rows.first);
  }

  /// 引数をtask_idに持つtodoを取得する
  Future<List<Todo>?> getByTaskId(int taskId) async {
    final db = await instance.database;
    final rows =
        await db.rawQuery('SELECT * FROM $table WHERE task_id = ?', [taskId]);
    if (rows.isEmpty) return null;

    final List<Todo> todosInTask = [];
    for (var element in rows) {
      final Todo todoInTask = Todo.fromMap(element);
      todosInTask.add(todoInTask);
    }
    return todosInTask;
  }

  /// 引数をtodo_type_idに持つtodoを取得する
  Future<List<Todo>?> getByTodoTypeId(int todoTypeId) async {
    final db = await instance.database;
    final rows = await db
        .rawQuery('SELECT * FROM $table WHERE todo_type_id = ?', [todoTypeId]);
    if (rows.isEmpty) return null;

    final List<Todo> todoList = [];
    for (var element in rows) {
      final Todo todo = Todo.fromMap(element);
      todoList.add(todo);
    }
    return todoList;
  }

  /// Todoを更新する
  ///
  /// 更新に成功したらtrue、そうでなければfalseが返ってくる
  Future<bool> update(Todo updatedTodo) async {
    final db = await instance.database;
    final int affectedRowCount = await db.update(
      table,
      updatedTodo.toMap(),
      where: "todo_id=?",
      whereArgs: [updatedTodo.todoId],
    );

    return affectedRowCount > 0 ? true : false;
  }

  /// Todoを削除する
  ///
  /// 削除に成功したらtrue、そうでなければfalseが返ってくる
  Future<bool> delete(Todo deletedTodo) async {
    final db = await instance.database;
    final int affectedRowCount = await db.delete(
      table,
      where: "todo_id=?",
      whereArgs: [deletedTodo.todoId],
    );

    return affectedRowCount > 0 ? true : false;
  }
}
