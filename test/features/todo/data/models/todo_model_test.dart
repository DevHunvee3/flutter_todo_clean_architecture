import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:todo/features/todo/data/models/todo_model.dart';
import 'package:todo/features/todo/domain/entities/todo_entity.dart';

import '../../../../fixtures/fixture_reader.dart';

main() {
  final TodoModel tTodoModel =
      TodoModel(id: 1, title: 'todo', completed: false);

  test(
    'Should be a subclass of TodoEntity',
    () async {
      expect(tTodoModel, isA<TodoEntity>());
    },
  );

  group('fromJson', () {
    test(
      'Should return a valid model from JSON',
      () async {
        //arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('todo_fixture.json'));

        final result = TodoModel.fromJson(jsonMap);

        expect(result, tTodoModel);
      },
    );
  });

  group('toJson', () {
    test(
      'Should return a JSON Map containing the proper data of a TodoModel',
      () async {
        //act
        final result = tTodoModel.toJson();
        //assert
        expect(
          result,
          {
            "id": 1,
            "title": "todo",
            "completed": false,
          },
        );
      },
    );
  });
}
