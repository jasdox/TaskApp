import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';
import 'task.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

class EditGroupPage extends StatefulWidget {
  const EditGroupPage({super.key});


  @override
  State<EditGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<EditGroupPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var pageSelector = Provider.of<PageSelector>(context, listen: false);
    var taskManager = Provider.of<TaskManager>(context, listen: false);
    TaskGroup group = pageSelector.selectedGroup!;
    Color newColor = group.color;

    return Scaffold(
      appBar: AppBar(title: Text('Edit Group'), backgroundColor: Theme.of(context).colorScheme.inversePrimary,),
      body: Padding(
        padding: const EdgeInsets.all(64),
        child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Title'),
              initialValue: group.title,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Enter a title';
                return null;
              },
              onSaved: (value) {
                group.title = value!;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Description'),
              initialValue: group.description,
              onSaved: (value) {
                group.description = value!;
              },
              minLines: 1,
              maxLines: 6,
            ),
            MaterialColorPicker(
              onColorChange: (Color color) {
                    newColor = color;
                    },
              selectedColor: group.color
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
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save(); // Calls onSaved on all fields
                      group.color = newColor;
                        
                      await taskManager.updateGroup(group);

                      pageSelector.changePage(pageSelector.prevPage);
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