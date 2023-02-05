// ignore_for_file: non_constant_identifier_names

import 'package:easy_localization/easy_localization.dart';
import 'package:memo/constant/config.dart';

Note modelSafetyCheck(Note note) {
  Note safeNote = Note(
    id: note.id,
    title: note.title.isEmpty ? "un titled" : note.title,
    note: note.note.isEmpty ? "empty" : note.note,
    category: note.category.isEmpty ? "unCategorized" : note.category,
    date: note.date.isEmpty ? DateFormatter() : note.date,
  );
  return safeNote;
}

class Note {
  int? id;
  String title;
  String note;
  String category;
  String date ;

  Note({
    this.id,
    required this.title,
    required this.note,
    required this.category,
    required this.date,
  });

  factory Note.fromJson(Map<String, dynamic> databaseNote) => Note(
      id: databaseNote["id"],
      title: "${databaseNote["title"]}",
      note: "${databaseNote["note"]}",
      category: databaseNote["category"],
      date: databaseNote['date']
  );

  void clear (){
    id = null ;
    title = title ;
    note = "";
    category = "unCategorized";
    date = DateFormatter();
  }

  static Map<String, dynamic> toJson(Note model) => {
    'id': model.id!,
    'title': model.title,
    'note': model.note,
    'category': model.category,
    'date' : model.date,
  };

  bool isEmpty() {
    if (title.isEmpty && note.isEmpty && category.isEmpty) {
      return true;
    } else {
      return false;
    }
  }
}

final List<Note> StartUpNotes = [
  Note(
    id: 1,
    title: "get start".tr(),
    note: "write your thoughts".tr(),
    category: "",
    date: DateFormatter(),
  ),
  Note(
    id: 2,
    title: "use the categories".tr(),
    note: "choose a category for your notes and make your own categories".tr(),
    category: "",
    date: DateFormatter(),
  ),
  Note(
    id: 3,
    title: "that is all".tr(),
    note: "this is all for this version".tr(),
    category: "",
    date: DateFormatter(),
  ),
];
