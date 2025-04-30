import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    var pageSelector = Provider.of<PageSelector>(context, listen: false);
    var taskManager = Provider.of<TaskManager>(context, listen: false);


    return Scaffold(
      appBar: AppBar(title: Text('Create New Task')),
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
            ),
            Column(
              children: [
                Text('${_dueDate.day}/${_dueDate.month}/${_dueDate.year}'),
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
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save(); // Calls onSaved on all fields
        
                  Task newTask = Task(title: _title, dueDate: _dueDate, description: _description);
                  taskManager.addTask(newTask);
                  pageSelector.changePage(0);
                }
              },
              child: Text('Submit'),
            ),
          ],
        ),
          ),
      ),
    );

  }
}