import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:memo/provider/settings_provider.dart';
import 'package:simple_animations/animation_builder/loop_animation_builder.dart';

class AppLockerScreenWidgets {
  final Size size;
  final BuildContext context;
  final SettingsProvider settingsProvider;

  AppLockerScreenWidgets({
    required this.size,
    required this.context,
    required this.settingsProvider,
  });

  Widget forgetPasswordButton() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 7.5),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(
            settingsProvider.forgetPassword
                ? "did you remember it ?".tr()
                : "forget the password ?".tr(),
            style: const TextStyle(fontSize: 17.5)),
        TextButton(
          onPressed: () {
            if (settingsProvider.forgetPassword) {
              settingsProvider.forgetPasswordMode = false;
            } else {
              settingsProvider.forgetPasswordMode = true;
            }
          },
          child: Text(
            "yes".tr(),
            style: const TextStyle(
              color: Colors.blue,
              fontSize: 17.5,
            ),
          ),
        )
      ]),
    );
  }

  Widget passwordTextField(TextEditingController passwordController,
      TextEditingController passcodeController) {
    return Container(
      width: size.width * 0.8,
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      padding: const EdgeInsets.symmetric(horizontal: 12.5),
      decoration: BoxDecoration(
        border: Border.all(
            width: 0.45, color: settingsProvider.currentTheme.switchColor),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: settingsProvider.forgetPassword
              ? "enter the passcode".tr()
              : "enter the password".tr(),
          labelText: settingsProvider.forgetPassword
              ? "passcode".tr()
              : "password".tr(),
          border: InputBorder.none,
        ),
        controller: settingsProvider.forgetPassword
            ? passcodeController
            : passwordController,
        autofocus: true,
        keyboardType: settingsProvider.forgetPassword
            ? TextInputType.text
            : TextInputType.visiblePassword,
        style: const TextStyle(
          fontSize: 20.0,
        ),
      ),
    );
  }

  Widget confirmButton(void Function(SettingsProvider settingsProvider) onPressed) {
    return MaterialButton(
      shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 3.0,
            color: settingsProvider.currentTheme.currentPrimaryColor,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(15.0)),
      height: 50.0,
      minWidth: 75.0,
      onPressed: () async => onPressed(settingsProvider),
      child: Text(
        "enter".tr(),
        style: TextStyle(
            color: settingsProvider.currentTheme.currentPrimaryColor,
            fontSize: 30.0),
      ),
    );
  }

  Widget lockIcon() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          LoopAnimationBuilder<double>(
            tween: Tween(
              begin: 0.0,
              end: 160,
            ), // 0° to 360° (2π)
            duration:
                const Duration(seconds: 100), // for 2 seconds per iteration
            builder: (context, value, _) {
              return Transform.rotate(
                angle: value, // use value
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                      gradient: settingsProvider.currentTheme.gradient,
                      borderRadius: BorderRadius.circular(50)),
                ),
              );
            },
          ),
          Container(
            padding: const EdgeInsets.all(17.5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            child: const Icon(
              Icons.lock,
              size: 50,
            ),
          ),
        ],
      ),
    );
  }
}
