import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';

class Task {
  String id;
  String title;
  DateTime dueDate;
  String? description;
  TaskGroup? group;
  
  

  Task({required this.title, required this.dueDate, this.description, this.group, String? id}) : id = id ?? Uuid().v4();

  @override
  String toString() {
    return '$title | ${dueDate.month}/${dueDate.day}/${dueDate.year}';
  }

  Map<String, Object?> toMap() {
    return {'id': id, 'title': title, 'description': description, 'dueDate': dueDate.millisecondsSinceEpoch, 'groupID': group?.id};
  }

  void addToGroup(TaskGroup group) {
    this.group = group;
  }
}

class TaskGroup {
  String id;
  String title;
  Color color;
  int taskCount;
  String? description;

  TaskGroup({required this.title, required this.color, this.description, String? id, int? taskCount}) : id = id ?? Uuid().v4(), taskCount = taskCount ?? 1;

  Map<String, Object?> toMap() {
    return {'id': id, 'title': title, 'color': color.toARGB32(), 'taskCount': taskCount};
  }

  @override
  String toString() {
    return title;
  }
}