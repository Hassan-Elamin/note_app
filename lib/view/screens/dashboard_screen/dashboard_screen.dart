

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:memo/constant/app_enums.dart';
import 'package:memo/provider/database_provider.dart';
import 'package:memo/provider/settings_provider.dart';
import 'package:memo/view/screens/archive_screen/archive_screen.dart';
import 'package:memo/view/screens/categories_screen/categories_screen.dart';
import 'package:memo/view/screens/notes_view_screen/notes_view_screen.dart';
import 'package:memo/view/screens/note_editor_screen/note_editor_screen.dart';
import 'package:memo/view/screens/settings_screen/settings_screen.dart';
import 'package:memo/view/widgets/appBar_widget/appBar_widget.dart';
import 'package:memo/view/widgets/dialog_widgets/confirmation_dialog.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {

  static const String screenRoute = "/DashboardScreen";

  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {


  List<Widget> screens = const [
    NotesViewScreen(),
    CategoriesScreen(),
    ArchiveScreen(),
    SettingsScreen(),
  ];

  ScreenType currentScreenType (int index){
    switch(index){
      case 0 :{
        return ScreenType.Notes;
      }
      case 1 :{
        return ScreenType.Category;
      }
      case 2 :{
        return ScreenType.Archive;
      }
      case 3 :{
        return ScreenType.Settings;
      }
      default : return ScreenType.Notes;
    }
  }

  Future<bool> onWillPop ()async{
    return (await
    showDialog(
      context: context, builder: (context) {
        return ConfirmationDialogWidget(
            onPressedYes: (){
              SystemNavigator.pop(animated: true);
            },
            onPressedNo: (){},
            content: "want to exit ?".tr(),
        );
    },
    )
    )?? false ;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    DatabaseProvider databaseProvider = Provider.of<DatabaseProvider>(context);
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);

    Widget navButton (IconData icon , String label , int index ){
      return MaterialButton(
        height: 60.0,
        minWidth: 70.0,
        padding: const EdgeInsets.all(0),
        onPressed: (){
          settingsProvider.indexNavigate = index ;
        },
        color: settingsProvider.currentScreenIndex == index ?
        settingsProvider.currentTheme.currentSecondaryColor : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),

        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon , size: 25.0,),
            Text(label.tr() , style: const TextStyle( fontSize: 12.5 ),)
          ],
        ),
      );
    }

    Widget floatActionButton() {
      return Container(
        height: 60.0,
        width: 60.0,
        decoration: BoxDecoration(
            gradient: settingsProvider.currentTheme.gradient,
            borderRadius: BorderRadius.circular(75)
        ),
        child: MaterialButton(
          height: 60.0,
          minWidth: 60.0,
          padding: const EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              width: 0.4 ,
              color: Colors.black,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(50.0),
          ),
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NoteEditorScreen(note: null),
              )),
          child: const Icon(
            Icons.add_box_outlined,
            size: 37.5,
            color: Colors.white,
          ),
        ),
      );
    }

    AppBarWidget appBarWidget = AppBarWidget(
        databaseProvider: databaseProvider,
        context: context, size: size,
        screenType: currentScreenType(settingsProvider.currentScreenIndex),
        settingsProvider: settingsProvider
    );

    BottomAppBar bar (){
      return BottomAppBar(
        elevation: 25.0,
        shape: const CircularNotchedRectangle(),
        notchMargin: 7.5,
        clipBehavior: Clip.hardEdge,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children:[
            navButton(Icons.notes , "notes" , 0),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: navButton(Icons.category , "categories" , 1),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: navButton(Icons.archive , "archive" , 2),
            ),
            navButton(Icons.settings , "settings" , 3),
          ],
        ),
      );
    }

    return WillPopScope(
      onWillPop: onWillPop,
      child: SafeArea(
        child: Scaffold(
          appBar: appBarWidget.GlobalAppBar(),
          body: screens[settingsProvider.currentScreenIndex],
          bottomNavigationBar: bar(),
          floatingActionButton: floatActionButton(),
          floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
        ),
      ),
    );
  }
}
