// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:memo/view/screens/app_locker_screen/app_locker_screen.dart';
import 'package:memo/view/screens/archive_screen/archive_screen.dart';
import 'package:memo/view/screens/categories_screen/categories_screen.dart';
import 'package:memo/view/screens/dev_info_screen/dev_info_Screen.dart';
import 'package:memo/view/screens/dashboard_screen/dashboard_screen.dart';
import 'package:memo/view/screens/error_screen/error_screen.dart';
import 'package:memo/view/screens/notes_view_screen/notes_view_screen.dart';
import 'package:memo/view/screens/onBoarding_screen/onBoarding_screen.dart';
import 'package:memo/view/screens/settings_screen/settings_screen.dart';
import 'package:memo/view/screens/splash_screen/splash_screen.dart';

final Map<String, Widget Function(BuildContext)> Routes = {

  NotesViewScreen.screenRoute : (_) => const NotesViewScreen(),
  ArchiveScreen.screenRoute: (_) => const ArchiveScreen(),
  SplashScreen.screenRoute: (_) => const SplashScreen(),
  SettingsScreen.screenRoute: (_) => const SettingsScreen(),
  DeveloperInfoScreen.screenRoute: (_) => const DeveloperInfoScreen(),
  CategoriesScreen.screenRoute :(_)=> const CategoriesScreen(),
  DashboardScreen.screenRoute : (_)=> const DashboardScreen(),
  OnBoardingScreen.screenRoute : (_)=> const OnBoardingScreen(),
  AppLockerScreen.screenRoute : (_) => const AppLockerScreen(),
  ErrorScreen.screenRoute : (_) => const ErrorScreen(),

};