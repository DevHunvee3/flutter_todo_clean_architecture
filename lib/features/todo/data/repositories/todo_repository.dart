import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/failures_interface.dart';
import '../../domain/entities/todo_entity.dart';
import '../../domain/repositories/todo_repository_interface.dart';
import '../datasources/datasource_interface.dart';
import '../models/todo_model.dart';

class TodoRepository implements ITodoRepository {
  final IDataSource dataSource;

  TodoRepository({@required this.dataSource});

  @override
  Future<Either<IFailure, TodoEntity>> createTodo({String title}) async {
    try {
      final todoModel = await dataSource
          .createTodo(TodoModel(id: 0, title: title, completed: false));
      return Right(todoModel);
    } on DBConnectionException {
      return Left(DBFailure());
    } on Exception {
      return Left(DBFailure());
    }
  }

  @override
  Future<Either<IFailure, TodoEntity>> editTodo(
      {int id, TodoEntity todo}) async {
    try {
      final edittedTodo = await dataSource.editTodo(id, todo);
      return Right(edittedTodo);
    } on DBResourceNotFoundException {
      return Left(DBResourceNotFoundFailure());
    } on DBConnectionException {
      return Left(DBFailure());
    } on Exception {
      return Left(DBFailure());
    }
  }

  @override
  Future<Either<IFailure, TodoEntity>> getTodo({int id}) async {
    try {
      final todoModel = await dataSource.getTodo(id);
      return Right(todoModel);
    } on DBConnectionException {
      return Left(DBFailure());
    } on DBResourceNotFoundException {
      return Left(DBResourceNotFoundFailure());
    } on Exception {
      return Left(DBFailure());
    }
  }

  @override
  Future<Either<IFailure, List<TodoEntity>>> getTodoList(
      {bool completed}) async {
    try {
      final List<TodoModel> todos = await dataSource.getTodoList(completed);
      return Right(todos);
    } on DBConnectionException {
      return Left(DBFailure());
    } on Exception {
      return Left(DBFailure());
    }
  }
}
