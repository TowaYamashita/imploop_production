import 'package:imploop/domain/todo_type.dart';
import 'package:imploop/repository/database_provider.dart';

class TodoTypeRepository {
  static String table = 'todo_type';
  static DBProvider instance = DBProvider.instance;

  Future<TodoType> create(String name) async {
    final Map<String, String> row = {
      "name": name,
    };

    final db = await instance.database;
    final id = await db.insert(table, row);

    return TodoType(
      todoTypeId: id,
      name: name,
    );
  }

  Future<List<TodoType>?> getAll() async {
    final db = await instance.database;
    final rows = await db.rawQuery('SELECT * FROM $table');
    if (rows.isEmpty) return null;

    final List<TodoType> allType = [];
    for (Map<String, dynamic> element in rows) {
      final TodoType todoType = TodoType.fromMap(element);
      allType.add(todoType);
    }
    return allType;
  }

  /// Tagを取得する
  Future<TodoType?> get(int todoTypeId) async {
    final db = await instance.database;
    final rows = await db
        .rawQuery('SELECT * FROM $table WHERE todo_type_id = ?', [todoTypeId]);
    if (rows.isEmpty) return null;

    return TodoType.fromMap(rows.first);
  }
}
