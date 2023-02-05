


import 'package:flutter/material.dart';
import 'package:memo/constant/app_enums.dart';
import 'package:memo/constant/config.dart';
import 'package:memo/constant/constant_strings.dart';
import 'package:memo/models/note_model.dart';
import 'package:memo/services/local_storage_services/shared_preferences_services.dart';

class NoteEditorProvider extends ChangeNotifier {

  final Note? passedNote ;
  final TextEditingController titleController ;
  final TextEditingController noteController ;

  NoteEditorProvider({
    required this.passedNote,
    required this.titleController,
    required this.noteController,
  }){
    noteEditorInitial(passedNote);
  }

  final SharedPrefServices _pref = SharedPrefServices();

  bool readOnly = false ;

  bool isLoading = true ;

  bool autoSave = false ;

  late double fontSize ;

  set changeFontSize (double input) {
    fontSize = input ;
    _pref.setItem(LocalStoreKeys.fontSize, fontSize);
    notifyListeners();
  }

  TextDirection textDirection = TextDirection.ltr;

  set setDirection (String input){
    final string = input.trim();
    final firstUnit = string.codeUnitAt(0);
    if (string.isEmpty){
      textDirection = TextDirection.ltr ;
    } else if (firstUnit > 0x0600 && firstUnit < 0x06FF ||
        firstUnit > 0x0750 && firstUnit < 0x077F ||
        firstUnit > 0x07C0 && firstUnit < 0x07EA ||
        firstUnit > 0x0840 && firstUnit < 0x085B ||
        firstUnit > 0x08A0 && firstUnit < 0x08B4 ||
        firstUnit > 0x08E3 && firstUnit < 0x08FF ||
        firstUnit > 0xFB50 && firstUnit < 0xFBB1 ||
        firstUnit > 0xFBD3 && firstUnit < 0xFD3D ||
        firstUnit > 0xFD50 && firstUnit < 0xFD8F ||
        firstUnit > 0xFD92 && firstUnit < 0xFDC7 ||
        firstUnit > 0xFDF0 && firstUnit < 0xFDFC ||
        firstUnit > 0xFE70 && firstUnit < 0xFE74 ||
        firstUnit > 0xFE76 && firstUnit < 0xFEFC ||
        firstUnit > 0x10800 && firstUnit < 0x10805 ||
        firstUnit > 0x1B000 && firstUnit < 0x1B0FF ||
        firstUnit > 0x1D165 && firstUnit < 0x1D169 ||
        firstUnit > 0x1D16D && firstUnit < 0x1D172 ||
        firstUnit > 0x1D17B && firstUnit < 0x1D182 ||
        firstUnit > 0x1D185 && firstUnit < 0x1D18B ||
        firstUnit > 0x1D1AA && firstUnit < 0x1D1AD ||
        firstUnit > 0x1D242 && firstUnit < 0x1D244) {
      textDirection = TextDirection.rtl;
    }else{
      textDirection = TextDirection.ltr;
    }
    notifyListeners();
  }

  TextDirection getDirection(String v) {
    final string = v.trim();
    if (string.isEmpty) return TextDirection.ltr;
    final firstUnit = string.codeUnitAt(0);
    if (firstUnit > 0x0600 && firstUnit < 0x06FF ||
        firstUnit > 0x0750 && firstUnit < 0x077F ||
        firstUnit > 0x07C0 && firstUnit < 0x07EA ||
        firstUnit > 0x0840 && firstUnit < 0x085B ||
        firstUnit > 0x08A0 && firstUnit < 0x08B4 ||
        firstUnit > 0x08E3 && firstUnit < 0x08FF ||
        firstUnit > 0xFB50 && firstUnit < 0xFBB1 ||
        firstUnit > 0xFBD3 && firstUnit < 0xFD3D ||
        firstUnit > 0xFD50 && firstUnit < 0xFD8F ||
        firstUnit > 0xFD92 && firstUnit < 0xFDC7 ||
        firstUnit > 0xFDF0 && firstUnit < 0xFDFC ||
        firstUnit > 0xFE70 && firstUnit < 0xFE74 ||
        firstUnit > 0xFE76 && firstUnit < 0xFEFC ||
        firstUnit > 0x10800 && firstUnit < 0x10805 ||
        firstUnit > 0x1B000 && firstUnit < 0x1B0FF ||
        firstUnit > 0x1D165 && firstUnit < 0x1D169 ||
        firstUnit > 0x1D16D && firstUnit < 0x1D172 ||
        firstUnit > 0x1D17B && firstUnit < 0x1D182 ||
        firstUnit > 0x1D185 && firstUnit < 0x1D18B ||
        firstUnit > 0x1D1AA && firstUnit < 0x1D1AD ||
        firstUnit > 0x1D242 && firstUnit < 0x1D244) {
      return TextDirection.rtl;
    }
    return TextDirection.ltr;
  }

  void autoSaveMode (){
    if(autoSave){
      autoSave = false;
    }else{
      autoSave = true;
    }
    notifyListeners();
  }

  Future<void> noteEditorInitial (Note? passedNote)async{
    isLoading = true ;
    notifyListeners();
    changeFontSize = await _pref.getItem(LocalStoreKeys.fontSize);
    if(passedNote == null){
      changeEditorState = NoteEditorState.Creating;
    }else{
      changeEditorState = NoteEditorState.Reading ;
      onEditing();
    }
    isLoading = false ;
    notifyListeners();
  }

  String nowDate = DateFormatter();

  Note note = Note(
    title: "",
    note: "",
    category: 'unCategorized',
    date: DateFormatter(),
  );

  set changeNoteData (Note newData){
    note = newData ;
    notifyListeners();
  }

  late NoteEditorState state ;

  void editingSetUp (){
    note.title = titleController.text;
    note.note = noteController.text;
    notifyListeners();
  }

  void afterCreating (Note insertedNote){
    changeNoteData = insertedNote;
    changeEditorState = NoteEditorState.Done;
    notifyListeners();
  }

  void onEditing (){
    changeNoteData = passedNote!;
    readMode = true ;
    editingModeSetUp();
  }

  set changeCategory (String newCategory){
    note.category = newCategory;
    notifyListeners();
  }

  set changeEditorState (NoteEditorState newState){
    state = newState ;
    notifyListeners();
  }

  set readMode (bool value){
    readOnly = value ;
    notifyListeners();
  }

  void readModeSwitch (){
    if(readOnly){
      readOnly = false;
      changeEditorState = NoteEditorState.Editing;
      notifyListeners();
    }else{
      readOnly = true ;
      changeEditorState = NoteEditorState.Reading;
      notifyListeners();
    }
  }

  void editingModeSetUp (){
    titleController.text = note.title ;
    noteController.text = note.note ;
    titleController.selection =
        TextSelection.collapsed(offset: titleController.text.length);
    noteController.selection =
        TextSelection.collapsed(offset: noteController.text.length);
    notifyListeners();
  }

}