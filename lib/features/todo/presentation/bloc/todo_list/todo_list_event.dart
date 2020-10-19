part of 'todo_list_bloc.dart';

abstract class ITodoListEvent with EquatableMixin {
  final List<dynamic> properties;
  ITodoListEvent({this.properties = const []});
  @override
  List<Object> get props {
    return properties;
  }
}

class GetTodoListEvent extends ITodoListEvent {
  final bool completed;

  GetTodoListEvent({this.completed}) : super(properties: [completed]);
}
