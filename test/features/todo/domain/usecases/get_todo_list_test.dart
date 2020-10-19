import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo/features/todo/domain/entities/todo_entity.dart';
import 'package:todo/features/todo/domain/repositories/todo_repository_interface.dart';
import 'package:todo/features/todo/domain/usecases/get_todo_list.dart';
import 'package:todo/features/todo/domain/usecases/use_case_interface.dart';

class MockTodoRepository extends Mock implements ITodoRepository {}

main() {
  IUseCase useCase;
  ITodoRepository repository;

  setUp(() {
    repository = MockTodoRepository();
    useCase = GetTodoList(repository: repository);
  });

  final List<TodoEntity> tTodoList = [
    TodoEntity(id: 1, title: "todo", completed: false)
  ];
  final List<TodoEntity> tCompletedTodoList = [
    TodoEntity(id: 1, title: "todo", completed: true),
    TodoEntity(id: 2, title: "todo", completed: true),
    TodoEntity(id: 3, title: "todo", completed: true)
  ];

  test(
    'Should return a List<TodoEntity> from the repository',
    () async {
      //arrange
      when(repository.getTodoList(completed: anyNamed('completed')))
          .thenAnswer((_) async => Right(tTodoList));
      //act
      final result = await useCase(GetTodoListParams());
      //assert
      expect(result, Right(tTodoList));
      verify(repository.getTodoList(completed: null));
      verifyNoMoreInteractions(repository);
    },
  );

  test(
    'Should return a List<TodoEntity> from the repository with only completed TodoEntity',
    () async {
      //arrange
      when(repository.getTodoList(completed: anyNamed('completed')))
          .thenAnswer((_) async => Right(tCompletedTodoList));
      //act
      final results = await useCase(GetTodoListParams(completed: true));
      //assert
      expect(results, Right(tCompletedTodoList));
      verify(repository.getTodoList(completed: true));
      verifyNoMoreInteractions(repository);
    },
  );
}
