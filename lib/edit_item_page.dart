import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';
import 'task.dart';

class EditItemPage extends StatefulWidget {

  @override
  State<EditItemPage> createState() => _EditItemPageState();
}

class _EditItemPageState extends State<EditItemPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var pageSelection = Provider.of<PageSelector>(context, listen: false);
    Task task = pageSelection.selectedTask!;


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
                Text('${task.dueDate.day}/${task.dueDate.month}/${task.dueDate.year}'),
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
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save(); // Calls onSaved on all fields
                      pageSelection.changePage(2);
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