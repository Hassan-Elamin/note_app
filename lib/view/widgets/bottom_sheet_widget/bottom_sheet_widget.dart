import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:memo/provider/settings_provider.dart';
import 'package:provider/provider.dart';

class BottomSheetContent extends StatefulWidget {

  final double theHeight;
  final Widget content;

  const BottomSheetContent({
    required this.theHeight,
    required this.content,
    Key? key
  }) : super(key: key);

  @override
  State<BottomSheetContent> createState() => _BottomSheetContentState();
}

class _BottomSheetContentState extends State<BottomSheetContent> {
  bool done = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, child) {
        return Container(
          height: size.height * widget.theHeight,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: settingsProvider.currentTheme.switchColor,
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: done
              ? (const Center(child: Icon(Icons.done, size: 40.0)))
              : (widget.content),
        );
      },
    );
  }
}

void showTheBottomSheet(BuildContext context, Widget content, double height) {
  showModalBottomSheet(
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
      topRight: Radius.circular(25.0),
      topLeft: Radius.circular(25.0),
    )),
    clipBehavior: Clip.antiAlias,
    isScrollControlled: true,
    enableDrag: true,
    context: context,
    builder: (context) {
      return BottomSheetContent(theHeight: height, content: content);
    },
  );
}

class BottomSheetWidget {

  void showTheBottomSheet(BuildContext context, Widget content, double height) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(25.0),
            topLeft: Radius.circular(25.0),
          )),
      clipBehavior: Clip.antiAlias,
      isScrollControlled: true,
      enableDrag: true,
      context: context,
      builder: (context) {
        return BottomSheetContent(theHeight: height, content: content);
      },
    );
  }

  List<IconData> icons = [
    Icons.select_all,
    Icons.delete,
    Icons.archive,
  ];

  List<String> labels = [
    "select",
    "delete",
    "archive",
  ];

  Widget bottomSheetButton(IconData icon, String label,
      void Function() onPressed) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(

        borderRadius: BorderRadius.circular(40),
        boxShadow: const<BoxShadow>[
          BoxShadow(
            blurStyle: BlurStyle.outer,
            spreadRadius: 0.5,
            blurRadius: 2.5,
          ),
        ],
      ),
      child: MaterialButton(
        minWidth: 70,
        height: 70,
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(35),

        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 22.5,
            ),
            Text(
              label,
              style: const TextStyle(fontSize: 10.0),
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomSheetNoteOptions(List<void Function()> methods) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 25,),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List<Widget>.generate(
            3, (index) =>
            bottomSheetButton(
              icons[index],
              labels[index].tr(),
              methods[index],
            )),
      ),
    );
  }

  void showNotesOptions(BuildContext context , List<void Function ()> methods ) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(25.0),
            topLeft: Radius.circular(25.0),
          )),
      clipBehavior: Clip.antiAlias,
      isScrollControlled: true,
      enableDrag: true,
      context: context,
      builder: (context) {
        return BottomSheetContent(
          theHeight: 0.175,
          content: bottomSheetNoteOptions(methods),);
      },
    );
  }

}
