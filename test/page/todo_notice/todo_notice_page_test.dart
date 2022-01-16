import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:imploop/page/task_list/todo/recommendation_todo_type_input_form.dart';
import 'package:imploop/page/todo_notice/todo_notice_page.dart';

import '../../mock/mock_todo.dart';
import '../../widget_test_util.dart';

void main() {
  /// テスト対象の画面を起動する処理
  bootstrap(WidgetTester tester) async {
    await tester.pumpWidget(ProviderScope(
      overrides: [
        selectedTodoTypeProvider.overrideWithValue(StateController(null))
      ],
      child: MaterialApp(
        home: TodoNoticePage(
          todo: mockTodo.copyWith(
            elapsed: 120,
          ),
        ),
      ),
    ));
  }

  group('初期表示', () {
    testWidgets('AppBar', (tester) async {
      await bootstrap(tester);
      expect(
        find.byKey(TodoNoticePage.appBarKey),
        findsOneWidget,
        reason: 'AppBarが表示されること',
      );
    });

    testWidgets('AppBarの戻るボタン', (tester) async {
      await bootstrap(tester);
      expect(
        evaluateWidget<AppBar>(find.byKey(TodoNoticePage.appBarKey))
            .automaticallyImplyLeading,
        isFalse,
        reason: 'AppBarの戻るボタンが削除されていること',
      );
    });

    testWidgets('Todoの見積もり時間', (tester) async {
      await bootstrap(tester);
      expect(
        (evaluateWidget<ListTile>(find.byKey(TodoNoticePage.todoEstimateInfoKey))
            .title as Text).data,
        '100',
        reason: 'Todoの見積もり時間に100と表示されること',
      );
    });

    testWidgets('Todoの実作業時間', (tester) async {
      await bootstrap(tester);
      expect(
        (evaluateWidget<ListTile>(find.byKey(TodoNoticePage.todoElapsedInfoKey))
            .title as Text).data,
        '120',
        reason: 'Todoの実作業時間に120と表示されること',
      );
    });

    testWidgets('TodoNoticeの入力フォーム', (tester) async {
      await bootstrap(tester);
      expect(
        evaluateWidget<TextFormField>(
                find.byKey(TodoNoticePage.todoNoticeInputFormFieldKey))
            .initialValue,
        '',
        reason: 'TodoNoticeの入力フォームの初期値が空で表示されること',
      );
    });

    testWidgets('TodoNoticeのSubmitボタン', (tester) async {
      await bootstrap(tester);
      expect(
        ((evaluateWidget<ElevatedButton>(
                    find.byKey(TodoNoticePage.todoNoticeSubmitButtonKey))
                .child) as Text)
            .data,
        '振り返りを記録する',
        reason: 'TodoNoticeのSubmitボタンに「振り返りを記録する」と表示されること',
      );
    });
  });
}
