// ignore_for_file: non_constant_identifier_names, file_names

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:memo/constant/app_enums.dart';
import 'package:memo/constant/constant_strings.dart';
import 'package:memo/constant/style.dart';
import 'package:memo/provider/database_provider.dart';
import 'package:memo/provider/settings_provider.dart';

class AppBarWidget {

  final BuildContext context;
  final Size size;

  final SettingsProvider settingsProvider;
  final ScreenType screenType ;
  final DatabaseProvider databaseProvider;

  AppBarWidget({
    required this.databaseProvider,
    required this.context,
    required this.size,
    required this.settingsProvider,
    required this.screenType ,
  });

  String appBarTitleHeader (ScreenType screenType){
    switch(screenType){
      case ScreenType.Notes:
        return "notes";
      case ScreenType.Archive:
        return "archive";
      case ScreenType.Category:
        return "category";
      case ScreenType.Settings:
        return "settings";
    }
  }

  Widget selectAllButton (void Function() onPressed){
    return MaterialButton(
        minWidth: 125.0,
        onPressed: onPressed,
        child: Text(
          settingsProvider.allSelected ? "all selected".tr() : "Select All".tr() ,
          style: const TextStyle(
            fontSize: 20 ,
            color: Colors.white,
          ),
        )
    );
  }

  Widget appBarButton (void Function() onPressed , IconData icon ){
    return IconButton(
        onPressed:onPressed,
        icon: Icon(icon, size: 35, color: Colors.white));
  }

  Widget dashboardActionButtons(DatabaseProvider databaseProvider, SettingsProvider settingsProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: settingsProvider.selectingMode == SelectingMode.ON ?
      (<Widget>[
        selectAllButton(() {
          if(settingsProvider.selectingMode == SelectingMode.ON ){
            settingsProvider.selectAll(databaseProvider.notes);
          }
        }),
        appBarButton(()async{
          await databaseProvider.archiveTheSelected(settingsProvider);
        }, Icons.archive,),
        appBarButton(()async{
          if(settingsProvider.isDeleteSafe){
            await databaseProvider.archiveTheSelected(settingsProvider);
          }else{
            await databaseProvider.deleteTheSelected(DatabaseKeys.notes_table,settingsProvider);
          }
        }, Icons.delete,),
      ])
          : (<Widget>[]),
    );
  }

  Widget archiveActionButtons(DatabaseProvider databaseProvider, SettingsProvider settingsProvider) {
    return Row(
      children: settingsProvider.selectingMode == SelectingMode.OFF ?
      (<Widget>[]) :
      (<Widget>[
        selectAllButton(() {
          if(settingsProvider.selectingMode == SelectingMode.ON ){
            settingsProvider.selectAll(databaseProvider.archiveNotes);
          }
        }),
        appBarButton(() async {
          databaseProvider.restoreTheSelected(settingsProvider);
        },
          Icons.restore,
        ),
        appBarButton(()async{
          await databaseProvider.deleteTheSelected(DatabaseKeys.archive_table,settingsProvider);
        },
          Icons.delete_forever,
        ),
      ]),
    );
  }

  Widget actionButtonsWidgets(ScreenType screenState) {
    if (screenState == ScreenType.Notes) {
      return dashboardActionButtons(databaseProvider, settingsProvider);
    } else if (screenState == ScreenType.Archive) {
      return archiveActionButtons(databaseProvider, settingsProvider);
    } else {
      return const SizedBox();
    }
  }

  Widget appBarTitle(SelectingMode state) {
    TextStyle headerStyle =
        appTextStyles.headerStyle.copyWith(fontSize: 35, color: Colors.white);
    if (state == SelectingMode.ON) {
      return const SizedBox();
    } else {
      return Text(
        appBarTitleHeader(screenType).tr(),
        style: headerStyle,
      );
      
    }
  }

  AppBar GlobalAppBar() {
    return AppBar(
      toolbarHeight: 70.0,
      title: Container(
          height: 70.0,
          width:size.width,
          margin: const EdgeInsets.only(bottom:10,right: 5,left: 5),
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: settingsProvider.currentTheme.gradient,
            borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(60),
              bottomLeft: Radius.circular(60),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              appBarTitle(settingsProvider.selectingMode),
              actionButtonsWidgets(screenType),
            ],
          )),
      titleSpacing: 0,
      centerTitle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(60),
          bottomLeft: Radius.circular(60),
        )
      ),
      backgroundColor: Colors.white,
      toolbarOpacity: 0.7,
    );
  }
}

