import 'dart:io';

import 'package:awake_app/Common/ClassList.dart';
import 'package:awake_app/Common/Constants.dart';
import 'package:awake_app/Common/Services.dart';
import 'package:awake_app/Components/LoadingComponent.dart';
import 'package:awake_app/Components/VisitedStallComponents.dart';
import 'package:awake_app/Components/VisitedVisitorComponent.dart';
import 'package:awake_app/Components/offlineVisitedVisitorComponent.dart';
import 'package:awake_app/offlinedatabase/db_handler.dart';
import 'package:flutter/material.dart';
import 'package:awake_app/Common/Constants.dart' as cnst;
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StallVisited extends StatefulWidget {
  @override
  _StallVisitedState createState() => _StallVisitedState();
}

class _StallVisitedState extends State<StallVisited> {
  bool isLoading = false;
  List visitedStallData = new List();
  List visitedVisitorData = new List();
  String memberMobile;
  bool isConclave = false;
  TabController _tabController;
  int selectedTab = 0;
  List<Visitorclass> visitordata = [];
  List<Visitorclass> stalldata = [];
  List<Visitorclass> allVisitedData = [];
  bool isData;
  DBHelper dbHelper;
  ProgressDialog pr;

  @override
  void initState() {
    super.initState();
    dbHelper = new DBHelper();
    getOfflineData();
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(
        message: "Please Wait",
        borderRadius: 10.0,
        progressWidget: Container(
          padding: EdgeInsets.all(15),
          child: CircularProgressIndicator(),
        ),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.w600));
    _getLocalData();
  }

  getOfflineData() async {
    Future res = dbHelper.getVisitors();
    await res.then((data) async {
      if (data != null && data.length > 0) {
        setState(() {
          isData = true;
          allVisitedData = data;
        });
        for (int i = 0; i < data.length; i++) {
          print(data[i].type);
          if (data[i].type == 'visitor') {
            setState(() {
              visitordata.add(data[i]);
            });
          } else {
            setState(() {
              stalldata.add(data[i]);
            });
          }
        }
        print('Stall Data =>' + stalldata.toString());
        print('visitorData Data =>' + visitordata.toString());
      } else {
        setState(() {
          isData = false;
        });
        _getStallVisitorList();
      }
    }, onError: (e) {
      print("Error $e");
    });
  }

  _getLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var conclave = prefs.getString(cnst.Session.conclave);
    if (conclave == "Conclave") {
      setState(() {
        isConclave = true;
      });
    }
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
        Future res = Services.getStallVisitor(memberMobile1);
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              visitedStallData = data[0];
              visitedVisitorData = data[1];
              isLoading = false;
              //visitedVisitorData
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
      }
    } on SocketException catch (_) {}
  }

  sendVisitedDataList() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });

        SharedPreferences prefs = await SharedPreferences.getInstance();
        String MemberName = prefs.getString(Session.name);
        String MemberMobile = prefs.getString(Session.mobile);
        String MemberCompany = prefs.getString(Session.company);
        String MemberCategory = prefs.getString(Session.category);
        String MemberEmail = prefs.getString(Session.email);

        for (int i = 0; i < allVisitedData.length; i++) {
          Services.sendVisitorData(
                  "${allVisitedData[i].id}",
                  MemberName,
                  MemberMobile,
                  MemberCompany,
                  MemberCategory,
                  MemberEmail,
                  "${allVisitedData[i].type}",
                  '${allVisitedData[i].mobileNumber}')
              .then((data) async {
            if (data.ERROR_STATUS == false) {
              dbHelper.delete();
              showMsg("Data Sent Successfully");
            } else {
              showMsg("Try Again.");
            }
          }, onError: (e) {
            setState(() {
              isLoading = false;
            });
            showMsg("Try Again");
          });
        }
        setState(() {
          isLoading = false;
          isData = false;
        });
        _getStallVisitorList();
      }
    } on SocketException catch (_) {
      pr.hide();
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
    double width = MediaQuery.of(context).size.width;
    return DefaultTabController(
        length: 2,
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
              TabBar(
                controller: _tabController,
                indicatorColor: cnst.appPrimaryMaterialColor,
                unselectedLabelColor: Colors.black,
                onTap: (index) {
                  setState(() {
                    selectedTab = index;
                  });
                },
                tabs: [
                  Tab(
                    child: Text(
                      'Visited Stalls',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Visited Visitor',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              isData != null && isData
                  ? Expanded(
                      child: isLoading
                          ? LoadingComponent()
                          : Column(
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    height: MediaQuery.of(context).size.height -
                                        (MediaQuery.of(context).size.width *
                                            0.53),
                                    width: MediaQuery.of(context).size.width,
                                    child: TabBarView(children: [
                                      stalldata.length > 0
                                          ? Container(
                                              child: ListView.builder(
                                              itemCount: stalldata.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return offVisitedVisitorComponent(
                                                    stalldata[index]);
                                              },
                                            ))
                                          : Center(
                                              child: Container(
                                                  child: Text(
                                                      "No Data Available",
                                                      style: TextStyle(
                                                          fontSize: 17,
                                                          color: Colors
                                                              .black54)))),
                                      visitordata.length > 0
                                          ? Container(
                                              child: ListView.builder(
                                              itemCount: visitordata.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return offVisitedVisitorComponent(
                                                    visitordata[index]);
                                              },
                                            ))
                                          : Center(
                                              child: Container(
                                                  child: Text(
                                                      "No Data Available",
                                                      style: TextStyle(
                                                          fontSize: 17,
                                                          color: Colors
                                                              .black54)))),
                                    ]),
                                  ),
                                ),
                                MaterialButton(
                                    height: 45,
                                    minWidth: MediaQuery.of(context).size.width,
                                    color: cnst.appprimarycolors[600],
                                    onPressed: () {
                                      sendVisitedDataList();
                                    },
                                    child: Text(
                                      "Sync Data",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white),
                                    )),
                              ],
                            ),
                    )
                  : Container(
                      height:
                          MediaQuery.of(context).size.height - (width * 0.53),
                      width: MediaQuery.of(context).size.width,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          isLoading
                              ? LoadingComponent()
                              : visitedStallData.length != 0
                                  ? Container(
                                      child: ListView.builder(
                                      itemCount: visitedStallData.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return VisitedStallComponents(
                                            visitedStallData[index]);
                                      },
                                    ))
                                  : Center(
                                      child: Container(
                                          child: Text("No Data Available",
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  color: Colors.black54)))),
                          isLoading
                              ? LoadingComponent()
                              : visitedVisitorData.length != 0
                                  ? Container(
                                      child: ListView.builder(
                                      itemCount: visitedVisitorData.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return VisitedVisitorComponent(
                                            visitedVisitorData[index]);
                                      },
                                    ))
                                  : Center(
                                      child: Container(
                                          child: Text("No Data Available",
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  color: Colors.black54)))),
                        ],
                      ),
                    ),
            ],
          ),
        ));
  }
}
