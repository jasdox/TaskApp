import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'task.dart';
import 'package:flutter/material.dart';


class TaskDatabase {
  static Database? database;
  static List<Task> tasks = [];
  static List<TaskGroup> taskGroups = [];

  static initDb() async{
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

  // below is for if databse needs to be re-created
  //final dbPath = join(await getDatabasesPath(), 'task_database.db');
  //await deleteDatabase(dbPath);


    database = await openDatabase(
    join(await getDatabasesPath(), 'task_database.db'),

    onCreate: (db, version) async {
      await db.execute('CREATE TABLE tasks(id TEXT PRIMARY KEY, title TEXT, description TEXT, dueDate INTEGER, groupId TEXT, FOREIGN KEY (groupId) REFERENCES groups(id) ON DELETE SET NULL)');
      await db.execute('CREATE TABLE groups(id TEXT PRIMARY KEY, title TEXT, color INTEGER, taskCount INTEGER)');
    },

    version: 1,
  );

  updateLists();
  }

  static updateLists() async {
    final List<Map<String, Object?>> taskMaps = await database!.query('tasks'); 
    final List<Map<String, Object?>> groupMaps = await database!.query('groups'); 

    taskGroups = [for (final {'id': id as String, 'title': title as String, 'color': color as int, 'taskCount': taskCount as int} in groupMaps) TaskGroup(title: title, id: id, color: Color(color), taskCount: taskCount)];

    tasks = [];
      for (final {'id': id as String, 'title': title as String, 'description': description as String, 'dueDate': dueDate as int, 'groupId': groupId as String?} in taskMaps) {
      TaskGroup? group = taskGroups.where((group) => group.id == groupId).isNotEmpty
      ? taskGroups.firstWhere((group) => group.id == groupId)
      : null;
      
      tasks.add(Task(id: id, title: title, description: description, dueDate: DateTime.fromMillisecondsSinceEpoch(dueDate), group: group));  
 
      }
  }

    static insertTask(Task task) {
    database!.insert('tasks', task.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

      static insertGroup(TaskGroup taskGroup) { 
    database!.insert('groups', taskGroup.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static updateTask(Task task) {
    database!.update('tasks', task.toMap(), where: 'id = ?', whereArgs: [task.id]);
  }

  static updateGroup(TaskGroup taskGroup) {
    database!.update('groups', taskGroup.toMap(), where: 'id = ?', whereArgs: [taskGroup.id]);
  }

  static deleteTask(Task task) {
    database!.delete('tasks', where: 'id = ?', whereArgs: [task.id]);
  }

  static deleteGroup(TaskGroup taskGroup) {
    database!.delete('groups', where: 'id = ?', whereArgs: [taskGroup.id]);
  }
}