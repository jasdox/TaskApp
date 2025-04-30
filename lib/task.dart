import 'package:uuid/uuid.dart';

class Task {
  Uuid id = Uuid();
  String title;
  DateTime dueDate;
  String? description;
  Uuid? groupId; 
  

  Task({required this.title, required this.dueDate, this.description, this.groupId});

  @override
  String toString() {
    return 'Task(title: $title, description: $description, dueDate: ${dueDate.toIso8601String()})';
  }
}

class TaskGroup {
  Uuid id = Uuid();
  List<Task> tasks = [];
}