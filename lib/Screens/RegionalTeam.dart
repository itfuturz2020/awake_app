import 'dart:io';

import 'package:awake_app/Common/Services.dart';
import 'package:awake_app/Components/RegionalTeamComponent.dart';
import 'package:flutter/material.dart';
import 'package:awake_app/Common/Constants.dart' as cnst;
import 'package:shimmer/shimmer.dart';

class RegionalTeam extends StatefulWidget {
  @override
  _RegionalTeamState createState() => _RegionalTeamState();
}

class _RegionalTeamState extends State<RegionalTeam> {
  bool isLoading = true;
  List regionalData = [];

  @override
  void initState() {
    _getRegionalTeam();
  }

  _getRegionalTeam() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Future res = Services.GetReginalTeam();
        setState(() {
          isLoading = true;
        });
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              regionalData = data;
              isLoading = false;
            });
          } else {
            setState(() {
              isLoading = false;
            });
            showMsg("Data Not Found");
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
          });
          print("Error : on Chapter Data Call $e");
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
    return Scaffold(
        appBar: AppBar(
          title: Text("Regional Team"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body:
            /*Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Shimmer.fromColors(
                baseColor: Colors.grey[300],
                highlightColor: Colors.grey[100],
                child: Row(
                  children: <Widget>[
                    ClipOval(
                      child: Container(
                        height: 70,
                        width: 70,
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5),
                    ),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30))),
                            height: 15,
                            width: double.infinity,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30))),
                            height: 15,
                            width: double.infinity,
                          ),
                          */ /*Container(
                            height: 20,
                            color: Colors.white,
                            width: double.infinity,
                          ),*/ /*
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )*/
            isLoading
                ? Center(child: CircularProgressIndicator())
                : regionalData.length > 0
                    ? Container(
                        child: ListView.builder(
                        itemCount: regionalData.length,
                        itemBuilder: (BuildContext context, int index) {
                          return RegionalTeamComponent(regionalData[index]);
                        },
                      ))
                    : Center(
                        child: Container(
                            child: Text("No Data Available",
                                style: TextStyle(
                                    fontSize: 17, color: Colors.black54)))));
  }
}
/* Shimmer.fromColors(
              baseColor: Colors.grey[300],
              highlightColor: Colors.grey[100],
              child: Row(
                children: <Widget>[
                  ClipOval(
                    child: Container(height: 70, width: 70),
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 20,
                          color: Colors.white,
                          width: double.infinity,
                          child: Text("s"),
                        ),
                        Container(
                          height: 20,
                          color: Colors.white,
                          width: double.infinity,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )*/
