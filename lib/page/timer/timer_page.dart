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

  static const appBarKey = Key('TimerPageAppBar');
  static const timerKey = Key('TimerPageCountUpTimer');
  static const timerStartButtonKey = Key('TimerPageCountUpTimerStartButton');
  static const timerStopButtonKey = Key('TimerPageCountUpTimerStopButton');
  static const timerResetButtonKey = Key('TimerPageCountUpTimerResetButton');

  static const buttonToSelectTodoKey = Key('TimerPageButtonToSelectTodo');
  static const buttonToFinishTodoKey = Key('TimerPageButtonToFinishTodo');
  static const buttonToCancelTodoKey = Key('TimerPageButtonToCancelTodo');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTodo = ref.watch(selectedTodoProvider);
    return Scaffold(
      appBar: AppBar(
        key: appBarKey,
        automaticallyImplyLeading: false,
        title: const Text('タイマー'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CountUpTimer(
            key: timerKey,
            stopWatchTimer: stopWatchTimer,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CountUpTimerStartButton(
                key: timerStartButtonKey,
                stopWatchTimer: stopWatchTimer,
              ),
              CountUpTimerStopButton(
                key: timerStopButtonKey,
                stopWatchTimer: stopWatchTimer,
              ),
              CountUpTimerResetButton(
                key: timerResetButtonKey,
                stopWatchTimer: stopWatchTimer,
              ),
            ],
          ),
          selectedTodo == null
              ? ElevatedButton(
                  key: buttonToSelectTodoKey,
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
                  key: buttonToFinishTodoKey,
                  onPressed: () async {
                    final int elapsedMinute =
                        TodoTimer(stopWatchTimer).elapsedMinutes();
                    if (await TodoService.finishTodo(
                      selectedTodo,
                      elapsedMinute,
                    )) {
                      TodoNoticePage.show(
                        context,
                        (await TodoService.getTodo(selectedTodo.todoId))!,
                      );
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "${selectedTodo.name}を完了させる",
                      ),
                      IconButton(
                        key: buttonToCancelTodoKey,
                        onPressed: () {
                          ref
                              .read(selectedTodoProvider.notifier)
                              .update((state) => null);
                        },
                        icon: const Icon(Icons.cancel_outlined),
                      ),
                    ],
                  ),
                )
        ],
      ),
    );
  }
}

class TaskSelectorDialog extends HookConsumerWidget {
  const TaskSelectorDialog({
    Key? key,
  }) : super(key: key);

  static const emptyDialogKey = Key('TaskSelectorDialogAlertDialog');
  static const selectableTodoDialogKey = Key('TaskSelectorDialogSimpleDialog');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _future = useMemoized(
      () => ref.read(taskServiceProvider).getAllTaskWithoutFinished(),
      [DateTime.now().second],
    );
    final _snapshot = useFuture(_future);
    if (!_snapshot.hasData) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final List<Task> allTaskList = _snapshot.data!;
    return allTaskList.isEmpty
        ? AlertDialog(
            key: emptyDialogKey,
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
            key: selectableTodoDialogKey,
            title: const Text('Todoを選択'),
            children: [
              for (final task in allTaskList)
                SimpleDialogTaskListTile(task: task),
            ],
          );
  }
}

class SimpleDialogTaskListTile extends HookConsumerWidget {
  const SimpleDialogTaskListTile({
    Key? key,
    required this.task,
  }) : super(key: key);

  static const taskTileKey = Key('SimpleDialogTaskListTileTask');

  final Task task;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _future = useMemoized(() => ref
        .read(taskServiceProvider)
        .getAllTodoWithoutFinishedInTask(task.taskId));
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
          key: taskTileKey,
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

  static const todoTileKey = Key('SimpleDialogTodoListTileTodo');

  final Todo todo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        ref.read(selectedTodoProvider.notifier).update((state) => todo);
        Navigator.pop(context, true);
      },
      child: ListTile(
        key: todoTileKey,
        leading: const Icon(Icons.subdirectory_arrow_right),
        title: Text(todo.name),
      ),
    );
  }
}
