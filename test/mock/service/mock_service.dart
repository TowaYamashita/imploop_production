import 'package:imploop/service/task_notice_service.dart';
import 'package:imploop/service/task_service.dart';
import 'package:imploop/service/task_type_service.dart';
import 'package:imploop/service/todo_notice_service.dart';
import 'package:imploop/service/todo_service.dart';
import 'package:imploop/service/todo_type_service.dart';
import 'package:mockito/annotations.dart';
import 'mock_service.mocks.dart';

@GenerateMocks([
  TaskNoticeService,
  TaskService,
  TaskTypeService,
  TodoNoticeService,
  TodoService,
  TodoTypeService
])
void main() {}

final mockTaskNoticeService = MockTaskNoticeService();
final mockTaskService = MockTaskService();
final mockTaskTypeService = MockTaskTypeService();
final mockTodoNoticeService = MockTodoNoticeService();
final mockTodoService = MockTodoService();
final mockTodoTypeService = MockTodoTypeService();