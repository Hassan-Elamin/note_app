
// ignore_for_file: use_build_context_synchronously, file_names

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:memo/constant/constant_strings.dart';
import 'package:memo/models/note_model.dart';
import 'package:memo/provider/database_provider.dart';
import 'package:memo/provider/settings_provider.dart';
import 'package:memo/view/screens/dashboard_screen/dashboard_screen.dart';
import 'package:memo/view/screens/onBoarding_screen/introduction_screens//Settings_Screen.dart';
import 'package:memo/view/screens/onBoarding_screen/introduction_screens//intro_first_screen.dart';
import 'package:memo/view/screens/settings_screen/settings_widgets/settings_widgets.dart';
import 'package:provider/provider.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingScreen extends StatefulWidget {

  static const String screenRoute = "/OnBoardingScreen" ; 

  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    Text buttonText(String text) => Text(
      text.tr(),
      style: const TextStyle(fontSize: 20),
    );
    
    SettingsProvider settingsProvider =
        Provider.of<SettingsProvider>(context);

    DatabaseProvider databaseProvider = Provider.of<DatabaseProvider>(context);

    SettingsScreenWidgets settingsScreenWidgets = SettingsScreenWidgets(
        context: context, size: size, settingsProvider: settingsProvider);

    Future <void> _onDone() async {
      SharedPreferences preferences = await SharedPreferences.getInstance();

      await preferences.setBool(LocalStoreKeys.isFirstTime, false);
      await databaseProvider.insertTheSelected(StartUpNotes);
      await databaseProvider.getCategories();

      Navigator.pushNamedAndRemoveUntil(context,
          DashboardScreen.screenRoute , (route) => false);
    }

    return SafeArea(
        child: IntroductionScreen(
          pages:<PageViewModel>[
            IntroFirstScreen(size: size).introFirstScreen(),
            SettingsSelectionScreen(
                settingsProvider: settingsProvider ,
                settingsWidgets: settingsScreenWidgets
            ).systemSettingsScreen(),
          ],
          isBottomSafeArea: false,
          isTopSafeArea: false,
          freeze: false,
          next: buttonText("next"),
          back: buttonText("back"),
          done: buttonText("done"),
          showBackButton: true,
          onDone: _onDone,
        ));
  }
}
