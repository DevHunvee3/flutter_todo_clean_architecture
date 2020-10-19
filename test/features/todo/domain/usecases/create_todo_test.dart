import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo/features/todo/domain/entities/todo_entity.dart';
import 'package:todo/features/todo/domain/repositories/todo_repository_interface.dart';
import 'package:todo/features/todo/domain/usecases/create_todo.dart';
import 'package:todo/features/todo/domain/usecases/use_case_interface.dart';

class MockTodoRepository extends Mock implements ITodoRepository {}

main() {
  ITodoRepository repository;
  IUseCase useCase;

  setUp(() {
    repository = MockTodoRepository();
    useCase = CreateTodo(repository: repository);
  });

  final TodoEntity tTodoEntity =
      TodoEntity(id: 1, title: 'todo', completed: false);
  test(
    'Should a new TodoEntity from the repository',
    () async {
      //arrange
      when(repository.createTodo(title: anyNamed('title')))
          .thenAnswer((_) async => Right(tTodoEntity));
      //act
      final result = await useCase(CreateTodoParams(title: 'todo'));
      //assert
      expect(result, Right(tTodoEntity));
      verify(repository.createTodo(title: 'todo'));
      verifyNoMoreInteractions(repository);
    },
  );
}
