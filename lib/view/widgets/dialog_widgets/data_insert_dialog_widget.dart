

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:memo/provider/settings_provider.dart';
import 'package:provider/provider.dart';

class DataInsertDialog extends StatelessWidget {
  final String title ;
  final TextEditingController controller;
  final Future<void> Function() onPressed ;
  final int maxLength ;
  final TextInputType inputType ;

  DataInsertDialog({
    required this.title ,
    required this.controller ,
    required this.onPressed ,
    required this.maxLength,
    required this.inputType ,
    Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    return Form(
      key: _formKey,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        child: Container(
          height: 200.0,
          width: 200.0,
          padding: const EdgeInsets.symmetric(vertical: 10.0 , horizontal: 12.5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(title.tr() ,
                style: const TextStyle(
                fontSize: 20.0
              ) ,),
              Container(
                height: 50.0,
                decoration: BoxDecoration(
                  border: Border.all(width: 0.5,color: settingsProvider.currentTheme.switchColor ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextFormField(
                  maxLines: 1,
                  maxLength: maxLength ,
                  controller: controller,
                  keyboardType: inputType,
                  validator: (value) {
                    if(value == null || value.isEmpty ){
                      return "type something".tr();
                    }else{
                      return null ;
                    }
                  },
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                    border: InputBorder.none,
                  ),
                ),
              ),
              MaterialButton(
                onPressed: onPressed,
                child: Container(
                  height: 45.0,
                  width: 60.0,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(
                        width: 0.5 ,
                        color: settingsProvider.currentTheme.switchColor
                    ),
                    borderRadius: BorderRadius.circular(17.5),
                  ),
                  child: Text(
                    "enter".tr() ,
                    style: TextStyle(
                        color: settingsProvider.currentTheme.switchColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}