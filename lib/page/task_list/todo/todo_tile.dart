import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imploop/domain/todo.dart';
import 'package:imploop/page/common/slidable_tile.dart';
import 'package:imploop/page/home/home_page.dart';
import 'package:imploop/page/task_list/task_list_page.dart';
import 'package:imploop/page/task_list/todo/todo_create_modal.dart';
import 'package:imploop/page/task_list/todo/todo_edit_modal.dart';
import 'package:imploop/page/task_notice/task_notice_page.dart';
import 'package:imploop/page/timer/timer_page.dart';
import 'package:imploop/service/task_service.dart';
import 'package:imploop/service/todo_service.dart';

class TodoTile extends ConsumerWidget {
  const TodoTile({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.todo,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final Todo todo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SlidableTile(
      tile: ListTile(
        leading: IconButton(
          onPressed: () {
            if (todo.isNotFinished()) {
              ref.read(selectedTodoProvider.notifier).update((state) => todo);
              ref.read(displayPageSelectorProvider.notifier).state.jumpToTab(0);
            }
          },
          icon: Icon(
            Icons.local_fire_department,
            color: todo.isNotFinished() ? Colors.redAccent : Colors.grey,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            decoration: todo.isNotFinished()
                ? TextDecoration.none
                : TextDecoration.lineThrough,
          ),
        ),
        subtitle: Text(
          subtitle,
        ),
        trailing: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.arrow_forward_ios_rounded),
        ),
      ),
      editAction: (context) {
        if (todo.isNotFinished()) {
          TodoEditModal.show(context, todo);
        }
      },
      deleteAction: (context) async {
        if (todo.isNotFinished()) {
          if (await TodoService.deleteTodo(todo)) {
            // Task??????????????????????????????????????????????????????
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '${todo.name}???????????????????????????',
                ),
              ),
            );

            final int countFinishedTodoInTask =
                (await ref.read(taskServiceProvider).getAllTodoInTask(todo.taskId)).length;
            final bool containsNonFinishedTodo =
                await ref.read(taskServiceProvider).containsNonFinishedTodo(todo.taskId);

            if (countFinishedTodoInTask != 0 && containsNonFinishedTodo) {
              // ??????????????????????????????
              TaskListPage.show(context);
            } else if (countFinishedTodoInTask == 0) {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return WillPopScope(
                    /// ?????????????????????????????????
                    onWillPop: () async => false,
                    child: AlertDialog(
                      title: const Text("??????"),
                      content: const Text(
                        '??????Task???????????????Todo????????????????????????????????????\n????????????????????????????????????????????????????????????',
                        textAlign: TextAlign.start,
                      ),
                      actions: <Widget>[
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              TextButton(
                                child: const Text("Todo????????????????????????"),
                                onPressed: () async {
                                  TodoCreateModal.show(
                                    context,
                                    (await ref.read(taskServiceProvider).get(todo.taskId))!,
                                  );
                                },
                              ),
                              TextButton(
                                child: const Text("??????????????????????????????"),
                                onPressed: () async {
                                  TaskListPage.show(context);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            } else {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return WillPopScope(
                    /// ?????????????????????????????????
                    onWillPop: () async => false,
                    child: AlertDialog(
                      title: const Text("??????"),
                      content: const Text(
                        '??????Task???????????????Todo?????????????????????????????????????????????\n????????????????????????????????????????????????????????????',
                        textAlign: TextAlign.start,
                      ),
                      actions: <Widget>[
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              TextButton(
                                child: const Text(
                                  "Task????????????????????????",
                                ),
                                onPressed: () async {
                                  TaskNoticePage.show(
                                    context,
                                    (await ref.read(taskServiceProvider).get(todo.taskId))!,
                                  );
                                },
                              ),
                              TextButton(
                                child: const Text("Todo????????????????????????"),
                                onPressed: () async {
                                  TodoCreateModal.show(
                                    context,
                                    (await ref.read(taskServiceProvider).get(todo.taskId))!,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          }
        }
      },
    );
  }
}
