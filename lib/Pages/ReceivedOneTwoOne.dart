import 'dart:io';

import 'package:awake_app/Common/Constants.dart' as cnst;
import 'package:awake_app/Common/Services.dart';
import 'package:awake_app/Components/LoadingComponent.dart';
import 'package:awake_app/Components/ReceivedOneTwoOneComponent.dart';
import 'package:flutter/material.dart';

class ReceivedOneTwoOne extends StatefulWidget {
  @override
  _ReceivedOneTwoOneState createState() => _ReceivedOneTwoOneState();
}

class _ReceivedOneTwoOneState extends State<ReceivedOneTwoOne> {
  bool isLoading = true;
  List receivedOneTwoOne = [];

  @override
  void initState() {
    super.initState();
    _getReceivedOneTowOne();
  }

  _getReceivedOneTowOne() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Future res = Services.GetReceivedOneTowOneData();
        setState(() {
          isLoading = true;
        });
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              receivedOneTwoOne = data;
              isLoading = false;
            });
          } else {
            setState(() {
              isLoading = false;
            });
            //showMsg("Data Not Found");
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
          });
          print("Error : on Category Data Call $e");
          showMsg("$e");
        });
      } else {
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
        : receivedOneTwoOne.length > 0
            ? Container(
                child: ListView.builder(
                itemCount: receivedOneTwoOne.length,
                itemBuilder: (BuildContext context, int index) {
                  return ReceivedOneTwoOneComponent(
                      receivedOneTwoOneData: receivedOneTwoOne[index]);
                },
              ))
            : Center(
                child: Container(
                    child: Text("No Data Available",
                        style:
                            TextStyle(fontSize: 17, color: Colors.black54))));
  }
}
