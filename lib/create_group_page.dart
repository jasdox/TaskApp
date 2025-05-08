import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';
import 'task.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({super.key});


  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  Color? _color = Colors.red;

  @override
  Widget build(BuildContext context) {
    var pageSelector = Provider.of<PageSelector>(context, listen: false);
    var taskManager = Provider.of<TaskManager>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text('Create New Group'), backgroundColor: Theme.of(context).colorScheme.inversePrimary,),
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
            MaterialColorPicker(
            onColorChange: (Color color) {
                  _color = color;
                  },
            selectedColor: Colors.red
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                      pageSelector.changePage(pageSelector.prevPage);
                  },
                  child: Text('Back'),
                ),
                SizedBox(width: 8,),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save(); // Calls onSaved on all fields
                        
                      TaskGroup taskGroup = TaskGroup(title: _title,  description: _description, color: _color!);
                      pageSelector.selectedTask!.addToGroup(taskGroup);
                      taskManager.addGroup(taskGroup);
                      taskManager.updateTask(pageSelector.selectedTask!);
                      if (pageSelector.prevPage == 3) {pageSelector.changePage(2);}
                      else {pageSelector.changePage(0);}
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