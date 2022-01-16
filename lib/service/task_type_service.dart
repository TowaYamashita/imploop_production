import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:imploop/domain/task_type.dart';
import 'package:imploop/repository/task_type_repository.dart';

final taskTypeServiceProvider = StateProvider((_) => TaskTypeService());

class TaskTypeService {
  /// 新しく登録しようとしているTypeがすでに登録されていないか判定する
  ///
  /// すでに登録されていればtrue、そうでなければfalseを返す
  Future<bool> hasAlreadyRegistered(String name) async {
    final List<TaskType> registeredTodoTypeList =
        await TaskTypeRepository.getAll() ?? [];
    return registeredTodoTypeList
        .where((registeredTodoType) => registeredTodoType.name == name)
        .isNotEmpty;
  }

  /// 新しいTaskTypeを登録する
  ///
  /// 登録することができれば新しく登録したTodoTypeのデータを持つTaskTypeクラスを
  ///
  /// 登録できなければ、nullを返す
  Future<TaskType?> add(String name) async {
    if (await hasAlreadyRegistered(name) == false) {
      return await TaskTypeRepository.create(name);
    }
    return getByTypeName(name);
  }

  /// 登録済みのTaskTypeのリストを取得する
  ///
  /// 1件も登録されていなければ[]を返す
  Future<List<TaskType>> fetchRegisteredTaskTypeList() async {
    return await TaskTypeRepository.getAll() ?? [];
  }

  Future<bool> existsTaskType(int taskTypeId) async {
    return await TaskTypeRepository.get(taskTypeId) != null;
  }

  Future<TaskType?> get(int taskTypeId) async {
    return await TaskTypeRepository.get(taskTypeId);
  }

  Future<TaskType?> getByTypeName(String taskTypeName) async {
    final List<TaskType> registeredTaskTypeList =
        await TaskTypeRepository.getAll() ?? [];
    try {
      return registeredTaskTypeList.firstWhere(
          (registeredTaskType) => registeredTaskType.name == taskTypeName);
    } catch (e) {
      return null;
    }
  }
}
