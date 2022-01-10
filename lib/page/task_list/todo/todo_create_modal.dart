import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:imploop/domain/task.dart';
import 'package:imploop/domain/todo.dart';
import 'package:imploop/page/common/carousel_view.dart';
import 'package:imploop/page/task_list/task_list_page.dart';
import 'package:imploop/page/task_list/todo/recommendation_todo_type_input_form.dart';
import 'package:imploop/service/todo_service.dart';

class TodoCreateModal extends HookConsumerWidget {
  TodoCreateModal({
    Key? key,
    required this.task,
  }) : super(key: key);

  static show(BuildContext context, Task task) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return TodoCreateModal(task: task);
        },
        fullscreenDialog: true,
      ),
    );
  }

  static const appBarKey = Key('TodoCreateModalAppBar');
  static const todoNoticeCarouselViewKey =
      Key('TodoCreateModalTaskNoticeCarouselView');
  static const todoNameFormKey = Key('TodoCreateModaltodoNameForm');
  static const todoEstimateFormKey = Key('TodoCreateModaltodoEstimateForm');
  static const recommendationTodoTypeInputFormKey =
      Key('TodoCreateModalRecommendationTodoTypeInputForm');
  static const submitButtonKey = Key('TodoCreateModalSubmitButton');

  final Task task;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoName = useState<String?>(null);
    final todoEstimate = useState<int?>(null);

    useEffect(() {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        ref.read(selectedTodoTypeProvider.notifier).update((state) => null);
      });
    }, const []);
    return Scaffold(
      appBar: AppBar(
        key: appBarKey,
        title: const Text('Todo入力'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '過去のTodoの振り返り',
              style: Theme.of(context).textTheme.headline5,
            ),
            TodoNoticeCarouselView(
              key: todoNoticeCarouselViewKey,
              todoType: ref.read(selectedTodoTypeProvider.notifier).state,
            ),
            Center(
              child: Form(
                // key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      key: todoNameFormKey,
                      onChanged: (value) => todoName.value = value,
                      decoration: const InputDecoration(
                        labelText: "Todoの名前",
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '名前が入力されていません。';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      key: todoEstimateFormKey,
                      onChanged: (value) =>
                          todoEstimate.value = int.parse(value),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: const InputDecoration(
                        labelText: "このTodoを行うのにかかる時間の見積もり[分]",
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null) {
                          return '見積もりが入力されていません。';
                        }
                        return null;
                      },
                    ),
                    const RecommendationTodoTypeInputForm(
                      key: recommendationTodoTypeInputFormKey,
                    ),
                    ElevatedButton(
                      key: submitButtonKey,
                      onPressed: () async {
                        final selectedTodoType =
                            ref.read(selectedTodoTypeProvider.notifier).state;
                        final String? _name = todoName.value;
                        final int? _estimate = todoEstimate.value;
                        late final Todo? addedTodo;
                        if (_name != null &&
                            _estimate != null &&
                            selectedTodoType != null) {
                          addedTodo = await TodoService.registerNewTodo(
                            task,
                            _name,
                            _estimate,
                            selectedTodoType,
                          );
                        } else {
                          addedTodo = null;
                        }

                        // Todoが追加されたことをスナックバーで通知
                        if (addedTodo != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Todoが追加されました。',
                              ),
                            ),
                          );
                          //タスク一覧画面に遷移
                          TaskListPage.show(context);
                        }
                      },
                      child: const Text('登録する'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
