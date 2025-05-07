import 'package:flutter/material.dart';
import 'package:flutter_application_1/task.dart';
import 'package:flutter_application_1/task_database.dart';
import 'package:provider/provider.dart';
import 'main.dart';

class ToDoPage extends StatelessWidget  {

  @override
  Widget build(BuildContext context) {
    var pageSelection = Provider.of<PageSelector>(context, listen: false);
    var taskManager = Provider.of<TaskManager>(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      taskManager.loadTasks();
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("ToDo List"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              for (Task task in TaskDatabase.tasks)
                Center(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: OutlinedButton(
                              style: task.group != null ? ButtonStyle(backgroundColor: WidgetStateProperty.all(task.group!.color)) : null,
                              onPressed: () {
                                pageSelection.openTask(task);
                              }, 
                              child: Text(task.toString(), softWrap: true,),
                              ),
                          ),
                            OutlinedButton(
                            style: task.group != null ? ButtonStyle(backgroundColor: WidgetStateProperty.all(task.group!.color)) : null,
                            onPressed: () {
                            if (task.group != null) {
                              task.group!.taskCount -= 1;
                              taskManager.updateGroup(task.group!);
                              if (task.group!.taskCount <= 0) {
                                taskManager.removeTaskGroup(task.group!);
                              }
                            }
                            taskManager.removeTask(task);                              }, 
                            child: Text("Done"),
                            ),
                        ],
                      ),
                        SizedBox(height: 8,)
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          pageSelection.changePage(1);
        },
        tooltip: 'Add new task',
        child: const Icon(Icons.add),
      ),
    );
  }
}