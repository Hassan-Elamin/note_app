// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:memo/provider/settings_provider.dart';
import 'package:memo/view/screens/app_locker_screen/app_locker_widgets/app_locker_widgets.dart';
import 'package:memo/view/screens/dashboard_screen/dashboard_screen.dart';
import 'package:memo/view/widgets/snackBar_widget/snackBar_Widget.dart';
import 'package:provider/provider.dart';

class AppLockerScreen extends StatefulWidget {
  static const String screenRoute = "/AppLockerScreen";

  const AppLockerScreen({Key? key}) : super(key: key);

  @override
  State<AppLockerScreen> createState() => _AppLockerScreenState();
}

class _AppLockerScreenState extends State<AppLockerScreen> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController passcodeController = TextEditingController();

  @override
  void dispose() {
    passwordController.dispose();
    passcodeController.dispose();
    super.dispose();
  }

  Future<void> onPressed(SettingsProvider settingsProvider) async {
    bool isRight;
    if (settingsProvider.forgetPassword) {
      isRight = settingsProvider.checkReservePassCode(passcodeController.text);
      if (isRight) {
        Navigator.pushNamedAndRemoveUntil(
            context, DashboardScreen.screenRoute, (route) => false);
      } else {
        SnackBarWidget(context: context).showSnackBar("passcode is wrong");
      }
    } else {
      isRight = await settingsProvider.checkPassword(passwordController.text);
      if (isRight) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const DashboardScreen(),),
            (route) => false
        );
      } else {
        passwordController.clear();
        SnackBarWidget(context: context).showSnackBar("password is wrong".tr());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);

    Size size = MediaQuery.of(context).size;

    AppLockerScreenWidgets widgets = AppLockerScreenWidgets(
      size: size,
      context: context,
      settingsProvider: settingsProvider,
    );

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widgets.lockIcon(),
            widgets.passwordTextField(passwordController, passcodeController),
            widgets.forgetPasswordButton(),
            widgets.confirmButton((settingsProvider)=> onPressed(settingsProvider)),
          ],
        ),
      ),
    );
  }
}
