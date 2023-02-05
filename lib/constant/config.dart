// ignore_for_file: non_constant_identifier_names, unused_element, constant_identifier_names

import 'package:intl/intl.dart';
import 'package:memo/constant/constant_strings.dart';
import 'package:memo/models/language_model.dart';

String DateFormatter() {
  DateTime now = DateTime.now();
  String formatted = DateFormat('yyyy-MM-dd,HH:mm a').format(now);
  String nowDate = formatted;
  return nowDate;
}

Map<String,dynamic> startUpStorageKeys = {
  LocalStoreKeys.isFirstTime : true ,
  LocalStoreKeys.isFirstUse : false ,
  LocalStoreKeys.isLocked : false ,
  LocalStoreKeys.isDeleteSafe :  false ,
  LocalStoreKeys.appTheme : "light theme" ,
  LocalStoreKeys.user_name : "new user",
  LocalStoreKeys.categories : startUpCategories ,
  LocalStoreKeys.appLanguage : englishLanguage.languageName,
  LocalStoreKeys.fontSize : 15.0 ,
};
