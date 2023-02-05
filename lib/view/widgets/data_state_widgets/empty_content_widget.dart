

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:memo/constant/app_enums.dart';
import 'package:memo/res/assets_res.dart';

class EmptyContentWidget extends StatelessWidget {

  final ScreenType screenState ;

  const EmptyContentWidget({ required this.screenState , Key? key}) : super(key: key);

  String contentText (){
    if(screenState == ScreenType.Notes){
      return "empty".tr();
    }else if(screenState == ScreenType.Archive){
      return "nothing in archive".tr();
    }else{
      return "nothing here".tr();
    }
  }

  String ? hintText (){
    if(screenState == ScreenType.Notes){
      return "you can write \n a new note from here".tr();
    }else{
      return null ;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Center(
      child: Container(
        padding: EdgeInsets.only(top: size.height * 0.2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround ,
          children: [
            Column(
              children: [
                Image.asset(
                  AssetsRes.EMPTY_BOX ,
                  width: 150 ,
                ),
                Text(
                  contentText() ,
                  style: const TextStyle(fontSize: 40.0),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(hintText() ?? '' ,
                     textAlign: TextAlign.center ,
                     style: const TextStyle(fontSize: 24.0),
                     ),
                    screenState == ScreenType.Notes ?
                    const Icon(
                      Icons.keyboard_double_arrow_down_outlined ,

                      size: 50.0,
                    ) : const SizedBox() ,
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
