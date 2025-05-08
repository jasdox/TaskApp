import 'package:flutter/material.dart';
import 'package:flutter_application_1/task_database.dart';
import 'package:provider/provider.dart';
import 'main.dart';
import 'task.dart';

class GroupPage extends StatelessWidget {
  const GroupPage({super.key});


  @override
  Widget build(BuildContext context) {
    var pageSelection = Provider.of<PageSelector>(context, listen: false);
    var taskManager = Provider.of<TaskManager>(context, listen: false);
    TaskGroup group = pageSelection.selectedGroup!;


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(group.title),
      ),
      body: Align(
        alignment: Alignment(0.0, -1),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              if (group.description != null && group.description != '') ...[
              Text("Description: ${group.description ?? ''}"),
              SizedBox(height: 8,),
              ],
              Container(
                width: kWidth / 8,
                height: kWidth / 8,
                decoration: BoxDecoration(
                  color: group.color,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(height: 32,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                          onPressed: () {
                              pageSelection.openTask(pageSelection.selectedTask!);
                          },
                          child: Text('Back'),
                        ),
                  SizedBox(width: 8,),
                  ElevatedButton(
                          onPressed: () async {
                              await taskManager.removeTaskGroup(group);
                              pageSelection.selectedTask = TaskDatabase.tasks.firstWhere((task) => (task.id == pageSelection.selectedTask!.id));
                              pageSelection.changePage(pageSelection.prevPage);
                          },
                          child: Text('Delete'),
                        ),
                  SizedBox(width: 8,),
                  ElevatedButton(
                      onPressed: () {
                          pageSelection.prevPage = 5;
                          pageSelection.changePage(6);
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