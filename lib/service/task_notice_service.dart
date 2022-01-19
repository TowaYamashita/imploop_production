import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:imploop/domain/task.dart';
import 'package:imploop/domain/task_notice.dart';
import 'package:imploop/domain/task_type.dart';
import 'package:imploop/repository/task_notice_repository.dart';
import 'package:imploop/service/task_service.dart';
import 'package:imploop/service/task_type_service.dart';

final taskNoticeServiceProvider = StateProvider(
  (ref) => TaskNoticeService(
    ref.read,
    TaskNoticeRepository(),
  ),
);

class TaskNoticeService {
  final Reader read;
  final TaskNoticeRepository repository;

  TaskNoticeService(this.read, this.repository);

  /// Taskの振り返りを記録する
  ///
  /// 記録に成功すればtrue、そうでなければfalseを返す
  Future<bool> register(Task task, String body) async {
    // DB上に存在しないTaskは記録できない
    if (!await read(taskServiceProvider).existsTask(task)) {
      return false;
    }
    // DB上に存在しないTaskTypeは記録できない
    if (!await read(taskTypeServiceProvider).existsTaskType(task.taskTypeId)) {
      return false;
    }

    await read(taskServiceProvider).finishTask(task);

    return await repository.create(
          task.taskId,
          body,
        ) !=
        null;
  }

  /// Taskに紐づく振り返りをすべて取得する
  ///
  /// 1件も無ければnullを返す
  Future<List<TaskNotice>?> getTaskNoticeList(Task task) async {
    return await repository.getByTaskId(task.taskId);
  }

  /// TaskTypeに紐づく振り返りをすべて取得する
  Future<List<TaskNotice>> getTaskNoticeListByTaskType(
    TaskType? taskType,
  ) async {
    final int taskTypeId = taskType?.taskTypeId ?? -1;

    List<TaskNotice>? result;
    if (taskTypeId != -1) {
      result = await repository.getByTaskId(taskType!.taskTypeId);
    }

    return result ??= (await repository.getAll() ?? []);
  }
}
