import 'package:flutter/material.dart';
import 'package:memo/constant/app_enums.dart';
import 'package:memo/models/note_model.dart';
import 'package:memo/provider/database_provider.dart';
import 'package:memo/provider/note_editor_provider.dart';
import 'package:memo/view/screens/note_editor_screen/note_editor_widgets.dart';
import 'package:memo/view/widgets/data_state_widgets/loading_circle_widget.dart';
import 'package:provider/provider.dart';

class NoteEditorScreen extends StatefulWidget {
  final Note? note;

  const NoteEditorScreen({required this.note, Key? key}) : super(key: key);

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    DatabaseProvider databaseProvider = Provider.of<DatabaseProvider>(context);

    Future<void> floatButtonMethod(NoteEditorProvider provider) async {
      provider.editingSetUp();
      if (provider.state == NoteEditorState.Creating) {
        await databaseProvider.insertNote(provider.note).then((value) {
          provider.afterCreating(databaseProvider.notes.last);
        });
      } else {
        if (provider.readOnly) {
          provider.readModeSwitch();
        } else {
          if (provider.state == NoteEditorState.Done) {
            provider.readModeSwitch();
            Navigator.pop(context);
          } else {
            await databaseProvider.updateNote(provider.note).then((value) {
              provider.changeEditorState = NoteEditorState.Done;
            });
          }
        }
      }
    }

    IconData iconData(bool isDone, NoteEditorProvider provider) {
      if (provider.state == NoteEditorState.Creating) {
        return Icons.add;
      } else {
        if (provider.readOnly) {
          return Icons.edit;
        } else {
          if (isDone) {
            return Icons.done;
          } else {
            return Icons.save;
          }
        }
      }
    }

    return ChangeNotifierProvider<NoteEditorProvider>(
      create: (context) => NoteEditorProvider(
        passedNote: widget.note,
        titleController: titleController,
        noteController: noteController,
      ),
      builder: (context, child) {
        NoteEditorWidgets widgets = NoteEditorWidgets(
          context: context,
          size: size,
          databaseProvider: databaseProvider,
          provider: Provider.of<NoteEditorProvider>(context),
        );

        return Consumer<NoteEditorProvider>(
          builder: (context, editorProvider, child) {
            if (editorProvider.isLoading) {
              return LoadingCircleProgress();
            } else {
              return WillPopScope(
                onWillPop: () async {
                  if (editorProvider.autoSave) {
                    editorProvider.editingSetUp();
                    if (editorProvider.state == NoteEditorState.Editing) {
                      await databaseProvider.updateNote(editorProvider.note);
                    } else if(editorProvider.state == NoteEditorState.Creating) {
                      await databaseProvider.insertNote(editorProvider.note);
                    }else{
                      
                    }
                    return true;
                  } else {
                    Navigator.pop(context);
                    return false;
                  }
                },
                child: SafeArea(
                  child: Scaffold(
                    appBar: widgets.EditorAppBar(),
                    body: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: size.height * 0.1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(editorProvider.note.date),
                                editorProvider.readOnly
                                    ? Text(editorProvider.note.category)
                                    : widgets
                                        .categoriesViewButton(editorProvider),
                              ],
                            ),
                          ),
                          widgets.titleRecordingField(titleController),
                          widgets.noteRecordingField(noteController),
                        ],
                      ),
                    ),
                    floatingActionButton: FloatingActionButton(
                      onPressed: () async =>
                          await floatButtonMethod(editorProvider),
                      child: Icon(
                        iconData(
                            editorProvider.state == NoteEditorState.Done
                                ? true
                                : false,
                            editorProvider),
                        size: 30,
                      ),
                    ),
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }
}
