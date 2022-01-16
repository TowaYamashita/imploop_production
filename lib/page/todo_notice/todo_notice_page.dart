import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imploop/domain/task.dart';
import 'package:imploop/domain/todo.dart';
import 'package:imploop/page/task_notice/task_notice_page.dart';
import 'package:imploop/page/timer/timer_page.dart';
import 'package:imploop/service/task_service.dart';
import 'package:imploop/service/todo_notice_service.dart';

class TodoNoticePage extends HookWidget {
  TodoNoticePage({
    Key? key,
    required this.todo,
  }) : super(key: key);

  static show(
    BuildContext context,
    Todo todo,
  ) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return TodoNoticePage(
            todo: todo,
          );
        },
        fullscreenDialog: true,
      ),
    );
  }

  static const appBarKey = Key('TodoNoticePageAppBar');
  static const todoEstimateInfoKey = Key('TodoNoticePageTodoEstimateInfo');
  static const todoElapsedInfoKey = Key('TodoNoticePageTodoElapsedInfo');
  static const todoNoticeInputFormFieldKey =
      Key('TodoNoticePageTodoNoticeInputFormField');
  static const todoNoticeSubmitButtonKey =
      Key('TodoNoticePageTodoNoticeSubmitButton');

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    final todoNotice = useState<String?>(null);
    return Scaffold(
      appBar: AppBar(
        key: appBarKey,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _EstimateAndElapsedInfo(
                todo: todo,
              ),
              _NoticeFormArea(
                // formKey: noticeFormKey,
                todoNotice: todoNotice,
              ),
              _SubmitButton(
                todo: todo,
                todoNotice: todoNotice,
                // noticeFormKey: noticeFormKey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EstimateAndElapsedInfo extends StatelessWidget {
  const _EstimateAndElapsedInfo({Key? key, required this.todo})
      : super(key: key);

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.onSecondary),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          ListTile(
            key: TodoNoticePage.todoEstimateInfoKey,
            leading: const Text('見積もり[分]'),
            title: Text(
              "${todo.estimate}",
              textAlign: TextAlign.end,
            ),
          ),
          ListTile(
            key: TodoNoticePage.todoElapsedInfoKey,
            leading: const Text('実作業時間[分]'),
            title: Text(
              "${todo.elapsed}",
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}

/// 振り返りを記載する入力フォーム
class _NoticeFormArea extends StatelessWidget {
  const _NoticeFormArea({
    Key? key,
    // required this.formKey,
    required this.todoNotice,
  }) : super(key: key);

  final ValueNotifier<String?> todoNotice;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('振り返り'),
          TextFormField(
            key: TodoNoticePage.todoNoticeInputFormFieldKey,
            onChanged: (value) {
              if (value.length > 0 && value.length <= 400) {
                todoNotice.value = value;
              }
            },
            initialValue: '',
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 20,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value == null) {
                return 'Todoの振り返りを入力してください';
              }
              if (value.length == 0 || value.length > 400) {
                return '振り返りは1文字以上400文字以下で入力してください';
              }
              return null;
            },
            maxLength: 400,
          ),
        ],
      ),
    );
  }
}

/// フォームのサブミットボタン
///
/// これを押下したら振り返りの保存処理を走らせる
class _SubmitButton extends ConsumerWidget {
  const _SubmitButton({
    Key? key,
    required this.todoNotice,
    required this.todo,
  }) : super(key: key);

  final Todo todo;
  final ValueNotifier<String?> todoNotice;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      key: TodoNoticePage.todoNoticeSubmitButtonKey,
      onPressed: () async {
        if (todoNotice.value != null) {
          final String notice = todoNotice.value!;
          if (await TodoNoticeService.register(todo, notice)) {
            if (await ref.read(taskServiceProvider).containsNonFinishedTodo(todo.taskId)) {
              ref.read(selectedTodoProvider.notifier).update((state) => null);
              TimerPage.show(context);
            } else {
              final Task? finishedTask = await ref.read(taskServiceProvider).get(todo.taskId);
              TaskNoticePage.show(context, finishedTask!);
            }
          }
        }
      },
      child: const Text('振り返りを記録する'),
    );
  }
}
