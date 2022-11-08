///
class Note {
  ///
  final int id;

  ///
  String title;

  ///
  String? content;

  ///
  final DateTime createTime;

  ///
  DateTime modifyTime;

  ///
  int colorNote;

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
    return ''' Note{id: $id, title: $title, content: $content, createTime: $createTime, modifyTime: $modifyTime, color_note: $colorNote,} ''';
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
  Todo(
    this.id,
    this.task, {
    required this.check,
  });

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
