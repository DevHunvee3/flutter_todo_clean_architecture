import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../../core/errors/failures.dart';
import '../../../../../core/errors/failures_interface.dart';
import '../../../domain/entities/todo_entity.dart';
import '../../../domain/usecases/create_todo.dart';
import '../../../domain/usecases/edit_todo.dart';
import '../../../domain/usecases/get_todo.dart';
import 'todo_form_errors.dart';

part 'todo_form_event.dart';
part 'todo_form_state.dart';

class TodoFormBloc extends Bloc<ITodoFormEvent, ITodoFormState> {
  final GetTodo getTodoUseCase;
  final CreateTodo createTodoUseCase;
  final EditTodo editTodoUseCase;
  TodoFormBloc({
    @required GetTodo getTodo,
    @required CreateTodo createTodo,
    @required EditTodo editTodo,
  })  : assert(getTodo != null),
        assert(createTodo != null),
        assert(editTodo != null),
        getTodoUseCase = getTodo,
        createTodoUseCase = createTodo,
        editTodoUseCase = editTodo,
        super(EmptyTodo());

  @override
  Stream<ITodoFormState> mapEventToState(
    ITodoFormEvent event,
  ) async* {
    if (event is GetTodoEvent) {
      yield LoadingTodo();
      final resolution = await getTodoUseCase(GetTodoParams(id: event.id));
      yield resolution.fold(
        (failure) => Error(message: _mapFailureToMessage(failure)),
        (todo) => LoadedTodo(todo: todo),
      );
    }

    if (event is CreateTodoEvent) {
      yield SubmittingTodoForm();
      final resolution = await createTodoUseCase(
        CreateTodoParams(title: event.title),
      );
      yield resolution.fold(
        (failure) => Error(message: _mapFailureToMessage(failure)),
        (todo) => LoadedTodo(todo: todo),
      );
    }

    if (event is EditTodoEvent) {
      yield SubmittingTodoForm();
      final resolution = await editTodoUseCase(
        EditTodoParams(id: event.id, todo: event.todo),
      );
      yield resolution.fold(
        (failure) => Error(message: _mapFailureToMessage(failure)),
        (todo) => LoadedTodo(todo: todo),
      );
    }
  }

  _mapFailureToMessage(IFailure failure) {
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
