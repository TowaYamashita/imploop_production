import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imploop/domain/task.dart';
import 'package:imploop/page/timer/timer_page.dart';
import 'package:imploop/service/task_notice_service.dart';

class TaskNoticePage extends HookWidget {
  TaskNoticePage({
    Key? key,
    required this.task,
  }) : super(key: key);

  static show(
    BuildContext context,
    Task task,
  ) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return TaskNoticePage(
            task: task,
          );
        },
        fullscreenDialog: true,
      ),
    );
  }

  static const appBaKey = Key('TaskNoticePageAppBar');
  static const taskNoticeInputFormFieldKey =
      Key('TaskNoticePageTaskNoticeInputFormField');
  static const taskNoticeSubmitButtonKey =
      Key('TaskNoticePageTaskNoticeSubmitButton');

  final Task task;

  @override
  Widget build(BuildContext context) {
    final taskNotice = useState<String?>(null);
    return Scaffold(
      appBar: AppBar(
        key: appBaKey,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _NoticeFormArea(
                // formKey: noticeFormKey,
                taskNotice: taskNotice,
              ),
              _SubmitButton(
                task: task,
                // noticeFormKey: noticeFormKey,
                taskNotice: taskNotice,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 振り返りを記載する入力フォーム
class _NoticeFormArea extends StatelessWidget {
  const _NoticeFormArea({
    Key? key,
    // required this.formKey,
    required this.taskNotice,
  }) : super(key: key);

  final ValueNotifier<String?> taskNotice;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('タスクの振り返り'),
          TextFormField(
            key: TaskNoticePage.taskNoticeInputFormFieldKey,
            onChanged: (value) {
              if (value.length > 0 && value.length <= 400) {
                taskNotice.value = value;
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
                return 'Taskの振り返りを入力してください';
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
    required this.task,
    required this.taskNotice,
  }) : super(key: key);

  final Task task;
  final ValueNotifier<String?> taskNotice;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      key: TaskNoticePage.taskNoticeSubmitButtonKey,
      onPressed: () async {
        if (taskNotice.value != null) {
          final String notice = taskNotice.value!;
          if (await TaskNoticeService.register(task, notice)) {
            ref.read(selectedTodoProvider.notifier).update((state) => null);
            TimerPage.show(context);
          }
        }
      },
      child: const Text('振り返りを記録する'),
    );
  }
}
