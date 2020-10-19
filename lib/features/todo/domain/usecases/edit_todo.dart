import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/errors/failures_interface.dart';
import '../entities/todo_entity.dart';
import '../repositories/todo_repository_interface.dart';
import 'use_case_interface.dart';

class EditTodo implements IUseCase<TodoEntity, EditTodoParams> {
  final ITodoRepository repository;

  EditTodo({@required this.repository});

  @override
  Future<Either<IFailure, TodoEntity>> call(EditTodoParams params) async {
    return repository.editTodo(id: params.id, todo: params.todo);
  }
}

class EditTodoParams extends Equatable {
  final int id;
  final TodoEntity todo;

  EditTodoParams({@required this.id, @required this.todo});

  @override
  List<Object> get props => [todo];
}
