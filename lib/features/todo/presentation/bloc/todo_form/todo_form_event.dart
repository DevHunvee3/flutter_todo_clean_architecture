part of 'todo_form_bloc.dart';

abstract class ITodoFormEvent with EquatableMixin {
  final List<dynamic> properties;
  ITodoFormEvent({this.properties = const []});
  @override
  List<Object> get props {
    return properties;
  }
}

class GetTodoEvent extends ITodoFormEvent {
  final int id;

  GetTodoEvent({@required this.id}) : super(properties: [id]);
}

class CreateTodoEvent extends ITodoFormEvent {
  final String title;
  CreateTodoEvent({@required this.title}) : super(properties: [title]);
}

class EditTodoEvent extends ITodoFormEvent {
  final int id;
  final TodoEntity todo;

  EditTodoEvent({@required this.id, @required this.todo})
      : super(properties: [id, todo]);
}
