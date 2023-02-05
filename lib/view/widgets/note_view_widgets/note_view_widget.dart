// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:memo/constant/app_enums.dart';
import 'package:memo/constant/constant_strings.dart';
import 'package:memo/models/note_model.dart';
import 'package:memo/provider/database_provider.dart';
import 'package:memo/provider/settings_provider.dart';
import 'package:memo/view/screens/note_editor_screen/note_editor_screen.dart';
import 'package:memo/view/widgets/bottom_sheet_widget/bottom_sheet_widget.dart';
import 'package:memo/view/widgets/dialog_widgets/confirmation_dialog.dart';
import 'package:memo/view/widgets/data_state_widgets/empty_content_widget.dart';
import 'package:provider/provider.dart';

class NoteViewWidget extends StatefulWidget {

  final ScreenType screenType;
  final Note note;

  const NoteViewWidget({required this.screenType, required this.note, Key? key})
      : super(key: key);

  @override
  State<NoteViewWidget> createState() => _NoteViewWidgetState();
}

class _NoteViewWidgetState extends State<NoteViewWidget> {

  late Note note;

  @override
  void initState() {
    setState(() {
      note = widget.note;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    DatabaseProvider databaseProvider = Provider.of<DatabaseProvider>(context);
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);

    List<void Function()> methods = [
          () {
        settingsProvider.selectingOperator(note.id!);
        Navigator.pop(context);
      },
          () async {
        Navigator.pop(context);
        if(settingsProvider.isDeleteSafe){
          await databaseProvider.archiveNote(note.id!);
        }else{
          await databaseProvider.deleteNote(note.id!,DatabaseKeys.notes_table);
        }
      },
          () async {
        Navigator.pop(context);
        await databaseProvider.archiveNote(note.id!);
      },
    ];

    void _onLongPress() {
      if (settingsProvider.selectingMode == SelectingMode.OFF) {
        if (widget.screenType == ScreenType.Archive) {
          settingsProvider.selectingOperator(note.id!);
        } else if (widget.screenType == ScreenType.Notes) {
          BottomSheetWidget().showNotesOptions(context, methods);
        } else {

        }
      }
    }

    Widget categoryNameViewer(SettingsProvider settingsProvider) {
      if(widget.screenType != ScreenType.Category && widget.note.category != "unCategorized"){
        return Container(
          height: 75,
          padding : const EdgeInsets.symmetric( vertical: 5 ),
          decoration: BoxDecoration(
            color: settingsProvider.currentTheme.currentPrimaryColor,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: RotatedBox(
            quarterTurns: 135,
            child: Text(
              widget.note.category,
              style: const TextStyle(
                color: Colors.white,
                overflow: TextOverflow.ellipsis,

              ),
            ),
          ),
        );
      }else{
        return const SizedBox();
      }
    }

    Widget noteTitleViewer() {
      return SizedBox(
        child: Text(
          widget.note.title,
          maxLines: 1,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    }

    Widget noteContentViewer() {
      return SizedBox(
        width: size.width * 0.74,
        child: Text(
          widget.note.note,
          style: const TextStyle(),
          softWrap: true,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }

    Widget noteDateViewer() {
      return Text(
        note.date,
        style: const TextStyle(fontSize: 12.0),
      );
    }

    Widget selectingCheckBox() {
      if(settingsProvider.selectingMode == SelectingMode.ON){
        return Checkbox(
            value: settingsProvider.selectedNotes
                .contains(note.id) ? true : false,
            onChanged: (value) {
              settingsProvider.selectingOperator(widget.note.id!);
            });
      }else{
        return const SizedBox();
      }
    }
    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, child) => Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          color: settingsProvider.selectedNotes.contains(note.id) ?
          settingsProvider.currentTheme.currentSecondaryColor
              : settingsProvider.currentTheme.currentPrimaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            width: 0.2,
            color: settingsProvider.currentTheme.currentPrimaryColor,
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () {
            if (settingsProvider.selectingMode == SelectingMode.ON) {
              settingsProvider.selectingOperator(note.id!);
            } else {
              if (widget.screenType == ScreenType.Archive) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return ConfirmationDialogWidget(
                        onPressedYes: () {
                          databaseProvider.restoreTheSelected(settingsProvider);
                        },
                        onPressedNo: () {},
                        content: "restore this note ?");
                  },
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return NoteEditorScreen(note: widget.note);
                  }),
                );
              }
            }
          },
          onLongPress: _onLongPress,
          child: Container(
            margin: const EdgeInsets.all(7.5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: size.width * 0.72,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      noteTitleViewer(),
                      noteContentViewer(),
                      noteDateViewer(),
                    ],
                  ),
                ),
                selectingCheckBox(),
                categoryNameViewer(settingsProvider),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget NoteListBuilder(List<Note> DataList, ScreenType screenType) {
  if (DataList.isEmpty) {
    return EmptyContentWidget(screenState: screenType);
  } else {
    return ListView.builder(
      itemCount: DataList.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return NoteViewWidget(screenType: screenType, note: DataList[index]);
      },
    );
  }
}
