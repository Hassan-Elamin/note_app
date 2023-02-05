// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:memo/provider/settings_provider.dart';
import 'package:provider/provider.dart';

Widget LoadingCircleProgress (){
  return Consumer<SettingsProvider>(
    builder : (context, settingsProvider , child){
      return Center(
        child: CircularProgressIndicator(
          color: settingsProvider.currentTheme.currentSecondaryColor  ,
          backgroundColor: settingsProvider.currentTheme.switchColor,
          strokeWidth: 5,
        ),
      );
    }
  );
}