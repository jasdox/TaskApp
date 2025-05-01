import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'todo_page.dart';
import 'create_item_page.dart';
import 'task.dart';

void main() {
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

  void changePage(int pageNum) {
    currentPage = pageNum;
    notifyListeners();
  }
}

class TaskManager extends ChangeNotifier {
  List<Task> tasks = [];

  void addTask(Task newTask) {
    tasks.add(newTask);
    notifyListeners();
  }

  void removeTask(Task task) {
    tasks.remove(task);
    notifyListeners();
  }
}

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    int currentPage = context.watch<PageSelector>().currentPage;

    Widget page;
    switch(currentPage) {
      case 0: 
        page = ToDoPage();
        break;
      case 1:
        page = CreateItemPage();
        break;
      default:
        throw UnimplementedError("no widget exists");
    }

    return page;

  }
}