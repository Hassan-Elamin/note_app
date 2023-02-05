// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:memo/constant/style.dart';

mixin appThemes {

  static ThemeData lightModeTheme ()=> ThemeData.light().copyWith(
    textTheme: appTextStyles.themeText,
    colorScheme: appColors.LightModeColorScheme,
  );

  static ThemeData darkModeTheme ()=> ThemeData.dark().copyWith(
    textTheme: appTextStyles.themeText.apply(bodyColor: Colors.white),
    colorScheme: appColors.DarkModeColorScheme,
  );

  static ThemeData VolcanoTheme ()=> ThemeData(
    textTheme: appTextStyles.themeText.apply(bodyColor: Colors.white),
    scaffoldBackgroundColor: appColors.volcano_thirdColor,
    colorScheme: appColors.VolcanoColorScheme,
  );

  static ThemeData sakuraFlowerTheme ()=> ThemeData(
    textTheme: appTextStyles.themeText,
    scaffoldBackgroundColor: const Color(0XFFFff1ff),
    colorScheme: appColors.SakuraFlowerColorScheme,
  );

}

mixin appColors {
  static final Color border_light_mode_color = Colors.grey.shade200;

  static const Color lightMode_primaryColor = Color(0XFF005AFF);
  static const Color lightMode_secondaryColor = Color(0XFF21b5ff);
  static const Color lightMode_thirdColor = Color(0XFF2B5AFF);

  static const LinearGradient lightModeGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        lightMode_secondaryColor,
        lightMode_primaryColor,
        lightMode_thirdColor,
      ]);
  static const ColorScheme LightModeColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: lightMode_primaryColor,
    onPrimary: Colors.white,
    secondary: lightMode_secondaryColor,
    onSecondary: Colors.black,
    error: Colors.red,
    onError: Colors.black,
    background: lightMode_thirdColor,
    onBackground: Colors.white,
    surface: lightMode_secondaryColor,
    onSurface: Colors.black,
  );

  //

  static const Color darkMode_primaryColor = Color(0XFFE963FD);
  static const Color darkMode_secondaryColor = Color(0XFF8233C5);
  static const Color darkMode_thirdColor = Color(0XFF274B7A);

  static const LinearGradient darkModeGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        darkMode_primaryColor,
        darkMode_secondaryColor,
        darkMode_thirdColor,
      ]);
  static const ColorScheme DarkModeColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: darkMode_primaryColor,
    onPrimary: Colors.white,
    secondary: darkMode_secondaryColor,
    onSecondary: Colors.white,
    error: Colors.red,
    onError: Colors.white,
    background: darkMode_thirdColor,
    onBackground: Colors.white,
    surface: darkMode_primaryColor,
    onSurface: Colors.white,
  );

  //

  static const Color sakuraTheme_PrimaryColor = Color(0XFF903775);
  static const Color sakuraTheme_SecondaryColor = Color(0XFFE8458B);
  static const Color sakuraTheme_thirdColor = Color(0XFF363553);
  static const Color sakuraTheme_background_Color = Color(0XFFFff1ff);

  static const LinearGradient sakuraGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        sakuraTheme_SecondaryColor,
        sakuraTheme_PrimaryColor,
        sakuraTheme_thirdColor,
      ]
  );
  static const ColorScheme SakuraFlowerColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: sakuraTheme_SecondaryColor,
    onPrimary: Colors.white,
    secondary: sakuraTheme_PrimaryColor,
    onSecondary: Colors.white,
    error: Colors.black,
    onError: Colors.white,
    background: sakuraTheme_background_Color,
    onBackground: Colors.white,
    surface: sakuraTheme_PrimaryColor,
    onSurface: Colors.white,
  );

  //

  static const Color volcano_primaryColor = Colors.red;
  static const Color volcano_SecondaryColor = Color(0XFF480800);
  static const Color volcano_thirdColor = Colors.black;

  static const LinearGradient volcanoGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        volcano_primaryColor,
        volcano_SecondaryColor,
        volcano_thirdColor,
      ]);
  static const ColorScheme VolcanoColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: volcano_primaryColor,
    onPrimary: Colors.white,
    secondary: volcano_SecondaryColor,
    onSecondary: Colors.white,
    error: Colors.black,
    onError: Colors.white,
    background: volcano_thirdColor,
    onBackground: Colors.white,
    surface: volcano_primaryColor,
    onSurface: Colors.white,
  );

}
