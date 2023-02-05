

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:memo/res/assets_res.dart';

class IntroFirstScreen {

  final Size size ;

  IntroFirstScreen({ required this.size });

  PageViewModel introFirstScreen() {
    return PageViewModel(
      title: "Hello".tr(),
      bodyWidget: SizedBox(
        height: size.height * 0.750,
        width: size.width,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:<Widget>[
              Text(
                "Welcome to my simple application".tr(),
                style: const TextStyle(fontSize: 20),
              ),
              SizedBox(
                  height: 200.0,
                  child: Image.asset(
                    AssetsRes.HELLO,
                    width: 150.0 ,
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }

}