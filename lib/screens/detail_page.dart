// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:todo_app/src/constants.dart';
import 'package:todo_app/src/supabase_manager.dart';

import 'edit_page.dart';

class NotePage extends StatefulWidget {
  final Note? note;

  NotePage({this.note});
  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  Color _colText = textColorK;
  List<Todo> testList = [];
  //late Future<List<Todo>> allTodo;
  @override
  void initState() {
    _colText = _updateColor();

    super.initState();
  }

  Future<List<Todo>> _getTask() async {
    final _dataTasks =
        Services.of(context).notesService.getTaskById(widget.note!.id);
    return _dataTasks;
  }

  Color _updateColor() {
    final Color dataColor = ThemeData.estimateBrightnessForColor(
              colorPallete[widget.note!.colorNote],
            ) ==
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
      appBar: AppBar(
        title: Text(
          widget.note!.title,
          style: TextStyle(color: _colText),
        ),
        backgroundColor: colorPallete[widget.note?.colorNote ?? 0],
      ),
      bottomNavigationBar: BottomAppBar(
        color: colorPallete[widget.note?.colorNote ?? 0],
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              color: _colText,
              onPressed: () {
                _inputDialog(context);
              },
              icon: const Icon(Icons.add_box_outlined),
            ),
            Text(
              'Last changes: ${widget.note!.modifyTime.hour}:${widget.note!.modifyTime.minute}',
              style: TextStyle(color: _colText),
            ),
            IconButton(
                color: _colText,
                onPressed: () {
                  showModalBottomSheet(
                      backgroundColor:
                          colorPallete[widget.note?.colorNote ?? 0],
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          height: MediaQuery.of(context).size.height * 0.17,
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 15,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push<Note?>(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EditNotePage(
                                              note: widget.note,
                                            )),
                                  );
                                },
                                child: SizedBox(
                                  height: 30,
                                  child: Row(
                                    children: [
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Icon(
                                        Icons.note_alt_outlined,
                                        color: _colText,
                                      ),
                                      const SizedBox(
                                        width: 30,
                                      ),
                                      Text(
                                        'Edit note',
                                        style: TextStyle(color: _colText),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              InkWell(
                               // onTap: (() => print('dddd')),
                                child: SizedBox(
                                  height: 30,
                                  child: Row(
                                    children: [
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Icon(
                                        Icons.photo_outlined,
                                        color: _colText,
                                      ),
                                      const SizedBox(
                                        width: 30,
                                      ),
                                      Text(
                                        'Add image',
                                        style: TextStyle(color: _colText),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              InkWell(
                                onTap: () {
                                  for (int i = 0; i < testList.length; i++) {
                                    Services.of(context)
                                        .notesService
                                        .deleteTask(testList[i].id);
                                    _getTask();
                                  }
                                  Navigator.pop(context);
                                  setState(() {});
                                },
                                child: SizedBox(
                                  height: 30,
                                  child: Row(
                                    children: [
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Icon(
                                        Icons.delete,
                                        color: _colText,
                                      ),
                                      const SizedBox(
                                        width: 30,
                                      ),
                                      Text(
                                        'Clear all tasks',
                                        style: TextStyle(color: _colText),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      });
                },
                icon: const Icon(Icons.more_vert_outlined))
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Text(
              widget.note!.content ?? '',
              style: TextStyle(fontSize: 20, color: _colText),
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
      future: _getTask(),
      builder: (context, snaphot) {
        final _tasks = snaphot.data ?? [];
        testList = _tasks;
        if (snaphot.hasData) {
          return ListView.builder(
            itemCount: _tasks.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onLongPress: () {
                  Services.of(context)
                      .notesService
                      .deleteTask(_tasks[index].id);
                  setState(() {});
                },
                child: Row(
                  children: [
                    Expanded(
                      child: CheckboxListTile(
                        checkColor: textColorK,
                        activeColor: Colors.white60,
                        title: Text(
                          _tasks[index].task,
                          style: TextStyle(
                            fontSize: 20,
                            decoration: _tasks[index].check
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            color: _tasks[index].check
                                ? _colText.withOpacity(0.5)
                                : _colText,
                          ),
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                        value: _tasks[index].check,
                        onChanged: (bool? value) {
                          _tasks[index].check = value!;
                          Services.of(context).notesService.updateTaskById(
                                _tasks[index].id,
                                _tasks[index].check,
                              );
                          setState(() {
                            _getTask();
                          });
                        },
                      ),
                    )
                  ],
                ),
              );
            },
          );
        }

        return const Center(
          child: CircularProgressIndicator(
            color: Colors.black,
            backgroundColor: Colors.white,
          ),
        );
      },
    );
  }

  Future _inputDialog(BuildContext context) async {
    String taskStr = '';

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('New task'),
          content: Row(
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  maxLines: 5,
                  minLines: 1,
                  maxLength: 70,
                  autofocus: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please, enter some text';
                    }

                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Print new task',
                  ),
                  onChanged: (value) {
                    taskStr = value;
                  },
                ),
              )
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
                  _getTask();
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
