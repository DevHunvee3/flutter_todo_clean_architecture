import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo/core/errors/failures.dart';
import 'package:todo/core/errors/failures_interface.dart';
import 'package:todo/features/todo/domain/entities/todo_entity.dart';
import 'package:todo/features/todo/domain/usecases/get_todo_list.dart';
import 'package:todo/features/todo/domain/usecases/use_case_interface.dart';
import 'package:todo/features/todo/presentation/bloc/todo_list/todo_list_bloc.dart';
import 'package:todo/features/todo/presentation/bloc/todo_list/todo_list_errors.dart';

class MockGetTodoListUseCase extends Mock implements GetTodoList {}

main() {
  IUseCase getTodoList;
  TodoListBloc bloc;
  setUp(() {
    getTodoList = MockGetTodoListUseCase();
    bloc = TodoListBloc(getTodoList: getTodoList);
  });

  group('GetTodoList', () {
    final List<TodoEntity> tTodoList = [
      TodoEntity(id: 1, title: 'todo1', completed: false),
      TodoEntity(id: 2, title: 'todo2', completed: true),
    ];
    test(
      'Initial state should be EmptyTodoList',
      () async {
        final result = bloc.state;
        expect(result, EmptyTodoList());
      },
    );
    test(
      'Should emit [LoadingTodoList, LoadedTodoList] states when data is gotten successfully',
      () async {
        //arrange
        when(getTodoList(any)).thenAnswer(
            (_) async => Right<IFailure, List<TodoEntity>>(tTodoList));
        final expected = [
          LoadingTodoList(),
          LoadedTodoList(todos: tTodoList),
        ];
        //assert
        expectLater(bloc, emitsInOrder(expected));
        //act
        bloc.add(GetTodoListEvent());
      },
    );
    test(
      'Should emit [LoadingTodoList, Error] states when data fetch fails due to a DBFailure',
      () async {
        //arrange
        when(getTodoList(any)).thenAnswer(
            (_) async => Left<IFailure, List<TodoEntity>>(DBFailure()));
        final expected = [
          LoadingTodoList(),
          Error(message: DB_FAILURE_MESSAGE),
        ];
        //assert
        expectLater(bloc, emitsInOrder(expected));
        //act
        bloc.add(GetTodoListEvent());
      },
    );
    test(
      'Should emit [LoadingTodoList, Error] states when data fetch fails due to a ServerFailure',
      () async {
        //arrange
        when(getTodoList(any)).thenAnswer(
            (_) async => Left<IFailure, List<TodoEntity>>(ServerFailure()));
        final expected = [
          LoadingTodoList(),
          Error(message: DB_FAILURE_MESSAGE),
        ];
        //assert
        expectLater(bloc, emitsInOrder(expected));
        //act
        bloc.add(GetTodoListEvent());
      },
    );
  });
}
