import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/errors/failures_interface.dart';
import '../entities/todo_entity.dart';
import '../repositories/todo_repository_interface.dart';
import 'use_case_interface.dart';

class CreateTodo implements IUseCase<TodoEntity, CreateTodoParams> {
  final ITodoRepository repository;

  CreateTodo({@required this.repository});

  @override
  Future<Either<IFailure, TodoEntity>> call(CreateTodoParams params) async {
    return repository.createTodo(title: params.title);
  }
}

class CreateTodoParams extends Equatable {
  final String title;

  CreateTodoParams({@required this.title});

  @override
  List<Object> get props => [title];
}
