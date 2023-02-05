// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:memo/constant/app_enums.dart';
import 'package:memo/constant/themes.dart';
import 'package:memo/res/assets_res.dart';

class ThemeModel {
  final ThemeType themeMode;
  final String themeName;
  final Color switchColor;
  final ThemeData themeData;
  final LinearGradient gradient;
  final String themeImageUrl;

  ThemeModel(
      {required this.themeMode,
      required this.themeName,
      required this.switchColor,
      required this.themeData,
      required this.gradient,
      required this.themeImageUrl});

  Color get currentPrimaryColor {
    switch (themeMode) {
      case ThemeType.LightTheme:
        {
          return appColors.lightMode_primaryColor;
        }
      case ThemeType.DarkTheme:
        {
          return appColors.darkMode_primaryColor;
        }
      case ThemeType.VolcanoTheme:
        {
          return appColors.volcano_primaryColor;
        }
      case ThemeType.SakuraTheme:
        {
          return appColors.sakuraTheme_PrimaryColor;
        }
    }
  }

  Color get currentSecondaryColor {
    switch (themeMode) {
      case ThemeType.LightTheme:
        return appColors.lightMode_secondaryColor;

      case ThemeType.DarkTheme:
        return appColors.darkMode_secondaryColor;

      case ThemeType.VolcanoTheme:
        return appColors.volcano_SecondaryColor;

      case ThemeType.SakuraTheme:
        return appColors.sakuraTheme_SecondaryColor;
    }
  }
}

ThemeModel LightThemeModel = ThemeModel(
  themeMode: ThemeType.LightTheme,
  themeName: "Light theme",
  gradient: appColors.lightModeGradient,
  themeData: appThemes.lightModeTheme(),
  switchColor: Colors.black,
  themeImageUrl: AssetsRes.LIGHT_THEME_BANNER,
);

ThemeModel DarkThemeModel = ThemeModel(
  themeMode: ThemeType.DarkTheme,
  themeName: "Dark theme",
  gradient: appColors.darkModeGradient,
  themeData: appThemes.darkModeTheme(),
  switchColor: Colors.white,
  themeImageUrl: AssetsRes.DARK_PURPLE_MODE,
);

ThemeModel VolcanoThemeModel = ThemeModel(
  themeMode: ThemeType.VolcanoTheme,
  themeName: "Volcano theme",
  gradient: appColors.volcanoGradient,
  themeData: appThemes.VolcanoTheme(),
  switchColor: Colors.white,
  themeImageUrl: AssetsRes.VOLCANO_THEME_BANNER,
);

ThemeModel SakuraThemeModel = ThemeModel(
  themeMode: ThemeType.SakuraTheme,
  themeName: "Sakura flower theme",
  gradient: appColors.sakuraGradient,
  themeData: appThemes.sakuraFlowerTheme(),
  switchColor: Colors.black,
  themeImageUrl: AssetsRes.SAKURA_THEME_BANNER,
);

