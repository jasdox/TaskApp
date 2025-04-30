import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';

class ToDoPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var pageSelection = Provider.of<PageSelector>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("ToDo List"),
      ),
      body: Center(
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