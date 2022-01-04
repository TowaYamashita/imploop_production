import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:imploop/domain/task.dart';
import 'package:imploop/domain/todo.dart';
import 'package:imploop/domain/todo_timer.dart';
import 'package:imploop/page/common/count_up_timer.dart';
import 'package:imploop/page/task_list/task/task_create_modal.dart';
import 'package:imploop/page/todo_notice/todo_notice_page.dart';
import 'package:imploop/service/task_service.dart';
import 'package:imploop/service/todo_service.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

final selectedTodoProvider = StateProvider<Todo?>((_) => null);

class TimerPage extends ConsumerWidget {
  const TimerPage({
    Key? key,
  }) : super(key: key);

  static show(BuildContext context) {
    return pushNewScreen(
      context,
      screen: const TimerPage(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTodo = ref.watch(selectedTodoProvider);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('タイマー'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CountUpTimer(
            stopWatchTimer: stopWatchTimer,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CountUpTimerStartButton(
                stopWatchTimer: stopWatchTimer,
              ),
              CountUpTimerStopButton(
                stopWatchTimer: stopWatchTimer,
              ),
              CountUpTimerResetButton(
                stopWatchTimer: stopWatchTimer,
              ),
            ],
          ),
          selectedTodo == null
              ? ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return const TaskSelectorDialog();
                      },
                    );
                  },
                  child: const Text('やるtodoを選択する'),
                )
              : ElevatedButton(
                  onPressed: () async {
                    final int elapsedMinute =
                        TodoTimer(stopWatchTimer).elapsedMinutes();
                    if (await TodoService.finishTodo(
                      // selectedTodo!,
                      selectedTodo,
                      elapsedMinute,
                    )) {
                      TodoNoticePage.show(
                        context,
                        // (await TodoService.getTodo(selectedTodo!.todoId))!,
                        (await TodoService.getTodo(selectedTodo.todoId))!,
                      );
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        // "${selectedTodo!.name}を完了させる",
                        "${selectedTodo.name}を完了させる",
                      ),
                      IconButton(
                        onPressed: () {
                          ref
                              .read(selectedTodoProvider.notifier)
                              .update((state) => null);
                        },
                        icon: Icon(Icons.cancel_outlined),
                      ),
                    ],
                  ),
                )
        ],
      ),
    );
  }
}

class TaskSelectorDialog extends HookWidget {
  const TaskSelectorDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _snapshot = useFuture(TaskService.getAllTaskWithoutFinished());
    if (!_snapshot.hasData) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final List<Task> allTaskList = _snapshot.data!;
    return allTaskList.isEmpty
        ? AlertDialog(
            title: const Text('選択できるTaskがありません'),
            content: ElevatedButton(
              onPressed: () {
                TaskCreateModal.show(context);
              },
              child: const Text('Taskを作成する'),
            ),
            scrollable: true,
          )
        : SimpleDialog(
            title: const Text('Todoを選択'),
            children: [
              for (final task in allTaskList)
                SimpleDialogTaskListTile(task: task),
            ],
          );
  }
}

class SimpleDialogTaskListTile extends HookWidget {
  const SimpleDialogTaskListTile({
    Key? key,
    required this.task,
  }) : super(key: key);

  final Task task;

  @override
  Widget build(BuildContext context) {
    final _future = useMemoized(
        () => TaskService.getAllTodoWithoutFinishedInTask(task.taskId));
    final _snapshot = useFuture(_future);
    if (_snapshot.connectionState != ConnectionState.done) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final List<Todo> allTodoListInTask = _snapshot.data!;
    final _visible = useState<bool>(false);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: _visible.value
              ? const Icon(Icons.arrow_drop_up)
              : const Icon(Icons.arrow_drop_down),
          title: Text(task.name),
          onTap: () {
            _visible.value = !_visible.value;
          },
        ),
        Visibility(
          visible: _visible.value,
          child: Column(
            children: [
              for (final Todo todo in allTodoListInTask)
                SimpleDialogTodoListTile(todo: todo)
            ],
          ),
        ),
      ],
    );
  }
}

class SimpleDialogTodoListTile extends ConsumerWidget {
  const SimpleDialogTodoListTile({Key? key, required this.todo})
      : super(key: key);

  final Todo todo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        ref.read(selectedTodoProvider.notifier).update((state) => todo);
        Navigator.pop(context, true);
      },
      child: ListTile(
        leading: const Icon(Icons.subdirectory_arrow_right),
        title: Text(todo.name),
      ),
    );
  }
}
