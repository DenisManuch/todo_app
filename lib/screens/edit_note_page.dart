import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/src/constants.dart';
import 'package:todo_app/src/models/note.dart';
import 'package:todo_app/src/provider/provider_data.dart';
import 'package:todo_app/src/services.dart';
///
class EditNotePage extends StatefulWidget {
  ///
  final Note? note;
///
  const EditNotePage({this.note});

  @override
  _EditNotePageState createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  int _colorTap = 0;

  Future<void> _saveNote() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    if (title.isEmpty) {
      _showSnackBar('Title cannot be empty.');

      return;
    }
    final note = await _createOrUpdateNote(title, content);
    if (note != null) {
      Provider.of<ProviderData>(context, listen: false).changeNote(note);
      Navigator.pop(context, note);
    } else {
      _showSnackBar('Something went wrong.');
    }
  }

  Future<Note?> _createOrUpdateNote(String title, String content) {
    final notesService = Services.of(context).notesService;

    return widget.note != null
        ? notesService.updateNote(
            widget.note?.id ?? 0,
            title,
            content,
            _colorTap,
          )
        : notesService.createNote(title, content, _colorTap);
  }

  void _showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(
          widget.note != null ? 'Edit note' : 'New note',
        ),
      ),
      body: Column(
        children: <Widget>[
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              maxLength: maxLengthK,
              autofocus: true,
              style: const TextStyle(color: whiteColor),
              controller: _titleController,
              //validator: (value) => _validator(value!),
              decoration: const InputDecoration(
                counterStyle: TextStyle(color: whiteColor),
                hintText: 'Title',
                hintStyle: TextStyle(color: whiteColor),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: whiteColor),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: whiteColor),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              maxLength: maxLengthK,
              maxLines: maxLinesK,
              minLines: 1,
              style: const TextStyle(color: whiteColor),
              controller: _contentController,
              decoration: const InputDecoration(
                counterStyle: TextStyle(color: whiteColor),
                hintText: 'Description',
                hintStyle: TextStyle(color: whiteColor),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: whiteColor),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: whiteColor),
                ),
              ),
            ),
          ),
          SizedBox(
            height: sizedBoxHeightPallete,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: colorPallete.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    _colorTap = index;
                    // ignore: no-empty-block
                    setState(() {});
                  },
                  child: CircleTap(
                    color: index,
                    circleTap: _colorTap,
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveNote,
        child: const Text('Save'),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note?.title ?? 'title';
      _contentController.text = widget.note?.content ?? '';
      _colorTap = widget.note?.colorNote ?? 0;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
}
///
class CircleTap extends StatelessWidget {
  ///
  final int color;
  ///
  final int circleTap;
  ///
  const CircleTap({Key? key, required this.color, required this.circleTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: circleHeightK,
        height: circleHeightK,
        decoration: BoxDecoration(
          color: colorPallete[color],
          shape: BoxShape.circle,
          border: Border.all(width: circleBorderK, color: Colors.black38),
        ),
        child: color == circleTap ? const Icon(Icons.done) : null,
      ),
    );
  }
}
