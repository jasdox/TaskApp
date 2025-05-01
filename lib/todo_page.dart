import 'package:flutter/material.dart';
import 'package:flutter_application_1/task.dart';
import 'package:provider/provider.dart';
import 'main.dart';

class ToDoPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var pageSelection = Provider.of<PageSelector>(context, listen: false);
    List<Task> tasks = Provider.of<TaskManager>(context, listen: false).tasks;

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
              for (Task task in tasks)
                Center(
                  child: Column(
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          pageSelection.openTask(task);
                        }, 
                        child: Text(task.toString()),
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