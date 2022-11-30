import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../theme/app_theme.dart';
import 'globals.dart';
class ShowSnackBar {
  static show(String text) {
    if(text.isEmpty){
      return;
    }

    final SnackBar snackBar = SnackBar(
      content: Text(text),
      backgroundColor: AppTheme.appTheme.primaryColor,
      duration: const Duration(milliseconds: 3500),
    );
    snackbarKey.currentState
      ?..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}

class ShowToast{
 static show(String text){
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
}

class SnackBarMessages{

}