import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/data/todo_model.dart';
import 'package:todo_app/state/todos_state.dart';

class Completed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final todoState = Provider.of<TodosState>(context);
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
            child: Center(
              child: todoState.isFetching
                  ? CircularProgressIndicator()
                  : todoState.completedTodos.length > 0
                      ? ListView.builder(
                          itemCount: todoState.completedTodos.length,
                          itemBuilder: (context, index) {
                            return _buildCompletedTile(
                                todoState.completedTodos[index]);
                          },
                        )
                      : Text("No completed todos"),
            ),
          ),
          FloatingActionButton.extended(
            onPressed: () {
              todoState.clearCompletedTodos();
            },
            icon: Icon(Icons.clear_all),
            label: Text("Clear All Completed"),
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(),
          )
        ],
      ),
    );
  }

  Widget _buildCompletedTile(Todo todo) {
    return Container(
      padding: EdgeInsets.all(10),
      child: ListTile(
        title: Text(
          '${todo.item}',
          style: TextStyle(decoration: TextDecoration.lineThrough),
        ),
      ),
    );
  }
}
