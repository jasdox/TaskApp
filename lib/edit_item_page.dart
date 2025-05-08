import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';
import 'task.dart';
import 'task_database.dart';

class EditItemPage extends StatefulWidget {
  const EditItemPage({super.key});

  @override
  State<EditItemPage> createState() => _EditItemPageState();
}

class _EditItemPageState extends State<EditItemPage> {
  final _formKey = GlobalKey<FormState>();
  String? selectedGroup;
  late bool inGroup = false;

  @override 
  void initState() {
    super.initState();
     final task = Provider.of<PageSelector>(context, listen: false).selectedTask;
     inGroup = task!.group != null;
  }

  @override
  Widget build(BuildContext context) {
    var pageSelection = Provider.of<PageSelector>(context, listen: false);
    Task task = pageSelection.selectedTask!;
    var taskManager = Provider.of<TaskManager>(context, listen: false);

    List<DropdownMenuEntry<String>> groupEntries = TaskDatabase.taskGroups.map<DropdownMenuEntry<String>>(
      (TaskGroup taskGroup) {
        return DropdownMenuEntry<String>(value: taskGroup.id, label: taskGroup.toString());
        }
      ).toList();

    groupEntries.add(DropdownMenuEntry(value: "New Group", label: "New Group"));


    return Scaffold(
      appBar: AppBar(title: Text('Edit Task'), backgroundColor: Theme.of(context).colorScheme.inversePrimary,),
      body: Padding(
        padding: const EdgeInsets.all(64),
        child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextFormField(
              initialValue: task.title,
              decoration: InputDecoration(labelText: 'Title'),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Enter a title';
                return null;
              },
              onSaved: (value) {
                task.title = value!;
              },
            ),
            TextFormField(
              initialValue: task.description,
              decoration: InputDecoration(labelText: 'Description'),
              onSaved: (value) {
                task.description = value!;
              },
            ),
            Column(
              children: [
                Text('${task.dueDate.month}/${task.dueDate.day}/${task.dueDate.year}'),
                SizedBox(height: 8,),
                ElevatedButton.icon(
                  icon: const Icon(Icons.calendar_today),
                  label: Text('Pick a date'),
                  onPressed: () async {
                    DateTime? date = await showDatePicker(
                      context: context,
                      initialEntryMode: DatePickerEntryMode.calendarOnly,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2050),
                    );
                        
                    setState((){
                      if (date != null) {
                        task.dueDate = date;
                      }
                    });
                  }
                ),
              ],
            ),
            Row(
              children: [
                Checkbox(
                  value: inGroup,
                  onChanged: (value) => setState(() => inGroup = value!),
                ),
                SizedBox(width: 8),
                Text('In Group?'),
                if (inGroup) ...[
                SizedBox(width: 32),
                DropdownMenu<String>(
                  onSelected: (String? selection) {
                    selectedGroup = selection;
                  },
                  dropdownMenuEntries: groupEntries,
                  width: 160,
                  )
                ]
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                      pageSelection.changePage(pageSelection.prevPage);
                  },
                  child: Text('Back'),
                ),
                SizedBox(width: 8,),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save(); // Calls onSaved on all fields
                      taskManager.updateTask(task);

                      if (selectedGroup != null) {
                        if (selectedGroup == "New Group") {
                          pageSelection.changeSelectedTask(task);
                          pageSelection.prevPage = 3;
                          pageSelection.changePage(4);
                        }
                        else {
                          task.group = TaskDatabase.taskGroups.firstWhere((group) => group.id == selectedGroup);
                          task.group!.taskCount += 1;
                          taskManager.updateTask(task);
                          taskManager.updateGroup(task.group!);
                          pageSelection.changePage(2);
                        }
                      }
                      else {
                        pageSelection.changePage(2);
                      }
                    }
                  },
                  child: Text('Submit'),
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