import 'package:flutter/material.dart';

///
const primaryColor = Color(0xFF4859F2);

///
const darkBlue = Color(0xFF0A0C24);

///
const backgroundColor = Color(0xFFFAFAFA);

///
const whiteColor = Colors.white;

///
const darkGreyColor = Color(0xFF909090);

///
const greyColor = Color(0xFFECECEC);

///
const lightGrey = Color(0xFFF6F6F6);

///
const Color textColorK = Colors.black;

///
const Color iconColorK = Colors.black;

///
const List<Color> colorPallete = [
  Colors.white,
  Colors.red,
  Colors.orange,
  Colors.yellow,
  Colors.green,
  Colors.blue,
  Colors.purple,
  Colors.pink,
  Colors.grey,
];

///
const double sizedBoxHeight = 30.0;

///
const double sizedBoxHeightPallete = 100.0;

///
const double textOpacity = 0.5;

///
const double sizedBoxHeightModal = 150.0;

///
const int maxLinesK = 5;

///
const int maxLengthK = 70;

///
const double fontSizeK = 20;

///
const double circleHeightK = 50;

///
const double circleBorderK = 2.0;

///
class Note {
  ///
  final int id;

  ///
  final String title;

  ///
  final String? content;

  ///
  final DateTime createTime;

  ///
  final DateTime modifyTime;

  ///
  final int colorNote;

  ///
  Note(
    this.id,
    this.title,
    this.content,
    this.createTime,
    this.modifyTime,
    this.colorNote,
  );

  @override
  String toString() {
    // ignore: lines_longer_than_80_chars
    return 'Note{id: $id, title: $title, content: $content, createTime: $createTime, modifyTime: $modifyTime, color_note: $colorNote,}';
  }
}

///
class Todo {
  ///
  final int id;

  ///
  bool check;

  ///
  final String task;

  ///
  // ignore: avoid_positional_boolean_parameters
  Todo(this.id, this.check, this.task);

  @override
  String toString() {
    return 'Todo{id: $id, task: $task, check: $check}';
  }

  ///
  Map<String, dynamic> toJson() => <String, dynamic>{
        "id": id,
        "check": check,
        "task": task,
      };
}
