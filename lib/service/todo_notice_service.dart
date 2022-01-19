import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imploop/domain/todo.dart';
import 'package:imploop/domain/todo_notice.dart';
import 'package:imploop/domain/todo_type.dart';
import 'package:imploop/repository/todo_notice_repository.dart';
import 'package:imploop/service/todo_service.dart';
import 'package:imploop/service/todo_type_service.dart';

final todoNoticeServiceProvider = StateProvider(
  (ref) => TodoNoticeService(
    ref.read,
    TodoNoticeRepository(),
  ),
);

class TodoNoticeService {
  final Reader read;
  final TodoNoticeRepository repository;

  TodoNoticeService(this.read, this.repository);

  /// Todoの振り返りを記録する
  ///
  /// 記録に成功すればtrue、そうでなければfalseを返す
  Future<bool> register(Todo todo, String body) async {
    // DB上に存在しないTodoは記録できない
    if (!await read(todoServiceProvider).existsTodo(todo)) {
      return false;
    }
    // DB上に存在しないTodoTypeは記録できない
    if (!await read(todoTypeServiceProvider).existsTodoType(todo.todoTypeId)) {
      return false;
    }

    return await repository.create(
          todo.todoId,
          body,
        ) !=
        null;
  }

  /// Todoに紐づく振り返りをすべて取得する
  ///
  /// 1件も無ければnullを返す
  Future<List<TodoNotice>?> getTodoNoticeList(Todo todo) async {
    return await repository.getByTodoId(todo.todoId);
  }

  /// TodoTypeに紐づく振り返りをすべて取得する
  Future<List<TodoNotice>> getTodoNoticeListByTodoType(
    TodoType? todoType,
  ) async {
    final int todoTypeId = todoType?.todoTypeId ?? -1;

    List<TodoNotice>? result;
    if (todoTypeId != -1) {
      result = await repository.getByTodoId(todoType!.todoTypeId);
    }

    return result ??= (await repository.getAll() ?? []);
  }
}
