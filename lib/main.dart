import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:memo/constant/routes.dart';
import 'package:memo/models/language_model.dart';
import 'package:memo/provider/providers_list.dart';
import 'package:memo/provider/settings_provider.dart';
import 'package:memo/view/screens/splash_screen/splash_screen.dart';
import 'package:provider/provider.dart';

Future <void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(
      MultiProvider(
        providers: providers,
        builder: (context, child) {
          return EasyLocalization(
            supportedLocales:<Locale>[
              arabicLanguage.locale,
              englishLanguage.locale,
            ],
            path: "assets/languages",
            child: const MyApp(),
          );
        },
      )
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, child) {
        return MaterialApp(
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          debugShowCheckedModeBanner: false,
          title: 'memo',
          theme: settingsProvider.currentTheme.themeData,
          home: const SplashScreen(),
          routes: Routes,
        );
      },
    );
  }
}
