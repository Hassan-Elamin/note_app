// ignore_for_file: use_build_context_synchronously


import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:memo/constant/style.dart';
import 'package:memo/provider/settings_provider.dart';
import 'package:provider/provider.dart';
import 'package:simple_animations/animation_builder/play_animation_builder.dart';

class SplashScreen extends StatefulWidget {
  static const String screenRoute = "/SplashScreen";

  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  void systemNavigate(SettingsProvider settingsProvider) async {
    if (settingsProvider.appIsReady) {
      Navigator.pushNamedAndRemoveUntil(
          context, settingsProvider.startNavigate(), (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    return Scaffold(
      body: Center(
          child: PlayAnimationBuilder<Color?>(
            tween: ColorTween(
              begin: settingsProvider.currentTheme.currentPrimaryColor,
              end: settingsProvider.currentTheme.currentSecondaryColor,
            ), // red to blue
            duration: const Duration(seconds: 2), // for 5 seconds per iteration
            builder: (context, value, _) {
              return Text(
                "${"Hi".tr()} : ${settingsProvider.userName}",
                style: appTextStyles.headerStyle.copyWith(
                  color: value,
                ),
              );
            },
            onCompleted: () {
              systemNavigate(settingsProvider);
            },
          )),
    );
  }
}
