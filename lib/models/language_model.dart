
import 'package:flutter/material.dart';
import 'package:memo/res/assets_res.dart';

class LanguageModel {
  final Locale locale ;
  final String languageName ;
  final String languageIconUrl ;
  final String languageBanner ;

  LanguageModel ({
    required this.locale ,
    required this.languageName ,
    required this.languageIconUrl,
    required this.languageBanner,
  });
}

LanguageModel arabicLanguage = LanguageModel(
  locale: const Locale('ar'),
  languageName: "arabic",
  languageIconUrl: AssetsRes.UNITED_ARAB_EMIRATES,
  languageBanner: AssetsRes.ARABIC_LANGUAGE_BANNER,
);

LanguageModel englishLanguage = LanguageModel(
  locale: const Locale('en'),
  languageName: "english",
  languageIconUrl: AssetsRes.UNITED_KINGDOM,
  languageBanner: AssetsRes.ENGLISH_BANNER,
);