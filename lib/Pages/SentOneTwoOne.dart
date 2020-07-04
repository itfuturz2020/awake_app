import 'dart:io';

import 'package:awake_app/Common/Constants.dart' as cnst;
import 'package:awake_app/Common/Services.dart';
import 'package:awake_app/Components/LoadingComponent.dart';
import 'package:awake_app/Components/SentOneTwoOneComponent.dart';
import 'package:flutter/material.dart';

class SentOneTwoOne extends StatefulWidget {
  @override
  _SentOneTwoOneState createState() => _SentOneTwoOneState();
}

class _SentOneTwoOneState extends State<SentOneTwoOne> {
  bool isLoading = true;
  List sendOneTwoOne = [];

  @override
  void initState() {
    super.initState();
    _getSendOneTowOne();
  }

  _getSendOneTowOne() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Future res = Services.GetSendOneTowOneData();
        setState(() {
          isLoading = true;
        });
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              sendOneTwoOne = data;
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
    return Column(
      children: <Widget>[
        Expanded(
          child: isLoading
              ? LoadingComponent()
              : sendOneTwoOne.length > 0
                  ? Container(
                      child: ListView.builder(
                      itemCount: sendOneTwoOne.length,
                      itemBuilder: (BuildContext context, int index) {
                        return SentOneTwoOneComponent(
                            sendOneTwoOneData: sendOneTwoOne[index]);
                      },
                    ))
                  : Center(
                      child: Container(
                          child: Text("No Data Available",
                              style: TextStyle(
                                  fontSize: 17, color: Colors.black54)))),
        ),
      ],
    );
  }
}
