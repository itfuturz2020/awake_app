import 'dart:async';
import 'dart:io';
import 'package:awake_app/Common/ClassList.dart';
import 'package:awake_app/offlinedatabase/db_handler.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:awake_app/Common/Constants.dart' as cnst;

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  DBHelper dbHelper;
  Future<List<Visitorclass>> visitor;

  @override
  void initState() {
    Timer(Duration(seconds: 3), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String MemberId = prefs.getString(cnst.Session.MemberId);
      String isVerified = prefs.getString(cnst.Session.isVerified);
      dbHelper = new DBHelper();
      Future res1 = dbHelper.getVisitors();
      res1.then((data) async {
        if (data != null && data.length > 0) {
          prefs.setString(cnst.Session.isData, 'true');
        } else {
          prefs.setString(cnst.Session.isData, 'false');
        }
      }, onError: (e) {
        print("Error $e");
      });

      if (MemberId != null && MemberId != "") {
        if (isVerified == "true") {
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/ConclaveDashboard', (Route<dynamic> route) => false);
        } else {
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/ConclaveOTP', (Route<dynamic> route) => false);
        }
      } else {
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/ConclaveLogin', (Route<dynamic> route) => false);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Image.asset(
              "images/awec.png",
              fit: BoxFit.cover,
            ),
          ),
        ));
  }
}
