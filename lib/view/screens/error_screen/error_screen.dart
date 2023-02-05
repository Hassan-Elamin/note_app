 

import 'package:flutter/material.dart';
import 'package:memo/view/widgets/data_state_widgets/error_widget.dart';

class ErrorScreen extends StatelessWidget {

  static const String screenRoute = "/ErrorScreen";

  const ErrorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: errorWidget(),
      ),
    );
  }
}