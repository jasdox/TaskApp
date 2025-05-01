import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';
import 'task.dart';

class TaskPage extends StatelessWidget {
  final Task task;

  TaskPage({required this.task});

  @override
  Widget build(BuildContext context) {
    var pageSelection = Provider.of<PageSelector>(context, listen: false);
    var taskManager = Provider.of<TaskManager>(context, listen: false);


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(task.title),
      ),
      body: Align(
        alignment: Alignment(0.0, -1),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text("Description: ${task.description ?? ''}"),
              SizedBox(height: 8,),
              Text("Due Date: ${task.dueDate.day}/${task.dueDate.month}/${task.dueDate.year}"),
              SizedBox(height: 32,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                          onPressed: () {
                              pageSelection.changePage(0);
                          },
                          child: Text('Back'),
                        ),
                  ElevatedButton(
                          onPressed: () {
                              taskManager.removeTask(task);
                              pageSelection.changePage(0);
                          },
                          child: Text('Delete'),
                        ),
                ],
              ),
          
            ],
          ),
        ),
      ),
      
    );
  }
}