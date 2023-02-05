// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:memo/constant/app_enums.dart';
import 'package:memo/provider/database_provider.dart';
import 'package:memo/view/widgets/note_view_widgets/note_view_widget.dart';
import 'package:provider/provider.dart';

class NotesViewScreen extends StatefulWidget {

  static const screenRoute = "/NoteViewScreen";

  const NotesViewScreen({Key? key}) : super(key: key);

  @override
  State<NotesViewScreen> createState() => _NotesViewScreenState();
}

class _NotesViewScreenState extends State<NotesViewScreen> with TickerProviderStateMixin {

  @override
  void initState() {
    DatabaseProvider().reloadData();
    super.initState();
  }

  final _ScaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    DatabaseProvider databaseProvider = Provider.of<DatabaseProvider>(context);

    return SafeArea(
      child: Scaffold(
        key: _ScaffoldKey,
        body: NoteListBuilder(databaseProvider.notes, ScreenType.Notes),
      ),
    );
  }
}
