import 'package:flutter/foundation.dart';
import 'package:todo_app/data/database.dart';
import 'package:todo_app/data/todo_model.dart';

class TodosState with ChangeNotifier {
  List<Todo> _uncompleted = [];
  List<Todo> _completed = [];

  TodosState._() {
    _uncompletedFromDb();
  }

  factory TodosState() {
    return TodosState._();
  }

  bool _isFetching = false;

  bool get isFetching => _isFetching;

  void getTodos(int index) {
    if(index == 0) {
      _uncompletedFromDb();
    } else if(index == 1) {
      _completedFromDb();
    }
  }

  List<Todo> get uncompletedTodos {
    return _uncompleted;
  }

  List<Todo> get completedTodos {
    return _completed;
  }

  Future<void> _uncompletedFromDb() async {
    _isFetching = true;
    notifyListeners();
    await DBProvider.db.getUncompletedTodos().then((result) => {
          this._uncompleted = result,
        });
    _isFetching = false;
    notifyListeners();
  }

  Future<void> _completedFromDb() async {
    _isFetching = true;
    notifyListeners();
    await DBProvider.db.getCompletedTodos().then((result) => {
      this._completed = result
    });
    _isFetching = false;
    notifyListeners();
  }

  Future<void> _getUncompletedWithoutIcon() async {
    await DBProvider.db.getUncompletedTodos().then((result) => {
          this._uncompleted = result,
        });
    notifyListeners();
  }

  Future<void> saveTodo(String todo) async {
    await DBProvider.db.newTodo(todo);
    await _getUncompletedWithoutIcon();
  }

  Future<void> completeTodo(Todo todo) async {
    await DBProvider.db.completedOrUncompleteTask(todo);
    await _getUncompletedWithoutIcon();
  }

  void deleteTodo(int id) async {
    await DBProvider.db.deleteTodo(id);
    await _getUncompletedWithoutIcon();
  }

  void clearCompletedTodos() async {
    await DBProvider.db.deleteAllCompletedTodos();
    await _completedFromDb();
    notifyListeners();
  }
}
