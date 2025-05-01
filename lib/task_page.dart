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


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(task.title),
      ),
      body: Column(
        children: [
          Text(task.title),
          Text(task.description ?? ''),
          Text(task.dueDate.toString()),
          SizedBox(height: 32,),
          ElevatedButton(
                  onPressed: () {
                      pageSelection.changePage(0);
                  },
                  child: Text('Back'),
                ),

        ],
      ),
      
    );
  }
}