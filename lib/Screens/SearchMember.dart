import 'dart:io';

import 'package:awake_app/Common/Services.dart';
import 'package:awake_app/Components/CategoryMemberListComponent.dart';
import 'package:flutter/material.dart';
import 'package:awake_app/Common/Constants.dart' as cnst;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_dialog/progress_dialog.dart';

class SearchMember extends StatefulWidget {
  @override
  _SearchMemberState createState() => _SearchMemberState();
}

class _SearchMemberState extends State<SearchMember> {
  //SpeechRecognition _speechRecognition;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  PermissionStatus _permissionStatus = PermissionStatus.unknown;
  TextEditingController searchController = new TextEditingController();
  bool isSearch = false;
  List searchData = new List();
  AlertDialog al;
  ProgressDialog pr;
  FocusNode myFocusNode;
  @override
  void initState() {
    myFocusNode = FocusNode();
    myFocusNode.requestFocus();
    //_getCategoryData();
    //initSpeechRecognizer();
  }

  /* Future<void> requestPermission(PermissionGroup permission) async {
    final List<PermissionGroup> permissions = <PermissionGroup>[permission];
    final Map<PermissionGroup, PermissionStatus> permissionRequestResult =
        await PermissionHandler().requestPermissions(permissions);

    setState(() {
      print(permissionRequestResult);
      _permissionStatus = permissionRequestResult[permission];
      print(_permissionStatus);
    });
    if (permissionRequestResult[permission] == PermissionStatus.granted) {
      setState(() {
        searchController.text = "";
      });
      //_voiceInput();
    } else
      Fluttertoast.showToast(
          msg: "Permission Not Granted",
          gravity: ToastGravity.TOP,
          toastLength: Toast.LENGTH_SHORT);
  }*/

  showMsg(String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("BNI Evolve"),
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

  _searchData() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Future res = Services.ConclaveSearchMember(searchController.text);
        setState(() {
          isSearch = true;
        });
        pr.show();
        res.then((data) async {
          pr.hide();
          if (data.length > 0) {
            setState(() {
              searchData = data;
              //isSearch = true;
            });
          } else {
            setState(() {
              searchData.clear();
            });
            showMsg("Data Not Found");
          }
        }, onError: (e) {
          pr.hide();
          /*setState(() {
            isSearch = false;
          });*/
          print("Error : on Member Data Call $e");
          showMsg("$e");
        });
      } else {
        /*setState(() {
          isSearch = false;
        });*/
        pr.hide();
        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      setState(() {
        isSearch = false;
      });
      showMsg("No Internet Connection.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(top: 10),
          child: Column(
            children: <Widget>[
              Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        height: 61,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(10),
                        child: TextFormField(
                          focusNode: myFocusNode,
                          controller: searchController,
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.search,
                                size: 22,
                                color: Colors.black,
                              ),
                              /*suffixIcon: GestureDetector(
                                onTap: () {
                                  requestPermission(PermissionGroup.microphone);
                                },
                                child: Icon(
                                  Icons.keyboard_voice,
                                  color: Colors.black,
                                ),
                              ),*/
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              hintText: "Search",
                              hintStyle:
                                  TextStyle(fontSize: 13, color: Colors.black)),
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      height: 38,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(4.0)),
                        color: cnst.appPrimaryMaterialColor[600],
                        onPressed: () {
                          if (searchController.text != "") {
                            pr = new ProgressDialog(context,
                                type: ProgressDialogType.Normal,
                                isDismissible: false);
                            pr.style(
                                message: "Please Wait",
                                borderRadius: 10.0,
                                progressWidget: Container(
                                  padding: EdgeInsets.all(15),
                                  child: CircularProgressIndicator(
                                    valueColor:
                                        new AlwaysStoppedAnimation<Color>(
                                            cnst.appPrimaryMaterialColor),
                                  ),
                                ),
                                elevation: 10.0,
                                insetAnimCurve: Curves.easeInOut,
                                messageTextStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w600));
                            _searchData();
                          } else {
                            Fluttertoast.showToast(
                                msg: "Enter search text.",
                                backgroundColor: Colors.red,
                                gravity: ToastGravity.TOP,
                                toastLength: Toast.LENGTH_SHORT,
                                textColor: Colors.white);
                          }
                        },
                        child: Text(
                          "Search",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 17.0,
                              fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              isSearch == true
                  ? Expanded(
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: searchData.length > 0
                              ? ListView.builder(
                                  itemCount: searchData.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return CategoryMemberListComponent(
                                        categoryMemberData: searchData[index]);
                                  },
                                )
                              : Center(
                                  child: Container(
                                      child: Text("No Data Available",
                                          style: TextStyle(
                                              fontSize: 17,
                                              color: Colors.black54)))),
                        ),
                      ),
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}
