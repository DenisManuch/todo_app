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
      Navigator.pop(context, note);
    } else {
      _showSnackBar('Something went wrong.');
    }
  }

  Future<Note?> _createOrUpdateNote(String title, String content) {
    final notesService = Services.of(context).notesService;
    if (widget.note != null) {
      
      return notesService.updateNote(widget.note!.id, title, content, _colorTap);
    } else {
      return notesService.createNote(title, content, _colorTap);
    }
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
      appBar: AppBar(
        title: Text(widget.note != null ? 'Edit note' : 'New note'),
      ),
      body: Column(
        children: <Widget>[
          const SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              controller: _titleController,
              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please, enter some text';
                                }
                                return null;
                              },
              decoration: const InputDecoration(hintText: 'Title'),
            ),
          ),
          const SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              controller: _contentController,
              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please, enter some text';
                                }
                                return null;
                              },
              decoration: const InputDecoration(hintText: 'Description'),
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
                             setState(() {});
                          },
                          child: circle(index, _colorTap),);
                    },),),
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
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content ?? '';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
}
