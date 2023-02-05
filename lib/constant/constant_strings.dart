
// ignore_for_file: constant_identifier_names

List<String> startUpCategories = ["unCategorized", "work", "personal", "school"];

mixin ConstantStrings {

  static const String dbPath = "/data/data/com.notesApp.memo.memo/databases/notesDatabase.db";
  static const String GitHubLink = "https://github.com/Hassan-Elamin";
  static const String FacebookLink = "https://www.facebook.com/profile.php?id=100009322796701";
  static const String LinkedInLink = "https://www.linkedin.com/in/hassan-elamin-1053/";

}

mixin DatabaseKeys {
  static const String notes_table = "notes" ;

  static const String archive_table = "archive" ;

  static const String id_column = "id";
  static const String title_column = "title";
  static const String note_column = "note";
  static const String category_column = "category";
}

mixin LocalStoreKeys {

  static const String storageName = "memo_local_database.json" ;

  static const String isFirstTime = "isFirstTime" ;
  static const String isFirstUse = "isFirstUse";
  static const String isDeleteSafe = "isDeleteSafe" ;
  static const String isLocked = "isLocked" ;
  static const String ReservePasscodes = "reserve-passcodes";
  static const String appLanguage = "app-language";
  static const String fontSize = "font-size";

  static const String appTheme = "app-theme" ;
  static const String archive = "archive" ;
  static const String categories = "categories";
  static const String user_name = "user-name";
  static const String lockerPassword = "user-password" ;
}