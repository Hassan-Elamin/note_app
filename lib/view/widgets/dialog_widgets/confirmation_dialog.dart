
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ConfirmationDialogWidget extends StatelessWidget {

  final void Function() onPressedYes ;
  final void Function() onPressedNo ;
  final String content ;

  const ConfirmationDialogWidget({
    required this.onPressedYes , required this.onPressedNo ,
    required this.content ,  Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {


    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      title: Text(content.tr()),
      actions: [
        TextButton(
            onPressed:(){
              onPressedYes();
              Navigator.pop(context);
            },
            child: Text("yes".tr())
        ),
        TextButton(
            onPressed: (){
              onPressedNo();
              Navigator.pop(context);
            },
            child: Text("no".tr())
        ),
      ],
    );
  }
}


