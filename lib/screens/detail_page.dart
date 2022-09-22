import 'package:flutter/material.dart';
import 'package:todo_app/src/constants.dart';
import 'package:todo_app/src/supabase_manager.dart';

class NotePage extends StatefulWidget {
  final Note? note;

  NotePage({this.note});

  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  @override
  void initState() {
    textColor = _updateColor();
    iconColor = _updateColor();
    super.initState();
  }

  Future<List<Todo>> _getTask() async {
    var dataTasks =
        Services.of(context).notesService.getTaskById(widget.note!.id);
    return dataTasks;
  }

  Color _updateColor() {
    Color dataColor = ThemeData.estimateBrightnessForColor(
                colorPallete[widget.note!.colorNote]) ==
            Brightness.light
        ? const Color.fromARGB(255, 97, 85, 85)
        : Colors.white;

    return dataColor;
  }

  void _showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            _inputDialog(context);
          },
          child: const Text('Add task')),
      appBar: AppBar(
        title: Text(
          widget.note!.title,
          style: TextStyle(color: textColor),
        ),
        backgroundColor: colorPallete[widget.note?.colorNote ?? 0],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Text(
              widget.note!.content ?? '',
              style: TextStyle(fontSize: 20, color: textColor),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(child: _checkBox()),
          ],
        ),
      ),
      backgroundColor: colorPallete[widget.note!.colorNote],
    );
  }

  Widget _checkBox() {
    return FutureBuilder<List<Todo>>(
        future:
            _getTask(), 
        builder: (context, snaphot) {
          var tasks = (snaphot.data ?? []);
          if (snaphot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
                backgroundColor: Colors.white,
              ),
            );
          }
          if (snaphot.connectionState == ConnectionState.done) {
            return ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  if (tasks.isEmpty) {
                    return const Text('No tasks');
                  }
                  return GestureDetector(
                    onLongPress: () {
                      Services.of(context)
                          .notesService
                          .deleteTask(tasks[index].id);
                      setState(() {});
                    },
                    child: Row(
                      children: [
                        Checkbox(
                            value: tasks[index].check,
                            onChanged: (bool? value) {
                              tasks[index].check = value!;
                              setState(() {
                                Services.of(context)
                                    .notesService
                                    .updateTaskById(
                                        tasks[index].id, tasks[index].check);
                              });
                            }),
                        Expanded(
                          child: Text(
                            tasks[index].task,
                            style: TextStyle(
                              fontSize: 30,
                              decoration: tasks[index].check
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                              color: tasks[index].check
                                  ? textColor.withOpacity(0.5)
                                  : textColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                });
          }
          return const Text('No data!');
        });
  }

  Future _inputDialog(BuildContext context) async {
    String taskStr = '';
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('New task'),
          content: Row(
            children: <Widget>[
              Expanded(
                  child: TextFormField(
                autofocus: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please, enter some text';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    labelText: 'Prin new task', hintText: 'Task'),
                onChanged: (value) {
                  taskStr = value;
                },
              ))
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Done'),
              onPressed: () {
                if (taskStr.isEmpty) {
                  return _showSnackBar('Please, enter some text');
                }
                if (taskStr.isNotEmpty) {
                  Services.of(context)
                      .notesService
                      .createTask(taskStr, widget.note!.id);
                }
                setState(() {
                  Navigator.of(context).pop();
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
