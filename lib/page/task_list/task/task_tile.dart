import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:imploop/domain/task.dart';
import 'package:imploop/domain/todo.dart';
import 'package:imploop/page/common/slidable_tile.dart';
import 'package:imploop/page/task_list/task/task_edit_modal.dart';
import 'package:imploop/page/task_list/task_list_page.dart';
import 'package:imploop/page/task_list/todo/todo_create_modal.dart';
import 'package:imploop/page/task_list/todo/todo_tile.dart';
import 'package:imploop/service/task_service.dart';

class TaskTile extends HookWidget {
  const TaskTile({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.task,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final Task task;

  @override
  Widget build(BuildContext context) {
    final _isVisibleTodoList = useState<bool>(false);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SlidableTile(
            tile: ListTile(
              leading: IconButton(
                onPressed: () {
                  _isVisibleTodoList.value = !_isVisibleTodoList.value;
                },
                icon: _isVisibleTodoList.value
                    ? const Icon(Icons.arrow_drop_up_outlined)
                    : const Icon(Icons.arrow_drop_down_outlined),
              ),
              title: Text(
                title,
                style: TextStyle(
                  decoration: task.isNotFinished()
                      ? TextDecoration.none
                      : TextDecoration.lineThrough,
                ),
              ),
              subtitle: Text(
                subtitle,
              ),
              trailing: IconButton(
                onPressed: () => {
                  if (task.isNotFinished())
                    {
                      TodoCreateModal.show(context, task),
                    }
                },
                icon: const Icon(Icons.add_outlined),
              ),
            ),
            editAction: (context) {
              if (task.isNotFinished()) {
                TaskEditModal.show(context, task);
              }
            },
            deleteAction: (context) async {
              if (task.isNotFinished()) {
                if (await TaskService.deleteTask(task)) {
                  // Taskが追加されたことをスナックバーで通知
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Todoが削除されました。',
                      ),
                    ),
                  );
                  TaskListPage.show(context);
                }
              }
            }),
        Visibility(
          visible: _isVisibleTodoList.value,
          child: _TodoList(taskId: task.taskId),
        ),
      ],
    );
  }
}

class _TodoList extends StatelessWidget {
  const _TodoList({Key? key, required this.taskId}) : super(key: key);

  final int taskId;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Todo>>(
      future: TaskService.getAllTodoInTask(taskId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final List<Todo>? _todoList = snapshot.data ?? [];
        return ListView.builder(
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return TodoTile(
              title: _todoList![index].name.toString(),
              subtitle: '見積もり時間: ${_todoList[index].estimate}分',
              todo: _todoList[index],
            );
          },
          itemCount: _todoList!.length,
        );
      },
    );
  }
}
