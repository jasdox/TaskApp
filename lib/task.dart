import 'package:uuid/uuid.dart';

class Task {
  Uuid id = Uuid();
  String title;
  DateTime dueDate;
  List<SubTaskPair> subTasks; // Will always have sub-tasks, if none specified, will be a one entry list 
  String? description;
  Uuid? groupId; 
  

  Task({required this.title, required this.dueDate, required this.subTasks, this.description, this.groupId});
}

class SubTaskPair {
  String title;
  bool completed = false;

  SubTaskPair({required this.title});
}

class TaskGroup {
  Uuid id = Uuid();
  List<Task> tasks = [];
}