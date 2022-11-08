// ignore_for_file: avoid_dynamic_calls, unused_local_variable

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todo_app/src/models/note.dart';

///
class NotesService {
  ///
  static const notes = 'notes';

  ///
  static const todoList = 'tasks_list';

  final SupabaseClient _client;

  // ignore: public_member_api_docs
  NotesService(this._client);

  ///
  Future<List<Note>> getNotes() async {
    final response = await _client
        .from(notes)
        .select('id, title, content, create_time, modify_time, color_note')
        .execute();
    if (response.error == null) {
      final results = response.data as List<dynamic>;

      return results.map((dynamic e) => toNote(e)).toList();
    }
    debugPrint('Error geting notes: ${response.error?.message}');

    return [];
  }

  ///
  Future<List<Note>> getNotesById(int taskId) async {
    final response = await _client
        .from(notes)
        .select('id, title, content, create_time, modify_time')
        .eq('id', taskId)
        .execute();
    if (response.error == null) {
      final results = response.data as List<dynamic>;

      return results.map((dynamic e) => toNote(e)).toList();
    }
    debugPrint('Error geting notes: ${response.error?.message}');

    return [];
  }

  ///
  Future<List<Todo>> getTaskById(int taskId) async {
    final response = await _client
        .from(todoList)
        .select()
        .eq('note_id', taskId)
        .order('id', ascending: true)
        .execute();
    if (response.error == null) {
      final results = response.data as List<dynamic>;

      return results
          .map((dynamic e) => toTask(e as Map<String, dynamic>))
          .toList();
    }
    debugPrint('Error geting task: ${response.error?.message}');

    return [];
  }

  ///
  // ignore: avoid_positional_boolean_parameters
  Future<Todo?> updateTaskById(int taskId, bool check) async {
    final response = await _client
        .from(todoList)
        .update(<String, dynamic>{
          'check_task': check,
        })
        .eq('id', taskId)
        .execute();

    return null;
  }

  ///
  Future<Todo?> createTask(String task, int noteId) async {
    final response = await _client
        .from(todoList)
        .insert({'text': task, 'note_id': noteId}).execute();
    if (response.error == null) {
      final results = response.data as List<dynamic>;

      return toTask(results.first as Map<String, dynamic>);
    }
    debugPrint('Error creating note: ${response.error?.message}');

    return null;
  }

  ///
  Future<bool> deleteTask(int id) async {
    final response =
        await _client.from(todoList).delete().eq('id', id).execute();
    if (response.error == null) {
      return true;
    }
    debugPrint('Error deleting taks: ${response.error?.message}');

    return false;
  }

  ///
  Future<Note?> createNote(String title, String? content, int color) async {
    final response = await _client.from(notes).insert(
      {'title': title, 'content': content, 'color_note': color},
    ).execute();
    if (response.error == null) {
      final results = response.data as List<dynamic>;

      return toNote(results.first);
    }
    debugPrint('Error creating note: ${response.error?.message}');

    return null;
  }

  ///
  Future<Note?> updateNote(
    int id,
    String title,
    String? content,
    int color,
  ) async {
    final response = await _client
        .from(notes)
        .update(<String, dynamic>{
          'title': title,
          'content': content,
          'color_note': color,
          'modify_time': 'now()'
        })
        .eq('id', id)
        .execute();
    if (response.error == null) {
      final results = response.data as List<dynamic>;

      return toNote(results.first);
    }
    debugPrint('Error editing note: ${response.error?.message}');

    return null;
  }

  ///
  Future<bool> deleteNote(int id) async {
    final response = await _client.from(notes).delete().eq('id', id).execute();
    if (response.error == null) {
      return true;
    }
    debugPrint('Error deleting note: ${response.error?.message}');

    return false;
  }

  ///
  // ignore: type_annotate_public_apis
  Note toNote(dynamic result) {
    return Note(
      int.parse(result['id'].toString()),
      result['title'].toString(),
      result['content'].toString(),
      DateTime.parse(result['create_time'].toString()),
      DateTime.parse(result['modify_time'].toString()),
      int.parse(result['color_note'].toString()),
    );
  }

  ///
  Todo toTask(Map<String, dynamic> result) {
    return Todo(
      int.parse(result['id'].toString()),
      check: result['check_task'] as bool,
      result['text'].toString(),
    );
  }
}

// ///
// class DataClass extends ChangeNotifier {
//   ///
//   List? post;
//   bool loading = false;

//   ///
//   ///
//   ///
//   getNotesData() async {
//     loading = true;
//     post = await getNotes();
//     loading = false;
//   }
// }
