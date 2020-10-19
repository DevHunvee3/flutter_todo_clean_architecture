import 'package:meta/meta.dart';

import '../../domain/entities/todo_entity.dart';

class TodoModel extends TodoEntity {
  TodoModel({
    @required int id,
    @required String title,
    @required bool completed,
  }) : super(
          id: id,
          title: title,
          completed: completed,
        );

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json['id'] as int,
      title: json['title'],
      completed: json['completed'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "completed": completed,
    };
  }
}
