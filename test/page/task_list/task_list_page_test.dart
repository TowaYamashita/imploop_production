import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:imploop/page/task_list/task_list_page.dart';
import 'package:imploop/page/task_list/todo/recommendation_todo_type_input_form.dart';

import '../../widget_test_util.dart';

void main() {
  /// テスト対象の画面を起動する処理
  bootstrap(WidgetTester tester) async {
    await tester.pumpWidget(ProviderScope(
      overrides: [
        selectedTodoTypeProvider.overrideWithValue(StateController(null))
      ],
      child: const MaterialApp(
        home: TaskListPage(),
      ),
    ));
  }

  group('初期表示', () {
    testWidgets('AppBar', (tester) async {
      await bootstrap(tester);
      expect(
        (evaluateWidget<AppBar>(find.byKey(TaskListPage.appBarKey)).title
                as Text)
            .data,
        'Task一覧',
        reason: 'AppBarのtitleに「Task一覧」と表示されること',
      );
    });
    testWidgets('Task一覧', (tester) async {
      await bootstrap(tester);
      expect(
        find.byKey(TaskListPage.taskListKey),
        findsOneWidget,
        reason: 'Taskの一覧が表示されること',
      );
    });
    testWidgets('Taskを追加するボタン', (tester) async {
      await bootstrap(tester);
      expect(
        find.byKey(TaskListPage.addedTaskButtonKey),
        findsOneWidget,
        reason: 'Taskを追加するボタンが表示されること',
      );
    });
  });
}
