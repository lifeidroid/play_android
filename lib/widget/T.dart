import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class T{
  static void showToast(String _msg){
    Fluttertoast.showToast(
        msg: _msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

}