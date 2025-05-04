import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'todo_page.dart';
import 'create_item_page.dart';
import 'task.dart';
import 'task_page.dart';
import 'edit_item_page.dart';
import 'package:window_manager/window_manager.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'task_database.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

const double kWidth = 400;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  await TaskDatabase.initDb();

  if (Platform.isWindows) {
    WindowManager.instance.setMinimumSize(const Size(kWidth, 0));
    WindowManager.instance.setMaximumSize(const Size(kWidth, 2400));

    WindowOptions windowOptions = WindowOptions(
    size: const Size(400, 800),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    title: "Task App",
    );

    windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
    
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PageSelector()),
        ChangeNotifierProvider(create: (_) => TaskManager()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromRGBO(59, 115, 199, 1)),
        ),
        home: HomePage(),
      ),
    );
  }
}

class PageSelector extends ChangeNotifier {
  int currentPage = 0;
  Task? selectedTask;

  void changePage(int pageNum) {
    currentPage = pageNum;
    notifyListeners();
  }

  void openTask(Task task) {
    selectedTask = task;
    currentPage = 2;
    notifyListeners();
  }
}

class TaskManager extends ChangeNotifier {

  void addTask(Task newTask) async {
    TaskDatabase.insertTask(newTask);
    await TaskDatabase.updateTaskList();
    notifyListeners();
  }

  void removeTask(Task task) async {
    TaskDatabase.deleteTask(task);
    await TaskDatabase.updateTaskList();
    notifyListeners();
  }
}

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var pageSelection = context.watch<PageSelector>();

    Widget page;
    switch(pageSelection.currentPage) {
      case 0: 
        page = ToDoPage();
        break;
      case 1:
        page = CreateItemPage();
        break;
      case 2: 
        page = TaskPage();
        break;
      case 3: 
      page = EditItemPage();
        break;
      default:
        throw UnimplementedError("no widget exists");
    }

    return Container(child: page);

  }
}