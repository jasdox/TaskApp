import 'package:flutter/material.dart';
import 'package:flutter_application_1/task_database.dart';
import 'package:provider/provider.dart';
import 'main.dart';
import 'task.dart';

class CreateItemPage extends StatefulWidget {

  @override
  State<CreateItemPage> createState() => _CreateItemPageState();
}

class _CreateItemPageState extends State<CreateItemPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  DateTime _dueDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  bool inGroup = false;
  String? selectedGroup;

  @override
  Widget build(BuildContext context) {
    var pageSelector = Provider.of<PageSelector>(context, listen: false);
    var taskManager = Provider.of<TaskManager>(context, listen: false);

    List<DropdownMenuEntry<String>> groupEntries = TaskDatabase.taskGroups.map<DropdownMenuEntry<String>>(
      (TaskGroup taskGroup) {
        return DropdownMenuEntry<String>(value: taskGroup.id, label: taskGroup.toString());
        }
      ).toList();

    groupEntries.add(DropdownMenuEntry(value: "New Group", label: "New Group"));


    return Scaffold(
      appBar: AppBar(title: Text('Create New Task'), backgroundColor: Theme.of(context).colorScheme.inversePrimary,),
      body: Padding(
        padding: const EdgeInsets.all(64),
        child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Title'),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Enter a title';
                return null;
              },
              onSaved: (value) {
                _title = value!;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Description'),
              onSaved: (value) {
                _description = value!;
              },
              minLines: 1,
              maxLines: 6,
            ),
            Column(
              children: [
                Text('${_dueDate.day}/${_dueDate.month}/${_dueDate.year}'),
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
                        _dueDate = date;
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
                      pageSelector.changePage(0);
                  },
                  child: Text('Back'),
                ),
                SizedBox(width: 8,),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save(); // Calls onSaved on all fields

                      if (selectedGroup != null) {
                        if (selectedGroup == "New Group") {
                          Task newTask = Task(title: _title, dueDate: _dueDate, description: _description);
                          taskManager.addTask(newTask);
                          pageSelector.changeSelectedTask(newTask);
                          pageSelector.changePage(4);
                        }
                        else {
                          Task newTask = Task(title: _title, dueDate: _dueDate, description: _description, group: TaskDatabase.taskGroups.firstWhere((group) => group.id == selectedGroup));
                          newTask.group!.taskCount += 1;
                          taskManager.updateGroup(newTask.group!);
                          taskManager.addTask(newTask);
                          pageSelector.changePage(0);
                        }
                      }
                      else {
                       Task newTask = Task(title: _title, dueDate: _dueDate, description: _description);
                       taskManager.addTask(newTask);
                       pageSelector.changePage(0);
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