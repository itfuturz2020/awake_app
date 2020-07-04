import 'dart:io';

import 'package:awake_app/Common/Constants.dart' as cnst;
import 'package:awake_app/Common/Services.dart';
import 'package:awake_app/Components/ConclaveStallComponent.dart';
import 'package:awake_app/Components/LoadingComponent.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConclaveStalls extends StatefulWidget {
  @override
  _ConclaveStallsState createState() => _ConclaveStallsState();
}

class _ConclaveStallsState extends State<ConclaveStalls> {
  bool isLoading = true;
  List stallData = new List();
  String hasStall;
  int selectedTab = 0;

  @override
  void initState() {
    super.initState();
    _getStallVisitorList();
    _getStallDataCheckByMobile();
  }

  _getStallVisitorList() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        Future res = Services.getStallList();
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              stallData = data;
              isLoading = false;
            });
          } else {
            setState(() {
              isLoading = false;
            });
          }
        }, onError: (e) {
          print("Error : on Login Call $e");
          showMsg("$e");
          setState(() {
            isLoading = false;
          });
        });
      } else {
        setState(() {
          isLoading = false;
        });
        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  _getStallDataCheckByMobile() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String memberMobile = prefs.getString(cnst.Session.mobile);
      //check Internet Connection
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        Future res = Services.GetStallDataCheckByMobile(memberMobile);
        res.then((data) async {
          if (data.ERROR_STATUS == false) {
            setState(() {
              isLoading = false;
              /*if(data.Data==true){
                hasStall = "stall";
              }else{
                hasStall = "visitor";
              }*/
              hasStall = data.Data.toString();
              print("Has Stall : ${data}");
              //setData(list);
            });
          } else {
            setState(() {
              isLoading = false;
            });
            //showMsg("Try Again.");
          }
        }, onError: (e) {
          print("Error : on Login Call $e");
          showMsg("$e");
          setState(() {
            isLoading = false;
          });
        });
      } else {
        setState(() {
          isLoading = false;
        });
        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  showMsg(String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Error"),
          content: new Text(msg),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Close",
                style: TextStyle(color: cnst.appPrimaryMaterialColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? LoadingComponent()
        : stallData.length > 0
            ? Container(
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  itemCount: stallData.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ConclaveStallComponent(stallData[index]);
                  },
                ),
              )
            : Center(
                child: Container(
                    child: Text("No Data Available",
                        style:
                            TextStyle(fontSize: 17, color: Colors.black54))));
  }
}
