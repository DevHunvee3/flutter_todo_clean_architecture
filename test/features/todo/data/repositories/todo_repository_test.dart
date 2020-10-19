import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo/core/errors/exceptions.dart';
import 'package:todo/core/errors/failures.dart';
import 'package:todo/features/todo/data/datasources/datasource_interface.dart';
import 'package:todo/features/todo/data/models/todo_model.dart';
import 'package:todo/features/todo/data/repositories/todo_repository.dart';
import 'package:todo/features/todo/domain/repositories/todo_repository_interface.dart';

class MockDataSource extends Mock implements IDataSource {}

main() {
  IDataSource dataSource;
  ITodoRepository repository;
  setUp(() {
    dataSource = MockDataSource();
    repository = TodoRepository(dataSource: dataSource);
  });
  final tTodoId = 1;
  final tTodoModel = TodoModel(id: tTodoId, title: 'todo', completed: false);
  final List<TodoModel> tTodoList = [
    TodoModel(id: 1, title: "todo1", completed: true),
    TodoModel(id: 2, title: "todo2", completed: false),
    TodoModel(id: 3, title: "todo3", completed: true)
  ];
  final List<TodoModel> tCompleteTodoList = [
    TodoModel(id: 1, title: "todo1", completed: true),
    TodoModel(id: 2, title: "todo2", completed: true),
    TodoModel(id: 3, title: "todo3", completed: true)
  ];

  group('getTodo', () {
    test(
      'Should return a TodoEntity when the call to datasource is successful',
      () async {
        //arrange
        when(dataSource.getTodo(any)).thenAnswer((_) async => tTodoModel);
        //act
        final result = await repository.getTodo(id: tTodoId);
        //assert
        verify(dataSource.getTodo(tTodoId));
        expect(result, Right(tTodoModel));
      },
    );

    test(
      'Should return a DBResourceNotFoundFailure when the resource doesnt exist',
      () async {
        //arrange
        when(dataSource.getTodo(any)).thenThrow(DBResourceNotFoundException());
        //act
        final result = await repository.getTodo(id: tTodoId);
        //assert
        verify(dataSource.getTodo(tTodoId));
        verifyNoMoreInteractions(dataSource);
        expect(result, Left(DBResourceNotFoundFailure()));
      },
    );

    test(
      'Should return a DBFailure when the datasource fails due to a DBConnectionException',
      () async {
        //arrange
        when(dataSource.getTodo(any)).thenThrow(DBConnectionException());
        //act
        final result = await repository.getTodo(id: tTodoId);
        //assert
        verify(dataSource.getTodo(tTodoId));
        verifyNoMoreInteractions(dataSource);
        expect(result, Left(DBFailure()));
      },
    );

    test(
      'Should return a DBFailure when the datasource fails due to any other Exception',
      () async {
        //arrange
        when(dataSource.getTodo(any)).thenThrow(Exception());
        //act
        final result = await repository.getTodo(id: tTodoId);
        //assert
        verify(dataSource.getTodo(tTodoId));
        verifyNoMoreInteractions(dataSource);
        expect(result, Left(DBFailure()));
      },
    );
  });

  group('getTodoList', () {
    test(
      'Should return a List<TodoEntity> from the datasource when the call is successful',
      () async {
        //arrange
        when(dataSource.getTodoList(any)).thenAnswer((_) async => tTodoList);
        //act
        final result = await repository.getTodoList();
        //assert
        verify(dataSource.getTodoList(any));
        expect(result, Right(tTodoList));
      },
    );
    test(
      'Should return a List of TodoModels from datasource with all models being completed',
      () async {
        //arrange
        when(dataSource.getTodoList(any))
            .thenAnswer((_) async => tCompleteTodoList);
        //act
        final result = await repository.getTodoList(completed: true);
        //assert
        verify(dataSource.getTodoList(true));
        expect(result, Right(tCompleteTodoList));
      },
    );
    test(
      'Should return a DBFailure when the query to the datasource fails due to any other Exception',
      () async {
        //arrange
        when(dataSource.getTodoList(any)).thenThrow(Exception());
        //act
        final result = await repository.getTodoList();
        //assert
        verify(dataSource.getTodoList(any));
        verifyNoMoreInteractions(dataSource);
        expect(result, Left(DBFailure()));
      },
    );
    test(
      'Should return a DBFailure when the call to de datasource fails due to DBConnectionException',
      () async {
        //arrange
        when(dataSource.getTodoList(any)).thenThrow(DBConnectionException());
        //act
        final result = await repository.getTodoList();
        //assert
        verify(dataSource.getTodoList(any));
        verifyNoMoreInteractions(dataSource);
        expect(result, Left(DBFailure()));
      },
    );
  });

  group('createTodo', () {
    test(
      'Should return a TodoEntity with the same data that was sent',
      () async {
        //arrange
        when(dataSource.createTodo(any)).thenAnswer((_) async => tTodoModel);
        //act
        final result = await repository.createTodo(title: tTodoModel.title);
        //assert
        verify(dataSource.createTodo(any));
        expect(result, Right(tTodoModel));
      },
    );
    test(
      'Should return a DBFailure when call to dataSource fails due to any other Exception',
      () async {
        //arrange
        when(dataSource.createTodo(any)).thenThrow(Exception());
        //act
        final result = await repository.createTodo(title: 'todo');
        //assert
        verify(dataSource.createTodo(any));
        verifyNoMoreInteractions(dataSource);
        expect(result, Left(DBFailure()));
      },
    );
    test(
      'Should return a DBFailure when call to dataSource fails due to a DBConnectionException',
      () async {
        //arrange
        when(dataSource.createTodo(any)).thenThrow(DBConnectionException());
        //act
        final result = await repository.createTodo(title: 'todo');
        //assert
        verify(dataSource.createTodo(any));
        verifyNoMoreInteractions(dataSource);
        expect(result, Left(DBFailure()));
      },
    );
  });
  group('editTodo', () {
    test(
      'Should return a TodoEntity with the same data that was sent',
      () async {
        //arrange
        when(dataSource.editTodo(any, any)).thenAnswer((_) async => tTodoModel);
        //act
        final result =
            await repository.editTodo(id: tTodoModel.id, todo: tTodoModel);
        //assert
        verify(dataSource.editTodo(any, any));
        expect(result, Right(tTodoModel));
      },
    );
    test(
      'Should return a DBResourceNotFoundFailure when the resource to edit doesnt exist',
      () async {
        //arrange
        when(dataSource.editTodo(any, any))
            .thenThrow(DBResourceNotFoundException());
        //act
        final result =
            await repository.editTodo(id: tTodoModel.id, todo: tTodoModel);
        //assert
        verify(dataSource.editTodo(any, any));
        verifyNoMoreInteractions(dataSource);
        expect(result, Left(DBResourceNotFoundFailure()));
      },
    );
    test(
      'Should return a DBFailure when query to the datasource fails due to any other Exception',
      () async {
        //arrange
        when(dataSource.editTodo(any, any)).thenThrow(Exception());
        //act
        final result =
            await repository.editTodo(id: tTodoModel.id, todo: tTodoModel);
        //assert
        verify(dataSource.editTodo(any, any));
        verifyNoMoreInteractions(dataSource);
        expect(result, Left(DBFailure()));
      },
    );
    test(
      'Should return a DBFailure when query to the datasource fails due to a DBConnectionException',
      () async {
        //arrange
        when(dataSource.editTodo(any, any)).thenThrow(DBConnectionException());
        //act
        final result =
            await repository.editTodo(id: tTodoModel.id, todo: tTodoModel);
        //assert
        verify(dataSource.editTodo(any, any));
        verifyNoMoreInteractions(dataSource);
        expect(result, Left(DBFailure()));
      },
    );
  });
}
