import 'package:uuid/uuid.dart';

class Task {
  String id;
  String title;
  DateTime dueDate;
  String? description;
  TaskGroup? group;
  

  Task({required this.title, required this.dueDate, this.description, this.group, String? id}) : id = id ?? Uuid().v4();

  @override
  String toString() {
    return '$title | ${dueDate.day}/${dueDate.month}/${dueDate.year}';
  }

  Map<String, Object?> toMap() {
    return {'id': id, 'title': title, 'description': description, 'dueDate': dueDate.millisecondsSinceEpoch, 'groupID': group?.id};
  }
}

class TaskGroup {
  String id;
  String title;

  TaskGroup({required this.title, String? id}) : id = id ?? Uuid().v4();

  Map<String, Object?> toMap() {
    return {'id': id, 'title': title};
  }
}