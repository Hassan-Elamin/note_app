// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:memo/constant/app_enums.dart';
import 'package:memo/constant/constant_strings.dart';
import 'package:memo/models/note_model.dart';
import 'package:memo/provider/settings_provider.dart';
import 'package:memo/services/local_storage_services/shared_preferences_services.dart';
import 'package:memo/services/local_storage_services/sqlite_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseProvider extends ChangeNotifier {
  DatabaseProvider() {
    DatabaseInitial();
  }

  final String notesTable = DatabaseKeys.notes_table;

  final DatabaseServices _databaseServices = DatabaseServices();
  final SharedPrefServices _prefServices = SharedPrefServices();

  NoteDataState noteDataState = NoteDataState.Initial;

  void stateMange(String table, NoteDataState newState) {
    if (table == archiveTable) {
      noteDataState = newState;
    } else {
      archiveState = newState;
    }
    notifyListeners();
  }

  List<Note> notes = [];

  bool isDone = false;

  Future<void> DatabaseInitial() async {
    String firstTimeCheck = LocalStoreKeys.isFirstTime;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.containsKey(firstTimeCheck)) {
      bool isFirstTime = preferences.getBool(firstTimeCheck)!;
      if (isFirstTime == false) {
        await reloadData();
      }
    }
    notifyListeners();
  }

  Future<void> reloadData() async {
    notes = await getAllData(notesTable);
    archiveNotes = await getAllData(archiveTable);
    notifyListeners();
  }

  Future<List<Note>> getAllData(String table) async {
    stateMange(table, NoteDataState.Loading);
    notifyListeners();
    try {
      List<Note> returned;
      if (table == archiveTable) {
        returned = await _databaseServices.getAllData(archiveTable);
      } else {
        returned = await _databaseServices.getAllData(notesTable);
      }
      await getCategories();
      noteDataState = NoteDataState.Loaded;
      notifyListeners();
      return returned;
    } catch (exception) {
      noteDataState = NoteDataState.Error;
      notifyListeners();

      return Future.error(exception);
    }
  }

  Future<List<Note>> getTheSelected(List<int> selectedId, String table) async {
    try {
      List<Note> returnedNotes =
          await _databaseServices.getManyNotes(selectedId, table);
      return returnedNotes;
    } catch (exception) {
      return Future.error(exception);
    }
  }

  Future<List<Note>> getByCategory(String categoryName) async {
    noteDataState = NoteDataState.Loading;
    notifyListeners();
    try {
      List<Note> response = await _databaseServices.getByCategory(categoryName);
      noteDataState = NoteDataState.Loaded;
      notifyListeners();
      return response;
    } catch (exception) {
      noteDataState = NoteDataState.Error;
      notifyListeners();
      return [];
    }
  }

  Future<void> insertNote(Note noteModel) async {
    try {
      await _databaseServices
          .insertNote(noteModel, notesTable)
          .then((inserted) async {
        if (inserted) {
          isDone = inserted;
          await reloadData();
          notifyListeners();
          return isDone;
        } else {
          isDone = inserted;
          notifyListeners();
          return isDone;
        }
      });
    } catch (exception) {
      notifyListeners();
      Future.error(exception.toString());
    }
  }

  Future<bool> insertTheSelected(List<Note> notes) async {
    try {
      if (notes.length == 1) {
        await _databaseServices.insertNote(notes.first, notesTable);
      } else {
        await _databaseServices.insertManyNotes(notes, notesTable);
      }
      await reloadData();
      return true;
    } catch (exception) {
      Future.error(exception.toString());
      return false;
    }
  }

  Future<void> updateNote(Note noteModel) async {
    try {
      await _databaseServices.updateNote(noteModel).then((updated) async {
        if (updated) {
          await reloadData();
          isDone = updated;
          notifyListeners();
          return true;
        } else {
          isDone = updated;
          notifyListeners();
          return false;
        }
      });
    } catch (exception) {
      notifyListeners();
      return Future.error(exception);
    }
  }

  Future<void> updateNotesCategories (String category) async {
    List<Note>? notesCategory = await getByCategory(category);
    for (int index = 0 ; index < notesCategory.length ; index ++ ){
      notesCategory[index].category = "unCategorized" ;
    }
    for(Note element in notesCategory ){
      await updateNote(element);
    }
  }

  Future<void> deleteNote(int id, String table) async {
    try {
      await _databaseServices.deleteNote(id, table).then((deleted) async {
        if (deleted) {
          await reloadData();
          notifyListeners();
          return true;
        } else {
          notifyListeners();
          return false;
        }
      });
    } catch (exception) {
      return Future.error(exception);
    }
    notifyListeners();
  }

  Future<void> deleteTheSelected(String table, SettingsProvider settingsProvider) async {
    List<int> selectedId = settingsProvider.selectedNotes;
    stateMange(table, NoteDataState.Loading);
    notifyListeners();
    try {
      if (selectedId.length == 1) {
        await _databaseServices.deleteNote(selectedId.first, table);
      } else {
        await _databaseServices.deleteManyNotes(selectedId, table);
      }

      await reloadData();
      stateMange(table, NoteDataState.Loaded);
      notifyListeners();
    } catch (exception) {
      stateMange(table, NoteDataState.Error);
      notifyListeners();
      Future.error(exception.toString());
    }
    settingsProvider.selectModeChange = SelectingMode.OFF;
  }

  /// categories methods

  List<String> categories = [];

  Future<void> getCategories() async {
    categories = await _prefServices.categories;
    notifyListeners();
  }

  Future<void> insertCategory(String newCategory) async {
    categories.add(newCategory);
    await _prefServices.setItem(LocalStoreKeys.categories, categories);
    notifyListeners();
  }

  Future<void> removeCategory(String selectedCategory) async {
    await updateNotesCategories(selectedCategory);
    categories.remove(selectedCategory);
    await _prefServices.setItem(LocalStoreKeys.categories, categories);
    notifyListeners();
  }

  /// archive methods

  final String archiveTable = DatabaseKeys.archive_table;
  
  NoteDataState archiveState = NoteDataState.Initial;

  List<Note> archiveNotes = [];

  Future<void> archiveNote(int id) async {
    noteDataState = NoteDataState.Loading;
    notifyListeners();
    try {
      Note selectedNote = await _databaseServices.getOneNote(notesTable, id);
      await _databaseServices.archiveNote(selectedNote);
      await reloadData();
      noteDataState = NoteDataState.Loaded;
    } catch (exception) {
      noteDataState = NoteDataState.Error;
      return Future.error(exception.toString());
    }
    notifyListeners();
  }

  Future<void> archiveTheSelected(SettingsProvider settingsProvider) async {
    List<int> selectedId = settingsProvider.selectedNotes;
    noteDataState = NoteDataState.Loading;
    notifyListeners();
    try {
      List<Note> returnedNotes = await getTheSelected(selectedId,notesTable);
      if(returnedNotes.length == 1){
        await _databaseServices.archiveNote(returnedNotes.first);
      }else{
        await _databaseServices.archiveManyNotes(returnedNotes);
      }
      await reloadData();
      noteDataState = NoteDataState.Loaded;
    } catch (exception) {
      noteDataState = NoteDataState.Error;
      return Future.error(exception.toString());
    }
    settingsProvider.selectModeChange = SelectingMode.OFF ;
    notifyListeners();
  }

  Future<void> restoreFromArchive(int id) async {
    archiveState = NoteDataState.Loading;
    notifyListeners();
    try {
      Note returnedNote = await _databaseServices.getOneNote(DatabaseKeys.archive_table, id);
      await _databaseServices.restoreNote(returnedNote);
      await reloadData();
      archiveState = NoteDataState.Loaded;
    } catch (exception) {
      archiveState = NoteDataState.Error;
      return Future.error(exception);
    }
    notifyListeners();
  }

  Future<void> restoreTheSelected(SettingsProvider settingsProvider) async {
    List<int> selectedId = settingsProvider.selectedNotes;
    archiveState = NoteDataState.Loading;
    notifyListeners();
    try {
      if (selectedId.length == 1) {
        Note returnedNote = await _databaseServices.getOneNote(DatabaseKeys.archive_table, selectedId.first);
        await _databaseServices.restoreNote(returnedNote);
      } else {
        List<Note> returnedNotes = await getTheSelected(selectedId, archiveTable);
        await _databaseServices.restoreManyNotes(returnedNotes);
      }
      await reloadData();
      archiveState = NoteDataState.Loaded;
    } catch (exception) {
      archiveState = NoteDataState.Error;
      return Future.error(exception);
    }
    settingsProvider.selectModeChange = SelectingMode.OFF ;
    notifyListeners();
  }
}
