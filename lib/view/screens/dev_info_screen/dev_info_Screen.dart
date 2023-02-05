
// ignore_for_file: file_names

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:memo/constant/constant_strings.dart';
import 'package:memo/constant/style.dart';
import 'package:memo/provider/settings_provider.dart';
import 'package:memo/res/assets_res.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';



class DeveloperInfoScreen extends StatelessWidget {

  static const String screenRoute = "/DevInfoScreen";

  const DeveloperInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Future<void> openLink (String url)async{
      if(await canLaunchUrl(Uri.parse(url))){
        await launchUrlString(url);
      }else{
        showDialog(context: context, builder: (context) {
          return AlertDialog(
            content: const Text("there's a problem with that link"),
            actions: [
              TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                    },
                  child: const Text('ok')
              )
            ],
          );
          },);
      }
    }

    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);

    Widget iconHolder (String imageUrl,String link){
      return MaterialButton(
        color: settingsProvider.currentTheme.currentSecondaryColor,
        height: 80 ,
        minWidth: 80.0,
        onPressed: () async => await openLink(link),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40)
        ),
        child: Image.asset(
          imageUrl , fit: BoxFit.fill,
          height: 50.0, width: 50.0 ,
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(AssetsRes.APP_LOGO_PNG , height: 100.0),
            Text("V : 1.0.0+1".tr() , style: appTextStyles.headerStyle),
            Text("${'Developed By'.tr()} 🌚" , style: appTextStyles.headerStyle),
            Container(
                padding: const EdgeInsets.only(right: 20.0),
                child: Image.asset(AssetsRes.MY_LOGO_PNG,height: 100.0,)
            ),
            Container(
              width: 400.0,
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  iconHolder(AssetsRes.GIT_HUB_ICON,ConstantStrings.GitHubLink),
                  iconHolder(AssetsRes.FACEBOOK,ConstantStrings.FacebookLink),
                  iconHolder(AssetsRes.LINKEDIN,ConstantStrings.LinkedInLink),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
