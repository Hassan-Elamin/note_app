
// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:memo/constant/app_enums.dart';
import 'package:memo/provider/database_provider.dart';
import 'package:memo/view/widgets/note_view_widgets/note_grid_view_widget.dart';
import 'package:provider/provider.dart';

class ArchiveScreen extends StatefulWidget {

  static const String screenRoute = "/ArchiveScreen";

  const ArchiveScreen({Key? key}) : super(key: key);

  @override
  State<ArchiveScreen> createState() => _ArchiveScreenState();
}

class _ArchiveScreenState extends State<ArchiveScreen> {

  @override
  void initState() {
    DatabaseProvider().reloadData();
    super.initState();
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    DatabaseProvider databaseProvider = Provider.of<DatabaseProvider>(context);

    return SafeArea(
      child: Scaffold(
        key:_scaffoldKey,
        body: NoteGridBuilder(databaseProvider.archiveNotes, ScreenType.Archive),
      ),
    );
  }
}
