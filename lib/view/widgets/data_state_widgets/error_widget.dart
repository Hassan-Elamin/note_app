
import 'package:flutter/material.dart';

Widget errorWidget (){
  return Center(
    child: SizedBox(
      height: 150.0,
      width: 200.0,
      child: Column(
        children:const [
          Icon(Icons.error_outline , size: 75.0, color: Colors.grey,),
          Text("there is an error here" , style: TextStyle(fontSize: 20.0),)
        ]
      ),
    ),
  );
}