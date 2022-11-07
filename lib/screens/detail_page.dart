import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:todo_app/screens/edit_note_page.dart';
import 'package:todo_app/src/constants.dart';
import 'package:todo_app/src/models/note.dart';
import 'package:todo_app/src/provider/provider_data.dart';
import 'package:todo_app/src/services.dart';
import 'package:todo_app/widgets/checkbox_widget.dart';

///
class DetailPage extends StatefulWidget {
  ///
  final Note? note;

  ///
  final int noteId;

  ///
  const DetailPage({this.note, required this.noteId});
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  List<Todo> taskList = [];
  @override
  void initState() {
    // _noteInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const DetailPageFuture();
  }

  @override
  void dispose() {
    super.dispose();
  }
}

///
class DetailPageFuture extends StatefulWidget {
  ///
  const DetailPageFuture({
    Key? key,
    //this.noteInfo,
  }) : super(key: key);

  @override
  State<DetailPageFuture> createState() => _DetailPageFutureState();
}

class _DetailPageFutureState extends State<DetailPageFuture> {
  ///
  void _showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  ///
  void _checkInputText(String taskStr) {
    if (taskStr.isEmpty) {
      return _showSnackBar('Please, enter some text');
    }
    if (taskStr.isNotEmpty) {
      Services.of(context).notesService.createTask(
            taskStr,
            Provider.of<ProviderData>(context, listen: false).getNoteInfo?.id ??
                0,
          );
    }
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        // _getTask();
      });
    });
    Navigator.of(context).pop();
  }

  Future _inputDialog(BuildContext context) async {
    String taskStr = '';

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('New task'),
          content: Column(
            children: [
              Expanded(
                child: Image.network(
                  dotenv.get('inputDialogPicture'),
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      maxLines: maxLinesK,
                      minLines: 1,
                      maxLength: maxLengthK,
                      autofocus: true,
                      validator: (value) {
                        _checkInputText(value?.trim() ?? '');

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
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Done'),
              onPressed: () => _checkInputText(taskStr.trim()),
            ),
          ],
        );
      },
    );
  }

  void _removeAllTask() {
    for (int i = 0;
        i <
            Provider.of<ProviderData>(context, listen: false)
                .taskListProvider
                .length;
        i++) {
      Services.of(context).notesService.deleteTask(
            Provider.of<ProviderData>(context, listen: false)
                .taskListProvider[i]
                .id,
          );
    }
    setState(() {});
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final String _lastChangesTime = timeago.format(
      Provider.of<ProviderData>(context).getNoteInfo?.modifyTime ??
          DateTime.now(),
    );

    return Scaffold(
      appBar: AppBar(
        actions: const [
          RemoveTaskButtonWidget(),
        ],
        title: Text(
          Provider.of<ProviderData>(context).getNoteInfo?.title ?? 'Title',
          //widget.noteInfo?.title ?? 'Title',
          style:
              TextStyle(color: Provider.of<ProviderData>(context).getTextColor),
        ),
        backgroundColor: colorPallete[
            Provider.of<ProviderData>(context).getNoteInfo?.colorNote ?? 0],
      ),
      bottomNavigationBar: BottomAppBar(
        color: colorPallete[
            Provider.of<ProviderData>(context).getNoteInfo?.colorNote ?? 0],
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              color: context.read<ProviderData>().getTextColor,
              onPressed: () {
                _inputDialog(context);
              },
              icon: const Icon(Icons.add_box_outlined),
            ),
            Text(
              'Last changes: $_lastChangesTime',
              style:
                  TextStyle(color: context.read<ProviderData>().getTextColor),
            ),
            IconButton(
              color: context.read<ProviderData>().getTextColor,
              onPressed: () {
                showModalBottomSheet<void>(
                  backgroundColor: colorPallete.first,
                  context: context,
                  builder: (BuildContext context) {
                    return SizedBox(
                      height: sizedBoxHeightModal,
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
                                    note: Provider.of<ProviderData>(context)
                                        .getNoteInfo,
                                  ),
                                ),
                              );
                            },
                            child: SizedBox(
                              height: sizedBoxHeight,
                              child: Row(
                                children: const [
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Icon(
                                    Icons.note_alt_outlined,
                                    color: Colors.black,
                                  ),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  Text(
                                    'Edit note',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          InkWell(
                            child: SizedBox(
                              height: sizedBoxHeight,
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  const Icon(
                                    Icons.photo_outlined,
                                    color: Colors.black,
                                  ),
                                  const SizedBox(
                                    width: 30,
                                  ),
                                  Text(
                                    'Add image',
                                    style: TextStyle(
                                      color:
                                          Colors.black.withOpacity(textOpacity),
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
                            onTap: () => _removeAllTask(),
                            child: SizedBox(
                              height: sizedBoxHeight,
                              child: Row(
                                children: const [
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Icon(
                                    Icons.delete,
                                    color: Colors.black,
                                  ),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  Text(
                                    'Clear all tasks',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              icon: const Icon(Icons.more_vert_outlined),
            )
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Text(
              Provider.of<ProviderData>(context).getNoteInfo?.content ?? '',
              style: TextStyle(
                fontSize: fontSizeK,
                color: context.read<ProviderData>().getTextColor,
              ),
            ),
            Expanded(
              child: CheckBoxWidget(
                note: Provider.of<ProviderData>(context).getNoteInfo ??
                    Note(
                      0,
                      'title',
                      'content',
                      DateTime.now(),
                      DateTime.now(),
                      0,
                    ),
              ),
            )
          ],
        ),
      ),
      backgroundColor: colorPallete[
          Provider.of<ProviderData>(context).getNoteInfo?.colorNote ?? 0],
    );
  }
}

///
class RemoveTaskButtonWidget extends StatelessWidget {
  ///
  const RemoveTaskButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return context.watch<ProviderData>().getRemoveTask
        ? IconButton(
            color: Provider.of<ProviderData>(context).getTextColor,
            onPressed: () {
              context.read<ProviderData>().remove();
            },
            icon: const Icon(
              Icons.check,
              //color: Colors.redAccent,
            ),
          )
        : IconButton(
            color: Provider.of<ProviderData>(context).getTextColor,
            onPressed: () {
              context.read<ProviderData>().remove();
            },
            icon: const Icon(Icons.edit),
          );
  }
}

///
class RemoveTaskWidget extends StatelessWidget {
  ///
  final int task;

  ///
  final int taskIndex;

  ///
  const RemoveTaskWidget({
    super.key,
    required this.task,
    required this.taskIndex,
  });

  @override
  Widget build(BuildContext context) {
    return context.watch<ProviderData>().getRemoveTask
        ? IconButton(
            color: Provider.of<ProviderData>(context).getTextColor,
            onPressed: () {
              //print(object)
              Services.of(context).notesService.deleteTask(task);
              Provider.of<ProviderData>(
                context,
                listen: false,
              ).removeTask(taskIndex);

              // Future.delayed(const Duration(milliseconds: 200), () {
              //   setState(() {
              //     _getTask();
              //   });
              // });
            },
            icon: const Icon(
              Icons.clear,
              //color: Colors.redAccent,
            ),
          )
        : const SizedBox();
    // : IconButton(
    //     onPressed: () {
    //       context.read<ProviderData>().remove();
    //     },
    //     icon: const Icon(Icons.access_alarm),
    //   );
  }
}
