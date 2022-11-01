// ignore_for_file: public_member_api_docs, avoid_dynamic_calls, lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:todo_app/screens/edit_note_page.dart';
import 'package:todo_app/src/constants.dart';
import 'package:todo_app/src/supabase_manager.dart';

class DetailPage extends StatefulWidget {
  final Note? note;

  const DetailPage({this.note});
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Color _colText = textColorK;
  List<Todo> taskList = [];
  //late Note test;
  @override
  void initState() {
    _colText = _updateColor();
    //context.read<ProviderData>().listTaskProvider(widget.note!.id);
    //_getTask();
    //var test = _getNoteInfo() as Future<Future<Object>>;
    //print(test);
    // _getNoteInfo();
    super.initState();

    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   context.read<ProviderData>().listTaskProvider(widget.note!.id);
    // });
  }

  Future<List<Todo>> _getTask() async {
    final _dataTasks =
        Services.of(context).notesService.getTaskById(widget.note?.id ?? 0);
    // final _dataTasks =
    //     context.watch<ProviderData>().listTaskProvider(widget.note!.id);

    return _dataTasks;
  }

  Future<List<Note>> _getNoteInfo() async {
    final _noteInfo =
        Services.of(context).notesService.getNotesById(widget.note?.id ?? 0);

    return _noteInfo;
  }

  ///
  // Future<List<Todo>> _getTaskProvider() async {
  //   // final _dataTasks =
  //   //     Services.of(context).notesService.getTaskById(widget.note!.id);

  //   //context.read<ProviderData>().getListOfTask = _dataTasks;
  //   final _dataTasks =
  //       context.read<ProviderData>().listTaskProvider(widget.note!.id);

  //   return _dataTasks;
  // }

  Color _updateColor() {
    final Color dataColor = ThemeData.estimateBrightnessForColor(
              colorPallete[widget.note?.colorNote ?? 0],
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
          //test.first.title,
          widget.note?.title ?? 'Title',
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
              'Last changes: ${widget.note?.modifyTime.hour ?? 0}:${widget.note?.modifyTime.minute ?? 0}',
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
                        return SizedBox(
                          height: 150,
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
                                      ),
                                    ),
                                  );
                                },
                                child: SizedBox(
                                  height: sizedBoxHeight,
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
                                  height: sizedBoxHeight,
                                  child: Row(
                                    children: [
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Icon(
                                        Icons.photo_outlined,
                                        color:
                                            _colText.withOpacity(textOpacity),
                                      ),
                                      const SizedBox(
                                        width: 30,
                                      ),
                                      Text(
                                        'Add image',
                                        style: TextStyle(
                                          color:
                                              _colText.withOpacity(textOpacity),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              InkWell(
                                onTap: () {
                                  for (int i = 0; i < taskList.length; i++) {
                                    Services.of(context)
                                        .notesService
                                        .deleteTask(taskList[i].id);
                                    _getTask();
                                  }
                                  Navigator.pop(context);
                                  // ignore: no-empty-block
                                  setState(() {});
                                },
                                child: SizedBox(
                                  height: sizedBoxHeight,
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
                      },);
                },
                icon: const Icon(Icons.more_vert_outlined),)
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Text(
              widget.note?.content ?? '',
              style: TextStyle(fontSize: 20, color: _colText),
            ),
            Expanded(
                child: CheckBox(
              note: widget.note!,
            ),),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
      backgroundColor: colorPallete[widget.note?.colorNote ?? 0],
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
                    taskStr = value.trim();
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
                // setState(() {
                //   Navigator.of(context).pop();
                //   _getTask();
                // });
                Future.delayed(const Duration(milliseconds: 200), () {
                  setState(() {
                    _getTask();
                  });
                });
                Navigator.of(context).pop();
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

class CheckBox extends StatefulWidget {
  final Note note;
  const CheckBox({Key? key, required this.note}) : super(key: key);

  @override
  State<CheckBox> createState() => _CheckBoxState();
}

class _CheckBoxState extends State<CheckBox> {
  List<Todo> taskList = [];
  Color _colText = textColorK;

  Future<List<Todo>> _getTask() async {
    final _dataTasks =
        Services.of(context).notesService.getTaskById(widget.note.id);

    return _dataTasks;
  }

  Color _updateColor() {
    final Color dataColor = ThemeData.estimateBrightnessForColor(
              colorPallete[widget.note.colorNote],
            ) ==
            Brightness.light
        ? const Color.fromARGB(255, 97, 85, 85)
        : Colors.white;

    return dataColor;
  }

  @override
  void initState() {
    super.initState();
    _colText = _updateColor();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Todo>>(
      future: _getTask(),
      builder: (context, snaphot) {
        final _tasks = snaphot.data ?? [];
        taskList = _tasks;
        if (snaphot.hasData) {
          return ListView.builder(
            itemCount: _tasks.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onHorizontalDragEnd: (vert) {
                  if (_tasks[index].check) {
                    _tasks[index].check = false;
                    Services.of(context).notesService.updateTaskById(
                          _tasks[index].id,
                          _tasks[index].check,
                        );
                  } else {
                    _tasks[index].check = true;
                    Services.of(context).notesService.updateTaskById(
                          _tasks[index].id,
                          _tasks[index].check,
                        );
                  }
                  Future.delayed(const Duration(milliseconds: 200), () {
                    setState(() {
                      _getTask();
                    });
                  });
                },
                onLongPress: () {
                  Services.of(context)
                      .notesService
                      .deleteTask(_tasks[index].id);
                  // ignore: no-empty-block
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
                                ? _colText.withOpacity(textOpacity)
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
                          Future.delayed(const Duration(milliseconds: 200), () {
                            setState(() {
                              _getTask();
                            });
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
}
