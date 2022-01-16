import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:imploop/domain/todo_type.dart';
import 'package:imploop/page/task_list/todo/recommendation_todo_type_input_form.dart';
import 'package:imploop/page/task_list/todo/todo_edit_modal.dart';
import 'package:imploop/service/todo_type_service.dart';
import 'package:mockito/mockito.dart';
import '../../../mock/mock_todo.dart';
import '../../../mock/service/mock_service.dart';
import '../../../widget_test_util.dart';

const _mockTodoType = TodoType(
  todoTypeId: -1,
  name: 'dummyTodoTypeName',
);

void main() {
  /// テスト対象の画面を起動する処理
  bootstrap(WidgetTester tester) async {
    final _mockTodoTypeService = mockTodoTypeService;
    when(_mockTodoTypeService.get(-1))
        .thenAnswer((_) => Future.value(_mockTodoType));
    await tester.pumpWidget(ProviderScope(
      overrides: [
        selectedTodoTypeProvider.overrideWithValue(StateController(null)),
        todoTypeServiceProvider
            .overrideWithValue(StateController(_mockTodoTypeService)),
      ],
      child: MaterialApp(
        home: TodoEditModal(
          todo: mockTodo,
        ),
      ),
    ));
  }

  group('初期表示', () {
    testWidgets('AppBar', (tester) async {
      await bootstrap(tester);
      expect(
        find.byKey(TodoEditModal.appBarKey),
        findsOneWidget,
        reason: 'AppBarが表示されること',
      );
    });
    testWidgets('入力フォーム', (tester) async {
      await bootstrap(tester);
      expect(
        evaluateWidget<TextFormField>(find.byKey(TodoEditModal.todoNameFormKey))
            .initialValue,
        mockTodo.name,
        reason: 'Todoの名前の入力フォームにdummyTodoと表示されること',
      );
      expect(
        evaluateWidget<TextFormField>(find.byKey(TodoEditModal.todoEstimateFormKey))
            .initialValue,
        mockTodo.estimate.toString(),
        reason: 'Todoの見積もり時間の入力フォームが100と表示されること',
      );
      expect(
        find.byKey(TodoEditModal.recommendationTodoTypeInputFormKey),
        findsOneWidget,
        reason: 'TodoTypeの入力フォームが表示されること',
      );
      expect(
        (evaluateWidget<ElevatedButton>(
                    find.byKey(TodoEditModal.submitButtonKey))
                .child as Text)
            .data,
        '変更する',
        reason: '変更すると書かれたボタンが表示されること',
      );
    });
  });
}
