import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo/features/todo/domain/entities/todo_entity.dart';
import 'package:todo/features/todo/domain/repositories/todo_repository_interface.dart';
import 'package:todo/features/todo/domain/usecases/edit_todo.dart';
import 'package:todo/features/todo/domain/usecases/use_case_interface.dart';

class MockTodoRepository extends Mock implements ITodoRepository {}

main() {
  IUseCase useCase;
  ITodoRepository repository;

  setUp(() {
    repository = MockTodoRepository();
    useCase = EditTodo(repository: repository);
  });

  final TodoEntity tEditedTodoEntity =
      TodoEntity(id: 1, title: 'todo edit', completed: false);
  test(
    'Should edit the title of a Todo Entity and return it from the repository',
    () async {
      //arrange
      when(repository.editTodo(id: anyNamed('id'), todo: anyNamed('todo')))
          .thenAnswer((_) async => Right(tEditedTodoEntity));
      //act
      final result =
          await useCase(EditTodoParams(id: 1, todo: tEditedTodoEntity));
      //assert
      expect(result, Right(tEditedTodoEntity));
      verify(repository.editTodo(id: 1, todo: tEditedTodoEntity));
      verifyNoMoreInteractions(repository);
    },
  );
}
