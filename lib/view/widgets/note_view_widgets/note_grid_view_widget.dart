import 'package:flutter/material.dart';
import 'package:memo/constant/app_enums.dart';
import 'package:memo/models/note_model.dart';
import 'package:memo/provider/database_provider.dart';
import 'package:memo/provider/settings_provider.dart';
import 'package:memo/view/screens/note_editor_screen/note_editor_screen.dart';
import 'package:memo/view/widgets/dialog_widgets/confirmation_dialog.dart';
import 'package:memo/view/widgets/data_state_widgets/empty_content_widget.dart';
import 'package:provider/provider.dart';

class NoteGridViewWidget extends StatefulWidget {
  final ScreenType state;

  final Note note;

  const NoteGridViewWidget({required this.state, required this.note, Key? key})
      : super(key: key);

  @override
  State<NoteGridViewWidget> createState() => _NoteGridViewWidgetState();
}

class _NoteGridViewWidgetState extends State<NoteGridViewWidget> {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    DatabaseProvider databaseProvider = Provider.of<DatabaseProvider>(context);

    Widget titleView (){
      return Text(
        widget.note.title,
        maxLines: 1,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          overflow: TextOverflow.visible,
        ),
      );
    }

    Widget noteView (){
      return SizedBox(

        child: Text(
          widget.note.note,
          softWrap: true,
          maxLines: 2,
          overflow: TextOverflow.fade,
        ),
      );
    }

    Widget dateView (){
      return Container(

          alignment: Alignment.bottomRight,
          child: Text(
            widget.note.date,
            style: const TextStyle(fontSize: 12.0),
          ));
    }

    Widget categoryNameView (){
      if(widget.note.category == "unCategorized"){
        return const SizedBox();
      }else {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(25),
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
      }
    }

    Widget selectCheckBox (SettingsProvider settingsProvider){
      if(settingsProvider.selectingMode == SelectingMode.ON){
        return Checkbox(
            materialTapTargetSize:
            MaterialTapTargetSize.shrinkWrap,
            activeColor: settingsProvider.currentTheme.currentPrimaryColor,
            value: settingsProvider
                .selectedNotes
                .contains(widget.note.id) ? true : false,
            onChanged: (value) {
              settingsProvider
                  .selectingOperator(widget.note.id!);
            });
      }else{
        return const SizedBox();
      }

    }

    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, child) => Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: settingsProvider.currentTheme.currentPrimaryColor,
          ),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.shade400,
                blurRadius: 0.6,
                blurStyle: BlurStyle.outer),
          ],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            if (settingsProvider.selectingMode == SelectingMode.ON) {
              settingsProvider.selectingOperator(widget.note.id!);
            } else {
              if (widget.state == ScreenType.Archive) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return ConfirmationDialogWidget(
                        onPressedYes: () {
                          databaseProvider.restoreFromArchive(widget.note.id!);
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
          onLongPress: () {
            settingsProvider.selectingModeSwitch();
            settingsProvider.selectingOperator(widget.note.id!);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: size.width * 0.25,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      titleView(),
                      noteView(),
                      dateView(),
                    ],
                  ),
                ),
                selectCheckBox(settingsProvider),
                categoryNameView(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ignore: non_constant_identifier_names
Widget NoteGridBuilder(List<Note> DataList, ScreenType screenType) {
  if (DataList.isEmpty) {
    return EmptyContentWidget(screenState: screenType);
  } else {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: DataList.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemBuilder: (context, index) {
        return NoteGridViewWidget(state: screenType, note: DataList[index]);
      },
    );
  }
}
