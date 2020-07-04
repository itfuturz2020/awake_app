import 'dart:io';

import 'package:awake_app/Common/Constants.dart' as cnst;
import 'package:awake_app/Common/Services.dart';
import 'package:awake_app/Components/ConclaveStallComponent.dart';
import 'package:awake_app/Components/LoadingComponent.dart';
import 'package:awake_app/Screens/MyStallVisitorList.dart';

import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConclaveExhibitors extends StatefulWidget {
  @override
  _ConclaveExhibitorsState createState() => _ConclaveExhibitorsState();
}

class _ConclaveExhibitorsState extends State<ConclaveExhibitors> {
  bool isLoading = true;
  List stallData = new List();
  String hasStall;
  TabController _tabController;
  int selectedTab = 0;

  @override
  void initState() {
    _getStallVisitorList();
    _getStallDataCheckByMobile();
  }

  _getStallVisitorList() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String memberMobile1 = prefs.getString(cnst.Session.mobile);
      //check Internet Connection
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        Future res = Services.getStallList();
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              isLoading = false;
              stallData = data;
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
              hasStall=data.Data.toString();
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
    double height = MediaQuery.of(context).size.height;
    double widt = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("Exhibitors"),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            Expanded(
              child: isLoading
                  ? LoadingComponent()
                  : stallData.length != 0
                      ? Container(
                          width: MediaQuery.of(context).size.width,
                          //height:MediaQuery.of(context).size.height,
                          //: MediaQuery.of(context).size.height - (width*0.4),
                          /*height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.only(bottom:hasStall == "true" ?0:width * 0.15),*/
                          child: ListView.builder(
                            itemCount: stallData.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ConclaveStallComponent(stallData[index]);
                            },
                          ))
                      : Center(
                  child: Container(
                      child: Text("No Data Available",
                          style: TextStyle(
                              fontSize: 17, color: Colors.black54)))),
            ),
            /*Container(

              color: Colors.grey[100],
              //padding: EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width / 2.1,
                    child: RaisedButton(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        elevation: 5,
                        textColor: Colors.white,
                        color: cnst.appPrimaryMaterialColor,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text("Edit Profile",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15)),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/ConclaveProfile');
                        },
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0))),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 2.1,
                    child: RaisedButton(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        elevation: 5,
                        textColor: Colors.white,
                        color: cnst.appPrimaryMaterialColor,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text("Visitor List",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15)),
                        ),
                        onPressed: () async {
                          //hasStall == "true"
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyVisitorsList(
                                      type: hasStall == "true"
                                          ? "stall"
                                          : "visitor")));
                          //Navigator.pushNamed(context, "/MyVisitorsList");
                        },
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0))),
                  )
                ],
              ),
            )*/
          ],
        ),
      ),
    );
  }
}
