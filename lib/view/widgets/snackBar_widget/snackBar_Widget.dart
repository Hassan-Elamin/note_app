

// ignore_for_file: file_names

import 'package:flutter/material.dart';

class SnackBarWidget {

  final BuildContext context;

  SnackBarWidget({required this.context});

  SnackBar _snackBarWidget (String content){
    return SnackBar(
      content: Text(content),
    );
  }

  void showSnackBar(String content){
    ScaffoldMessenger.of(context).showSnackBar(
        _snackBarWidget(content),
    );
  }

}
