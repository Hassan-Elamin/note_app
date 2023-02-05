import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:memo/constant/style.dart';
import 'package:memo/provider/settings_provider.dart';
import 'package:memo/services/text_field_validators.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

class PasswordSettingForm extends StatefulWidget {
  const PasswordSettingForm({Key? key}) : super(key: key);

  @override
  State<PasswordSettingForm> createState() => _PasswordSettingFormState();
}

class _PasswordSettingFormState extends State<PasswordSettingForm> {
  bool done = false;

  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);

    Widget passwordTextField(
      TextEditingController controller,
      String label,
      String? Function(String?) validator,
    ) {
      return Container(
        margin: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          
            border: Border.all(
                width: 0.5, color: settingsProvider.currentTheme.switchColor),
            borderRadius: BorderRadius.circular(15.0)),
        child: TextFormField(
          onFieldSubmitted: (value) {
            setState(() {
              controller.text = value;
            });
          },
          controller: controller,
          autofocus: label == "password" ? true : false,
          validator: validator,
          keyboardType: TextInputType.visiblePassword,
          maxLines: 1,
          maxLength: 16,
          decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            labelText: label,
            alignLabelWithHint: true,
            floatingLabelAlignment: FloatingLabelAlignment.start,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            border: InputBorder.none,
          ),
        ),
      );
    }

    Future <void> setPassword() async {
      if (formKey.currentState!.validate()) {
        settingsProvider.appLockModeOn(passwordConfirmController.text);
        setState(() {
          done = true;
        });
      }
    }

    Widget confirmButton(Future<void> Function () onPressed ) {
      return Container(
        decoration: BoxDecoration(
          gradient: settingsProvider.currentTheme.gradient,
          borderRadius: BorderRadius.circular(25),
        ),
        child: MaterialButton(
          height: 50.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          onPressed:onPressed,
          child: Text('confirm'.tr() , style: const TextStyle(color: Colors.white)),
        ),
      );
    }

    Widget passCodeViewer(String passcode) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 12.5),
        height: 75.0,
        width: 75.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              width: 0.5,
              color: settingsProvider.currentTheme.switchColor,
            )),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(passcode),
            IconButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: passcode));
                },
                icon: const Icon(Icons.copy)
                ),
          ],
        ),
      );
    }

    Widget passcodesListBuilder() {
      return SizedBox(
        height: settingsProvider.reservePasscodes.length * 85,
        child: ListView.builder(
          shrinkWrap: false,
          itemCount: settingsProvider.reservePasscodes.length,
          itemBuilder: (context, index) {
            return passCodeViewer(settingsProvider.reservePasscodes[index]);
          },
        ),
      );
    }

    if (done) {
      return SizedBox(
        height: size.height * 0.5,
        width: size.width * 0.8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "copy the passcodes for case \n if your forget your password".tr() ,
              style: const TextStyle(
                fontSize: 20,
              ),
              ),
            passcodesListBuilder(),
            confirmButton(() async{
              Navigator.pop(context);
            }),
          ],
        ),
      );
    } else {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
        padding: const EdgeInsets.all(5),
        alignment: Alignment.center,
        height: size.height * 0.4,
        width: size.width * 0.8,
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "protect your notes".tr(),
                style: appTextStyles.headerStyle,
              ),
              passwordTextField(
                passwordController,
                "password".tr(),
                (password) {
                  if (isPasswordValid(password ?? "")) {
                    return null;
                  } else {
                    return "enter a valid password".tr();
                  }
                },
              ),
              passwordTextField(
                passwordConfirmController,
                "confirm your password".tr(),
                (password) {
                  if (isPasswordConfirmValid(
                      passwordController.text, password ?? "")) {
                    return null;
                  } else {
                    return "confirm with the same input".tr();
                  }
                },
              ),
              confirmButton(() async{
                if(done){
                  Navigator.pop(context);
                }else{
                  await setPassword();
                } 
              }),
            ],
          ),
        ),
      );
    }
  }
}
