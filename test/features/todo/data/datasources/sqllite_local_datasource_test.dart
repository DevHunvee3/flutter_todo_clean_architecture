import 'dart:convert';

import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';
import 'package:matcher/matcher.dart';
import 'package:todo/core/errors/exceptions.dart';
import 'package:todo/features/todo/data/datasources/datasource_interface.dart';
import 'package:todo/features/todo/data/datasources/sqllite_datasource.dart';
import 'package:todo/features/todo/data/models/todo_model.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockDatabase extends Mock implements Database {}

main() {
  IDataSource dataSource;
  Database database;
  setUp(() {
    database = MockDatabase();
    dataSource = SQLLiteDataSource(database: database);
  });

  final tTodoModel = TodoModel(id: 1, title: 'todo', completed: false);
  final List<Map<String, dynamic>> tSqlGetEmptyResponse = [];
  final List<Map<String, dynamic>> tSqlGetResponse = [
    json.decode(fixture('todo_fixture.json'))
  ];
  whenDatabaseOpenAndClose() {
    when(database.isOpen).thenReturn(true);
    when(database.close()).thenAnswer((_) async {});
  }

  verifyDatabaseWasOpenedAndThenClosed() {
    verify(database.isOpen);
    verify(database.close());
  }

  verifyNoDatabaseConnection() {
    verify(database.isOpen);
    verifyNever(database.close());
    verifyNever(database.query(any));
    verifyNoMoreInteractions(database);
  }

  group('getTodo', () {
    test(
      'Should return a valid TodoModel from database if the id is present at least once',
      () async {
        //arrange
        whenDatabaseOpenAndClose();
        when(database.query(any,
                where: anyNamed('where'), whereArgs: anyNamed('whereArgs')))
            .thenAnswer((_) async => tSqlGetResponse);
        //act
        final result = await dataSource.getTodo(1);
        //assert
        verifyDatabaseWasOpenedAndThenClosed();
        verify(database.query(any,
            where: anyNamed('where'), whereArgs: anyNamed('whereArgs')));
        verifyNoMoreInteractions(database);
        expect(result, tTodoModel);
      },
    );
    test(
      'Should return DBConnectionException when the database is closed before executing the query',
      () async {
        //arrange
        when(database.isOpen).thenReturn(false);
        //act

        final call = () async {
          await dataSource.getTodo(1);
          verifyNoDatabaseConnection();
        };

        //assert

        expect(call, throwsA(TypeMatcher<DBConnectionException>()));
      },
    );
    test(
      'Should return DBResourceNotFoundException when todo with id does not exist',
      () async {
        //arrange
        whenDatabaseOpenAndClose();
        when(database.query(any,
                where: anyNamed('where'), whereArgs: anyNamed('whereArgs')))
            .thenAnswer((_) async => tSqlGetEmptyResponse);
        //act

        final call = () async {
          await dataSource.getTodo(1);
          verifyDatabaseWasOpenedAndThenClosed();
          verify(database.query(any,
              where: anyNamed('where'), whereArgs: anyNamed('whereArgs')));
          verifyNoMoreInteractions(database);
        };

        //assert

        expect(call, throwsA(TypeMatcher<DBResourceNotFoundException>()));
      },
    );
  });

  group('getTodoList', () {
    final tSqlGetTodoListResponse = List<Map<String, dynamic>>.from(
        json.decode(fixture('todo_list_fixture.json')));
    final List<TodoModel> tTodoModelList = [
      TodoModel(id: 1, title: "todo1", completed: false),
      TodoModel(id: 2, title: "todo2", completed: false)
    ];
    test(
      'Should return a List of valid TodoModels from database',
      () async {
        //arrange
        whenDatabaseOpenAndClose();
        when(database.query(any,
                where: anyNamed('where'), whereArgs: anyNamed('whereArgs')))
            .thenAnswer((_) async => tSqlGetTodoListResponse);
        //act
        final result = await dataSource.getTodoList(null);
        //assert
        verifyDatabaseWasOpenedAndThenClosed();
        verify(database.query(any,
            where: anyNamed('where'), whereArgs: anyNamed('whereArgs')));
        verifyNoMoreInteractions(database);
        expect(result, tTodoModelList);
      },
    );

    test(
      'Should return DBConnectionException when the database is closed before executing the query',
      () async {
        //arrange
        when(database.isOpen).thenReturn(false);
        //act
        final call = () async {
          await dataSource.getTodoList(null);
          verifyNoDatabaseConnection();
        };
        //assert
        expect(call, throwsA(TypeMatcher<DBConnectionException>()));
      },
    );
    test(
      'Should call query method on database with filters when complete is not null',
      () async {
        //arrange
        when(database.isOpen).thenReturn(true);
        when(database.close()).thenAnswer((_) async {});
        when(database.query(any, where: 'completed = ?', whereArgs: [true]))
            .thenAnswer((_) async => tSqlGetTodoListResponse);
        //act
        await dataSource.getTodoList(true);
        //assert

        verify(database.query(any, where: 'completed = ?', whereArgs: [true]));
        verifyNever(database.query(any, where: null, whereArgs: null));
      },
    );
  });

  group('createTodo', () {
    test(
      'Should return a valid TodoModel from dataSource',
      () async {
        //arrange
        whenDatabaseOpenAndClose();
        when(database.insert('todos', any)).thenAnswer((_) async => 1);
        //act
        final result = await dataSource.createTodo(tTodoModel);
        //assert
        verifyDatabaseWasOpenedAndThenClosed();
        verify(database.insert('todos', any));
        verifyNoMoreInteractions(database);
        expect(result, tTodoModel);
      },
    );
    test(
      'Should return a DBConnectionException the database is closed before performing a query',
      () async {
        //arrange
        when(database.isOpen).thenReturn(false);
        //act
        final call = () async {
          await dataSource.createTodo(tTodoModel);
          verifyNoDatabaseConnection();
        };
        //assert
        expect(call, throwsA(TypeMatcher<DBConnectionException>()));
      },
    );
  });
  group('editTodo', () {
    test(
      'Should return a valid TodoModel from dataSource when a todo is editted',
      () async {
        //arrange
        whenDatabaseOpenAndClose();
        when(database.query(any,
                where: anyNamed('where'), whereArgs: anyNamed('whereArgs')))
            .thenAnswer((_) async => tSqlGetResponse);
        when(database.update('todos', any,
                where: anyNamed('where'), whereArgs: anyNamed('whereArgs')))
            .thenAnswer((_) async => tTodoModel.id);
        //act
        final result = await dataSource.editTodo(tTodoModel.id, tTodoModel);
        //assert
        verifyDatabaseWasOpenedAndThenClosed();
        verify(database.query('todos',
            where: anyNamed('where'), whereArgs: anyNamed('whereArgs')));
        verify(database.update('todos', any,
            where: anyNamed('where'), whereArgs: anyNamed('whereArgs')));
        verifyNoMoreInteractions(database);
        expect(result, tTodoModel);
      },
    );
    test(
      'Should return a DBConnectionException the database is closed before performing a query',
      () async {
        //arrange
        when(database.isOpen).thenReturn(false);
        //act
        final call = () async {
          await dataSource.editTodo(tTodoModel.id, tTodoModel);
          verifyNoDatabaseConnection();
        };
        //assert
        expect(call, throwsA(TypeMatcher<DBConnectionException>()));
      },
    );
    test(
      'Should return a DBResourceNotFoundException when the editted todo doesnt exist',
      () async {
        //arrange
        whenDatabaseOpenAndClose();
        when(database.query(any,
                where: anyNamed('where'), whereArgs: anyNamed('whereArgs')))
            .thenAnswer((_) async => tSqlGetEmptyResponse);
        //act
        final call = () async {
          await dataSource.editTodo(tTodoModel.id, tTodoModel);
          verifyDatabaseWasOpenedAndThenClosed();
          verify(database.query(any,
              where: anyNamed('where'), whereArgs: anyNamed('whereArgs')));
          verifyNoMoreInteractions(database);
        };

        //assert

        expect(call, throwsA(TypeMatcher<DBResourceNotFoundException>()));
      },
    );
  });
}
