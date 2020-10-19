import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/errors/failures_interface.dart';
import '../entities/todo_entity.dart';

abstract class ITodoRepository {
  Future<Either<IFailure, TodoEntity>> getTodo({@required int id});
  Future<Either<IFailure, List<TodoEntity>>> getTodoList({bool completed});
  Future<Either<IFailure, TodoEntity>> createTodo({@required String title});
  Future<Either<IFailure, TodoEntity>> editTodo(
      {@required int id, @required TodoEntity todo});
}
