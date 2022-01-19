import 'package:imploop/domain/todo_notice.dart';
import 'package:imploop/repository/database_provider.dart';

class TodoNoticeRepository {
  static String table = 'todo_notice';
  static DBProvider instance = DBProvider.instance;

  /// TodoNoticeを新規追加する
  Future<TodoNotice?> create(int todoId, String body) async {
    final Map<String, dynamic> row = {
      "todo_id": todoId,
      "body": body,
    };

    final db = await instance.database;
    final id = await db.insert(table, row);

    return await get(id);
  }

  /// TodoNoticeを取得する
  Future<TodoNotice?> get(int todoNoticeId) async {
    final db = await instance.database;
    final rows = await db.rawQuery(
        'SELECT * FROM $table WHERE todo_notice_id = ?', [todoNoticeId]);
    if (rows.isEmpty) return null;

    return TodoNotice.fromMap(rows.first);
  }

  /// Todoに紐づくTodoNoticeを取得する
  Future<List<TodoNotice>?> getByTodoId(int todoId) async {
    final db = await instance.database;
    final rows =
        await db.rawQuery('SELECT * FROM $table WHERE todo_id = ?', [todoId]);
    if (rows.isEmpty) return null;

    final List<TodoNotice> todoNoticeInTodo = [];
    for (var element in rows) {
      final TodoNotice todoNotice = TodoNotice.fromMap(element);
      todoNoticeInTodo.add(todoNotice);
    }
    return todoNoticeInTodo;
  }

  /// すべてのTodoNoticeを取得する
  Future<List<TodoNotice>?> getAll() async {
    final db = await instance.database;
    final rows = await db.rawQuery('SELECT * FROM $table');
    if (rows.isEmpty) return null;

    final List<TodoNotice> todoNoticeList = [];
    for (var element in rows) {
      final TodoNotice todoNotice = TodoNotice.fromMap(element);
      todoNoticeList.add(todoNotice);
    }
    return todoNoticeList;
  }
}
