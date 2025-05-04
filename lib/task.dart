import 'package:uuid/uuid.dart';

class Task {
  String id;
  String title;
  DateTime dueDate;
  String? description;
  Uuid? groupId; 
  

  Task({required this.title, required this.dueDate, this.description, this.groupId, String? id}) : id = id ?? Uuid().v4();

  @override
  String toString() {
    return '$title | ${dueDate.day}/${dueDate.month}/${dueDate.year}';
  }

  Map<String, Object?> toMap() {
    return {'id': id, 'title': title, 'description': description, 'dueDate': dueDate.millisecondsSinceEpoch};
  }
}

class TaskGroup {
  Uuid id = Uuid();
  List<Task> tasks = [];
}