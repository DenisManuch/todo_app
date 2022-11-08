import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/screens/detail_page.dart';
import 'package:todo_app/src/constants.dart';
import 'package:todo_app/src/models/note.dart';
import 'package:todo_app/src/provider/provider_data.dart';
import 'package:todo_app/src/services.dart';

///
class CheckBoxWidget extends StatefulWidget {
  ///
  final Note note;

  ///
  const CheckBoxWidget({
    Key? key,
    required this.note,
  }) : super(key: key);

  @override
  State<CheckBoxWidget> createState() => _CheckBoxState();
}

class _CheckBoxState extends State<CheckBoxWidget> {
  List<Todo> taskList = [];

  Future<List<Todo>> _getTask() async {
    final _dataTasks =
        Services.of(context).notesService.getTaskById(widget.note.id);
    //

    return _dataTasks;
  }

  @override
  void initState() {
    Future.microtask(
      () => Provider.of<ProviderData>(context, listen: false)
          .updateColor(widget.note.colorNote),
    );
    Provider.of<ProviderData>(context, listen: false).removeExit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Todo>>(
      future: _getTask(),
      builder: (context, snaphot) {
        final _tasks = snaphot.data ?? [];
        //taskList = _tasks;
        context.watch<ProviderData>().taskListProvider = _tasks;
        if (snaphot.hasData) {
          return ListView.builder(
            itemCount: context.watch<ProviderData>().taskListProvider.length,
            itemBuilder: (context, index) {
              return GestureDetector(
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
                        secondary: RemoveTaskWidget(
                          task: _tasks[index].id,
                          taskIndex: index,
                        ),
                        checkColor:
                            Provider.of<ProviderData>(context).getTextColor,
                        activeColor: colorPallete[widget.note.colorNote],
                        title: Text(
                          context
                              .watch<ProviderData>()
                              .taskListProvider[index]
                              .task,
                          style: TextStyle(
                            fontSize: fontSizeK,
                            decoration: context
                                    .watch<ProviderData>()
                                    .taskListProvider[index]
                                    .check
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            color: context
                                    .watch<ProviderData>()
                                    .taskListProvider[index]
                                    .check
                                ? context
                                    .read<ProviderData>()
                                    .getTextColor
                                    .withOpacity(textOpacity)
                                : Provider.of<ProviderData>(context)
                                    .getTextColor,
                          ),
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                        value: context
                            .watch<ProviderData>()
                            .taskListProvider[index]
                            .check,
                        onChanged: (bool? value) {
                          Provider.of<ProviderData>(context, listen: false)
                              .taskListProvider[index]
                              .check = value ?? true;
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
                    ),
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
