import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:imploop/page/task_list/todo/recommendation_todo_type_input_form.dart';
import 'package:imploop/page/task_list/todo/todo_create_modal.dart';

import '../../../mock/mock_task.dart';
import '../../../widget_test_util.dart';

void main() {
  /// テスト対象の画面を起動する処理
  bootstrap(WidgetTester tester) async {
    await tester.pumpWidget(ProviderScope(
      overrides: [
        selectedTodoTypeProvider.overrideWithValue(StateController(null))
      ],
      child: MaterialApp(
        home: TodoCreateModal(
          task: mockTask,
        ),
      ),
    ));
  }

  group('初期表示', () {
    testWidgets('AppBar', (tester) async {
      await bootstrap(tester);
      expect(
        (evaluateWidget<AppBar>(find.byKey(TodoCreateModal.appBarKey)).title
                as Text)
            .data,
        'Todo入力',
        reason: 'AppBarのtitleに「Todo入力」と表示されること',
      );
    });
    testWidgets('過去の振り返り', (tester) async {
      await bootstrap(tester);
      expect(
        find.byKey(TodoCreateModal.todoNoticeCarouselViewKey),
        findsOneWidget,
        reason: 'Todoの過去の振り返りが表示されること',
      );
    });
    testWidgets('入力フォーム', (tester) async {
      await bootstrap(tester);
      expect(
        evaluateWidget<TextFormField>(
                find.byKey(TodoCreateModal.todoNameFormKey))
            .initialValue,
        '',
        reason: 'Todoの名前の入力フォームが空の状態で表示されること',
      );
      expect(
        evaluateWidget<TextFormField>(
                find.byKey(TodoCreateModal.todoEstimateFormKey))
            .initialValue,
        '',
        reason: 'Todoの見積もり時間の入力フォームが空の状態で表示されること',
      );
      expect(
        find.byKey(TodoCreateModal.recommendationTodoTypeInputFormKey),
        findsOneWidget,
        reason: 'TodoTypeの入力フォームが表示されること',
      );
      expect(
        (evaluateWidget<ElevatedButton>(
                    find.byKey(TodoCreateModal.submitButtonKey))
                .child as Text)
            .data,
        '登録する',
        reason: '登録すると書かれたボタンが表示されること',
      );
    });
  });
}
