import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:imploop/domain/task.dart';
import 'package:imploop/domain/task_type.dart';
import 'package:imploop/page/task_list/task/recommendation_task_type_input_form.dart';
import 'package:imploop/page/task_list/task_list_page.dart';
import 'package:imploop/service/task_service.dart';
import 'package:imploop/service/task_type_service.dart';

class TaskEditModal extends HookConsumerWidget {
  TaskEditModal({Key? key, required this.task}) : super(key: key);

  static show(BuildContext context, Task task) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return TaskEditModal(task: task);
        },
        fullscreenDialog: true,
      ),
    );
  }

  static const appBarKey = Key('TaskEditModalAppBar');
  static const taskNameFormKey = Key('TaskEditModaltaskNameForm');
  static const recommendationTaskTypeInputFormKey =
      Key('TaskEditModalRecommendationTaskTypeInputForm');
  static const submitButtonKey = Key('TaskEditModalSubmitButton');

  final Task task;
  final GlobalKey<FormFieldState<String>> nameKey =
      GlobalKey<FormFieldState<String>>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskName = useState<String?>(null);

    /// タスクに既に登録されているTaskTypeでProviderを上書きする
    useEffect(() {
      WidgetsBinding.instance?.addPostFrameCallback((_) async {
        final currentTaskType =
            await ref.read(taskTypeServiceProvider).get(task.taskTypeId);
        ref
            .read(selectedTaskTypeProvider.notifier)
            .update((state) => currentTaskType);
      });
    }, const []);

    return Scaffold(
      appBar: AppBar(key: appBarKey),
      body: Center(
        child: Form(
          child: Column(
            children: [
              TextFormField(
                key: taskNameFormKey,
                onChanged: (value) => taskName.value = value,
                initialValue: task.name,
              ),
              RecommendationTaskTypeInputForm(
                key: recommendationTaskTypeInputFormKey,
                task: task,
              ),
              ElevatedButton(
                key: submitButtonKey,
                onPressed: () async {
                  String? updatedName = taskName.value ?? task.name;
                  final TaskType? selectedTaskType =
                      ref.read(selectedTaskTypeProvider.notifier).state;
                  final TaskType? registeredTaskType = selectedTaskType != null
                      ? await ref
                          .read(taskTypeServiceProvider)
                          .add(selectedTaskType.name)
                      : null;
                  if (updatedName != null && registeredTaskType != null) {
                    final updatedTask = task.copyWith(
                      name: updatedName,
                      taskTypeId: registeredTaskType.taskTypeId,
                    );
                    if (await ref.read(taskServiceProvider).editTask(updatedTask)) {
                      // Taskが追加されたことをスナックバーで通知
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Taskが変更されました。",
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
