import '../models/todo_model.dart';

abstract class IDataSource {
  Future<TodoModel> getTodo(int id);
  Future<List<TodoModel>> getTodoList(bool completed);
  Future<TodoModel> createTodo(TodoModel todo);
  Future<TodoModel> editTodo(int id, TodoModel todo);
}
