import 'dart:io';

import 'package:awake_app/Common/Constants.dart';
import 'package:awake_app/Common/Constants.dart' as cnst;
import 'package:awake_app/Common/Services.dart';
import 'package:awake_app/Components/LoadingComponent.dart';
import 'package:awake_app/Screens/CategoryMemberList.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

//import 'package:speech_recognition/speech_recognition.dart';
//denish swit speech
class ConclaveCategory extends StatefulWidget {
  @override
  _ConclaveCategoryState createState() => _ConclaveCategoryState();
}

class _ConclaveCategoryState extends State<ConclaveCategory> {
  List categoryData = [];
  List subCategoryData = [];
  bool isLoading = true;
  bool isProfileUpdate = false;
  String categoryId = "";

  //SpeechRecognition _speechRecognition;
  TextEditingController searchController = new TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  PermissionStatus _permissionStatus = PermissionStatus.unknown;

  @override
  void initState() {
    _getCategoryData();
    //initSpeechRecognizer();
  }

  _checkProfileStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var profileUpdate = prefs.getString(Session.isProfileUpdate);

    if (profileUpdate == "Profile Updated") {
      isProfileUpdate = true;
    }
    if (isProfileUpdate == false) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text("Information !!!"),
            content: new Text(
                "For better experience of Application and to express yourself and your Company.\nPlease Update your Profile !!!"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text(
                  "Update Profile",
                  style: TextStyle(color: cnst.appPrimaryMaterialColor),
                ),
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.setString(
                      Session.isProfileUpdate, "Profile Updated");
                  isProfileUpdate = true;
                  Navigator.of(context).pop();
                  Navigator.pushReplacementNamed(context, '/ConclaveProfile');
                },
              ),
              /*new FlatButton(
                child: new Text(
                  "Skip",
                  style: TextStyle(color: cnst.appPrimaryMaterialColor),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),*/
            ],
          );
        },
      );
    }
  }

  _getCategoryData() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Future res = Services.GetCategoryData();
        setState(() {
          isLoading = true;
        });
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              categoryData = data;
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
          print("Error : on Category Data Call $e");
          showMsg("$e");
        });
      } else {
        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
    //_checkProfileStatus();
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
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("Category"),
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
      body: Column(
        key: _scaffoldKey,
        children: <Widget>[
          !isLoading
              ? categoryData.length > 0 && categoryData != null
                  ? Expanded(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(5),
                        child: StaggeredGridView.countBuilder(
                          crossAxisCount: 2,
                          itemCount: categoryData.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                print(
                                    "Selected Category Id: ${categoryData[index]["Id"]}");
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CategoryMemberList(
                                                categoryId: categoryData[index]
                                                    ["Id"],
                                                childCount: categoryData[index]
                                                    ["ChildCount"])));
                              },
                              child: Container(
                                  margin: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      border: new Border.all(
                                          color: Colors.black54, width: 0.7),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Center(
                                      child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      categoryData[index]["Image"] != "" &&
                                              categoryData[index]["Image"] !=
                                                  null
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: FadeInImage.assetNetwork(
                                                placeholder:
                                                    'assets/loading.gif',
                                                image: IMG_URL +
                                                    categoryData[index]
                                                        ["Image"],
                                                height: 60,
                                                width: 60,
                                                fit: BoxFit.fill,
                                              ),
                                            )
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Image.asset(
                                                'images/no_image.png',
                                                height: 60,
                                                width: 60,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10),
                                        child: Text(
                                          "${categoryData[index]["CategoryName"]}",
                                          style: TextStyle(
                                              fontSize: 13,
                                              color:
                                                  cnst.appPrimaryMaterialColor,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ],
                                  ))),
                            );
                          },
                          staggeredTileBuilder: (_) => StaggeredTile.fit(1),
                          mainAxisSpacing: 2,
                          crossAxisSpacing: 2,
                        ),
                      ),
                    )
                  : Center(
                      child: Container(
                          child: Text("No Data Available",
                              style: TextStyle(
                                  fontSize: 17, color: Colors.black54))))
              : LoadingComponent()
        ],
      ),
    );
  }
}
