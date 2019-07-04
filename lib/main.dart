import 'package:flutter/material.dart';
import 'package:todo_app/data/database.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/screens/completed.dart';
import 'package:todo_app/screens/todo.dart';
import 'package:todo_app/state/theme_state.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:todo_app/state/todos_state.dart';

import 'state/app_state.dart';
import 'data/todo_model.dart';

void main() => runApp(Root());

class Root extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(builder: (_) => AppState()),
        ChangeNotifierProvider(builder: (_) => ThemeState()),
        ChangeNotifierProvider(builder: (_) => TodosState()),
      ],
      child: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeData = Provider.of<ThemeState>(context);
    return MaterialApp(
      title: 'Todo',
      theme: themeData.getTheme(),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final List<Widget> _children = [Todos(), Completed()];

  @override
  Widget build(BuildContext context) {
    final themeData = Provider.of<ThemeState>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Todos'),
        actions: <Widget>[
          IconButton(
            icon: IconTheme(
              data: IconThemeData(
                  color: themeData.isDark ? Colors.white : Colors.black),
              child: Icon(themeData.isDark
                  ? FontAwesomeIcons.solidSun
                  : FontAwesomeIcons.solidMoon),
            ),
            onPressed: () {
              themeData.setTheme();
            },
          )
        ],
      ),
      body: _children[Provider.of<AppState>(context).bottomIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.list), title: Text("Todos")),
          BottomNavigationBarItem(
              icon: Icon(Icons.check), title: Text("Completed")),
        ],
        currentIndex: Provider.of<AppState>(context).bottomIndex,
        onTap: (index) {
          Provider.of<AppState>(context).changeBottomIndex(index);
          Provider.of<TodosState>(context).getTodos(index);
        },
      ),
    );
  }
}

