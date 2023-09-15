import 'dart:async';

import 'package:chatapp/ui/auth/login_screen.dart';
import 'package:chatapp/ui/dashboard_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MyServices {
  void isLogin(BuildContext context) {
    final _auth = FirebaseAuth.instance;
    if (_auth.currentUser == null) {
      Timer(
        Duration(seconds: 3),
        () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LoginScreen(),
            ),
          );
        },
      );
    } else {
      Timer(
        Duration(seconds: 5),
        () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => DashboardScreen(),
            ),
          );
        },
      );
    }
  }

  void toastmsg(String msg, bool status) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: status ? Colors.green : Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
