import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:imploop/domain/todo.dart';
import 'package:imploop/page/timer/timer_page.dart';
import 'package:imploop/service/task_service.dart';
import 'package:mockito/mockito.dart';

import '../../mock/mock_task.dart';
import '../../mock/mock_todo.dart' as mock;
import '../../mock/service/mock_service.dart';
import '../../widget_test_util.dart';

void main() {
  final _mockTaskService = mockTaskService;

  /// テスト対象の画面を起動する処理
  bootstrap(
    WidgetTester tester,
    Todo? mockTodo, {
    bool existsTask = true,
  }) async {
    when(_mockTaskService.getAllTaskWithoutFinished())
        .thenAnswer((_) => Future.value(existsTask ? [mockTask] : []));
    when(_mockTaskService.getAllTodoWithoutFinishedInTask(-1))
        .thenAnswer((_) => Future.value([mock.mockTodo]));
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          selectedTodoProvider.overrideWithValue(
            StateController(mockTodo),
          ),
          taskServiceProvider.overrideWithValue(
            StateController(_mockTaskService),
          ),
        ],
        child: const MaterialApp(
          home: TimerPage(),
        ),
      ),
    );
  }

  group('共通', () {
    testWidgets('AppBar', (tester) async {
      for (var t in [mock.mockTodo, null]) {
        final selectedTodoStatus = t != null ? 'Todo選択' : 'Todo未選択';
        await bootstrap(tester, t);
        expect(
          (evaluateWidget<AppBar>(find.byKey(TimerPage.appBarKey)).title
                  as Text)
              .data,
          'タイマー',
          reason: '$selectedTodoStatus: AppBarのtitleに「タイマー」と表示されること',
        );
      }
    });

    testWidgets('AppBarの戻るボタン', (tester) async {
      for (var t in [mock.mockTodo, null]) {
        final selectedTodoStatus = t != null ? 'Todo選択' : '未Todo選択';
        await bootstrap(tester, t);
        expect(
          evaluateWidget<AppBar>(find.byKey(TimerPage.appBarKey))
              .automaticallyImplyLeading,
          isFalse,
          reason: '$selectedTodoStatus: AppBarの戻るボタンが削除されていること',
        );
      }
    });

    testWidgets('タイマー', (tester) async {
      for (var t in [mock.mockTodo, null]) {
        final selectedTodoStatus = t != null ? 'Todo選択' : 'Todo未選択';
        await bootstrap(tester, t);
        expect(
          find.byKey(TimerPage.timerKey),
          findsOneWidget,
          reason: '$selectedTodoStatus: タイマーが表示されていること',
        );
      }
    });

    testWidgets('タイマーの開始ボタン', (tester) async {
      for (var t in [mock.mockTodo, null]) {
        final selectedTodoStatus = t != null ? 'Todo選択' : 'Todo未選択';
        await bootstrap(tester, t);
        expect(
          find.byKey(TimerPage.timerStartButtonKey),
          findsOneWidget,
          reason: '$selectedTodoStatus: タイマーの開始ボタンが表示されていること',
        );
      }
    });

    testWidgets('タイマーの停止ボタン', (tester) async {
      for (var t in [mock.mockTodo, null]) {
        final selectedTodoStatus = t != null ? 'Todo選択' : 'Todo未選択';
        await bootstrap(tester, t);
        expect(
          find.byKey(TimerPage.timerStopButtonKey),
          findsOneWidget,
          reason: '$selectedTodoStatus: タイマーの停止ボタンが表示されていること',
        );
      }
    });

    testWidgets('タイマーのリセットボタン', (tester) async {
      for (var t in [mock.mockTodo, null]) {
        final selectedTodoStatus = t != null ? 'Todo選択' : 'Todo未選択';
        await bootstrap(tester, t);
        expect(
          find.byKey(TimerPage.timerResetButtonKey),
          findsOneWidget,
          reason: '$selectedTodoStatus: タイマーのリセットボタンが表示されていること',
        );
      }
    });
  });

  group('Todoが選択されていない場合', () {
    testWidgets('Todoを選択できるボタン', (tester) async {
      await bootstrap(tester, null);

      expect(
        (evaluateWidget<ElevatedButton>(
                    find.byKey(TimerPage.buttonToSelectTodoKey))
                .child as Text)
            .data,
        'やるtodoを選択する',
        reason: 'Todoを選択できるボタンに「やるtodoを選択する」と表示されていること',
      );
    });

    group('完了状態ではないTaskが存在する場合', () {
      testWidgets('Taskを選択するダイアログのヘッダー', (tester) async {
        await bootstrap(tester, null);
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(TimerPage.buttonToSelectTodoKey));
        await tester.pumpAndSettle();

        expect(
          (evaluateWidget<SimpleDialog>(
                      find.byKey(TaskSelectorDialog.selectableTodoDialogKey))
                  .title as Text)
              .data,
          'Todoを選択',
          reason: 'Todoを選択できるボタンを押下すると「Todoを選択」とヘッダーに書かれたダイアログが表示されること',
        );
      });

      testWidgets('Taskを選択するダイアログのコンテンツ', (tester) async {
        await bootstrap(tester, null);
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(TimerPage.buttonToSelectTodoKey));
        await tester.pumpAndSettle();

        expect(
          (evaluateWidget<ListTile>(
                      find.byKey(SimpleDialogTaskListTile.taskTileKey).first)
                  .title as Text)
              .data,
          'dummy',
          reason: 'Todoを選択できるボタンを押下すると「dummy」と書かれたListTileがダイアログの中に表示されること',
        );
      });

      testWidgets('Taskに属するTodoの名前を表示するListTile', (tester) async {
        await bootstrap(tester, null);
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(TimerPage.buttonToSelectTodoKey));
        await tester.pumpAndSettle();
        await tester
            .tap(find.byKey(SimpleDialogTaskListTile.taskTileKey).first);
        await tester.pumpAndSettle();

        expect(
          (evaluateWidget<ListTile>(
                      find.byKey(SimpleDialogTodoListTile.todoTileKey).first)
                  .title as Text)
              .data,
          'dummyTodo',
          reason:
              '「dummy」と書かれたListTileをタップすると「dummyTodo」と書かれたListTileがダイアログの中に表示されること',
        );
      });
    });
    group('完了状態ではないTaskが存在しない場合', () {
      testWidgets('Taskを選択するダイアログのヘッダー', (tester) async {
        await bootstrap(tester, null, existsTask: false);
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(TimerPage.buttonToSelectTodoKey));
        await tester.pumpAndSettle();

        expect(
          (evaluateWidget<AlertDialog>(
                      find.byKey(TaskSelectorDialog.emptyDialogKey))
                  .title as Text)
              .data,
          '選択できるTaskがありません',
          reason: 'Todoを選択できるボタンを押下すると「選択できるTaskがありません」とヘッダーに書かれたダイアログが表示されること',
        );
      });

      testWidgets('Taskを選択するダイアログのコンテンツ', (tester) async {
        await bootstrap(tester, null, existsTask: false);
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(TimerPage.buttonToSelectTodoKey));
        await tester.pumpAndSettle();

        expect(
          ((evaluateWidget<AlertDialog>(
                      find.byKey(TaskSelectorDialog.emptyDialogKey))
                  .content as ElevatedButton)
              .child as Text).data,
          'Taskを作成する',
          reason: 'Todoを選択できるボタンを押下すると「Taskを作成する」と書かれたボタンがダイアログの中に表示されること',
        );
      });
    });
  });
  group('Todoが選択されている場合', () {
    testWidgets('選択したTodoの名前が表示されるボタン', (tester) async {
      await bootstrap(tester, mock.mockTodo);
      expect(
        find.descendant(
          of: find.byKey(TimerPage.buttonToFinishTodoKey),
          matching: find.text('dummyTodoを完了させる'),
        ),
        findsOneWidget,
        reason: '「dummyTodoを完了させる」と書かれたボタンが表示されていること',
      );
    });

    testWidgets('選択したTodoをキャンセルできるボタン', (tester) async {
      await bootstrap(tester, mock.mockTodo);
      expect(
        find.descendant(
          of: find.byKey(TimerPage.buttonToFinishTodoKey),
          matching: find.byKey(TimerPage.buttonToCancelTodoKey),
        ),
        findsOneWidget,
        reason: '選択したTodoをキャンセルできるボタンが表示されていること',
      );
    });
  });
}
