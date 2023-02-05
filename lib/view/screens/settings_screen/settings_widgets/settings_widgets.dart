import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:memo/models/language_model.dart';
import 'package:memo/models/theme_model.dart';
import 'package:memo/provider/settings_provider.dart';
import 'package:memo/view/screens/dev_info_screen/dev_info_Screen.dart';
import 'package:memo/view/widgets/input_forms/password_setting_form.dart';
import 'package:memo/view/widgets/dialog_widgets/confirmation_dialog.dart';
import 'package:memo/view/widgets/dialog_widgets/data_insert_dialog_widget.dart';

class SettingsScreenWidgets {
  final BuildContext context;
  final Size size;
  final SettingsProvider settingsProvider;

  SettingsScreenWidgets(
      {required this.context,
      required this.size,
      required this.settingsProvider});

  BoxDecoration buttonDecoration (){
    return BoxDecoration(
        border: Border.all(
            width: 0.25, color: settingsProvider.currentTheme.switchColor),
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Colors.black,
            spreadRadius: 0.01,
            blurRadius: 1,
            blurStyle: BlurStyle.outer,
            offset: Offset.zero,
          ),
        ]);
  }

  Widget themeBox(ThemeModel themeModel) {
    String themeName = themeModel.themeName.tr();
    return MaterialButton(
      elevation: 0,
      padding: const EdgeInsets.all(0),
      onPressed: () {
        settingsProvider.themeSwitch(themeModel.themeName);
      },
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                height: size.height * 0.1,
                width: size.width,
                decoration: BoxDecoration(
                    gradient:  themeModel.gradient,
                    image:DecorationImage(
                      image: AssetImage(themeModel.themeImageUrl),
                      opacity: 0.5,
                      fit: BoxFit.fitWidth,
                    ),
                ) ,
                alignment: Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    themeName,
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              settingsProvider.currentTheme == themeModel ?
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 25.0 , right: 5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  alignment: Alignment.centerRight,
                  child: Text(
                    "[${"selected".tr()}]",
                    style: const TextStyle(
                      fontSize: 25 ,
                      color: Colors.white,
                    ),
                  ),
                ),
              ) :
              const SizedBox(),
            ],
          ),
        ],
      ),
    );
  }

  Widget themeSelectionButton (){
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      decoration: buttonDecoration(),
      child: ExpansionTile(
        childrenPadding: const EdgeInsets.symmetric(vertical: 2.5),
        title: Text('themes'.tr()),
        children: [
          themeBox(LightThemeModel),
          themeBox(DarkThemeModel),
          themeBox(VolcanoThemeModel),
          themeBox(SakuraThemeModel),
        ],
      ),
    );
  }

  Widget appInfoNavigator () {
    return Container(
      height: 55.0,
      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      decoration: BoxDecoration(
          border: Border.all(
              width: 0.25, color: settingsProvider.currentTheme.switchColor),
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Colors.black,
              spreadRadius: 0.01,
              blurRadius: 1,
              blurStyle: BlurStyle.outer,
              offset: Offset.zero,
            ),
          ]),
      child: ListTile(
        horizontalTitleGap: 0,
        leading: const Icon(Icons.ad_units),
        title: Text("about the app".tr(),
            textAlign: TextAlign.start,
            style: const TextStyle(
              fontSize: 17.5,
            )),
        style: ListTileStyle.list,
        onTap: () {
          Navigator.pushNamed(context, DeveloperInfoScreen.screenRoute);
        },
      ),
    );
  }

  Widget nameViewWidget(TextEditingController controller) {
    String hi = 'Hi'.tr();
    return Container(
      height: size.height * 0.075,
      width: size.width,
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 5.0),
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
      decoration: buttonDecoration(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: size.width * 0.65,
            child: Text("$hi ! ${settingsProvider.userName}",
                textAlign: TextAlign.start,
                maxLines: 1,
                softWrap: false,
                style: const TextStyle(
                  overflow: TextOverflow.fade,
                  fontSize: 20.0,
                )),
          ),
          TextButton(
            onPressed: () {
              controller.text = settingsProvider.userName!;
              controller.selection =
                  TextSelection.collapsed(offset: controller.text.length);
              showDialog(
                context: context,
                builder: (context) {
                  return DataInsertDialog(
                    title: "enter your name".tr(),
                    controller: controller,
                    onPressed: () async {
                      settingsProvider.setUserName(controller.text);
                      Navigator.pop(context);
                    },
                    maxLength: 20,
                    inputType: TextInputType.text,
                  );
                },
              );
            },
            child: Text(
              'change'.tr(),
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }

  Widget safeDeleteButton() {
    return Container(
      height: 85.0,
      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      decoration: buttonDecoration(),
      child: ListTile(
        title: Text("safe delete".tr(),
            style: const TextStyle(
              fontSize: 17.5,
            )),
        subtitle: Text(
            "when safe delete mode is active your deleted notes with go to the archive".tr(),
            style: const TextStyle(
              fontSize: 12.5,
              color: Colors.grey,
            )),
        trailing: Checkbox(
            value: settingsProvider.isDeleteSafe,
            onChanged: (bool? value) {
              settingsProvider.safeDeleteOperator();
            }),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        style: ListTileStyle.list,
        onTap: () {
          settingsProvider.safeDeleteOperator();
        },
      ),
    );
  }

  Widget languageSelectBox (LanguageModel languageModel){
    return InkWell(
      onTap: () {
        settingsProvider.changeLanguage(context, languageModel);
      },
      child: Container(
        height: 100.0,
        width: size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(languageModel.languageBanner),
            fit: BoxFit.fitWidth,
          ),
        ),
        alignment: Alignment.center,
      ),
    );
  }

  Widget languageSelectionButton (){
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      decoration: buttonDecoration(),
      child: ExpansionTile(
        title: Text("languages".tr()),
        children: [
          languageSelectBox(arabicLanguage),
          languageSelectBox(englishLanguage),
        ],
      ),
    );
  }

  Icon _lockerIcon(bool locked) {
    if (locked) {
      return const Icon(Icons.lock, color: Colors.green);
    } else {
      return const Icon(
        Icons.lock_open,
        color: Colors.red,
      );
    }
  }

  Widget appLockingSwitchButton() {
    return Container(
      height: 75.0,
      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      decoration: buttonDecoration(),
      child: ListTile(
        title: Text("locker".tr(),
            style: const TextStyle(
              fontSize: 17.5,
            )),
        subtitle: Text("make your notes safe with a password".tr(),
            style: const TextStyle(
              fontSize: 12.5,
              color: Colors.grey,
            )),
        trailing: _lockerIcon(settingsProvider.isLocked),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
        style: ListTileStyle.list,
        onTap: () async {
          if (settingsProvider.isLocked) {
            showDialog(
              context: context,
              builder: (context) {
                return ConfirmationDialogWidget(
                    onPressedYes: () async {
                      settingsProvider.appLockModeOff();
                    },
                    onPressedNo: () {},
                    content: "turn off the locker");
              },
            );
          } else {
            showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    clipBehavior: Clip.hardEdge,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: const PasswordSettingForm(),
                  );
                });
          }
        },
      ),
    );
  }
}
