import 'dart:io';

import 'package:awake_app/Common/Constants.dart' as cnst;
import 'package:awake_app/Common/Constants.dart';
import 'package:awake_app/Common/Services.dart';
import 'package:awake_app/Screens/MemberProfileView.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ChapterMemberComponent extends StatefulWidget {
  var memberData;
  var id;

  ChapterMemberComponent(this.memberData, this.id);

  @override
  _ChapterMemberComponentState createState() => _ChapterMemberComponentState();
}

class _ChapterMemberComponentState extends State<ChapterMemberComponent> {
  String chepterId;
  String status = "";
  TextEditingController edtZoomLink = new TextEditingController();
  bool isLoading = false, OneTwoOneRequest = false;
  String OneTwoOneType = "Physical";
  _addOneTwoOneStatus() async {
    try {
      setState(() {
        isLoading = true;
      });
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        String senderId = preferences.getString(Session.MemberId);
        Future res = Services.AddOneTwoOneRequest(
            senderId,
            widget.memberData["memberid"].toString(),
            OneTwoOneType,
            edtZoomLink.text);

        res.then((data) async {
          setState(() {
            isLoading = false;
            OneTwoOneRequest = false;
          });

          if (data.ERROR_STATUS == false) {
            setState(() {
              widget.memberData["Status"] = "Requested";
            });
          } else {
            setState(() {
              isLoading = false;
            });
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

  @override
  void initState() {
    _getChepter();
  }

  _getChepter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      chepterId = prefs.getString(cnst.Session.chapterid);
    });
  }

  _openWhatsapp() {
    String whatsAppLink = cnst.whatsAppLink;
    String urlwithmobile = whatsAppLink.replaceAll(
        "#mobile", "91${widget.memberData["mobile"].toString()}");
    String urlwithmsg = urlwithmobile.replaceAll("#msg", "");
    launch(urlwithmsg);
  }

  /* _addOneTwoOneStatus() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        String senderId = preferences.getString(Session.MemberId);
        Future res = Services.AddOneTwoOneRequest(
            senderId, widget.memberData["memberid"].toString());
        setState(() {
          isLoading = true;
        });
        res.then((data) async {
          setState(() {
            isLoading = false;
          });

          if (data.ERROR_STATUS == false) {
            setState(() {
              widget.memberData["Status"] = "Requested";
            });
            print("dobne");
          } else {
            setState(() {
              isLoading = false;
            });
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
  }*/

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

  confirmDialog(String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Confirmation !!!"),
          content: new Text(msg),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "No",
                style: TextStyle(
                    color: cnst.appPrimaryMaterialColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w600),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text(
                "Yes",
                style: TextStyle(
                    color: cnst.appPrimaryMaterialColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w600),
              ),
              onPressed: () {
                Navigator.pop(context);
                //AskOneTwoOneType("Pick one option for 1-2-1 Meeting");
                setState(() {
                  OneTwoOneRequest = true;
                });
              },
            ),
          ],
        );
      },
    );
  }

  showHHMsg(String msg) {
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
                style: TextStyle(
                    color: cnst.appPrimaryMaterialColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w600),
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
    return Card(
      elevation: 4,
      child: Container(
        padding: EdgeInsets.only(top: 7, left: 10, right: 10, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Hero(
                  tag: "${widget.memberData["memberid"]}",
                  child: widget.memberData["image"] != null &&
                          widget.memberData["image"] != '' &&
                          (widget.memberData["image"]
                                  .toString()
                                  .toLowerCase()
                                  .contains(".jpg") ||
                              widget.memberData["image"]
                                  .toString()
                                  .toLowerCase()
                                  .contains(".jpeg") ||
                              widget.memberData["image"]
                                  .toString()
                                  .toLowerCase()
                                  .contains(".png"))
                      ? CircleAvatar(
                          backgroundColor: Colors.grey[100],
                          child: ClipOval(
                            child: FadeInImage.assetNetwork(
                              placeholder: '',
                              image: widget.memberData["image"]
                                      .toString()
                                      .contains("http://crm.buyinbni.in/")
                                  ? '${widget.memberData["image"]}'
                                  : "http://crm.buyinbni.in/" +
                                      '${widget.memberData["image"]}',
                              height: 55,
                              width: 55,
                              fit: BoxFit.fill,
                            ),
                          ),
                        )
                      : Container(
                          decoration: new BoxDecoration(
                              color: cnst.appPrimaryMaterialColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          width: 40,
                          height: 40,
                          child: Center(
                              child: Text(
                                  widget.memberData["name"] == "" ||
                                          widget.memberData["name"] == null
                                      ? "?"
                                      : "${widget.memberData["name"].toString().substring(0, 1)}",
                                  style: TextStyle(
                                      decoration: TextDecoration.none,
                                      fontSize: 19,
                                      color: Colors.white))),
                        ),
                ),
                Padding(padding: EdgeInsets.only(left: 7)),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            widget.memberData["name"] != "" &&
                                    widget.memberData["name"] != null
                                ? Text("${widget.memberData["name"]}",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600))
                                : Container(),
                            widget.memberData["companyname"] != "" &&
                                    widget.memberData["companyname"] != null
                                ? Text("${widget.memberData["companyname"]}",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontSize: 13, color: Colors.grey[700]))
                                : Container(),
                            widget.memberData["categoryname"] != "" &&
                                    widget.memberData["categoryname"] != null
                                ? Text("${widget.memberData["categoryname"]}",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontSize: 13, color: Colors.grey[700]))
                                : Container(),
                            widget.memberData["Status"] != "" &&
                                    widget.memberData["Status"] != null
                                ? Text("${widget.memberData["Status"]}",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontSize: 13, color: Colors.grey[700]))
                                : Container(),
                          ],
                        ),
                      ),
                      Column(
                        children: <Widget>[
                          isLoading
                              ? CircularProgressIndicator()
                              : Container(
                                  height: 35,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: widget.memberData["Status"] ==
                                                      "Requested" ||
                                                  widget.memberData["Status"] ==
                                                      "Completed"
                                              ? Colors.white
                                              : cnst.appPrimaryMaterialColor,
                                          width: 2),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: MaterialButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(10.0)),
                                    color: widget.memberData["Status"] ==
                                            "Requested"
                                        ? cnst.appPrimaryMaterialColor
                                        : widget.memberData["Status"] ==
                                                "Completed"
                                            ? Colors.green
                                            : Colors.white,
                                    onPressed: () {
                                      if (widget.memberData["Status"] == "" ||
                                          widget.memberData["Status"] == null) {
                                        confirmDialog(
                                            "Are you sure to Send 1-2-1 Request?");
                                      } else if (widget.memberData["Status"] ==
                                          "Requested") {
                                        showHHMsg(
                                            "Your 1-2-1 Request is already sent !!!");
                                      } else if (widget.memberData["Status"] ==
                                          "Completed") {
                                        showHHMsg(
                                            "Your 1-2-1 Meeting is already Completed.\nYou can't send another Request for 1-2-1 !!!");
                                      } else {
                                        showHHMsg(
                                            "Your 1-2-1 Request is accepeted !!!");
                                      }
                                    },
                                    child: Text(
                                      widget.memberData["Status"] == "Requested"
                                          ? "1-2-1 Requested"
                                          : widget.memberData["Status"] ==
                                                  "Accepted"
                                              ? "1-2-1 Accepted"
                                              : widget.memberData["Status"] ==
                                                      "Completed"
                                                  ? "1-2-1 Completed"
                                                  : "Send 1-2-1",
                                      style: TextStyle(
                                          color: widget.memberData["Status"] ==
                                                      "Requested" ||
                                                  widget.memberData["Status"] ==
                                                      "Completed"
                                              ? Colors.white
                                              : cnst.appPrimaryMaterialColor,
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                          /*GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MemberProfileView(
                                        memberData: widget.memberData,
                                        image: widget.memberData["image"]),
                                  ));
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Image.asset(
                                'images/eye.png',
                                height: 27,
                                width: 27,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),*/
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Container(
                              height: 35,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(7))),
                              child: MaterialButton(
                                minWidth: 100,
                                shape: RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(7)),
                                color: cnst.appPrimaryMaterialColor,
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MemberProfileView(
                                            memberData: widget.memberData,
                                            image: widget.memberData["image"]),
                                      ));
                                },
                                child: Text(
                                  "Preview",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            OneTwoOneRequest
                ? Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 15),
                    child: Text("Select 1-2-1 Meeting Type",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  )
                : Container(),
            OneTwoOneRequest
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          new Radio(
                            value: "Physical",
                            onChanged: (String value) {
                              setState(() {
                                OneTwoOneType = "Physical";
                              });
                            },
                            groupValue: OneTwoOneType,
                          ),
                          Text("Physical")
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          new Radio(
                            value: "Zoom",
                            onChanged: (String value) {
                              setState(() {
                                OneTwoOneType = "Zoom";
                              });
                            },
                            groupValue: OneTwoOneType,
                          ),
                          Text("Zoom")
                        ],
                      ),
                    ],
                  )
                : Container(),
            OneTwoOneType == "Zoom" && OneTwoOneRequest
                ? Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    height: 75,
                    child: TextFormField(
                      controller: edtZoomLink,
                      scrollPadding: EdgeInsets.all(0),
                      decoration: InputDecoration(
                          counterText: "",
                          border: new OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.black),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          labelText: "Zoom Link",
                          hintText: "Zoom Link"),
                      keyboardType: TextInputType.text,
                      style: TextStyle(color: Colors.black),
                    ),
                  )
                : Container(),
            OneTwoOneRequest
                ? Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 45,
                      margin: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(6))),
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10.0)),
                        color: cnst.appPrimaryMaterialColor,
                        onPressed: () {
                          _addOneTwoOneStatus();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 11, right: 11),
                          child: Text(
                            "Submit",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 17.0,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
