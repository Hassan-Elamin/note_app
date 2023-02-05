// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'package:google_fonts/google_fonts.dart' ;
import 'package:flutter/material.dart';

mixin appTextStyles {

  static const String ExoTextStyle = "Exo";

  static const TextStyle headerStyle = TextStyle(
    fontFamily: ExoTextStyle,
    fontWeight: FontWeight.bold,
    fontSize: 30,
  );

  static TextTheme themeText = GoogleFonts.notoSansTextTheme();

}

