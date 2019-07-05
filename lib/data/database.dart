import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:todo_app/data/preference_model.dart';
import 'package:todo_app/data/todo_model.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null)
      return _database;
    else {
      _database = await initDB();
      List<Todo> todos = await getAllTodos();
      List<Preference> prefs = await getAllPrefences();
      if (todos.length == 0) await enterStartingData();
      if (prefs.length == 0) await enterStartingPrefs();
    }
    return _database;
  }

  initDB() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'main.db');
    await deleteDatabase(path);
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int versions) async {
      await db.execute("CREATE TABLE Preferences ("
          "id INTEGER PRIMARY KEY,"
          "key Text,"
          "value Text"
          ")");
      await db.execute("CREATE TABLE Todo ("
          "id INTEGER PRIMARY KEY,"
          "item Text,"
          "completed BIT"
          ")");
    });
  }

  completedOrUncompleteTask(Todo todo) async {
    final db = await database;
    Todo completed =
        Todo(id: todo.id, item: todo.item, completed: !todo.completed);
    var res = await db.update("Todo", completed.toMap(),
        where: "id = ?", whereArgs: [todo.id]);
    return res;
  }

  changePreferenceSetting(Preference preference) async {
    final db = await database;
    return await db.update("Preferences", preference.toMap(),
        where: "id = ?", whereArgs: [preference.id]);
  }

  enterStartingData() async {
    final db = await database;
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM Todo");
    int id = table.first['id'];
    await db.rawInsert(
        "INSERT Into Todo (id,item,completed)"
        " VALUES (?,?,?)",
        [id, 'Todo1', false]);
  }

  enterStartingPrefs() async {
    final db = await database;
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM Preferences");
    int id = table.first['id'];
    await db.rawInsert(
        "INSERT Into Preferences (id,key,value)"
        " VALUES (?,?,?)",
        [id, 'theme', 'dark']);
  }

  newTodo(String item) async {
    final db = await database;
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM Todo");
    int id = table.first['id'];
    var insert = await db.rawInsert(
        "INSERT Into Todo (id,item,completed)"
        " VALUES (?,?,?)",
        [id, item, false]);
  }

  deleteAllCompletedTodos() async {
    final db = await database;
    return await db.delete("Todo", where: "completed = ?", whereArgs: [1]);
  }

  Future<List<Todo>> getAllTodos() async {
    final db = await database;
    var res = await db.query("Todo");
    List<Todo> list =
        res.isNotEmpty ? res.map((t) => Todo.fromMap(t)).toList() : [];
    return list;
  }

  Future<List<Preference>> getAllPrefences() async {
    final db = await database;
    var res = await db.query("Preferences");
    List<Preference> list =
        res.isNotEmpty ? res.map((p) => Preference.fromMap(p)).toList() : [];
    return list;
  }

  Future<List<Todo>> getUncompletedTodos() async {
    final db = await database;
    var res = await db.query("Todo", where: "completed = ?", whereArgs: [0]);
    List<Todo> list =
        res.isNotEmpty ? res.map((t) => Todo.fromMap(t)).toList() : [];
    return list;
  }

  Future<List<Todo>> getCompletedTodos() async {
    final db = await database;
    var res = await db.query("Todo", where: "completed = ?", whereArgs: [1]);
    List<Todo> list =
        res.isNotEmpty ? res.map((t) => Todo.fromMap(t)).toList() : [];
    return list;
  }

  deleteTodo(int id) async {
    final db = await database;
    return db.delete("Todo", where: "id = ?", whereArgs: [id]);
  }

  deleteDB() async {
    try {
      var databasesPath = await getDatabasesPath();
      String path = join(databasesPath, 'main.db');

      // Delete the database
      await deleteDatabase(path);
    } catch (ex) {
      print(ex);
    }
  }
}
