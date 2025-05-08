import 'package:flutter/material.dart';
import 'package:flutter_application_1/task_database.dart';
import 'package:provider/provider.dart';
import 'main.dart';

class ToDoPage extends StatefulWidget  {
  const ToDoPage({super.key});

  @override
  State<ToDoPage> createState() => _ToDoPageState();
}

class _ToDoPageState extends State<ToDoPage> {

  @override 
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var taskManager = Provider.of<TaskManager>(context, listen: false);
      taskManager.loadTasks();
    });
  }


  @override
  Widget build(BuildContext context) {
    var pageSelection = Provider.of<PageSelector>(context, listen: false);
    var taskManager = Provider.of<TaskManager>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("ToDo List"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: DropdownMenu<int>(
                      label: Text("Sort By"),
                      dropdownMenuEntries: [DropdownMenuEntry(value: 0, label: "Due Date"), DropdownMenuEntry(value: 1, label: "Group")],
                      onSelected: (int? value) {
                        if (value != null) {
                          taskManager.sortTasks(value);
                        }
                      },
                      ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: TaskDatabase.tasks.length,
                padding: const EdgeInsets.only(top: 16),
                itemBuilder: (context, index) {
                  final task = TaskDatabase.tasks[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: OutlinedButton(
                            style: task.group != null
                                ? ButtonStyle(
                                    backgroundColor: WidgetStateProperty.all(task.group!.color),
                                  )
                                : null,
                            onPressed: () {
                              pageSelection.openTask(task);
                            },
                            child: Text(task.toString(), softWrap: true),
                          ),
                        ),
                        OutlinedButton(
                          style: task.group != null
                              ? ButtonStyle(
                                  backgroundColor: WidgetStateProperty.all(task.group!.color),
                                )
                              : null,
                          onPressed: () async {
                            if (task.group != null) {
                              task.group!.taskCount -= 1;
                              await taskManager.updateGroup(task.group!);
                              if (task.group!.taskCount <= 0) {
                                await taskManager.removeTaskGroup(task.group!);
                              }
                            }
                            await taskManager.removeTask(task);
                          },
                          child: const Text("Done"),
                        ),
                      ],
                    ),
                  );
                },
              ),
            )

          ],
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