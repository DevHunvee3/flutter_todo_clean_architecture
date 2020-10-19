import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo/core/errors/failures.dart';
import 'package:todo/core/errors/failures_interface.dart';
import 'package:todo/features/todo/domain/entities/todo_entity.dart';
import 'package:todo/features/todo/domain/usecases/create_todo.dart';
import 'package:todo/features/todo/domain/usecases/edit_todo.dart';
import 'package:todo/features/todo/domain/usecases/get_todo.dart';
import 'package:todo/features/todo/domain/usecases/use_case_interface.dart';
import 'package:todo/features/todo/presentation/bloc/todo_form/todo_form_bloc.dart';
import 'package:todo/features/todo/presentation/bloc/todo_form/todo_form_errors.dart';

class MockGetTodoUseCase extends Mock implements GetTodo {}

class MockCreateTodoUseCase extends Mock implements CreateTodo {}

class MockEditTodoUseCase extends Mock implements EditTodo {}

main() {
  IUseCase getTodo;
  IUseCase createTodo;
  IUseCase editTodo;
  TodoFormBloc bloc;
  setUp(() {
    getTodo = MockGetTodoUseCase();
    createTodo = MockCreateTodoUseCase();
    editTodo = MockEditTodoUseCase();
    bloc = TodoFormBloc(
        getTodo: getTodo, createTodo: createTodo, editTodo: editTodo);
  });

  final tTodoEntity = TodoEntity(id: 1, title: 'todo', completed: false);
  test(
    'Initial state should be EmptyTodoForm',
    () async {
      final result = bloc.state;
      expect(result, EmptyTodo());
    },
  );

  group('GetTodo', () {
    test(
      'Should emit [LoadingTodo, LoadedTodo] state when data is fetched successfully',
      () async {
        when(getTodo(any))
            .thenAnswer((_) async => Right<IFailure, TodoEntity>(tTodoEntity));

        final expected = [
          LoadingTodo(),
          LoadedTodo(todo: tTodoEntity),
        ];

        expectLater(bloc, emitsInOrder(expected));

        bloc.add(GetTodoEvent(id: tTodoEntity.id));
      },
    );
    test(
      'Should emit [LoadingTodo, Error] state when fetching data fails due to DBFailure',
      () async {
        when(getTodo(any))
            .thenAnswer((_) async => Left<IFailure, TodoEntity>(DBFailure()));

        final expected = [
          LoadingTodo(),
          Error(message: DB_FAILURE_MESSAGE),
        ];

        expectLater(bloc, emitsInOrder(expected));

        bloc.add(GetTodoEvent(id: tTodoEntity.id));
      },
    );
    test(
      'Should emit [LoadingTodo, Error] state when fetching data fails due to DBResourceNotFoundFailure',
      () async {
        when(getTodo(any)).thenAnswer((_) async =>
            Left<IFailure, TodoEntity>(DBResourceNotFoundFailure()));

        final expected = [
          LoadingTodo(),
          Error(message: DB_RESOURCE_NOT_FOUND_MESSAGE),
        ];

        expectLater(bloc, emitsInOrder(expected));

        bloc.add(GetTodoEvent(id: tTodoEntity.id));
      },
    );
    test(
      'Should emit [LoadingTodo, Error] state when fetching data fails due to ServerFailure',
      () async {
        when(getTodo(any)).thenAnswer(
            (_) async => Left<IFailure, TodoEntity>(ServerFailure()));

        final expected = [
          LoadingTodo(),
          Error(message: UNKNOWN_FAILURE),
        ];

        expectLater(bloc, emitsInOrder(expected));

        bloc.add(GetTodoEvent(id: tTodoEntity.id));
      },
    );
  });
  group('CreateTodo', () {
    test(
      'Should emit [SubmittingForm, LoadedTodo] when data is sent and the todo is created successfully',
      () {
        //arrange
        when(createTodo(any))
            .thenAnswer((_) async => Right<IFailure, TodoEntity>(tTodoEntity));
        //assert
        final expected = [
          SubmittingTodoForm(),
          LoadedTodo(todo: tTodoEntity),
        ];

        expectLater(bloc, emitsInOrder(expected));
        //act
        bloc.add(CreateTodoEvent(title: tTodoEntity.title));
      },
    );
    test(
      'Should emit [SubmittingForm, Error] when data is sent but fails due to a DBFailure',
      () {
        //arrange
        when(createTodo(any))
            .thenAnswer((_) async => Left<IFailure, TodoEntity>(DBFailure()));
        //assert
        final expected = [
          SubmittingTodoForm(),
          Error(message: DB_FAILURE_MESSAGE)
        ];

        expectLater(bloc, emitsInOrder(expected));
        //act
        bloc.add(CreateTodoEvent(title: tTodoEntity.title));
      },
    );
    test(
      'Should emit [SubmittingForm, Error] when data is sent but fails due to a ServerFailure',
      () {
        //arrange
        when(createTodo(any)).thenAnswer(
            (_) async => Left<IFailure, TodoEntity>(ServerFailure()));
        //assert
        final expected = [
          SubmittingTodoForm(),
          Error(message: UNKNOWN_FAILURE)
        ];

        expectLater(bloc, emitsInOrder(expected));
        //act
        bloc.add(CreateTodoEvent(title: tTodoEntity.title));
      },
    );
  });

  group('EditTodo', () {
    test(
      'Should emit [SubmittingForm, LoadedTodo] when data is sent and the todo is created successfully',
      () {
        //arrange
        when(editTodo(any))
            .thenAnswer((_) async => Right<IFailure, TodoEntity>(tTodoEntity));
        //assert
        final expected = [
          SubmittingTodoForm(),
          LoadedTodo(todo: tTodoEntity),
        ];

        expectLater(bloc, emitsInOrder(expected));
        //act
        bloc.add(EditTodoEvent(id: tTodoEntity.id, todo: tTodoEntity));
      },
    );
    test(
      'Should emit [SubmittingForm, Error] when data is sent but fails due to a DBFailure',
      () {
        //arrange
        when(editTodo(any))
            .thenAnswer((_) async => Left<IFailure, TodoEntity>(DBFailure()));
        //assert
        final expected = [
          SubmittingTodoForm(),
          Error(message: DB_FAILURE_MESSAGE)
        ];

        expectLater(bloc, emitsInOrder(expected));
        //act
        bloc.add(EditTodoEvent(id: tTodoEntity.id, todo: tTodoEntity));
      },
    );
    test(
      'Should emit [SubmittingForm, Error] when data is sent but fails due to a DBResourceNotFoundFailure',
      () {
        //arrange
        when(editTodo(any)).thenAnswer(
            (_) async => Left<IFailure, TodoEntity>(ServerFailure()));
        //assert
        final expected = [
          SubmittingTodoForm(),
          Error(message: DB_RESOURCE_NOT_FOUND_MESSAGE)
        ];

        expectLater(bloc, emitsInOrder(expected));
        //act
        bloc.add(EditTodoEvent(id: tTodoEntity.id, todo: tTodoEntity));
      },
    );
    test(
      'Should emit [SubmittingForm, Error] when data is sent but fails due to a ServerFailure',
      () {
        //arrange
        when(editTodo(any)).thenAnswer(
            (_) async => Left<IFailure, TodoEntity>(ServerFailure()));
        //assert
        final expected = [
          SubmittingTodoForm(),
          Error(message: UNKNOWN_FAILURE)
        ];

        expectLater(bloc, emitsInOrder(expected));
        //act
        bloc.add(EditTodoEvent(id: tTodoEntity.id, todo: tTodoEntity));
      },
    );
  });
}
