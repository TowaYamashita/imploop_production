import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:imploop/domain/todo.dart';
import 'package:imploop/domain/todo_type.dart';
import 'package:imploop/page/task_list/task_list_page.dart';
import 'package:imploop/page/task_list/todo/recommendation_todo_type_input_form.dart';
import 'package:imploop/service/todo_service.dart';
import 'package:imploop/service/todo_type_service.dart';

class TodoEditModal extends HookConsumerWidget {
  TodoEditModal({Key? key, required this.todo}) : super(key: key);

  static show(BuildContext context, Todo todo) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return TodoEditModal(todo: todo);
        },
        fullscreenDialog: true,
      ),
    );
  }

  final Todo todo;
  // final GlobalKey<FormFieldState<String>> nameKey =
  //     GlobalKey<FormFieldState<String>>();
  // final GlobalKey<FormFieldState<String>> estimateKey =
  //     GlobalKey<FormFieldState<String>>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoName = useState<String?>(null);
    final todoEstimate = useState<int?>(null);

    /// タスクに既に登録されているTaskTypeでProviderを上書きする
    useEffect(() {
      WidgetsBinding.instance?.addPostFrameCallback((_) async {
        final _currentTodoType = await TodoTypeService.get(todo.todoTypeId);
        ref
            .read(selectedTodoTypeProvider.notifier)
            .update((state) => _currentTodoType);
      });
    }, const []);
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Form(
          child: Column(
            children: [
              TextFormField(
                // key: nameKey,
                onChanged: (value) => todoName.value = value,
                initialValue: todo.name,
              ),
              TextFormField(
                // key: estimateKey,
                onChanged: (value) => todoEstimate.value = int.parse(value),
                initialValue: todo.estimate.toString(),
              ),
              RecommendationTodoTypeInputForm(
                todo: todo,
              ),
              ElevatedButton(
                onPressed: () async {
                  String? updatedName = todoName.value ?? todo.name;
                  int? updatedEstimate = todoEstimate.value ?? todo.estimate;
                  final selectedTodoType =
                      ref.read(selectedTodoTypeProvider.notifier).state;
                  final TodoType? registeredTodoType = selectedTodoType != null
                      ? await TodoTypeService.add(selectedTodoType.name)
                      : null;
                  if (updatedName != null &&
                      updatedEstimate != null &&
                      registeredTodoType != null) {
                    final updatedTodo = todo.copyWith(
                      name: updatedName,
                      estimate: updatedEstimate,
                      todoTypeId: registeredTodoType.todoTypeId,
                    );
                    if (await TodoService.editTodo(updatedTodo)) {
                      // Todoが追加されたことをスナックバーで通知
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Todoが変更されました。",
                          ),
                        ),
                      );
                      TaskListPage.show(context);
                    }
                  }
                },
                child: const Text('変更する'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
