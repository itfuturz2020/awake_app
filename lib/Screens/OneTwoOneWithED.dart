import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:awake_app/Common/Constants.dart' as cnst;
import 'package:awake_app/Common/Services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class OneTwoOneWithED extends StatefulWidget {
  @override
  _OneTwoOneWithEDState createState() => _OneTwoOneWithEDState();
}

class _OneTwoOneWithEDState extends State<OneTwoOneWithED> {
  TextEditingController edtSubject = new TextEditingController();
  bool isLoading = true;
  List EdDetails = [];
  final format = DateFormat("yyyy-MM-dd");
  String OneTwoOneDate = "", OneTwoOneTime = "";
  @override
  void initState() {
    _getEdDetail();
  }

  _getEdDetail() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Future res = Services.GetEdDetails();
        setState(() {
          isLoading = true;
        });
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              EdDetails = data;
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

  _saveOneTwoOneWithEd() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Future res = Services.SaveOneTwoOneWithEd(
            edtSubject.text, OneTwoOneDate, OneTwoOneTime);
        setState(() {
          isLoading = true;
        });
        res.then((data) async {
          if (data != "1") {
            setState(() {
              //Save
              //EdDetails = data;
              isLoading = false;
            });
            Fluttertoast.showToast(
                msg: "1-2-1 Request with Ed Added Successfully!!!",
                gravity: ToastGravity.BOTTOM,
                toastLength: Toast.LENGTH_LONG);
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/ConclaveDashboard', (Route<dynamic> route) => false);
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

  printDate(String DateTime) {
    print("d: ${DateTime}");
    return DateTime;
  }

  @override
  Widget build(BuildContext context) {
    double screen = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
          title: Text("1-2-1 with ED"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          )),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: SafeArea(
                child: Stack(
                  children: <Widget>[
                    ClipPath(
                      child: Container(
                        padding: EdgeInsets.only(bottom: 5),
                        //height:MediaQuery.of(context).size.height/4.5,
                        color: cnst.appPrimaryMaterialColor,
                        height: screen > 550.0 ? screen / 3.7 : screen / 3.4,
                        width: MediaQuery.of(context).size.width,
                        //child: Image.asset(''),
                      ),
                      clipper: displayDateClipper(),
                    ),
                    Container(
                        margin: EdgeInsets.only(
                          top: screen > 550.0
                              ? MediaQuery.of(context).size.height / 6.7
                              : MediaQuery.of(context).size.height / 7,
                        ),
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: <Widget>[
                            EdDetails[0]["UserImage"] == "" ||
                                    EdDetails[0]["UserImage"] == null
                                ? Container(
                                    margin: EdgeInsets.only(top: 10),
                                    height: 180,
                                    width: 180,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(100),
                                        ),
                                        boxShadow: [
                                          new BoxShadow(
                                            color: Colors.grey,
                                            blurRadius: 5.0,
                                          ),
                                        ]),
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: AvatarGlow(
                                        //startDelay: Duration(milliseconds: 1500),
                                        glowColor: cnst.appPrimaryMaterialColor,
                                        endRadius: 200.0,
                                        duration: Duration(milliseconds: 2000),
                                        repeat: true,
                                        showTwoGlows: true,
                                        repeatPauseDuration:
                                            Duration(milliseconds: 100),
                                        child: Material(
                                          elevation: 8.0,
                                          shape: CircleBorder(),
                                          child: CircleAvatar(
                                            backgroundColor: Colors.grey[100],
                                            child: ClipOval(
                                                child: Image.asset(
                                              "images/icon_profile_new.png",
                                              height: 180,
                                              width: 180,
                                              fit: BoxFit.fill,
                                            )),
                                            radius: 80.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(
                                    margin: EdgeInsets.only(top: 10),
                                    height: 180,
                                    width: 180,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(100),
                                        ),
                                        boxShadow: [
                                          new BoxShadow(
                                            color: Colors.grey,
                                            blurRadius: 5.0,
                                          ),
                                        ]),
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: AvatarGlow(
                                        //startDelay: Duration(milliseconds: 1500),
                                        glowColor: cnst.appPrimaryMaterialColor,
                                        endRadius: 200.0,
                                        duration: Duration(milliseconds: 2000),
                                        repeat: true,
                                        showTwoGlows: true,
                                        repeatPauseDuration:
                                            Duration(milliseconds: 100),
                                        child: Material(
                                            elevation: 8.0,
                                            shape: CircleBorder(),
                                            child: CircleAvatar(
                                              backgroundColor: Colors.grey[100],
                                              child: ClipOval(
                                                  child:
                                                      FadeInImage.assetNetwork(
                                                image:
                                                    "http://evolve.buyinbni.in/" +
                                                        EdDetails[0]
                                                            ["UserImage"],
                                                placeholder:
                                                    'assets/loading.gif',
                                                height: 180,
                                                width: 180,
                                                fit: BoxFit.fill,
                                              )),
                                              radius: 80.0,
                                            )),
                                      ),
                                    ),
                                  ),
                            Container(
                              padding: const EdgeInsets.only(top: 20),
                              child: Text(
                                "${EdDetails[0]["Name"]}",
                                style: TextStyle(
                                    color: cnst.appPrimaryMaterialColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 5.0, bottom: 15, left: 20, right: 20),
                              child: Text(
                                "${EdDetails[0]["Position"]}",
                                style: TextStyle(
                                    color: cnst.appPrimaryMaterialColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 20),
                              child: TextFormField(
                                controller: edtSubject,
                                scrollPadding: EdgeInsets.all(0),
                                decoration: InputDecoration(
                                    border: new OutlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.black),
                                    ),
                                    hintText: "Subject"),
                                keyboardType: TextInputType.text,
                                maxLines: 3,
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 20, bottom: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  GestureDetector(
                                      onTap: () {
                                        DatePicker.showDatePicker(context,
                                            theme: DatePickerTheme(
                                              containerHeight: 210.0,
                                            ),
                                            showTitleActions: true,
                                            onConfirm: (date) {
                                          // print('confirm $time');
                                          setState(() {
                                            DateTime d =
                                                DateFormat("yyyy-mm-dd").parse(
                                                    '${date.year}-${date.month}-${date.day}');
                                            OneTwoOneDate =
                                                DateFormat("yyyy-mm-dd")
                                                    .format(d)
                                                    .toString();
                                          }); // think this will work better for you
                                        });
                                      },
                                      child: Container(
                                        height: 40,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.5,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          border:
                                              Border.all(color: Colors.black),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                        child: Center(
                                          child: Text(OneTwoOneDate == ""
                                              ? "Select Date"
                                              : OneTwoOneDate),
                                        ),
                                      )),
                                  GestureDetector(
                                      onTap: () {
                                        DatePicker.showTimePicker(context,
                                            theme: DatePickerTheme(
                                              containerHeight: 210.0,
                                            ),
                                            showTitleActions: true,
                                            onConfirm: (time) {
                                          // print('confirm $time');
                                          setState(() {
                                            DateTime t = DateFormat("HH:mm").parse(
                                                '${time.hour}:${time.minute}');
                                            OneTwoOneTime =
                                                DateFormat("hh:mm a")
                                                    .format(t)
                                                    .toString();
                                          }); // think this will work better for you
                                        });
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(left: 20),
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.5,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          border:
                                              Border.all(color: Colors.black),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                        child: Center(
                                          child: Text(OneTwoOneTime == ""
                                              ? "Select Time"
                                              : OneTwoOneTime),
                                        ),
                                      )),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 20, bottom: 30),
                              height: 45,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(6))),
                              child: MaterialButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(10.0)),
                                color: cnst.appPrimaryMaterialColor,
                                onPressed: () {
                                  _saveOneTwoOneWithEd();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  child: Text(
                                    "1-2-1 with ED",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ))
                  ],
                ),
              ),
            ),
    );
  }
}

class displayDateClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // TODO: implement getClip
    var path = Path();

    path.lineTo(0.0, size.height - 50);
    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2, size.height);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondControlPoint = Offset(size.width - (size.width / 4), size.height);
    var secondEndPoint = Offset(size.width, size.height - 50);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height - 50);
    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
