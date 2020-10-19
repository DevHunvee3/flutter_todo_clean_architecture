import 'package:meta/meta.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/todo_model.dart';
import 'datasource_interface.dart';

class SQLLiteDataSource implements IDataSource {
  final Database database;

  SQLLiteDataSource({@required this.database});

  @override
  Future<TodoModel> createTodo(TodoModel todo) async {
    if (database.isOpen) {
      final result = await database.insert('todos', todo.toJson());
      database.close();
      return TodoModel(
        id: result,
        title: todo.title,
        completed: todo.completed,
      );
    }
    throw DBConnectionException();
  }

  @override
  Future<TodoModel> editTodo(int id, TodoModel todo) async {
    if (database.isOpen) {
      final List<Map<String, dynamic>> results =
          await database.query('todos', where: 'id = ?', whereArgs: [id]);
      if (results.length > 0) {
        await database
            .update('todos', todo.toJson(), where: 'id = ?', whereArgs: [id]);
        database.close();
        return todo;
      }
      throw DBResourceNotFoundException();
    }
    throw DBConnectionException();
  }

  @override
  Future<TodoModel> getTodo(int id) async {
    if (database.isOpen) {
      final List<Map<String, dynamic>> results =
          await database.query('todos', where: 'id = ?', whereArgs: [id]);
      database.close();
      if (results.length > 0) {
        final todoModel = TodoModel.fromJson(results[0]);
        return todoModel;
      } else {
        throw DBResourceNotFoundException();
      }
    }
    throw DBConnectionException();
  }

  @override
  Future<List<TodoModel>> getTodoList(bool completed) async {
    if (database.isOpen) {
      List<Map<String, dynamic>> results;
      if (completed == null) {
        results = await database.query('todos');
      } else {
        results = await database
            .query('todos', where: 'completed = ?', whereArgs: [completed]);
      }
      database.close();
      return results.map((todo) => TodoModel.fromJson(todo)).toList();
    }
    throw DBConnectionException();
  }
}
