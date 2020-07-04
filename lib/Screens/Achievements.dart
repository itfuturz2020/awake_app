import 'dart:io';

import 'package:awake_app/Common/Constants.dart' as cnst;
import 'package:awake_app/Common/Services.dart';
import 'package:awake_app/Components/CrorepatiAchievementComponent.dart';
import 'package:awake_app/Components/GoldAchievementComponent.dart';
import 'package:awake_app/Components/RegionalTeamComponent.dart';
import 'package:flutter/material.dart';

class Achievements extends StatefulWidget {
  @override
  _AchievementsState createState() => _AchievementsState();
}

class _AchievementsState extends State<Achievements> {
  TabController _tabController;
  int selectedTab = 0;
  bool isLoading = true;
  List regionalData = [], achievementData = [];

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
            });
            _getGoldCrorepatiMemebers();
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
        showMsg("Something went wrong");
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  _getGoldCrorepatiMemebers() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Future res = Services.GetGoldCrorepatiMemebers();
        setState(() {
          isLoading = true;
        });
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              achievementData = data;
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
        showMsg("Something went wrong");
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
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Achievements"),
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: Container(
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
                          'REGIONAL TEAM',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'GOLD CLUB',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'CROREPATI',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        isLoading
                            ? Center(child: CircularProgressIndicator())
                            : regionalData.length > 0
                                ? Container(
                                    child: ListView.builder(
                                    itemCount: regionalData.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return RegionalTeamComponent(
                                          regionalData[index]);
                                    },
                                  ))
                                : Center(
                                    child: Container(
                                        child: Text("No Data Available",
                                            style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.black54)))),
                        isLoading
                            ? Center(child: CircularProgressIndicator())
                            : achievementData[0]["GoldAchievementDataList"]
                                        .length >
                                    0
                                ? Container(
                                    child: ListView.builder(
                                    itemCount: achievementData[0]
                                            ["GoldAchievementDataList"]
                                        .length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return GoldAchievementComponent(
                                          achievementData[0]
                                                  ["GoldAchievementDataList"]
                                              [index]);
                                    },
                                  ))
                                : Center(
                                    child: Container(
                                        child: Text("No Data Available",
                                            style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.black54)))),
                        isLoading
                            ? Center(child: CircularProgressIndicator())
                            : achievementData[0]["CrorepatiAchievementDataList"]
                                        .length >
                                    0
                                ? Container(
                                    child: ListView.builder(
                                    itemCount: achievementData[0]
                                            ["CrorepatiAchievementDataList"]
                                        .length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return CrorepatiAchievementComponent(
                                          achievementData[0][
                                                  "CrorepatiAchievementDataList"]
                                              [index]);
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
                  )
                ],
              )),
        ));
  }
}
