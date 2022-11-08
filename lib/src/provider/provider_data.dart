import 'package:flutter/material.dart';
import 'package:todo_app/src/constants.dart';
import 'package:todo_app/src/models/note.dart';

///
class ProviderData with ChangeNotifier {
  bool _removeTaskBool = false;
  Color _textColor = textColorK;
///
  List<Note> noteList = [];
 ///
  Note? noteInfo;
 ///
  List<Todo> taskListProvider = [];

  ///
  bool get getRemoveTask => _removeTaskBool;
  ///
  Color get getTextColor => _textColor;
   ///
  List<Note> get getNoteList => noteList;

   ///
  List<Todo> get getTaskList => taskListProvider;
  

  ///
  Note? get getNoteInfo => noteInfo;

  ///
  void remove() {
    _removeTaskBool = !_removeTaskBool;
    notifyListeners();
  }

  ///
  void removeExit() {
    _removeTaskBool = false;
  }

///
   

  ///
  Future<void> updateColor(int colorId) async {
    _textColor = ThemeData.estimateBrightnessForColor(
              colorPallete[colorId],
            ) ==
            Brightness.light
        ? Colors.black
        : Colors.white;
    notifyListeners();
  }

  ///
 

 

  ///
  void fetchNoteDate(Note note) {
    noteInfo = note;
    notifyListeners();
  }

  ///
  void changeNote(
    Note note,
  ) {
    noteInfo?.title = note.title;
    noteInfo?.content = note.content;
    noteInfo?.colorNote = note.colorNote;
    noteInfo?.modifyTime = note.modifyTime;
    notifyListeners();
  }

  ///
  void deleteAllNote() {
    noteList.clear();
    notifyListeners();
  }

  ///

 

  ///
  void removeTask(int taskIndex) {
    taskListProvider.removeAt(taskIndex);
    notifyListeners();
  }
///
  void removeAllTasks() {
    taskListProvider.clear();
    notifyListeners();
  }
}
