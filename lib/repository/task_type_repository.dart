import 'package:imploop/domain/task_type.dart';
import 'package:imploop/repository/database_provider.dart';

class TaskTypeRepository {
   static String table = 'task_type';
   static DBProvider instance = DBProvider.instance;

   Future<TaskType> create(String name) async {
    final Map<String, String> row = {
      "name": name,
    };

    final db = await instance.database;
    final id = await db.insert(table, row);

    return TaskType(
      taskTypeId: id,
      name: name,
    );
  }

   Future<List<TaskType>?> getAll() async {
    final db = await instance.database;
    final rows = await db.rawQuery('SELECT * FROM $table');
    if (rows.isEmpty) return null;

    final List<TaskType> allTaskType = [];
    for (Map<String, dynamic> element in rows) {
      final TaskType taskType = TaskType.fromMap(element);
      allTaskType.add(taskType);
    }
    return allTaskType;
  }

  /// Tagを取得する
   Future<TaskType?> get(int taskTypeId) async {
    final db = await instance.database;
    final rows = await db
        .rawQuery('SELECT * FROM $table WHERE task_type_id = ?', [taskTypeId]);
    if (rows.isEmpty) return null;

    return TaskType.fromMap(rows.first);
  }
}
