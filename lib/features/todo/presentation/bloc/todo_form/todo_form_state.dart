part of 'todo_form_bloc.dart';

abstract class ITodoFormState with EquatableMixin {
  final List<dynamic> properties;

  ITodoFormState({this.properties = const []});

  @override
  List<Object> get props {
    return properties;
  }
}

class EmptyTodo extends ITodoFormState {}

class LoadingTodo extends ITodoFormState {}

class SubmittingTodoForm extends ITodoFormState {}

class LoadedTodo extends ITodoFormState {
  final TodoEntity todo;

  LoadedTodo({@required this.todo}) : super(properties: [todo]);
}

class Error extends ITodoFormState {
  final String message;

  Error({@required this.message});
}
