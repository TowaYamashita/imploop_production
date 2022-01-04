import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:imploop/domain/todo.dart';
import 'package:imploop/domain/todo_type.dart';
import 'package:imploop/service/todo_type_service.dart';

final StateProvider<TodoType?> selectedTodoTypeProvider =
    StateProvider((_) => null);

/// 既存のテーブルにある値をフォームに入力した文字列に応じて表示するフォーム
class RecommendationTodoTypeInputForm extends HookConsumerWidget {
  const RecommendationTodoTypeInputForm({
    Key? key,
    this.todo,
  }) : super(key: key);

  final Todo? todo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ValueNotifier<String?> input = useState<String?>(null);
    final showRecommedationList = useState<bool>(false);
    final selectedTodoType = ref.watch(selectedTodoTypeProvider);
    final TextEditingController controller = TextEditingController();

    controller.text = input.value ?? selectedTodoType?.name ?? '';
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
            onTap: () =>
                showRecommedationList.value = !showRecommedationList.value,
          ),
          trailing: IconButton(
            onPressed: () {
              input.value = null;
              showRecommedationList.value = false;
              ref.read(selectedTodoTypeProvider.notifier).state = null;
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
          TodoTypeRecommendationLogic.getRecommendationList(input.value ?? ''),
      [input.value],
    );
    final _snapshot = useFuture<List<TodoType>>(_future);

    if (_snapshot.connectionState != ConnectionState.done ||
        !_snapshot.hasData) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }
    final List<TodoType> recommendationList = _snapshot.data!;

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
                    .read(selectedTodoTypeProvider.notifier)
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

class TodoTypeRecommendationLogic {
  static Future<List<TodoType>> getRecommendationList(String input) async {
    final List<TodoType> registeredTodoTypeList =
        await TodoTypeService.fetchRegisteredTodoTypeList();
    if (registeredTodoTypeList == []) {
      return [];
    }

    if (input.isEmpty) {
      return registeredTodoTypeList;
    }

    List<TodoType> result = registeredTodoTypeList.where((registeredTodoType) {
      return registeredTodoType.name.contains(input);
    }).toList();
    result.insert(0, TodoType(todoTypeId: -1, name: input));

    return result;
  }
}
