import 'dart:io';

import 'package:awake_app/Common/Constants.dart' as cnst;
import 'package:awake_app/Common/Services.dart';
import 'package:awake_app/Components/ChapterComponent.dart';
import 'package:awake_app/Components/LoadingComponent.dart';
import 'package:awake_app/Components/searchMemberComponent.dart';
import 'package:flutter/material.dart';

//import 'package:speech_recognition/speech_recognition.dart';
//denish swit speech
class ConclaveDirectory extends StatefulWidget {
  @override
  _ConclaveDirectoryState createState() => _ConclaveDirectoryState();
}

class _ConclaveDirectoryState extends State<ConclaveDirectory> {
  TextEditingController searchController = new TextEditingController();

  //SpeechRecognition _speechRecognition;
  //final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  //PermissionStatus _permissionStatus = PermissionStatus.unknown;

  List chapterData = [];

  bool isLoading = true;
  List searchData = [];

  TabController _tabController;
  int selectedTab = 0;

  @override
  void initState() {
    _getChapterData();
    //initSpeechRecognizer();
  }

  _getChapterData() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Future res = Services.GetChapterData();
        setState(() {
          isLoading = true;
        });
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              chapterData = data;
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

  _searchMember() async {
    if (searchController.text != '') {
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          Future res = Services.SearchMember(searchController.text);
          res.then((data) async {
            if (data != null && data.length > 0) {
              setState(() {
                searchData = data;
              });
            } else {
              setState(() {
                searchData.clear();
              });
              showMsg("Data Not Found");
            }
          }, onError: (e) {
            print("Error : on Chapter Data Call $e");
            showMsg("$e");
          });
        } else {
          showMsg("No Internet Connection.");
        }
      } on SocketException catch (_) {
        showMsg("No Internet Connection.");
      }
    } else
      showMsg("Please Input Any Value");
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
        title: Text("Member Directory"),
        elevation: 0,
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios)),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: !isLoading
            ? chapterData.length > 0 && chapterData != null
                ? searchData.length > 0 && searchData != null
                    ? WillPopScope(
                        onWillPop: () {
                          setState(() {
                            searchData.clear();
                          });
                        },
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
                                  height: 60,
                                  width:
                                      MediaQuery.of(context).size.width - 110,
                                  padding: EdgeInsets.all(10),
                                  child: TextFormField(
                                    controller: searchController,
                                    decoration: InputDecoration(
                                        prefixIcon:
                                            Icon(Icons.search, size: 22),
                                        border: new OutlineInputBorder(
                                            borderSide: new BorderSide(
                                                color: Colors.black),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(12))),
                                        hintText: "Search Member Name",
                                        hintStyle: TextStyle(fontSize: 13)),
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        _searchMember();
                                      },
                                      child: Container(
                                        height: 45,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: cnst.appPrimaryMaterialColor,
                                        ),
                                        child: Center(
                                            child: Text("Search",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white))),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: searchData.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return searchMemberComponent(
                                      searchData[index]);
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
                                  height: 40,
                                  width:
                                      MediaQuery.of(context).size.width - 110,
                                  child: TextFormField(
                                    controller: searchController,
                                    decoration: InputDecoration(
                                        prefixIcon:
                                            Icon(Icons.search, size: 22),
                                        border: new OutlineInputBorder(
                                            borderSide: new BorderSide(
                                                color: Colors.black),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(12))),
                                        hintText: "Search Member Name",
                                        hintStyle: TextStyle(fontSize: 13)),
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        _searchMember();
                                      },
                                      child: Container(
                                        height: 45,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: cnst.appPrimaryMaterialColor,
                                        ),
                                        child: Center(
                                            child: Text("Search",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white))),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: chapterData.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return ChapterComponent(chapterData[index]);
                                },
                              ),
                            )
                          ],
                        ),
                      )
                : Center(
                    child: Container(
                        child: Text("No Data Available",
                            style: TextStyle(
                                fontSize: 17, color: Colors.black54))))
            : LoadingComponent(),
      ),
    );
  }
}
