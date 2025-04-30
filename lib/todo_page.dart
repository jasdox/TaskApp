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
      body: Center(
        child: Column(
          children: [
            for (Task task in tasks)
              Text(task.toString()),
          ],
        )
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