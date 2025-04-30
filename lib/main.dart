import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'todo_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PageSelector(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
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
        page = Placeholder();
        break;
      default:
        throw UnimplementedError("no widget exists");
    }

    return page;

  }
}