import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';
import 'package:todo_app/src/constants.dart';

class NotesService {
  static const notes = 'notes';
  static const todoList = 'todo_list';

  final SupabaseClient _client;

  NotesService(this._client);

  Future<List<Note>> getNotes() async {
    final response = await _client
        .from(notes)
        .select('id, title, content, create_time, modify_time, color_note')
        .execute();
    if (response.error == null) {
      final results = response.data as List<dynamic>;

      return results.map((e) => toNote(e)).toList();
    }
    debugPrint('Error geting notes: ${response.error!.message}');

    return [];
  }

  Future<List<Note>> getNotesById(int taskId) async {
    final response = await _client
        .from(notes)
        .select('id, title, content, create_time, modify_time')
        .eq('id', taskId)
        .execute();
    if (response.error == null) {
      final results = response.data as List<dynamic>;

      return results.map((e) => toNote(e)).toList();
    }
    debugPrint('Error geting notes: ${response.error!.message}');
    return [];
  }

  Future<List<Todo>> getTaskById(int taskId) async {
    final response = await _client
        .from(todoList)
        .select('id, task, check, note_id')
        .eq('note_id', taskId)
        .order('id', ascending: true)
        .execute();
    if (response.error == null) {
      final results = response.data as List<dynamic>;

      return results.map((e) => toTask(e as Map<String, dynamic>)).toList();
    }
    debugPrint('Error geting task: ${response.error!.message}');

    return [];
  }

  Future<Todo?> updateTaskById(int taskId, bool check) async {
    final response = await _client
        .from(todoList)
        .update({
          'check': check,
        })
        .eq('id', taskId)
        .execute();

    return null;
  }

  Future<Todo?> createTask(String task, int noteId) async {
    final response = await _client
        .from(todoList)
        .insert({'task': task, 'note_id': noteId}).execute();
    if (response.error == null) {
      final results = response.data as List<dynamic>;

      return toTask(results.first as Map<String, dynamic>);
    }
    debugPrint('Error creating note: ${response.error!.message}');
    return null;
  }

  Future<bool> deleteTask(int id) async {
    final response =
        await _client.from(todoList).delete().eq('id', id).execute();
    if (response.error == null) {
      return true;
    }
    debugPrint('Error deleting taks: ${response.error!.message}');

    return false;
  }

  Future<Note?> createNote(String title, String? content, int color) async {
    final response = await _client.from(notes).insert(
        {'title': title, 'content': content, 'color_note': color}).execute();
    if (response.error == null) {
      final results = response.data as List<dynamic>;

      return toNote(results[0]);
    }
    debugPrint('Error creating note: ${response.error!.message}');

    return null;
  }

  Future<Note?> updateNote(
      int id, String title, String? content, int color) async {
    final response = await _client
        .from(notes)
        .update({
          'title': title,
          'content': content,
          'color_note': color,
          'modify_time': 'now()'
        })
        .eq('id', id)
        .execute();
    if (response.error == null) {
      final results = response.data as List<dynamic>;

      return toNote(results[0]);
    }
    debugPrint('Error editing note: ${response.error!.message}');
    return null;
  }

  // Future<Note?> updateNoteModifyTime(
  //     int id) async {
  //   final response = await _client
  //       .from(notes)
  //       .update({
  //         'modify_time': 'now()'
  //       })
  //       .eq('id', id)
  //       .execute();
  //   if (response.error == null) {
  //     final results = response.data as List<dynamic>;

  //     return toNote(results[0]);
  //   }
  //   debugPrint('Error editing note: ${response.error!.message}');
  //   return null;
  // }

  Future<bool> deleteNote(int id) async {
    final response = await _client.from(notes).delete().eq('id', id).execute();
    if (response.error == null) {
      return true;
    }
    debugPrint('Error deleting note: ${response.error!.message}');

    return false;
  }

  Note toNote(result) {
    return Note(
      int.parse(result['id'].toString()),
      result['title'].toString(),
      result['content'].toString(),
      DateTime.parse(result['create_time'].toString()),
      DateTime.parse(result['modify_time'].toString()),
      int.parse(result['color_note'].toString()),
    );
  }

  Todo toTask(Map<String, dynamic> result) {
    return Todo(
      int.parse(result['id'].toString()),
      result['check'] as bool,
      result['task'].toString(),
    );
  }
}
