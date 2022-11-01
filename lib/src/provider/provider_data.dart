// ignore_for_file: avoid_dynamic_calls, type_annotate_public_apis

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todo_app/api/api_key.dart';
import 'package:todo_app/src/constants.dart';

///
class ProviderData with ChangeNotifier {
  ///
  // Note? notes;
  bool loading = false;
  final int _testd = 0;

  ///
  int get getData => _testd;
  // ignore: member-ordering-extended
  List<Note> _listOfNotes = [];
  // ignore: public_member_api_docs
  List<Note> get getListOfNote => _listOfNotes;

  // ignore: member-ordering-extended
  List<Todo> _listOfTask = [];

  ///
  List<Todo> get getListOfTask => _listOfTask;
// ignore: member-ordering-extended
  ///
  final client = SupabaseClient(supabaseUrl, supabaseKey);

  ///
  ProviderData();

  ///
  // ignore: always_declare_return_types
  Future<List<Note>> getNotesData() async {
    loading = true;
    final response = await client.from('notes').select('*').execute();
    //print(client.auth);
    final results = response.data as List<dynamic>;

    //print(_listOfNotes);
    //return results.map((e) => toNote(e)).toList();

    _listOfNotes = results.map((e) => toNote(e)).toList();
    notifyListeners();

    return [];
  }

  ///
  Future<List<Todo>> listTaskProvider(int taskId) async {
    final response = await client
        .from('tasks_list')
        .select()
        .eq('note_id', taskId)
        .order('id', ascending: true)
        .execute();
    if (response.error == null) {
      //print(response.data);
      final result = response.data as List<dynamic>;

      _listOfTask =
          result.map((e) => toTask(e as Map<String, dynamic>)).toList();
      notifyListeners();
      //print(_listOfTask);

      //return _listOfTask;
    }
    debugPrint('Error geting task: ${response.error?.message}');

    return _listOfTask;
  }

  ///
  dynamic getTestData() {
    _listOfTask.clear();
    notifyListeners();

    //return count;
  }
}
///
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

///
Todo toTask(Map<String, dynamic> result) {
  return Todo(
    int.parse(result['id'].toString()),
    result['check_task'] as bool,
    result['text'].toString(),
  );
}

///
class SupabaseData {
  ///
  final client = SupabaseClient(supabaseUrl, supabaseKey);
  final List<Note> _listOfTask = [];
  // ignore: public_member_api_docs
  List<Note> get getListOfTask => _listOfTask;

  ///
  Future<List<Todo>> getTaskById(int taskId) async {
    final response = await client
        .from('task_list')
        .select()
        .eq('note_id', taskId)
        .order('id', ascending: true)
        .execute();
    if (response.error == null) {
      final _listOfTask = response.data as List<dynamic>;

      return _listOfTask.map((e) => toTask(e as Map<String, dynamic>)).toList();
    }
    debugPrint('Error geting task: ${response.error?.message}');

    return [];
  }
}
