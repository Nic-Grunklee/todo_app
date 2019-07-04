import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/data/todo_model.dart';
import 'package:todo_app/state/theme_state.dart';
import 'package:todo_app/state/todos_state.dart';

class Todos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final todoState = Provider.of<TodosState>(context);
    final textController = TextEditingController();

    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          TextField(
            textCapitalization: TextCapitalization.sentences,
            maxLength: 40,
            controller: textController,
            onSubmitted: (value) async {
              if (value.length > 0) await todoState.saveTodo(value);
              textController.clear();
            },
            decoration: new InputDecoration(
              hintText: 'Enter something to do...',
              contentPadding: const EdgeInsets.all(25.0),
              border: OutlineInputBorder(),
            ),
          ),
          Expanded(
            child: Center(
              child: todoState.isFetching
                  ? CircularProgressIndicator()
                  : todoState.uncompletedTodos.length > 0
                      ? ListView.builder(
                          itemCount: todoState.uncompletedTodos.length,
                          itemBuilder: (context, index) {
                            return _buildTile(
                                todoState.uncompletedTodos[index], context);
                          },
                        )
                      : Text("Please add todos"),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTile(Todo todo, BuildContext context) {
    final todoState = Provider.of<TodosState>(context);
    final themeState = Provider.of<ThemeState>(context);
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      dismissThresholds: <DismissDirection, double>{
        DismissDirection.endToStart: 0.7,
      },
      onDismissed: (direction) {
        todoState.deleteTodo(todo.id);
      },
      background: Container(
        color: Colors.red,
        child: Align(
          alignment: FractionalOffset(0.9, 0.5),
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ),
      child: ListTile(
        title: Text(todo.item),
        trailing: Checkbox(
          value: todo.completed,
          onChanged: (value) async {
            await todoState.completeTodo(todo);
            final snackBar = SnackBar(
              content: Text(
                '${todo.item} Completed! Nice work!',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 25,
                    color: themeState.isDark
                        ? themeState.getTheme().primaryColor
                        : Colors.white),
              ),
              duration: Duration(seconds: 2),
              backgroundColor: themeState.getTheme().accentColor,
            );
            Scaffold.of(context).showSnackBar(snackBar);
          },
        ),
      ),
    );
  }
}
