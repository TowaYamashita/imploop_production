import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  final _databaseName = "Imploop.db";
  final _databaseVersion = 1;

  DBProvider._();
  static final DBProvider instance = DBProvider._();

  Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// テーブル作成
  Future<void> _createTableFunction(Database db) async {
    const List<String> _queryList = _initializeQuery;

    var batch = db.batch();
    for (var _query in _queryList) {
      batch.execute(_query);
    }
    await batch.commit();
  }

  Future<Database> _initDatabase() async {
    final Directory documentsDirectory =
        await getApplicationDocumentsDirectory();
    final String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: (db, version) async {
        _createTableFunction(db);
      },
      onConfigure: (db) async {
        // 外部キー制約を有効化
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onDowngrade: onDatabaseDowngradeDelete,
    );
  }
}

const List<String> _initializeQuery = [
  '''
  CREATE TABLE task(
    task_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    status_id INTEGER NOT NULL DEFAULT 1,
    task_type_id INTEGER NOT NULL,
    foreign key (status_id) references status(status_id)
    foreign key (task_type_id) references task_type(task_type_id)
  )''',
  '''
  CREATE TABLE todo(
    todo_id INTEGER PRIMARY KEY AUTOINCREMENT,
    task_id INTEGER NOT NULL,
    name TEXT NOT NULL,
    status_id INTEGER NOT NULL DEFAULT 1,
    todo_type_id INTEGER,
    estimate INTEGER NOT NULL,
    elapsed INTEGER DEFAULT NULL,
    foreign key (task_id) references task(task_id) on delete cascade
    foreign key (status_id) references status(status_id)
    foreign key (todo_type_id) references todo_type(todo_type_id)
  )''',
  '''
  CREATE TABLE status(
    status_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL
  )''',
  '''
  INSERT INTO status (name) VALUES('todo'), ('doing'), ('done')
  ''',
  '''
  CREATE TABLE task_notice(
    task_notice_id INTEGER PRIMARY KEY AUTOINCREMENT,
    task_id INTEGER NOT NULL,
    body TEXT NOT NULL
  )''',
  '''
  CREATE TABLE todo_notice(
    todo_notice_id INTEGER PRIMARY KEY AUTOINCREMENT,
    todo_id INTEGER NOT NULL,
    body TEXT NOT NULL
  )''',
  '''
  CREATE TABLE task_type(
    task_type_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL
  )''',
  '''
  CREATE TABLE todo_type(
    todo_type_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL
  )''',
];
