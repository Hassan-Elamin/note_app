// ignore_for_file: constant_identifier_names, dead_code, depend_on_referenced_packages, camel_case_types

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:memo/constant/app_enums.dart';
import 'package:memo/constant/constant_strings.dart';
import 'package:memo/models/language_model.dart';
import 'package:memo/models/note_model.dart';
import 'package:memo/models/theme_model.dart';
import 'package:memo/services/local_storage_services/shared_preferences_services.dart';
import 'package:memo/view/screens/app_locker_screen/app_locker_screen.dart';
import 'package:memo/view/screens/dashboard_screen/dashboard_screen.dart';
import 'package:memo/view/screens/error_screen/error_screen.dart';
import 'package:memo/view/screens/onBoarding_screen/onBoarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';


class SettingsProvider extends ChangeNotifier {
  SettingsProvider() {
    systemInit();
  }

  bool appIsReady = false;

  NavigatePoint navigateTo = NavigatePoint.Init;

  Future<void> systemInit() async {
    appIsReady = false;
    notifyListeners();

    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool isFirstUse = preferences.getBool(LocalStoreKeys.isFirstUse) ?? true;
    if (isFirstUse) {
      await firstUseInit(preferences);
    } else {
      bool isFirstTime =
          preferences.getBool(LocalStoreKeys.isFirstTime) ?? true;
      userName = await getUserName;
      await themeInitial(preferences);
      isDeleteSafe = preferences.getBool(LocalStoreKeys.isDeleteSafe)!;
      await appLockerInit(preferences);
      notifyListeners();
      if (isFirstTime) {
        navigateTo = NavigatePoint.firstTime;
      } else {
        if (isLocked) {
          navigateTo = NavigatePoint.locker;
        } else {
          navigateTo = NavigatePoint.dashboard;
        }
      }
    }
    appIsReady = true;
    notifyListeners();
  }

  Future<void> firstUseInit (SharedPreferences preferences)async{
    userName = "new user".tr();
    await _pref.firstUseSetUp();
    navigateTo = NavigatePoint.firstTime;
    await appLockerInit(preferences);
  }

  String startNavigate() {
    switch (navigateTo) {
      case NavigatePoint.Init:
        return ErrorScreen.screenRoute;
        break;
      case NavigatePoint.dashboard:
        return DashboardScreen.screenRoute;
        break;
      case NavigatePoint.firstTime:
        return OnBoardingScreen.screenRoute;
        break;
      case NavigatePoint.locker:
        return AppLockerScreen.screenRoute;
        break;
    }
  }

  final SharedPrefServices _pref = SharedPrefServices();

  int currentScreenIndex = 0;

  set indexNavigate(int index) {
    if (selectingMode == SelectingMode.ON) {
      selectModeChange = SelectingMode.OFF ;
    }
    currentScreenIndex = index;
    notifyListeners();
  }

  String? userName;

  void setUserName(String newName) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(LocalStoreKeys.user_name, newName);
    userName = newName;
    notifyListeners();
  }

  Future<String> get getUserName async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.containsKey(LocalStoreKeys.user_name)) {
      return preferences.getString(LocalStoreKeys.user_name)!;
    } else {
      return "new user".tr();
    }
  }

  /// localization

  LanguageModel appLanguage = englishLanguage;

  void changeLanguage(BuildContext context, LanguageModel language) {
    appLanguage = language;
    context.setLocale(language.locale);
    notifyListeners();
  }

  /// app lock

  late bool isLocked ;

  bool forgetPassword = false;

  List<String> reservePasscodes = [];

  Future<void> appLockerInit(SharedPreferences preferences) async {
    isLocked = preferences.getBool(LocalStoreKeys.isLocked) ?? false;
    if (isLocked) {
      reservePasscodes = preferences.getStringList(LocalStoreKeys.ReservePasscodes)!;
    }
    notifyListeners();
  }

  Future <void> appLockModeOn(String password) async {
    await _pref.setItem(LocalStoreKeys.isLocked,true);
    await _pref.setItem(LocalStoreKeys.lockerPassword,password);
    reservePasscodes = await createReservePasscodes();
    isLocked = true;
    notifyListeners();
  }

  Future <void> appLockModeOff() async {
    await _pref.setItem(LocalStoreKeys.isLocked, false);
    await _pref.removeItem(LocalStoreKeys.lockerPassword);
    isLocked = false;
    notifyListeners();
  }

  Future<bool> checkPassword(String enteredPassword) async {
    String password = await _pref.getItem(LocalStoreKeys.lockerPassword);
    (password);
    if (password == enteredPassword) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> changePassword(String newPassword) async {
    await _pref.setItem(LocalStoreKeys.lockerPassword, newPassword);
  }

  String _generateRandomPassCode(int len) {
    var random = Random();
    String chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => chars[random.nextInt(chars.length)])
        .join();
  }

  Future<List<String>> createReservePasscodes() async {
    List<String> passCodes =
        List<String>.generate(3, (index) => _generateRandomPassCode(15));
    await _pref.setItem(LocalStoreKeys.ReservePasscodes, passCodes);
    return passCodes;
  }

  set forgetPasswordMode(bool value) {
    forgetPassword = value;
    notifyListeners();
  }

  bool checkReservePassCode(String passcode) {
    if (reservePasscodes.contains(passcode)) {
      return true;
    } else {
      return false;
    }
  }

  /// safe delete mode

  bool isDeleteSafe = false ;

  void safeDeleteOperator() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (isDeleteSafe) {
      isDeleteSafe = false;
    } else {
      isDeleteSafe = true;
    }
    preferences.setBool(LocalStoreKeys.isDeleteSafe, isDeleteSafe);
    notifyListeners();
  }

  /// themes and colors

  ThemeModel currentTheme = LightThemeModel;

  set currentThemeChange(ThemeModel theme) {
    currentTheme = theme;
    notifyListeners();
  }

  Future<void> themeInitial(SharedPreferences preferences) async {
    String themeKey = LocalStoreKeys.appTheme;
    String loadedTheme = preferences.getString(themeKey) ?? "light theme";
    themeSwitch(loadedTheme);
    notifyListeners();
  }

  void themeSwitch(String themeName) async {
    if (themeName == LightThemeModel.themeName) {
      currentThemeChange = LightThemeModel;
    } else if (themeName == DarkThemeModel.themeName) {
      currentThemeChange = DarkThemeModel;
    } else if (themeName == VolcanoThemeModel.themeName) {
      currentThemeChange = VolcanoThemeModel;
    } else if (themeName == SakuraThemeModel.themeName) {
      currentThemeChange = SakuraThemeModel;
    } else {
      currentThemeChange = LightThemeModel;
    }
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(LocalStoreKeys.appTheme, themeName);
  }

  //SELECT MODE

  SelectingMode selectingMode = SelectingMode.OFF;

  bool allSelected = false;

  List<int> selectedNotes = [];

  bool selectModeIsOn ()=> selectingMode == SelectingMode.ON ? true : false ;

  set selectModeChange(SelectingMode mode) {
    if(mode == SelectingMode.OFF) {
      selectedNotes.clear();
      allSelected = false ;
    }
    selectingMode = mode;
    notifyListeners();
  }

  void selectingModeSwitch() {
    if (selectModeIsOn()) {
      selectingMode = SelectingMode.OFF;
    } else {
      selectingMode = SelectingMode.ON;
    }
    notifyListeners();
  }

  void select (int id){
    if(!selectModeIsOn()){
      selectModeChange = SelectingMode.ON ;
    }
    selectedNotes.add(id);
    notifyListeners();
  }

  void unSelect (int id){
    selectedNotes.remove(id);
    if (selectedNotes.isEmpty) {
      selectModeChange = SelectingMode.OFF;
    }
    notifyListeners();
  }

  void selectingOperator(int id) {
    if (selectedNotes.contains(id)) {
      unSelect(id);
    } else {
      select(id);
    }
    notifyListeners();
  }

  void selectAll(List<Note> allNotes) {
    Set<int> selected = {};
    if (allSelected) {
      selectModeChange = SelectingMode.OFF ;
    } else {
      for (Note element in allNotes) {
        selected.add(element.id!);
      }
      selectedNotes = selected.toList();
      allSelected = true;
    }
    notifyListeners();
  }
}
