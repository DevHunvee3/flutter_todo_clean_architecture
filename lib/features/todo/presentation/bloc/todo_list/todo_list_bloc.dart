import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../../core/errors/failures.dart';
import '../../../../../core/errors/failures_interface.dart';
import '../../../domain/entities/todo_entity.dart';
import '../../../domain/usecases/get_todo_list.dart';
import 'todo_list_errors.dart';

part 'todo_list_event.dart';
part 'todo_list_state.dart';

class TodoListBloc extends Bloc<ITodoListEvent, ITodoListState> {
  final GetTodoList getTodoListUseCase;
  TodoListBloc({
    @required GetTodoList getTodoList,
  })  : assert(getTodoList != null),
        getTodoListUseCase = getTodoList,
        super(EmptyTodoList());

  @override
  Stream<ITodoListState> mapEventToState(
    ITodoListEvent event,
  ) async* {
    if (event is GetTodoListEvent) {
      yield LoadingTodoList();
      final resolution = await getTodoListUseCase(GetTodoListParams());
      yield resolution.fold(
        (failure) => Error(message: _mapFailureToMessage(failure)),
        (todos) => LoadedTodoList(todos: todos),
      );
    }
  }

  String _mapFailureToMessage(IFailure failure) {
    switch (failure.runtimeType) {
      case DBFailure:
        return DB_FAILURE_MESSAGE;
      case DBResourceNotFoundFailure:
        return DB_RESOURCE_NOT_FOUND_MESSAGE;
      default:
        return UNKNOWN_FAILURE;
    }
  }
}
