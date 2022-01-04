import 'package:imploop/domain/task_notice.dart';
import 'package:imploop/repository/database_provider.dart';

class TaskNoticeRepository {
  static String table = 'task_notice';
  static DBProvider instance = DBProvider.instance;

  /// TaskNoticeを新規追加する
  static Future<TaskNotice?> create(int taskId, String body) async {
    final Map<String, dynamic> row = {
      "task_id": taskId,
      "body": body,
    };

    final db = await instance.database;
    final id = await db.insert(table, row);

    return await get(id);
  }

  /// TaskNoticeを取得する   
  static Future<TaskNotice?> get(int taskNoticeId) async {
    final db = await instance.database;
    final rows = await db
        .rawQuery('SELECT * FROM $table WHERE task_notice_id = ?', [taskNoticeId]);
    if (rows.isEmpty) return null;

    return TaskNotice.fromMap(rows.first);
  }

  /// Taskに紐づくTaskNoticeを取得する   
  static Future<List<TaskNotice>?> getByTaskId(int taskId) async {
    final db = await instance.database;
    final rows = await db
        .rawQuery('SELECT * FROM $table WHERE task_id = ?', [taskId]);
    if (rows.isEmpty) return null;


    final List<TaskNotice> taskNoticeInTodo = [];
    for (var element in rows) {
      final TaskNotice taskNotice = TaskNotice.fromMap(element);
      taskNoticeInTodo.add(taskNotice);
    }
    return taskNoticeInTodo;
  }

  /// すべてのTaskNoticeを取得する
  static Future<List<TaskNotice>?> getAll() async {
    final db = await instance.database;
    final rows = await db.rawQuery('SELECT * FROM $table');
    if (rows.isEmpty) return null;

    final List<TaskNotice> taskNoticeList = [];
    for (var element in rows) {
      final TaskNotice todoNotice = TaskNotice.fromMap(element);
      taskNoticeList.add(todoNotice);
    }
    return taskNoticeList;
  }
}
