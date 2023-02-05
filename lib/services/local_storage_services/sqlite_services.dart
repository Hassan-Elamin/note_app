// ignore_for_file: non_constant_identifier_names, constant_identifier_names, depend_on_referenced_packages, avoid_print

import 'package:memo/constant/constant_strings.dart';
import 'package:memo/models/note_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' show join;

mixin SqliteMethods {
  static String insertLine(Note note, String table) {
    if (table == DatabaseKeys.archive_table) {
      return ('''
      INSERT INTO $table VALUES (${note.id},'${note.title}','${note.note}','${note.category}','${note.date}');
      ''');
    } else {
      return ('''
      INSERT INTO $table (title , note , category , date) VALUES ('${note.title}','${note.note}','${note.category}','${note.date}');
      ''');
    }
  }

  static String updateLine(Note note) => ('''
  UPDATE ${DatabaseKeys.notes_table} SET (title,note,category,date) = 
  ('${note.title}','${note.note}','${note.category}','${note.date}')
  WHERE id = ${note.id} ;
  ''');

  static String selectLine(String table, int id) => (" SELECT * FROM $table WHERE id = $id ; ");

  static String deleteLine(String table, int id) => (" DELETE FROM $table WHERE id = $id ; ");

  static String restoreLine(Note note) => ('''
  INSERT OR REPLACE INTO notes VALUES (${note.id} , '${note.title}' , '${note.note}' , '${note.category}' , '${note.date}');
  ''');
}

class DatabaseServices {
  Database? _database;

  final String _databaseFile_name = "notesDatabase.db";
  String _Path = "";

  Future<String> get path async {
    String databasePath = await getDatabasesPath();
    _Path = join(databasePath, _databaseFile_name);
    return _Path;
  }

  Future<Database> DatabaseInitial() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, _databaseFile_name);
    Database myDatabase = await openDatabase(
      path,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      version: 1,
    );
    return myDatabase;
  }

  Future get database async {
    if (_database == null) {
      _database = await DatabaseInitial();
      return _database;
    } else {
      return _database;
    }
  }

  void _onCreate(Database database, int version) async {
    Batch batch = database.batch();
    batch.execute('''
    CREATE TABLE ${DatabaseKeys.notes_table} (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL ,
    note TEXT ,
    category varchar(15),
    date varchar(20) NOT NULL
    );
    ''');
    batch.execute('''
    CREATE TABLE ${DatabaseKeys.archive_table} (
    id INTEGER UNIQUE,
    title TEXT NOT NULL ,
    note TEXT ,
    category varchar(15) ,
    date varchar(20) NOT NULL 
    )
    ''');
    await batch.commit(noResult: true);
    print(
        " =============================== TABLE HAS BEEN CREATED =============================== ");
  }

  void _onUpgrade(Database database, int oldVersion, int newVersion) {
    print(
        " =============================== DATABASE ON UPGRADE =============================== ");
  }

  ///getting

  Future<List<Note>> getAllData(String table) async {
    Database db = await database;
    List<Map<String, Object?>> response = await db.query(table);
    List<Note> finalResult = List.generate(response.length, (index) {
      return Note.fromJson(response[index]);
    });
    return finalResult;
  }

  Future<Note> getOneNote(String table, int id) async {

    Database db = await database;
    List<Map<String, Object?>> response =
        await db.rawQuery(SqliteMethods.selectLine(table, id));
    List<Note> finalResult = List.generate(response.length, (index) {
      return Note.fromJson(response[index]);
    });
    return finalResult.first;
  }

  Future<List<Note>> getManyNotes(List<int> selectedId, String table) async {
    Database db = await database;
    List<Map<String, Object?>> response = [];
    for (int id in selectedId) {
      await db
          .query(table, where: "id = $id")
          .then((value) => response.addAll(value));
    }
    List<Note> finalResult = List.generate(response.length, (index) {
      return Note.fromJson(response[index]);
    });
    return finalResult;
  }

  Future<List<Note>> getByCategory(String category) async {
    Database db = await database;
    List<Map<String, dynamic>> response = await db.query(
      DatabaseKeys.notes_table,
      where: " category = '$category' ",
    );
    if (response.isNotEmpty) {
      List<Note> finalResult = List.generate(response.length, (index) {
        return Note.fromJson(response[index]);
      });
      return finalResult;
    } else {
      return <Note>[];
    }
  }

  ///inserting

  Future<bool> insertNote(Note noteModel, String table) async {
    Note checkedNote = modelSafetyCheck(noteModel);
    Database? db = await database;
    int response =
        await db!.rawInsert(SqliteMethods.insertLine(checkedNote, table));
    if (response == 0) {
      return false;
    } else {
      return true;
    }
  }

  Future<void> insertManyNotes(List<Note> notes, String table) async {
    Database db = await database;
    List<Note> checkedNotes =
        List.generate(notes.length, (index) => modelSafetyCheck(notes[index]));
    for (Note note in checkedNotes) {
      await db.rawInsert(SqliteMethods.insertLine(note,table));
    }
  }

  ///updating

  Future<bool> updateNote(Note noteModel) async {
    Note checkedNote = modelSafetyCheck(noteModel);
    Database db = await database;
    int response = await db.rawUpdate(SqliteMethods.updateLine(checkedNote));
    if (response == 0) {
      return false;
    } else {
      return true;
    }
  }

  /// archiving

  Future<void> archiveNote(Note note)async{
    await insertNote(note, DatabaseKeys.archive_table).then((value)async{
      await deleteNote(note.id!, DatabaseKeys.notes_table);
    });
  }

  Future<void> archiveManyNotes (List<Note> selectedNotes)async{
    await insertManyNotes(selectedNotes,DatabaseKeys.archive_table);
    final List<int> selectedNotesId = List.generate(selectedNotes.length, (index) => selectedNotes[index].id!);
    await deleteManyNotes(selectedNotesId,DatabaseKeys.notes_table);
  }

  Future<void> restoreNote(Note note) async {
    Database db = await database ;
    await db.rawInsert(SqliteMethods.restoreLine(note)).then((inserted)async{
      if(inserted != 0){
        await deleteNote(note.id!, DatabaseKeys.archive_table);
      }else{
        return Future.error("did not insert");
      }
    });
  }

  Future<void> restoreManyNotes(List<Note> notes) async {
    List<Note> checkedNotes = List.generate(notes.length, (index) => modelSafetyCheck(notes[index]));
    for (Note note in checkedNotes) {
      await restoreNote(note);
    }
  }

  /// deleting

  Future<bool> deleteNote(int id, String table) async {
    Database db = await database;
    int response = await db.delete(table, where: "id = $id");
    if (response == 0) {
      return false;
    } else {
      return true;
    }
  }

  Future<bool> deleteManyNotes(List<int> selectedId, String table) async {
    try {
      Database? db = await database;
      for (var id in selectedId) {
        await db!.delete(table, where: "id = $id");
      }
      return true;
    } catch (exception) {
      print(exception.toString());
      return false;
    }
  }
}
