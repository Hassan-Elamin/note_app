import 'package:memo/constant/config.dart';
import 'package:memo/constant/constant_strings.dart' ;
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefServices {

  Future <List<String>> get categories async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if(preferences.containsKey(LocalStoreKeys.categories)){
      return preferences.getStringList(LocalStoreKeys.categories)!;
    }else{
      preferences.setStringList(LocalStoreKeys.categories, startUpCategories);
      return preferences.getStringList(LocalStoreKeys.categories)!;
    }
  }

  Future <void> setItem (String key,var item)async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    switch(item.runtimeType){
      case String :{
        preferences.setString(key, item);
      }break;
      case int : {
        preferences.setInt(key, item);
      }break;
      case double : {
        preferences.setDouble(key, item);
      }break;
      case bool : {
        preferences.setBool(key, item);
      }break;
      case List<String> : {
        preferences.setStringList(key, item);
      }break;
      default :return Future.error("enter a valid data type");
    }
  }

  Future <dynamic> getItem (String key)async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var item = preferences.get(key);
    if(item != null){
      return item ;
    }else{
      return "no element like that here";
    }
  }

  Future <void> removeItem (String key)async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove(key);
  }

  Future <void> insertManyItems (List<String> keys , List<dynamic> items)async{
    for(int index = 0 ; index < keys.length ; index++ ){
      await setItem(keys[index], items[index]);
    }
  }

  Future <void> firstUseSetUp ()async{
    await insertManyItems(
        startUpStorageKeys.keys.toList(),
        startUpStorageKeys.values.toList()
    );
  }

}