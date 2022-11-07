import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/screens/detail_page.dart';
import 'package:todo_app/screens/edit_note_page.dart';
import 'package:todo_app/screens/login_widget.dart';
import 'package:todo_app/src/constants.dart';
import 'package:todo_app/src/models/note.dart';
import 'package:todo_app/src/provider/provider_data.dart';
import 'package:todo_app/src/services.dart';
///
class GroupNotesWidget extends StatefulWidget {
  ///
  const GroupNotesWidget({Key? key}) : super(key: key);

  @override
  State<GroupNotesWidget> createState() => _GroupNotesWidgetState();
}

class _GroupNotesWidgetState extends State<GroupNotesWidget> {
  Future<void> _addNote() async {
    final note = await Navigator.push<Note?>(
      context,
      MaterialPageRoute(builder: (context) => const EditNotePage()),
    );
    if (note != null) {
      // ignore: no-empty-block
      setState(() {});
    }
  }

  Future<void> _editNote(Note note) async {
    final updatedNote = await Navigator.push<Note?>(
      context,
      MaterialPageRoute(builder: (context) => EditNotePage(note: note)),
    );
    if (updatedNote != null) {
      // ignore: no-empty-block
      setState(() {});
    }
  }

  Future<void> _detailNote(Note note) async {
    Provider.of<ProviderData>(context, listen: false).noteInfo = note;
    final updatedNote = await Navigator.push<Note?>(
      context,
      MaterialPageRoute(
        builder: (context) => DetailPage(
          note: note,
          noteId: note.id,
        ),
      ),
    );
    if (updatedNote != null) {
      // ignore: no-empty-block
      setState(() {});
    }
  }

  void refresh() {
    // ignore: no-empty-block
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('List of notes'),
        actions: [
          IconButton(
            onPressed: () {
              Provider.of<ProviderData>(context, listen: false).deleteAllNote();
            },
            icon: const Icon(Icons.abc),
          ),
          IconButton(
            onPressed: () {
              refresh();
            },
            icon: const Icon(Icons.refresh),
          ),
          const _LogOutButton(),
        ],
      ),
      body: ListView(
        children: [
          FutureBuilder<List<Note>>(
            future: Services.of(context).notesService.getNotes(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: primaryColor),
                );
              }
              final notes = (snapshot.data ?? [])
                ..sort(
                  (x, y) =>
                      y.modifyTime.difference(x.modifyTime).inMilliseconds,
                );
              Provider.of<ProviderData>(context).noteList = notes;
              //notess = notes;

              return Column(
                children: Provider.of<ProviderData>(context)
                    .getNoteList
                    .map(_toNoteWidget)
                    .toList(),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Add note'),
        icon: const Icon(Icons.add),
        onPressed: _addNote,
      ),
    );
  }

  Widget _toNoteWidget(Note note) {

    return Dismissible(
      key: ValueKey(note.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) =>
          Services.of(context).notesService.deleteNote(note.id),
      onDismissed: (_) => setState(() {}),
      background: Container(
        padding: const EdgeInsets.all(16.0),
        color: Theme.of(context).errorColor,
        alignment: Alignment.centerRight,
        child: const Icon(Icons.delete),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          color: colorPallete[note.colorNote],
          child: ListTile(
            leading: const Icon(Icons.paste),
            trailing: const Icon(Icons.arrow_forward_ios),
            title: Text(
              note.title,
              style: const TextStyle(fontSize: 25),
            ),
            subtitle: Text(note.content ?? ''),
            onLongPress: () => _editNote(note),
            onTap: () => _detailNote(note),
          ),
        ),
      ),
    );
  }
}

class _LogOutButton extends StatefulWidget {
  const _LogOutButton({Key? key}) : super(key: key);

  @override
  State<_LogOutButton> createState() => _LogOutButtonState();
}

class _LogOutButtonState extends State<_LogOutButton> {
  Future<void> _signOut() async {
    final success = await Services.of(context).authService.signOut();
    if (success) {
      await Navigator.pushReplacement<void, void>(
        context,
        MaterialPageRoute(builder: (_) => const LoginWidget()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('There was an issue logging out.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: _signOut,
      icon: const Icon(Icons.logout),
    );
  }
}
