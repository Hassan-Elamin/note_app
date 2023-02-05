
// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:memo/provider/settings_provider.dart';
import 'package:memo/view/screens/settings_screen/settings_widgets/settings_widgets.dart';
import 'package:memo/view/widgets/input_forms/name_setting_form.dart';
import 'package:provider/provider.dart';

class SettingsSelectionScreen {

  final SettingsProvider settingsProvider ;
  final SettingsScreenWidgets settingsWidgets ;

  SettingsSelectionScreen({
    required this.settingsProvider,
    required this.settingsWidgets ,
  });

  PageViewModel systemSettingsScreen() {
    return PageViewModel(
        title: "System Settings",
        bodyWidget: Consumer<SettingsProvider>(
          builder: (context, settingsProvider, child) {
            return Column(
              children:<Widget>[
                const UserNameSettingForm(),
                settingsWidgets.themeSelectionButton(),
                settingsWidgets.appLockingSwitchButton(),
                settingsWidgets.languageSelectionButton(),
              ],
            );
          },
        ));
  }

}