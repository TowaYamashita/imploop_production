import 'package:imploop/domain/task.dart';
import 'package:imploop/repository/database_provider.dart';

/// Taskの永続化処理を行う
class TaskRepository {
  static String table = 'task';
  static DBProvider instance = DBProvider.instance;

  /// Taskを新規追加する
  static Future<Task> create(String name, int taskTypeId) async {
    final Map<String, dynamic> row = {
      "name": name,
      "task_type_id": taskTypeId,
    };

    final db = await instance.database;
    final id = await db.insert(table, row);

    return Task(
      taskId: id,
      name: name,
      statusId: 1,
      taskTypeId: taskTypeId,
    );
  }

  /// 引数をtask_idに持つTaskを取得する
  static Future<Task?> get(int taskId) async {
    final db = await instance.database;
    final rows =
        await db.rawQuery('SELECT * FROM $table WHERE task_id = ?', [taskId]);
    if (rows.isEmpty) return null;

    return Task.fromMap(rows.first);
  }

  /// DBに保存されているTaskをすべて取得する
  static Future<List<Task>?> getAll() async {
    final db = await instance.database;
    final rows = await db.rawQuery('SELECT * FROM $table');
    if (rows.isEmpty) return null;

    final List<Task> allTask = [];
    for (Map<String, dynamic> element in rows) {
      final Task task = Task.fromMap(element);
      allTask.add(task);
    }
    return allTask;
  }

  /// Taskの名前を更新する
  ///
  /// 更新に成功したらtrue、そうでなければfalseが返ってくる
  static Future<bool> update(Task updatedTask) async {
    final db = await instance.database;
    final int affectedRowCount = await db.update(
      table,
      updatedTask.toMap(),
      where: "task_id=?",
      whereArgs: [updatedTask.taskId],
    );

    return affectedRowCount > 0 ? true : false;
  }

  /// Taskを削除する
  ///
  /// 削除に成功したらtrue、そうでなければfalseが返ってくる
  static Future<bool> delete(Task deletedTask) async {
    final db = await instance.database;
    final int affectedRowCount = await db.delete(
      table,
      where: "task_id=?",
      whereArgs: [deletedTask.taskId],
    );

    return affectedRowCount > 0 ? true : false;
  }
}
