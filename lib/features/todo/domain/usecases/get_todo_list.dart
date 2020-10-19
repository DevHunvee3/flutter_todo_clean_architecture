import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures_interface.dart';
import 'package:dartz/dartz.dart';
import '../entities/todo_entity.dart';
import '../repositories/todo_repository_interface.dart';
import 'use_case_interface.dart';
import 'package:meta/meta.dart';

class GetTodoList implements IUseCase<List<TodoEntity>, GetTodoListParams> {
  final ITodoRepository repository;

  GetTodoList({@required this.repository});

  @override
  Future<Either<IFailure, List<TodoEntity>>> call(
      GetTodoListParams params) async {
    return repository.getTodoList(completed: params.completed);
  }
}

class GetTodoListParams extends Equatable {
  final bool completed;

  GetTodoListParams({this.completed});

  @override
  List<Object> get props => [completed];
}
