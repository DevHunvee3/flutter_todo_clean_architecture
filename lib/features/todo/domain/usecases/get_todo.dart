import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import "package:meta/meta.dart";

import '../../../../core/errors/failures_interface.dart';
import '../entities/todo_entity.dart';
import '../repositories/todo_repository_interface.dart';
import 'use_case_interface.dart';

class GetTodo implements IUseCase<TodoEntity, GetTodoParams> {
  final ITodoRepository repository;

  GetTodo({@required this.repository});

  @override
  Future<Either<IFailure, TodoEntity>> call(GetTodoParams params) async {
    return repository.getTodo(id: params.id);
  }
}

class GetTodoParams extends Equatable {
  final int id;
  GetTodoParams({@required this.id});

  @override
  List<Object> get props => [id];
}
