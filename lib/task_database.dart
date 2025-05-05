import 'package:flutter/gestures.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'task.dart';
import 'main.dart';


class TaskDatabase {
  static Database? database;
  static List<Task> tasks = [];

  static initDb() async{
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    database = await openDatabase(
    join(await getDatabasesPath(), 'task_database.db'),

    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE tasks(id TEXT PRIMARY KEY, title TEXT, description TEXT, dueDate INTEGER)',
      );
    },

    version: 1,
  );

  updateTaskList();
  }

  static updateTaskList() async {
    final List<Map<String, Object?>> taskMaps = await database!.query('tasks'); 

    tasks = [
      for (final {'id': id as String?, 'title': title as String, 'description': description as String, 'dueDate': dueDate as int} in taskMaps) Task(id: id, title: title, description: description, dueDate: DateTime.fromMillisecondsSinceEpoch(dueDate))
    ];
  }

    static insertTask(Task task) {
    database!.insert('tasks', task.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static updateTask(Task task) {
    database!.update('tasks', task.toMap(), where: 'id = ?', whereArgs: [task.id]);
  }

  static deleteTask(Task task) {
    database!.delete('tasks', where: 'id = ?', whereArgs: [task.id]);
  }
}