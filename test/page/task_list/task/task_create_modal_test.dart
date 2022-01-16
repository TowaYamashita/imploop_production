import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:imploop/page/task_list/task/recommendation_task_type_input_form.dart';
import 'package:imploop/page/task_list/task/task_create_modal.dart';

import '../../../widget_test_util.dart';

void main() {
  /// テスト対象の画面を起動する処理
  bootstrap(WidgetTester tester) async {
    await tester.pumpWidget(ProviderScope(
      overrides: [
        selectedTaskTypeProvider.overrideWithValue(StateController(null))
      ],
      child: MaterialApp(
        home: TaskCreateModal(),
      ),
    ));
  }

  group('初期表示', () {
    testWidgets('AppBar', (tester) async {
      await bootstrap(tester);
      expect(
        (evaluateWidget<AppBar>(find.byKey(TaskCreateModal.appBarKey)).title
                as Text)
            .data,
        'Task入力',
        reason: 'AppBarのtitleに「Task入力」と表示されること',
      );
    });
    testWidgets('過去の振り返り', (tester) async {
      await bootstrap(tester);
      expect(
        find.byKey(TaskCreateModal.taskNoticeCarouselViewKey),
        findsOneWidget,
        reason: 'Taskの過去の振り返りが表示されること',
      );
    });
    testWidgets('入力フォーム', (tester) async {
      await bootstrap(tester);
      expect(
        evaluateWidget<TextFormField>(
                find.byKey(TaskCreateModal.taskNameFormKey))
            .initialValue,
        '',
        reason: 'Taskの名前の入力フォームが初期値空の状態で表示されること',
      );
      expect(
        find.byKey(TaskCreateModal.recommendationTaskTypeInputFormKey),
        findsOneWidget,
        reason: 'TaskTypeの入力フォームが表示されること',
      );
      expect(
        (evaluateWidget<ElevatedButton>(
                    find.byKey(TaskCreateModal.submitButtonKey))
                .child as Text)
            .data,
        '登録する',
        reason: '登録すると書かれたボタンが表示されること',
      );
    });
  });
}
