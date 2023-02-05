import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:memo/constant/app_enums.dart';
import 'package:memo/provider/database_provider.dart';
import 'package:memo/provider/settings_provider.dart';
import 'package:memo/view/widgets/dialog_widgets/confirmation_dialog.dart';
import 'package:memo/view/widgets/dialog_widgets/data_insert_dialog_widget.dart';
import 'package:memo/view/widgets/note_view_widgets/note_view_widget.dart';
import 'package:provider/provider.dart';


class CategoriesScreen extends StatefulWidget {

  static const String screenRoute = "/CategoriesScreen";

  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {

  String selectedCategory = "unCategorized" ;

  TextEditingController categoryInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final scaffoldKey = GlobalKey<ScaffoldState>();

    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    DatabaseProvider databaseProvider = Provider.of<DatabaseProvider>(context);

    Future <void> onPressed ()async{
      Navigator.pop(context);
      await databaseProvider.insertCategory(categoryInputController.text);
      categoryInputController.clear();
    }

    Widget categoryViewWidget (String categoryName){
      return Container(
        decoration: BoxDecoration(
            border: Border.all(width: 0.5 , color: settingsProvider.currentTheme.switchColor),
            borderRadius: BorderRadius.circular(10),
          gradient: selectedCategory == categoryName ? settingsProvider.currentTheme.gradient : null ,
        ),
        margin: const EdgeInsets.all(7.5),
        child: MaterialButton(
            onLongPress: () {
              if(categoryName != "unCategorized"){
                showDialog(
                  context: context,
                  builder: (context) {
                    return ConfirmationDialogWidget(
                        onPressedYes:(){
                          databaseProvider.removeCategory(categoryName);
                        },
                        onPressedNo: (){},
                        content: "delete the category".tr()
                    );
                  },
                );
              }
            },
            onPressed: () {
              setState(() {
                selectedCategory = categoryName ;
              });
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              categoryName,
              style: TextStyle(
                color: selectedCategory == categoryName ? Colors.white : null ,
              ),
            )
        ),
      );
    }

    Widget categoryInsertWidget (){
      return Container(
          decoration: BoxDecoration(
            border: Border.all(
                width: 0.75,
                color: settingsProvider.currentTheme.switchColor
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(7.5),
          child: MaterialButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return DataInsertDialog(
                        title: 'add a new category',
                        controller: categoryInputController,
                        onPressed: onPressed,
                        maxLength: 20,
                        inputType: TextInputType.text,
                      );
                    },
                );
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.add)
          )
      );
    }

    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        body: Column(
          children: [
            SizedBox(
              height: 50.0,
              child: ListView.builder(
                itemCount: databaseProvider.categories.length + 1,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  if(index == databaseProvider.categories.length){
                    return categoryInsertWidget();
                  }else{
                    return categoryViewWidget(databaseProvider.categories[index]);
                  }

                },
              ),
            ),
            Expanded(
              child: NoteListBuilder(
                  databaseProvider.notes.where(
                          (element) => element.category == selectedCategory)
                      .toList(),
                  ScreenType.Category
              ),
            ),
          ],
        ),
      ),
    );
  }
}
