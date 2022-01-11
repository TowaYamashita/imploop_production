import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:imploop/page/task_list/todo/recommendation_todo_type_input_form.dart';
import 'package:imploop/page/task_notice/task_notice_page.dart';

import '../../mock/mock_task.dart';
import '../../widget_test_util.dart';

void main() {
  /// テスト対象の画面を起動する処理
  bootstrap(WidgetTester tester) async {
    await tester.pumpWidget(ProviderScope(
      overrides: [
        selectedTodoTypeProvider.overrideWithValue(StateController(null))
      ],
      child: MaterialApp(
        home: TaskNoticePage(
          task: mockTask,
        ),
      ),
    ));
  }

  group('初期表示', () {
    testWidgets('AppBar', (tester) async {
      await bootstrap(tester);
      expect(
        find.byKey(TaskNoticePage.appBaKey),
        findsOneWidget,
        reason: 'AppBarが表示されること',
      );
    });

    testWidgets('TaskNoticeの入力フォーム', (tester) async {
      await bootstrap(tester);
      expect(
        evaluateWidget<TextFormField>(
                find.byKey(TaskNoticePage.taskNoticeInputFormFieldKey))
            .initialValue,
        '',
        reason: 'TaskNoticeの入力フォームの初期値が空で表示されること',
      );
    });

    testWidgets('TaskNoticeのSubmitボタン', (tester) async {
      await bootstrap(tester);
      expect(
        ((evaluateWidget<ElevatedButton>(
                find.byKey(TaskNoticePage.taskNoticeSubmitButtonKey))
            .child) as Text).data,
        '振り返りを記録する',
        reason: 'TaskNoticeのSubmitボタンに「振り返りを記録する」と表示されること',
      );
    });
  });
}
