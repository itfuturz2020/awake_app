import 'dart:io';

import 'package:awake_app/Common/Constants.dart' as cnst;
import 'package:awake_app/Common/Services.dart';
import 'package:awake_app/Components/ConclaveSpeakersComponent.dart';
import 'package:awake_app/Components/LoadingComponent.dart';
import 'package:flutter/material.dart';
import 'package:awake_app/Common/Constants.dart' as cnst;
import 'package:shared_preferences/shared_preferences.dart';

class ConclaveSpeakerList extends StatefulWidget {
  @override
  _ConclaveSpeakerListState createState() => _ConclaveSpeakerListState();
}

class _ConclaveSpeakerListState extends State<ConclaveSpeakerList> {
  bool isLoading = true;
  List speakerData = [];

  @override
  void initState() {
    _getSpeakerList();
  }

  _getSpeakerList() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String memberMobile1 = prefs.getString(cnst.Session.mobile);
      //check Internet Connection
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        Future res = Services.getSpeakerList();
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              isLoading = false;
              speakerData = data;
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Speakers"),
        elevation: 0,
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios)),
      ),
      body: isLoading
          ? LoadingComponent()
          : speakerData.length > 0
              ? Container(
                  child: ListView.builder(
                  itemCount: speakerData.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ConclaveSpeakersComponent(speakerData[index]);
                  },
                ))
              : Center(
                  child: Container(
                      child: Text("No Data Available",
                          style:
                              TextStyle(fontSize: 17, color: Colors.black54)))),
    );
  }
}
