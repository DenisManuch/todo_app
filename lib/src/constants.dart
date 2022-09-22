import 'package:flutter/material.dart';

const primaryColor = Color(0xFF4859F2);
const darkBlue = Color(0xFF0A0C24);
const backgroundColor = Color(0xFFFAFAFA);
const whiteColor = Colors.white;
const darkGreyColor = Color(0xFF909090);
const greyColor = Color(0xFFECECEC);
const lightGrey = Color(0xFFF6F6F6);
Color textColor = Colors.black;
Color iconColor = Colors.black;

List<Color> colorPallete = [
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

class Note {
  final int id;
  final String title;
  final String? content;
  final DateTime createTime;
  final DateTime modifyTime;
  final int colorNote;

  Note(this.id, this.title, this.content, this.createTime, this.modifyTime,
      this.colorNote);  

  @override
  String toString() {
    return 'Note{id: $id, title: $title, content: $content, createTime: $createTime, modifyTime: $modifyTime, color_note: $colorNote,}';
  }
}

class Todo {
  final int id;
   bool check;
  final String task;

  Todo(this.id,this.check,this.task);

  @override
  String toString() {
    return 'Todo{id: $id, task: $task, check: $check}';
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "check": check,
    "task": task,
  };
}