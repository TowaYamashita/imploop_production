import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:imploop/domain/task_type.dart';
import 'package:imploop/page/task_list/task/recommendation_task_type_input_form.dart';
import 'package:imploop/page/task_list/task/task_edit_modal.dart';
import 'package:imploop/service/task_type_service.dart';
import 'package:mockito/mockito.dart';
import '../../../mock/mock_task.dart';
import '../../../mock/service/mock_service.dart';
import '../../../widget_test_util.dart';

const _mockTaskType = TaskType(
  taskTypeId: -1,
  name: 'dummyTaskTypeName',
);

void main() {
  /// テスト対象の画面を起動する処理
  bootstrap(WidgetTester tester) async {
    final _mockTaskTypeService = mockTaskTypeService;
    when(_mockTaskTypeService.get(-1))
        .thenAnswer((_) => Future.value(_mockTaskType));
    await tester.pumpWidget(ProviderScope(
      overrides: [
        selectedTaskTypeProvider.overrideWithValue(StateController(null)),
        taskTypeServiceProvider
            .overrideWithValue(StateController(_mockTaskTypeService)),
      ],
      child: MaterialApp(
        home: TaskEditModal(
          task: mockTask,
        ),
      ),
    ));
  }

  group('初期表示', () {
    testWidgets('AppBar', (tester) async {
      await bootstrap(tester);
      expect(
        find.byKey(TaskEditModal.appBarKey),
        findsOneWidget,
        reason: 'AppBarが表示されること',
      );
    });
    testWidgets('入力フォーム', (tester) async {
      await bootstrap(tester);
      expect(
        evaluateWidget<TextFormField>(find.byKey(TaskEditModal.taskNameFormKey))
            .initialValue,
        'dummy',
        reason: 'Taskの名前の入力フォームがdummyと表示された状態で表示されること',
      );
      expect(
        find.byKey(TaskEditModal.recommendationTaskTypeInputFormKey),
        findsOneWidget,
        reason: 'TaskTypeの入力フォームが表示されること',
      );
      expect(
        (evaluateWidget<ElevatedButton>(
                    find.byKey(TaskEditModal.submitButtonKey))
                .child as Text)
            .data,
        '変更する',
        reason: '変更すると書かれたボタンが表示されること',
      );
    });
  });
}
