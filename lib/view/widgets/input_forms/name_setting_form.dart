 import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:memo/constant/style.dart';
import 'package:memo/provider/settings_provider.dart';
import 'package:provider/provider.dart';

 class UserNameSettingForm extends StatefulWidget {
  const UserNameSettingForm({Key? key}) : super(key: key);

  @override
  State<UserNameSettingForm> createState() => _UserNameSettingFormState();
}

class _UserNameSettingFormState extends State<UserNameSettingForm> {

  TextEditingController controller = TextEditingController();
  
  bool done = false ;
  

  @override
  Widget build(BuildContext context) {

    final SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    Size size = MediaQuery.of(context).size;

    Widget inputDoneWidget (){
      return Container (
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          border: Border.all(),
          gradient: settingsProvider.currentTheme.gradient,
        ),
        child: const Icon(Icons.done,size: 30,),
      );
    }

    if (done) {
      return inputDoneWidget();
    } else {
      return Container(
        height: size.height * 0.25,
        width: size.width * 0.9,
        padding: const EdgeInsets.symmetric(vertical:5 , horizontal: 10),
        decoration: BoxDecoration(
            border: Border.all(
              color: settingsProvider.currentTheme.switchColor,
              width: 0.5,
            ),
            borderRadius: BorderRadius.circular(15.0)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("type your name".tr() , style: appTextStyles.headerStyle,),
            Container(
              height: 60.0,
              padding: const EdgeInsets.symmetric(vertical: 5.0 , horizontal: 10.0),
              decoration: BoxDecoration(
                  border: Border.all(
                    width: 0.5,
                    color: settingsProvider.currentTheme.switchColor,
                  ),
                  borderRadius: BorderRadius.circular(25)
              ),
              child: TextField(
                controller: controller,
                textAlign: TextAlign.start,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 7.5 ,horizontal: 5),
                  border: InputBorder.none,
                ),
                maxLines: 1,
                maxLength: 25,
              ),
            ),
            MaterialButton(
              onPressed: ()async{
                settingsProvider.setUserName(controller.text);
                setState(() {
                  done = true ;
                });
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: BorderSide(color: settingsProvider.currentTheme.currentPrimaryColor)
              ),
              child: Text("save".tr() , style: const TextStyle(fontSize: 20),),
            ),
          ],
        ),
      );
    }
  }
}