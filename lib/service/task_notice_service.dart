import 'package:imploop/domain/task.dart';
import 'package:imploop/domain/task_notice.dart';
import 'package:imploop/domain/task_type.dart';
import 'package:imploop/repository/task_notice_repository.dart';
import 'package:imploop/service/task_service.dart';
import 'package:imploop/service/task_type_service.dart';

class TaskNoticeService {
  /// Taskの振り返りを記録する
  ///
  /// 記録に成功すればtrue、そうでなければfalseを返す
  static Future<bool> register(Task task, String body) async {
    // DB上に存在しないTaskは記録できない
    if (!await TaskService().existsTask(task)) {
      return false;
    }
    // DB上に存在しないTaskTypeは記録できない
    // TODO: TaskTypeServiceはProvider経由で触るようなクラスだが、やっつけで使う度にnewしている（設計変更のタイミングで一緒に治す）
    if (!await TaskTypeService().existsTaskType(task.taskTypeId)) {
      return false;
    }

    await TaskService().finishTask(task);

    return await TaskNoticeRepository.create(
          task.taskId,
          body,
        ) !=
        null;
  }

  /// Taskに紐づく振り返りをすべて取得する
  ///
  /// 1件も無ければnullを返す
  static Future<List<TaskNotice>?> getTaskNoticeList(Task task) async {
    return await TaskNoticeRepository.getByTaskId(task.taskId);
  }

  /// TaskTypeに紐づく振り返りをすべて取得する
  static Future<List<TaskNotice>> getTaskNoticeListByTaskType(
    TaskType? taskType,
  ) async {
    final int taskTypeId = taskType?.taskTypeId ?? -1;

    List<TaskNotice>? result;
    if (taskTypeId != -1) {
      result = await TaskNoticeRepository.getByTaskId(taskType!.taskTypeId);
    }

    return result ??= (await TaskNoticeRepository.getAll() ?? []);
  }
}
