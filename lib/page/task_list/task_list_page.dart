import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:imploop/domain/task.dart';
import 'package:imploop/page/task_list/task/task_create_modal.dart';
import 'package:imploop/page/task_list/task/task_tile.dart';
import 'package:imploop/service/task_service.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class TaskListPage extends HookConsumerWidget {
  const TaskListPage({Key? key}) : super(key: key);

  static show(BuildContext context) {
    return pushNewScreen(
      context,
      screen: const TaskListPage(),
    );
  }

  static const appBarKey = Key('TaskListPageAppBar');
  static const taskListKey = Key('TaskListPageTaskList');
  static const addedTaskButtonKey = Key('TaskListPageAddedTaskButton');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ValueNotifier<List<Task>?> allTaskList = useState<List<Task>?>(null);

    return Scaffold(
      appBar: AppBar(
        key: appBarKey,
        title: const Text('Task一覧'),
        automaticallyImplyLeading: false,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          allTaskList.value = await ref.read(taskServiceProvider).getAllTask();
        },
        child: const _TaskList(key: taskListKey),
      ),
      floatingActionButton: FloatingActionButton(
        key: addedTaskButtonKey,
        child: const Icon(Icons.add),
        onPressed: () => TaskCreateModal.show(context),
      ),
    );
  }
}

class _TaskList extends ConsumerWidget {
  const _TaskList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<List<Task>>(
      future: ref.read(taskServiceProvider).getAllTask(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final List<Task>? _taskList = snapshot.data ?? [];
        if (_taskList == null || _taskList.isEmpty) {
          return Center(
            child: Text(
              'Taskが登録されていません。\n右下のボタンを押下してTaskを追加しましょう。',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          );
        }
        return ListView.builder(
          itemBuilder: (context, index) {
            return TaskTileCreator(
              taskList: _taskList,
              index: index,
            );
          },
          itemCount: _taskList.length,
        );
      },
    );
  }
}

class TaskTileCreator extends HookConsumerWidget {
  const TaskTileCreator({
    Key? key,
    required this.taskList,
    required this.index,
  }) : super(key: key);

  final List<Task> taskList;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _snapshot = useFuture(
        ref.read(taskServiceProvider).getTodoStatusList(taskList[index]));
    if (!_snapshot.hasData) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }
    final todoStatusList = _snapshot.data!;
    return TaskTile(
      title: taskList[index].name.toString(),
      subtitle: todoStatusList.isEmpty
          ? 'まだTodoが登録されていません'
          : '実行前: ${todoStatusList["todo"]}/実行中:${todoStatusList["doing"]}/実行済:${todoStatusList["done"]}',
      task: taskList[index],
    );
  }
}
