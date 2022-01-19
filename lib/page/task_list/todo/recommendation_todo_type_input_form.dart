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
    final selectedTodoType = ref.watch(selectedTodoTypeProvider);
    final ValueNotifier<String?> formInput = useState<String?>(null);
    final showRecommedationList = useState<bool>(false);

    // TodoTypeが選択されていないときは入力フォームを表示する
    if (selectedTodoType == null) {
      return Column(
        children: [
          ListTile(
            title: TextFormField(
              decoration: const InputDecoration(hintText: '種類を選択してください'),
              initialValue: formInput.value ?? selectedTodoType?.name,
              onChanged: (value) {
                formInput.value = value;
              },
              onTap: () =>
                  showRecommedationList.value = !showRecommedationList.value,
            ),
          ),
          RecommendationListView(
            formInput: formInput,
            visible: showRecommedationList,
          ),
        ],
      );
    }
    // TodoTypeが選択されているときは選択したTodoTypeの名前を表示する
    return ListTile(
      title: Text(selectedTodoType.name),
      trailing: IconButton(
        // 初期化処理
        onPressed: () {
          formInput.value = null;
          showRecommedationList.value = false;
          ref.read(selectedTodoTypeProvider.notifier).state = null;
        },
        icon: const Icon(Icons.cancel_outlined),
      ),
    );
  }
}

class RecommendationListView extends HookConsumerWidget {
  const RecommendationListView({
    Key? key,
    required this.formInput,
    required this.visible,
  }) : super(key: key);
  final ValueNotifier<String?> formInput;
  final ValueNotifier<bool> visible;

  Future<List<TodoType>> getRecommendationList(
      WidgetRef ref, String input) async {
    final List<TodoType> registeredTodoTypeList =
        await ref.read(todoTypeServiceProvider).fetchRegisteredTodoTypeList();
    if (registeredTodoTypeList == []) {
      return [];
    }

    if (input.isEmpty) {
      return registeredTodoTypeList;
    }

    List<TodoType> result = registeredTodoTypeList.where((registeredTodoType) {
      return registeredTodoType.name.contains(input) &&
          registeredTodoType.name != input;
    }).toList();
    result.insert(0, TodoType(todoTypeId: -1, name: input));

    return result;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _future = useMemoized(
      () => getRecommendationList(ref, formInput.value ?? ''),
      [formInput.value],
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