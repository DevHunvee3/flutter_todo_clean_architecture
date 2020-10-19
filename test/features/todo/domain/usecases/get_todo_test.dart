import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo/features/todo/domain/entities/todo_entity.dart';
import 'package:todo/features/todo/domain/repositories/todo_repository_interface.dart';
import 'package:todo/features/todo/domain/usecases/get_todo.dart';
import 'package:todo/features/todo/domain/usecases/use_case_interface.dart';

class MockTodoRepository extends Mock implements ITodoRepository {}

main() {
  ITodoRepository repository;
  IUseCase useCase;
  setUp(() {
    repository = MockTodoRepository();
    useCase = GetTodo(repository: repository);
  });

  final tTodoEntity = TodoEntity(id: 1, title: "todo", completed: false);

  test(
    'Should return a TodoEntity from repository by id',
    () async {
      //arrange
      when(repository.getTodo(id: anyNamed('id')))
          .thenAnswer((_) async => Right(tTodoEntity));
      //act
      final result = await useCase(GetTodoParams(id: 1));
      //assert
      expect(result, Right(tTodoEntity));
      verify(repository.getTodo(id: 1));
      verifyNoMoreInteractions(repository);
    },
  );
}
