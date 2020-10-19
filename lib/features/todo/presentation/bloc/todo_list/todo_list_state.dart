part of 'todo_list_bloc.dart';

abstract class ITodoListState with EquatableMixin {
  final List<dynamic> properties;
  ITodoListState({this.properties = const []});
  @override
  List<Object> get props {
    return properties;
  }
}

class EmptyTodoList extends ITodoListState {}

class LoadingTodoList extends ITodoListState {}

class LoadedTodoList extends ITodoListState {
  final List<TodoEntity> todos;

  LoadedTodoList({@required this.todos}) : super(properties: [todos]);
}

class Error extends ITodoListState {
  final String message;

  Error({@required this.message});
}
