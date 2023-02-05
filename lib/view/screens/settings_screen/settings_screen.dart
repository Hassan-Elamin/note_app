
import 'package:flutter/material.dart';
import 'package:memo/provider/settings_provider.dart';
import 'package:memo/view/screens/settings_screen/settings_widgets/settings_widgets.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {

  static const screenRoute = "/SettingsScreen";

  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    final SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);

    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    SettingsScreenWidgets widgets = SettingsScreenWidgets(
        context: context,
        size: size,
        settingsProvider: settingsProvider
    );

    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              widgets.nameViewWidget(nameController),
              widgets.themeSelectionButton(),
              widgets.safeDeleteButton(),
              widgets.languageSelectionButton(),
              widgets.appLockingSwitchButton(),
              widgets.appInfoNavigator(),
            ],
          ),
        ),
      ),
    );
  }
}
