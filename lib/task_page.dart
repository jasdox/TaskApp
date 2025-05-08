import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';
import 'task.dart';

class TaskPage extends StatelessWidget {
  const TaskPage({super.key});



  @override
  Widget build(BuildContext context) {
    var pageSelection = Provider.of<PageSelector>(context, listen: false);
    var taskManager = Provider.of<TaskManager>(context);
    Task task = pageSelection.selectedTask!;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      taskManager.loadTasks();
    });


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
              if (task.description != null && task.description != '') ...[
              Text("Description: ${task.description ?? ''}"),
              SizedBox(height: 8,),
              ],
              Text("Due Date: ${task.dueDate.day}/${task.dueDate.month}/${task.dueDate.year}"),
              SizedBox(height: 32,),
              if (task.group != null) ...[
              OutlinedButton
              (onPressed:() {
                pageSelection.prevPage = 2;
                pageSelection.selectedGroup = task.group;
                pageSelection.changePage(5);
              },
              style: ButtonStyle(backgroundColor: WidgetStateProperty.all(task.group!.color)),
               child: Text("Group: ${task.group.toString()}"),
               ),
              SizedBox(height: 32,),
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                          onPressed: () {
                              pageSelection.changePage(0);
                          },
                          child: Text('Back'),
                        ),
                  SizedBox(width: 8,),
                  ElevatedButton(
                          onPressed: () {
                              if (task.group != null) {
                                task.group!.taskCount -= 1;
                                if (task.group!.taskCount <= 0) {
                                  taskManager.removeTaskGroup(task.group!);
                                }
                              }

                              taskManager.removeTask(task);
                              pageSelection.changePage(0);
                          },
                          child: Text('Done'),
                        ),
                  SizedBox(width: 8,),
                  ElevatedButton(
                      onPressed: () {
                          pageSelection.prevPage = 2;
                          pageSelection.changePage(3);
                      },
                      child: Text('Edit'),
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