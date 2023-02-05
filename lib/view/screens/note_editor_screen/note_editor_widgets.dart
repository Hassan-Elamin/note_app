// ignore_for_file: non_constant_identifier_names

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:memo/provider/database_provider.dart';
import 'package:memo/provider/note_editor_provider.dart';
import 'package:memo/view/widgets/dialog_widgets/data_insert_dialog_widget.dart';

class NoteEditorWidgets {
  final Size size;
  final BuildContext context;
  final DatabaseProvider databaseProvider;
  final NoteEditorProvider provider;

  NoteEditorWidgets({
    required this.context,
    required this.size,
    required this.databaseProvider,
    required this.provider,
  });

  TextEditingController controller = TextEditingController();

  TextDirection getDirection(String input) {
    final string = input.trim();
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
      return TextDirection.RTL;
    }
    return TextDirection.LTR;
  }

  Widget titleRecordingField(TextEditingController controller) {
    return SizedBox(
      width: size.width,
      child: TextFormField(
        textDirection: provider.textDirection,
        controller: controller,
        keyboardType: TextInputType.text,
        readOnly: provider.readOnly,
        autofocus: true,
        style: const TextStyle(
          fontSize: 35,
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 15),
          border: InputBorder.none,
          hintText: "type the title here".tr(),
          hintStyle: const TextStyle(
            fontSize: 30,
          ),
        ),
        onChanged: (String input) {
          provider.setDirection = input;
        },
      ),
    );
  }

  Widget noteRecordingField(TextEditingController controller) {
    return SizedBox(
      height: size.height * 0.6,
      width: size.width,
      child: TextField(
        controller: controller,
        textDirection: provider.textDirection,
        keyboardType: TextInputType.multiline,
        readOnly: provider.readOnly,
        style: TextStyle(
          fontSize: provider.fontSize,
        ),
        maxLines: null,
        decoration:InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 15),
          border: InputBorder.none,
          hintText: "type your note".tr(),
          hintStyle: const TextStyle(
            fontSize: 20,
            color: Colors.grey,
          ),
        ),
        onChanged: (String input){
          provider.setDirection = input ;
        },
      ),
    );
  }

  Widget _autoSaveButton() {
    return Row(
      children: [
        Text("auto save".tr()),
        Switch(
          value: provider.autoSave,
          onChanged: (value) {
            provider.autoSaveMode();
          },
        ),
      ],
    );
  }

  PreferredSize EditorAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(size.height * 0.1),
      child: Row(

        children: [
          MaterialButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              minWidth: 50.0,
              child: const Icon(
                Icons.arrow_back,
                size: 25.0,
              )),
          _autoSaveButton(),
          IconButton(
            onPressed: (){
              showDialog(
                  context: context,
                  builder: (context) {
                    controller.text = provider.fontSize.toString() ;
                    return DataInsertDialog(
                        title: "font size".tr(),
                        controller: controller,
                        onPressed: () async{
                          provider.changeFontSize = double.parse(controller.text);
                          Navigator.pop(context);
                        },
                        maxLength: 3,
                      inputType: TextInputType.number,
                    );
                  },
              );
            },
            icon: const Icon(Icons.format_size , size: 20),
          ),
        ],
      ),
    );
  }

  Widget categoriesViewButton(NoteEditorProvider provider) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: const BoxDecoration(),
      child: provider.readOnly
          ? Text(provider.note.category)
          : DropdownButton<String>(
              borderRadius: BorderRadius.circular(25),
              elevation: 1,
              hint: Text(provider.note.category),
              items: List<DropdownMenuItem<String>>.generate(
                  databaseProvider.categories.length, (index) {
                return DropdownMenuItem<String>(
                    value: databaseProvider.categories[index],
                    child: Text(databaseProvider.categories[index]));
              }),
              onChanged: (value) {
                provider.changeCategory = value ?? "unCategorized";
              },
            ),
    );
  }
}
