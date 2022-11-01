// ignore_for_file: public_member_api_docs, lines_longer_than_80_chars

import 'package:flutter/material.dart';

import 'package:todo_app/src/constants.dart';
import 'package:todo_app/src/supabase_manager.dart';

class EditNotePage extends StatefulWidget {
  final Note? note;

  const EditNotePage({this.note});

  @override
  _EditNotePageState createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  int _colorTap = 0;

  Future<void> _saveNote() async {
    final title = _titleController.text;
    final content = _contentController.text;
    if (title.isEmpty) {
      _showSnackBar('Title cannot be empty.');

      return;
    }
    final note = await _createOrUpdateNote(title, content);
    if (note != null) {
      // ignore: use_build_context_synchronously
      Navigator.pop(context, note);
    } else {
      _showSnackBar('Something went wrong.');
    }
  }

  Future<Note?> _createOrUpdateNote(String title, String content) {
    final notesService = Services.of(context).notesService;

    return widget.note != null
        ? notesService.updateNote(widget.note?.id ?? 0, title, content, _colorTap)
        : notesService.createNote(title, content, _colorTap);
  }

  void _showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Widget circle(int color, int circleTap) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: colorPallete[color],
          shape: BoxShape.circle,
          border: Border.all(width: 2.0, color: Colors.black38),
        ),
        child: color == circleTap ? const Icon(Icons.done) : null,
      ),
    );
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
              maxLength: 50,
              autofocus: true,
              style: const TextStyle(color: whiteColor),
              controller: _titleController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please, enter some text';
                }

                return null;
              },
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
              maxLength: 100,
              maxLines: 5,
              minLines: 1,
              style: const TextStyle(color: whiteColor),
              controller: _contentController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please, enter some text';
                }

                return null;
              },
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
            height: 100,
            child: Expanded(
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
                    child: circle(index, _colorTap),
                  );
                },
              ),
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
