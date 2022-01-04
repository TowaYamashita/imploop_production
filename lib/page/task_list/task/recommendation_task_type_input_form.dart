import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:imploop/domain/task.dart';
import 'package:imploop/domain/task_type.dart';
import 'package:imploop/service/task_type_service.dart';

/// 選択したTaskTypeを管理するProvider
final StateProvider<TaskType?> selectedTaskTypeProvider =
    StateProvider((_) => null);

/// 既存のテーブルにある値をフォームに入力した文字列に応じて表示するフォーム
class RecommendationTaskTypeInputForm extends HookConsumerWidget {
  const RecommendationTaskTypeInputForm({
    Key? key,
    this.task,
  }) : super(key: key);

  final Task? task;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ValueNotifier<String?> input = useState<String?>(null);
    final showRecommedationList = useState<bool>(false);
    final selectedTaskType = ref.watch(selectedTaskTypeProvider);
    final TextEditingController controller = TextEditingController();

    controller.text = input.value ?? selectedTaskType?.name ?? '';
    controller.selection = TextSelection.fromPosition(
        TextPosition(offset: controller.text.length));

    return Column(
      children: [
        ListTile(
          title: TextFormField(
              decoration: const InputDecoration(hintText: '種類を選択してください'),
              controller: controller,
              onChanged: (value) {
                input.value = value;
              },
              onTap: () {
                showRecommedationList.value = !showRecommedationList.value;
              }),
          trailing: IconButton(
            onPressed: () {
              input.value = null;
              showRecommedationList.value = false;
              ref
                  .read(selectedTaskTypeProvider.notifier)
                  .update((state) => null);
            },
            icon: const Icon(Icons.cancel_outlined),
          ),
        ),
        RecommendationListView(
          input: input,
          visible: showRecommedationList,
        ),
      ],
    );
  }
}

class RecommendationListView extends HookConsumerWidget {
  const RecommendationListView({
    Key? key,
    required this.input,
    required this.visible,
  }) : super(key: key);
  final ValueNotifier<String?> input;
  final ValueNotifier<bool> visible;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _future = useMemoized(
      () =>
          TaskTypeRecommendationLogic.getRecommendationList(input.value ?? ''),
      [input.value],
    );
    final _snapshot = useFuture<List<TaskType>>(_future);

    if (_snapshot.connectionState != ConnectionState.done ||
        !_snapshot.hasData) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }
    final List<TaskType> recommendationList = _snapshot.data!;

    return Visibility(
      visible: visible.value,
      child: SizedBox(
        height: 100,
        child: ListView.builder(
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(recommendationList[index].name),
              trailing: const Icon(
                Icons.add,
              ),
              onTap: () {
                ref
                    .read(selectedTaskTypeProvider.notifier)
                    .update((state) => recommendationList[index]);
                visible.value = false;
              },
            );
          },
          itemCount: recommendationList.length,
        ),
      ),
    );
  }
}

class TaskTypeRecommendationLogic {
  static Future<List<TaskType>> getRecommendationList(String input) async {
    final List<TaskType> registeredTaskTypeList =
        await TaskTypeService.fetchRegisteredTaskTypeList();
    if (registeredTaskTypeList == []) {
      return [];
    }

    if (input.isEmpty) {
      return registeredTaskTypeList;
    }

    List<TaskType> result = registeredTaskTypeList.where((registeredTaskType) {
      return registeredTaskType.name.contains(input);
    }).toList();
    result.insert(0, TaskType(taskTypeId: -1, name: input));

    return result;
  }
}
