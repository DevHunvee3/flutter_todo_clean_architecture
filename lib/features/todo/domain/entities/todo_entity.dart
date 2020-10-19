import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class TodoEntity extends Equatable {
  final int id;
  final String title;
  final bool completed;

  TodoEntity({
    @required this.id,
    @required this.title,
    @required this.completed,
  });

  @override
  List<Object> get props => [title, completed];
}
